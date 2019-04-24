//
//  SignInViewController.m
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 18/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import "SignInViewController.h"
#import "UploadViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signInButtonOutlet.layer.cornerRadius = 20.0;
    self.signInButtonOutlet.layer.masksToBounds = YES;
    
}
- (IBAction)signInButtonAction:(id)sender {
    UploadViewController *uploadViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadViewController"];
    [self.navigationController pushViewController:uploadViewController animated:YES];
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
