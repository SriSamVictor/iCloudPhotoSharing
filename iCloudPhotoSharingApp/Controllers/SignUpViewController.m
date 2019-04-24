//
//  SignUpViewController.m
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 13/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import "SignUpViewController.h"
#import "UserListViewController.h"

@interface SignUpViewController (){
    UIDatePicker *datePicker;
    NSInteger tag;
    UIImage *savedImage;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileImageViewOutlet.layer.cornerRadius = 75.0;
    self.profileImageViewOutlet.clipsToBounds = YES;
    self.profileImageViewOutlet.userInteractionEnabled = YES;
    
    self.firstNameTextfieldOutlet.delegate = self;
    self.lastNameTextifieldOutlet.delegate = self;
    self.emailTextfieldOutlet.delegate = self;
    self.passwordTextfieldOutlet.delegate = self;
    self.conformPasswordTextifieldOutlet.delegate = self;
    self.cityTextfieldOutlet.delegate = self;
    self.stateTextfieldOutlet.delegate = self;
    self.countryTextfieldOutlet.delegate = self;
    self.phoneNumberTextfieldOutlet.delegate = self;
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.profileImageViewOutlet addGestureRecognizer:singleTap];
    
    self.signUpButtonOutlet.layer.cornerRadius = 20.0;
    self.signUpButtonOutlet.layer.masksToBounds = YES;
    
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    [self.dateOfBirthTextFieldOutlet setInputView:datePicker];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(showSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    
    [self.dateOfBirthTextFieldOutlet setInputAccessoryView:toolBar];
    self.dateOfBirthTextFieldOutlet.tag = 30;
    
}
-(void)showSelectedDate{
    NSDateFormatter *dtfrm1 = [[NSDateFormatter alloc] init];
    //        [dtfrm1 setTimeZone:[NSTimeZone timeZoneWithAbbreviation: @"GMT"]];
    [dtfrm1 setDateFormat:@"MM/dd/yyyy"];
    NSString *nDate1 = [dtfrm1 stringFromDate:datePicker.date];
    self.dateOfBirthTextFieldOutlet.text = [NSString stringWithFormat:@"%@",nDate1];
    [self.dateOfBirthTextFieldOutlet resignFirstResponder];
}
// Dismiss Keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:TRUE];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.passwordTextfieldOutlet.secureTextEntry = YES;
    self.conformPasswordTextifieldOutlet.secureTextEntry = YES;
}
-(void)singleTapping:(UIGestureRecognizer *)recognizer {
    NSLog(@"single tapping");
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"You can access camera or photo library..!!!" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertActionCamera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    #if TARGET_IPHONE_SIMULATOR
            UIAlertController *alretController = [UIAlertController alertControllerWithTitle:@"OOPS" message:@"You can't use the camera in simulator" preferredStyle:UIAlertControllerStyleAlert];
        
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            [alretController addAction:ok];
            [self presentViewController:alretController animated:YES completion:nil];
            return;
        
    #else
        
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.showsCameraControls = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        
    #endif
        
    }];
    UIAlertAction *alertActionPhotoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.allowsEditing = YES;
        pickerView.delegate = self;
        [pickerView setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:pickerView animated:YES completion:nil];
    }];
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertControl addAction:alertActionCamera];
    [alertControl addAction:alertActionPhotoLibrary];
    [alertControl addAction:alertActionCancel];
    [self presentViewController:alertControl animated:YES completion:nil];
    
}
#pragma mark - Image picker controller delegate and datasource
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    savedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.profileImageViewOutlet.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageViewOutlet.clipsToBounds = YES;
    self.profileImageViewOutlet.image=savedImage;
}
#pragma mark - UItextfield delegate and datasource
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)showAlertMessage:(NSString *)message flag:(BOOL)flag{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alertController addAction:defaultAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)signUpBtnAction:(id)sender {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *firstNameStr = self.firstNameTextfieldOutlet.text;
    NSString *trimFirstName = [firstNameStr stringByTrimmingCharactersInSet:whitespace];
    
    NSString *lastNameStr = self.lastNameTextifieldOutlet.text;
    
    NSString *dateofbirthStr = self.dateOfBirthTextFieldOutlet.text;
    
    NSString *emailStr = self.emailTextfieldOutlet.text;
    NSString *trimEmail = [emailStr stringByTrimmingCharactersInSet:whitespace];
    
    NSString *passwordStr = self.passwordTextfieldOutlet.text;
    NSString *trimPasswordStr = [passwordStr stringByTrimmingCharactersInSet:whitespace];
    
    NSString *genderStr = @"";
    if(self.genderSegmentControlOutlet.selectedSegmentIndex == 0){
        genderStr = @"Male";
    }else if(self.genderSegmentControlOutlet.selectedSegmentIndex == 1){
        genderStr = @"Female";
    }else{
        genderStr = @"Transgender";
    }
    
    NSString *conformPasswordStr = self.conformPasswordTextifieldOutlet.text;
    NSString *trimConformPasswordStr = [conformPasswordStr stringByTrimmingCharactersInSet:whitespace];
    
    NSString *phoneNumber = self.phoneNumberTextfieldOutlet.text;
    
    NSString *cityStr = self.cityTextfieldOutlet.text;
    NSString *trimCityStr = [cityStr stringByTrimmingCharactersInSet:whitespace];
    
    NSString *stateStr = self.stateTextfieldOutlet.text;
    NSString *trimStateStr = [stateStr stringByTrimmingCharactersInSet:whitespace];
    
    NSString *countryStr = self.countryTextfieldOutlet.text;
    
    if([firstNameStr isEqualToString:@""] || [trimFirstName length] == 0){
        [self showAlertMessage:@"Please enter your name" flag:YES];
    }else if([emailStr isEqualToString:@""] || [trimEmail length] == 0){
         [self showAlertMessage:@"Please enter your email" flag:YES];
    }else if([passwordStr isEqualToString:@""] || [trimPasswordStr length] == 0){
           [self showAlertMessage:@"Please enter a password" flag:YES];
    }else if([conformPasswordStr isEqualToString:@""] || [trimConformPasswordStr length] == 0){
           [self showAlertMessage:@"Please enter a conform password" flag:YES];
    }else if(![passwordStr isEqualToString:conformPasswordStr]){
           [self showAlertMessage:@"password and conform password mismatched" flag:YES];
    }else if([cityStr isEqualToString:@""] || [trimCityStr length] == 0){
           [self showAlertMessage:@"Please enter your city" flag:YES];
    }else if([stateStr isEqualToString:@""] || [trimStateStr length] == 0){
           [self showAlertMessage:@"Please enter your state" flag:YES];
    }else{
        NSMutableDictionary *registrationDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%@",firstNameStr],@"firstName",
                            [NSString stringWithFormat:@"%@",lastNameStr],@"lastName",
                            [NSString stringWithFormat:@"%@",dateofbirthStr],@"dateofbirth",
                            [NSString stringWithFormat:@"%@",genderStr],@"gender",
                            [NSString stringWithFormat:@"%@",emailStr],@"email",
                            [NSString stringWithFormat:@"%@",passwordStr],@"password",
                            [NSString stringWithFormat:@"%@",conformPasswordStr],@"conformPassword",
                            [NSString stringWithFormat:@"%@",phoneNumber],@"phoneNumber",
                            [NSString stringWithFormat:@"%@",cityStr],@"city",
                            [NSString stringWithFormat:@"%@",stateStr],@"state",
                            [NSString stringWithFormat:@"%@",countryStr],@"country",
                            savedImage,@"image"
                            , nil];
        NSLog(@"registration dict %@",registrationDict);
        UserListViewController *userListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserListViewController"];
        userListViewController.getDict = registrationDict;
        [self.navigationController pushViewController:userListViewController animated:YES];
//        if([NSJSONSerialization isValidJSONObject:registrationDict]){
//            NSLog(@"registration dict %@",registrationDict);
//            NSError* error;
//            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:registrationDict options:NSJSONWritingPrettyPrinted error: &error];
//            NSLog(@"Json Data %@",jsonData);
//        }else{
//            NSLog(@"Not proper json");
//        }
    }
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
