//
//  MCSSplashViewController.h
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/27/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSDatabaseManager.h"
#import "MCSInventory.h"

@interface MCSSplashViewController : UIViewController
@property (nonatomic) NSInteger loadingComplete;
@property (strong, nonatomic) MCSDatabaseManager * databaseManager;
@property (strong, nonatomic) MCSInventory * inventoryManager;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIcon;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet UIButton *goToProductEntryButton;
- (IBAction)goToProductEntryAction:(UIButton *)sender;

@end
