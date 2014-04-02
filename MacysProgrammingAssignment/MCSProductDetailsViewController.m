//
//  MCSProductDetailsViewController.m
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/25/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import "MCSProductDetailsViewController.h"
#import "MCSProductFullSizeImageViewController.h"
#import "MCSProductEditViewController.h"

@interface MCSProductDetailsViewController ()

@end

@implementation MCSProductDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithProduct:(MCSProduct *)initialProduct {
    
    self = [super init];
    
    if (self) {
        self.product = [[MCSProduct alloc] init];
        self.product = initialProduct;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up Tap Gesture for imageview
    UITapGestureRecognizer *touchImage = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTouchImage)];
    touchImage.numberOfTapsRequired = 1;
    
    [self.imageViewContainer addGestureRecognizer:touchImage];
    
}

-(void)viewDidAppear:(BOOL)animated {
    // Simple request for the image data
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.product.imageURL]];
    
    // Set the image in the cell to the retrieved image data
    self.imageViewContainer.image = [UIImage imageWithData:data];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if(self.product) {
        
        // Set the title
        self.titleLabel.text = self.product.name;
        
        // Set up initial description
        [self setProductDescription];
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProductDescription {
    NSMutableString *completeDescription = [[NSMutableString alloc] initWithString:self.product.description];
    
    // Tack on the prices to the description
    NSString *priceString = [NSString stringWithFormat:@"\n\n%@ \n%@", self.product.regularPrice, self.product.salePrice];
    [completeDescription appendString:priceString];
    
    self.descriptionLabel.text = completeDescription;
    [self.descriptionLabel setNumberOfLines:50];
    [self.descriptionLabel sizeToFit];
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    
    if(sender.selectedSegmentIndex == 0) {
        
        [self setProductDescription];
        
    } else if(sender.selectedSegmentIndex == 1) {
        
        // Set the description to available colors
        NSMutableString *completeDescription = [[NSMutableString alloc] initWithString:@"Available Colors: \n"];
        NSString *colorsString = [self.product.colors componentsJoinedByString:@", "];
        [completeDescription appendString:colorsString];
        self.descriptionLabel.text = completeDescription;
        
    } else {
        // Set the description to available stores
        NSMutableString *completeDescription = [[NSMutableString alloc] initWithString:@"Available Stores: \n"];
        for(id key in self.product.stores){
            NSString *storeString = [NSString stringWithFormat:@"%@ - %@ \n", key, [self.product.stores objectForKey:key]];
            [completeDescription appendString:storeString];
        }
        self.descriptionLabel.text = completeDescription;
    }
    
    [self.descriptionLabel setNumberOfLines:50];
    [self.descriptionLabel sizeToFit];
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)handleTouchImage{
    [self performSegueWithIdentifier:@"showFullSizeImage" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual: @"showFullSizeImage"]) {
        
        MCSProductFullSizeImageViewController *fullsizeVC = segue.destinationViewController;
        fullsizeVC.fsImage = self.imageViewContainer.image;
    }
    else if([segue.identifier isEqual: @"editProductInformation"]) {
        
        MCSProductEditViewController *productEditVC = segue.destinationViewController;
        productEditVC.product = self.product;
    }
}

@end
