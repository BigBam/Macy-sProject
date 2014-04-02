//
//  MCSInventory.h
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/25/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCSProduct.h"
#import "MCSDataFetch.h"
#import "MCSDatabaseManager.h"

@interface MCSInventory : NSObject
+ (MCSInventory *)sharedInstance;

// Array of MCSProduct
@property (nonatomic) NSArray *availableInventory;
@property (nonatomic) NSMutableArray *myInventory;
-(void) download;
@end
