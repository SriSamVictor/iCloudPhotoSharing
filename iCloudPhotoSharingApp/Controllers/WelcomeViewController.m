//
//  WelcomeViewController.m
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 14/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SignUpViewController.h"
#import "SignInViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginBtnOutlet.layer.cornerRadius = 20.0;
    self.loginBtnOutlet.clipsToBounds = YES;
    
    self.registerBtnOutlet.layer.cornerRadius = 20.0;
    self.registerBtnOutlet.clipsToBounds = YES;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self animationMethod];
}
-(void) animationMethod {
    NSMutableArray *imageArray  = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"teal1.png"], [UIImage imageNamed:@"teals.png"],[UIImage imageNamed:@"teal2.png"],[UIImage imageNamed:@"teal3.png"], nil];
    self.photographerImage.animationImages = imageArray;
    self.photographerImage.animationRepeatCount = 0;
    self.photographerImage.animationDuration = 2.0f;
    [self.photographerImage startAnimating];
}
- (IBAction)loginBtnAction:(id)sender {
    SignInViewController *signInViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self.navigationController pushViewController:signInViewController animated:YES];
}
- (IBAction)registerBtnAction:(id)sender {
    SignUpViewController *signUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:signUpViewController animated:YES];
}
@end
