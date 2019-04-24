//
//  SignInViewController.h
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 18/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOutlet;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressOutlet;
@property (weak, nonatomic) IBOutlet UITextField *passwordOutlet;
@property (weak, nonatomic) IBOutlet UIButton *signInButtonOutlet;
- (IBAction)signInButtonAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
