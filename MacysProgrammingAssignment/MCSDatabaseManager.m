//
//  MCSDatabaseManager.m
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/25/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import "MCSDatabaseManager.h"

@implementation MCSDatabaseManager

static MCSDatabaseManager *sharedInstance = nil;

+ (id)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        //Creating the DB
        NSString * docsDirectory;
        NSArray * dirPaths;
        
        //Getting the docsDirectory Paths
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
        
        //Storing the correct path onto the docsDirectory
        docsDirectory = [dirPaths objectAtIndex:0];
        
        //Setting databasePath for the database
        self.databasePath = [[NSString alloc]initWithString:[docsDirectory stringByAppendingPathComponent:@"Macys.db"]];
    }
    
    return self;
}

- (void)createProductTable
{
    // Create PRODUCT table
    [self executeSql:@"CREATE TABLE IF NOT EXISTS PRODUCT (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, DESCRIPTION TEXT, IMAGE_URL TEXT, REGULAR_PRICE TEXT, SALE_PRICE TEXT)"];
    
    // Create COLOR table
    [self executeSql:@"CREATE TABLE IF NOT EXISTS COLOR (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, PRODUCT_ID INTEGER)"];
    
    // Create STORES table
    [self executeSql:@"CREATE TABLE IF NOT EXISTS STORES (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL UNIQUE, LOCATION TEXT)"];
    
    // Create INVENTORY table
    [self executeSql:@"CREATE TABLE IF NOT EXISTS INVENTORY (ID INTEGER PRIMARY KEY AUTOINCREMENT, PRODUCT_ID INTEGER, STORE_ID INTEGER)"];
}

- (NSInteger)insertProduct:(MCSProduct *)product {
    
    // Insert product
    NSString *queryString = [NSString stringWithFormat:@"INSERT INTO PRODUCT (NAME, DESCRIPTION, IMAGE_URL, REGULAR_PRICE, SALE_PRICE) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", product.name, product.description, product.imageURL, product.regularPrice, product.salePrice];
    [self executeSql:queryString];
    
    // Insert colors
    [self insertColorsByProduct:product];
    
    // Insert Store and Inventory
    [self insertStoresByProduct:product];
    
    NSMutableArray *getProductID = [self executeSql:@"SELECT MAX(ID) AS ID FROM PRODUCT"];
    
    return [[[getProductID objectAtIndex:0] objectForKey:@"ID"] integerValue];
}

- (void)updateProduct:(MCSProduct *)product {
    
    // SIMPLE - update product
    NSString *queryString = [NSString stringWithFormat:@"UPDATE PRODUCT SET NAME = \"%@\", DESCRIPTION = \"%@\", REGULAR_PRICE = \"%@\", SALE_PRICE = \"%@\" WHERE ID = %i", product.name, product.description, product.regularPrice, product.salePrice, product.id];
    
    [self executeSql:queryString];
}

- (void) deleteProduct:(NSInteger)productID {
    
    // Delete from product list
    [self deleteRowWithId:productID from:@"PRODUCT"];
    
    // Delete from inventory
    [self executeSql:[NSString stringWithFormat:@"DELETE FROM INVENTORY WHERE PRODUCT_ID = %i", productID]];
    
    // Delete from colors
    [self executeSql:[NSString stringWithFormat:@"DELETE FROM COLOR WHERE PRODUCT_ID = %i", productID]];
}

- (NSMutableArray *)returnInventory {
    
    // Array of Dictionaries detailing the results
    NSMutableArray *productArray = [[NSMutableArray alloc] initWithArray:[self findAllFrom:@"PRODUCT"]];
    
    // We must transform this into an array of MCSStore objects
    NSMutableArray *storeArray = [NSMutableArray array];
    
    for (NSMutableDictionary *productDict in productArray) {
        
        // Get the product ID
        NSInteger productID = [[productDict objectForKey:@"ID"] integerValue];
        
        // Get the colors
        NSArray *colors = [self getColorsArrayByProductID:productID];
        
        // Get the stores
        NSDictionary *stores = [self getStoresDictionaryByProductID:productID];
        
        // Now we create the product
        MCSProduct *productForRow = [[MCSProduct alloc] initWithProduct:productID andName:[productDict objectForKey:@"NAME"] andDescription:[productDict objectForKey:@"DESCRIPTION"] andRegularPrice:[productDict objectForKey:@"REGULAR_PRICE"] andSalesPrice:[productDict objectForKey:@"SALE_PRICE"] andImageURL:[productDict objectForKey:@"IMAGE_URL"] andColors:colors andStores:stores];
        
        [storeArray addObject:productForRow];
    }

    return storeArray;
}

#pragma mark - Helpers for the returnInventory method
- (NSArray *)getColorsArrayByProductID:(NSInteger)productID {
    NSArray *colors = [NSArray array];
    colors = [self executeSql:[NSString stringWithFormat:@"SELECT * FROM COLOR WHERE PRODUCT_ID = %i", productID]];
    
    NSMutableArray *transformedColorArray = [NSMutableArray array];
    for(NSDictionary *currentColor in colors) {
        [transformedColorArray addObject:[currentColor objectForKey:@"NAME"]];
    }
    
    return (NSArray *)transformedColorArray;
}

- (NSDictionary *)getStoresDictionaryByProductID:(NSInteger)productID {
    NSDictionary *stores = [self executeSql:[NSString stringWithFormat:@"SELECT DISTINCT NAME, LOCATION FROM STORES, INVENTORY WHERE INVENTORY.PRODUCT_ID = %i", productID]];
    
    NSMutableDictionary *transformedStoreDict = [[NSMutableDictionary alloc] init];
    for(NSDictionary *currentStore in stores)
    {
        NSString *name = [currentStore objectForKey:@"NAME"];
        NSString *location = [currentStore objectForKey:@"LOCATION"];
        NSDictionary *newDictFormat = [[NSDictionary alloc] initWithObjectsAndKeys:location, name, nil];
        [transformedStoreDict addEntriesFromDictionary:newDictFormat];
    }
    
    return (NSDictionary *)transformedStoreDict;
}

- (void)insertColorsByProduct:(MCSProduct *)product {
    
    for (NSString *colorResult in product.colors) {
        NSString *queryString = [NSString stringWithFormat:@"INSERT INTO COLOR (NAME, PRODUCT_ID) VALUES (\"%@\", (SELECT MAX(ID) FROM PRODUCT))", colorResult];
        [self executeSql:queryString];
    }
}

- (void)insertStoresByProduct:(MCSProduct *)product {
    
    NSDictionary *storeResult = product.stores;
    
    for (id key in storeResult) {
    
        // Update STORES
        NSString *queryStringStores = [NSString stringWithFormat:@"INSERT OR IGNORE INTO STORES (NAME, LOCATION) VALUES (\"%@\", \"%@\")", key, [storeResult objectForKey:key]];
        [self executeSql:queryStringStores];
        
        // Update INVENTORY
        NSString *queryStringInventory = [NSString stringWithFormat:@"INSERT INTO INVENTORY (PRODUCT_ID, STORE_ID) VALUES ((SELECT max(id) FROM PRODUCT), (SELECT ID FROM STORES WHERE STORES.NAME = \"%@\"))", key];
        [self executeSql:queryStringInventory];
    }
}

#pragma mark : Database Helper methods - Derived from https://github.com/anthonyly/SQLiteManager
- (NSDictionary *)indexByColumnName:(sqlite3_stmt *)init_statement {
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    int num_fields = sqlite3_column_count(init_statement);
    for(int index_value = 0; index_value < num_fields; index_value++) {
        const char* field_name = sqlite3_column_name(init_statement, index_value);
        if (!field_name){
            field_name="";
        }
        NSString *col_name = [NSString stringWithUTF8String:field_name];
        NSNumber *index_num = [NSNumber numberWithInt:index_value];
        [keys addObject:col_name];
        [values addObject:index_num];
    }
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    return dictionary;
}
#pragma SQL : FIND
-(NSArray *)_find:(NSString *)sql{
    //sqlite3 *database;
    NSMutableArray *dataReturn = [[NSMutableArray alloc] init];
    if(sqlite3_open([self.databasePath UTF8String], &_databaseManager) == SQLITE_OK) {
        const char *sqlStatement = (const char*)[sql UTF8String];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(_databaseManager, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            NSDictionary *dictionary = [self indexByColumnName:compiledStatement];
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSMutableDictionary * row = [[NSMutableDictionary alloc] init];
                for (NSString *field in dictionary) {
                    char * str = (char *)sqlite3_column_text(compiledStatement, [[dictionary objectForKey:field] intValue]);
                    if (!str){
                        str=" ";
                    }
                    NSString * value = [NSString stringWithUTF8String:str];
                    [row setObject:value forKey:field];
                }
                [dataReturn addObject:row];
            }
        }
        else {
            NSAssert1(0, @"Error sqlite3_prepare_v2 :. '%s'", sqlite3_errmsg(_databaseManager));
        }
        sqlite3_finalize(compiledStatement);
    }
    else {
        NSAssert1(0, @"Error sqlite3_open :. '%s'", sqlite3_errmsg(_databaseManager));
    }
    sqlite3_close(_databaseManager);
    return dataReturn;
}

-(NSArray *)findAllFrom:(NSString *)table{
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@",table];
    return [self _find:sql];
}

#pragma SQL : DELETE
-(BOOL)deleteRowWithId:(int)idRow from:(NSString *)table{
    //sqlite3 *database;
    if(sqlite3_open([self.databasePath UTF8String], &_databaseManager) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %d",table,idRow];
        const char *sqlStatement = (const char*)[sql UTF8String];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(_databaseManager, sqlStatement, -1, &compiledStatement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error sqlite3_prepare_v2 :. '%s'", sqlite3_errmsg(_databaseManager));
            return NO;
        }
        if(SQLITE_DONE != sqlite3_step(compiledStatement)) {
            NSAssert1(0, @"Error sqlite3_step :. '%s'", sqlite3_errmsg(_databaseManager));
            return NO;
        }else{
            sqlite3_finalize(compiledStatement);
            sqlite3_close(_databaseManager);
            return YES;
        }
    }else{
        NSAssert1(0, @"Error sqlite3_open :. '%s'", sqlite3_errmsg(_databaseManager));
        return NO;
    }
}

#pragma SQL : QUERY
-(id)executeSql:(NSString *)sql{
    NSNumber *returnYES = [NSNumber numberWithBool:YES];
    NSNumber *returnNO = [NSNumber numberWithBool:NO];
    NSCharacterSet *delimiterCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *firstWord = [[sql componentsSeparatedByCharactersInSet:delimiterCharacterSet] objectAtIndex:0];
    if ([firstWord isEqualToString:@"SELECT"]) {
        return [self _find:sql];
    }
    else{
        if(sqlite3_open([self.databasePath UTF8String], &_databaseManager) == SQLITE_OK) {
            const char *sqlStatement = (const char*)[sql UTF8String];
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(_databaseManager, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            }
            if(SQLITE_DONE != sqlite3_step(compiledStatement)) {
                NSAssert1(0, @"Error sqlite3_open :. '%s'", sqlite3_errmsg(_databaseManager));
                return returnNO;
            }else{
                sqlite3_finalize(compiledStatement);
                sqlite3_close(_databaseManager);
                return returnYES;
            }
        }else{
            NSAssert1(0, @"Error sqlite3_open :. '%s'", sqlite3_errmsg(_databaseManager));
            return returnNO;
        }
    }
}
@end
