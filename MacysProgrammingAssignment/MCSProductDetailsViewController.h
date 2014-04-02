//
//  MCSProductDetailsViewController.h
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/25/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSProduct.h"

@interface MCSProductDetailsViewController : UIViewController<UIPopoverControllerDelegate>
@property (nonatomic) MCSProduct *product;

#pragma mark - Outlets
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewContainer;

@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

- (IBAction)segmentChanged:(UISegmentedControl *)sender;

- (id)initWithProduct:(MCSProduct *)initialProduct;
@end
