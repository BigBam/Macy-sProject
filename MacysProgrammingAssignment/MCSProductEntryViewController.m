//
//  MCSProductEntryViewController.m
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/27/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import "MCSProductEntryViewController.h"

@interface MCSProductEntryViewController ()

@end

@implementation MCSProductEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the inventory manager
    self.inventoryManager = [MCSInventory sharedInstance];
    
    // Set delegate and databasours
    [self.productSelectionPicker setDataSource:self];
    [self.productSelectionPicker setDelegate:self];
    
    // Initialize selected product to the first product in the pickerview
    self.selectedProduct = [[MCSProduct alloc] init];
    self.selectedProduct = [self.inventoryManager.availableInventory objectAtIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.inventoryManager.availableInventory count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedProduct = [self.inventoryManager.availableInventory objectAtIndex:row];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* label = (UILabel*)view;
    
    if (view == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    
    MCSProduct *productForRow = [self.inventoryManager.availableInventory objectAtIndex:row];
    label.text = [NSString stringWithFormat:@"%@ - %@", productForRow.regularPrice, productForRow.name];
    label.textColor = [UIColor colorWithWhite:1 alpha:1];
    return label;
}

- (IBAction)addProductButton:(UIButton *)sender {
    
    // Add the Product to the Database
    MCSDatabaseManager *dbManager = [MCSDatabaseManager sharedInstance];

    // Assign an ID to the product
    self.selectedProduct.id = [dbManager insertProduct:self.selectedProduct];
    
    // Add the Product to myInventory in the InventoryManager
    [self.inventoryManager.myInventory addObject:self.selectedProduct];
    
    // Show an alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"New Product!" message: @"Your Product Has Been Added" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)showAllProductsButton:(UIButton *)sender {
}
@end
