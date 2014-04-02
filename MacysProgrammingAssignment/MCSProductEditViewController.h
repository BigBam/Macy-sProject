//
//  MCSProductEditViewController.h
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 4/1/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSProduct.h"
#import "MCSDatabaseManager.h"
#import "MCSInventory.h"

@interface MCSProductEditViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic) MCSDatabaseManager *databaseManager;
@property (nonatomic) MCSInventory *inventoryManager;

@property (strong, nonatomic) IBOutlet UITextField *productNameField;
@property (strong, nonatomic) IBOutlet UITextField *productDescriptionField;
@property (strong, nonatomic) IBOutlet UITextField *productRegularPriceField;
@property (strong, nonatomic) IBOutlet UITextField *productSalePriceField;
- (IBAction)deleteProduct:(id)sender;
- (IBAction)updateProduct:(id)sender;
@property (nonatomic) MCSProduct *product;
@end
