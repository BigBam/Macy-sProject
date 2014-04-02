//
//  MCSProductFullSizeImageViewController.m
//  MacysProgrammingAssignment
//
//  Created by Bam Faboyede on 3/25/14.
//  Copyright (c) 2014 Bam F. All rights reserved.
//

#import "MCSProductFullSizeImageViewController.h"

@interface MCSProductFullSizeImageViewController ()

@end

@implementation MCSProductFullSizeImageViewController

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
    
    [self setImageView:self.fsImage];
    
    UITapGestureRecognizer *touchView = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTouchView)];
    touchView.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:touchView];
    [self.imageViewContainer addGestureRecognizer:touchView];
}

- (void)handleTouchView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImageView:(UIImage *)setImage {
    [self.imageViewContainer setImage:setImage];
    
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

@end
