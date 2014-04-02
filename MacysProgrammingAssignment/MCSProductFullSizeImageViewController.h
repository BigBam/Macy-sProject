//
//  MCSProductFullSizeImageViewController.h
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/25/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCSProductFullSizeImageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageViewContainer;
@property (nonatomic) UIImage *fsImage;
- (void)setImageView:(UIImage *)setImage;
@end
