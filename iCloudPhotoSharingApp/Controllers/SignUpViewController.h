//
//  SignUpViewController.h
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 13/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageViewOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageActionOutlet;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextfieldOutlet;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextifieldOutlet;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentControlOutlet;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextFieldOutlet;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfieldOutlet;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfieldOutlet;
@property (weak, nonatomic) IBOutlet UITextField *conformPasswordTextifieldOutlet;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfieldOutlet;
@property (weak, nonatomic) IBOutlet UITextField *cityTextfieldOutlet;
@property (weak, nonatomic) IBOutlet UITextField *stateTextfieldOutlet;
@property (weak, nonatomic) IBOutlet UITextField *countryTextfieldOutlet;
- (IBAction)signUpBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *firstNameTextfield;
@property (weak, nonatomic) IBOutlet UIButton *signUpButtonOutlet;
@end

NS_ASSUME_NONNULL_END
