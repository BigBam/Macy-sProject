//
//  MCSDatabaseManager.h
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/25/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

#import "MCSProduct.h"

@interface MCSDatabaseManager : NSObject

@property (assign, nonatomic) sqlite3 *databaseManager;
@property (strong, nonatomic) NSString *databasePath;

+ (MCSDatabaseManager *)sharedInstance;

- (void)createProductTable;
- (NSInteger)insertProduct:(MCSProduct *)product;
- (void)updateProduct:(MCSProduct *)product;
- (void)deleteProduct:(NSInteger)productID;
- (NSMutableArray *)returnInventory;
@end
