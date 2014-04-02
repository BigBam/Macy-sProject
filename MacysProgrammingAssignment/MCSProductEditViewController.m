//
//  MCSProductEditViewController.m
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 4/1/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import "MCSProductEditViewController.h"
#import "MCSProductListTableViewController.h"
#import "MCSProductDetailsViewController.h"

@interface MCSProductEditViewController ()

@end

@implementation MCSProductEditViewController

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

    self.databaseManager = [MCSDatabaseManager sharedInstance];
    self.inventoryManager = [MCSInventory sharedInstance];
    
    // Preset the textfields with the current value
    if(self.product) {
        self.productNameField.text = self.product.name;
        self.productDescriptionField.text = self.product.description;
        self.productRegularPriceField.text = self.product.regularPrice;
        self.productSalePriceField.text = self.product.salePrice;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)deleteProduct:(id)sender {
    
    // Update database
    [self.databaseManager deleteProduct:self.product.id];
    
    // Update inventory with new database values
    self.inventoryManager.myInventory = [self.databaseManager returnInventory];
    
    // Prepare to go back to the product list
    MCSProductListTableViewController *pListVC = [[self.navigationController viewControllers] objectAtIndex:2];
    [pListVC.tableView reloadData];
    
    // Pop back
    [self.navigationController popToViewController:pListVC animated:YES];
}

- (IBAction)updateProduct:(id)sender {
    
    // Create the updated product
    MCSProduct *updatedProduct = [[MCSProduct alloc] initWithProduct:self.product.id andName:self.productNameField.text andDescription:self.productDescriptionField.text andRegularPrice:self.productRegularPriceField.text andSalesPrice:self.productSalePriceField.text andImageURL:self.product.imageURL andColors:self.product.colors andStores:self.product.stores];
    
    // Update database with the new product
    [self.databaseManager updateProduct:updatedProduct];
    
    // Update the inventory
    self.inventoryManager.myInventory = [self.databaseManager returnInventory];
    
    // Prepare to go back to the product details page
    MCSProductDetailsViewController *pDetailsVC = [[self.navigationController viewControllers] objectAtIndex:3];
    pDetailsVC.product = updatedProduct;
    
    // Pop back
    [self.navigationController popToViewController:pDetailsVC animated:YES];
}
@end
