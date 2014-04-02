//
//  MCSProductEntryViewController.h
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/27/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSInventory.h"
#import "MCSDatabaseManager.h"

#import "MCSProduct.h"

@interface MCSProductEntryViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic) MCSProduct *selectedProduct;
@property (strong, nonatomic) MCSInventory * inventoryManager;

@property (strong, nonatomic) IBOutlet UIPickerView *productSelectionPicker;
- (IBAction)addProductButton:(UIButton *)sender;
- (IBAction)showAllProductsButton:(UIButton *)sender;
@end
