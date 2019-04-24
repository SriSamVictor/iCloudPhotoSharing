//
//  ImageViewController.m
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 06/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import "ImageViewController.h"
#import "EditViewController.h"

@interface ImageViewController (){
}

@end

@implementation ImageViewController
@synthesize displayHeaderView,displayHeaderViewHeightConstraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    NSLog(@"Image str %@",self.imageView);
    self.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.displayImageView.clipsToBounds = YES;
//    self.displayImageView.image = self.imageView;
    self.displayImageView.image = [UIImage imageNamed:self.strImages];
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)editActionBtn:(id)sender {
    EditViewController *editViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
    editViewController.imageViewMine = (UIImage *)[UIImage imageNamed:self.strImages];
    NSLog(@"%@",editViewController.imageViewMine);
    [self.navigationController pushViewController:editViewController animated:YES];
}
@end
