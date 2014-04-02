//
//  MCSProductListTableViewController.m
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/26/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import "MCSProductListTableViewController.h"
#import "MCSProductDetailsViewController.h"

@interface MCSProductListTableViewController ()

@end

@implementation MCSProductListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

    // Set up database manager
    self.databaseManager = [MCSDatabaseManager sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.inventoryManager.myInventory count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    MCSProduct *productForRow = [self.inventoryManager.myInventory objectAtIndex:indexPath.row];
    
    // Style cell
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%@", productForRow.name];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        NSLog(@"%i", indexPath.row);
        
        // Delete from database
        MCSProduct *productForDeletion = [self.inventoryManager.myInventory objectAtIndex:indexPath.row];
        [self.databaseManager deleteProduct:productForDeletion.id];

        // Delete from inventory manager
        [self.inventoryManager.myInventory removeObjectAtIndex:indexPath.row];
    
        [self.tableView reloadData];
        
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"My Inventory";
    }
    else {
        return @"";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MCSProduct *passedProduct = [self.inventoryManager.myInventory objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"goToProductDetails" sender:passedProduct];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MCSProductDetailsViewController *productDetailsVC = [segue destinationViewController];
    productDetailsVC.product = sender;
}
@end
