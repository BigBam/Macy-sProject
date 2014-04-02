//
//  MCSSplashViewController.m
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/27/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import "MCSSplashViewController.h"
#import "MCSProductEntryViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface MCSSplashViewController ()

@end

@implementation MCSSplashViewController

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

}

- (void)viewDidAppear:(BOOL)animated {
    [self startUpSequence];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.loadingIcon startAnimating];
    self.goToProductEntryButton.hidden = TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startUpSequence {
    
    self.databaseManager = [MCSDatabaseManager sharedInstance];
    
    self.statusLabel.text = @"Initializing database...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Initialize the database
        [self.databaseManager createProductTable];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Set up Inventory
            self.statusLabel.text = @"Setting up inventory...";
            self.inventoryManager = [MCSInventory sharedInstance];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                // Download the available inventory
                [self.inventoryManager download];
                
                // Get the current inventory from the local database
                self.inventoryManager.myInventory = [self.databaseManager returnInventory];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // Update UI - enable entrance
                    self.statusLabel.text = @"";
                    self.loadingIcon.hidden = TRUE;
                    self.goToProductEntryButton.hidden = FALSE;
                });
            });
        });
    });
}

#pragma mark - Navigation

- (IBAction)goToProductEntryAction:(UIButton *)sender {
    
//    // Create the transition
//    CATransition *transition = [CATransition animation];
//    [transition setDelegate:self];
//    [transition setDuration:0.8];
//    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    transition.type = kCATransitionMoveIn;
//    transition.subtype = kCATransitionFromTop;
//    transition.fillMode = kCAFillModeForwards;
//    transition.startProgress = 0.3;
//    [transition setRemovedOnCompletion:NO];

    //[self.view addSubview:nextView];
	
    CATransition *animation = [CATransition animation];
	[animation setDuration:0.5];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromTop];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.view layer] addAnimation:animation forKey:@"SlideView"];
    
    // Perform transition
    //[self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    // Then perform segue
    //[self performSegueWithIdentifier:@"goToProductEntry" sender:sender];
}
@end
