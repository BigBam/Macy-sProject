//
//  MCSProductListTableViewController.h
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/26/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSInventory.h"
#import "MCSDatabaseManager.h"

@interface MCSProductListTableViewController : UITableViewController
@property (nonatomic) MCSInventory *inventoryManager;
@property (nonatomic) MCSDatabaseManager *databaseManager;
@end
