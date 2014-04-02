//
//  MCSInventory.m
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/25/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import "MCSInventory.h"

@implementation MCSInventory

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
        self.myInventory = [NSMutableArray array];
        self.availableInventory = [NSArray array];
        
        // Initialize myInventory from the Database
        MCSDatabaseManager *databaseManager = [MCSDatabaseManager sharedInstance];
        
        // Get the array of Products already saved in the database
        self.myInventory = [databaseManager returnInventory];
    }
    
    return self;
}

- (void)download {
    MCSDataFetch *fetchDictionary = [[MCSDataFetch alloc] init];
    [self save:[fetchDictionary fetch]];
}

- (void)save:(NSArray *)input {
    
    NSMutableArray *arrayOfProducts = [NSMutableArray array];
    
    for (NSDictionary *allresults in input) {
        
        // New Product
        MCSProduct *nextProduct = [[MCSProduct alloc] init];
        
        // Assign the properties
        nextProduct.name = [allresults objectForKey:@"productName"];
        nextProduct.description = [allresults objectForKey:@"productDescription"];
        nextProduct.imageURL = [allresults objectForKey:@"productImage"];
        nextProduct.regularPrice = [allresults objectForKey:@"productRegularPrice"];
        nextProduct.salePrice = [allresults objectForKey:@"productSalePrice"];
        nextProduct.stores = [allresults objectForKey:@"productStores"];
        nextProduct.colors = [allresults objectForKey:@"productColors"];
        
        // Add the product to the array of products
        [arrayOfProducts addObject:nextProduct];
    }
    
    self.availableInventory = (NSArray *)arrayOfProducts;
}
@end