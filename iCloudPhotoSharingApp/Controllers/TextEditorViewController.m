//
//  TextEditorViewController.m
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 31/01/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import "TextEditorViewController.h"
#import "UploadViewController.h"

@interface TextEditorViewController (){
    NSMutableArray *formatArray;
    UIPickerView *formatPicker;
    UIToolbar *formatToolbar;
    NSString *textStr;
}

@end

@implementation TextEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleTextField.delegate = self;
    self.formatTextField.delegate = self;
    self.contentTextView.delegate = self;
    [self uiComponentsDesign];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.titleTextField.text = [self.valuableDict valueForKey:@"title"];
    self.contentTextView.text = [self.valuableDict valueForKey:@"content"];
    self.formatTextField.text = [self.valuableDict valueForKey:@"format"];
    
}
-(void)uiComponentsDesign{
    
    UIColor *borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
    _contentTextView.layer.borderColor = borderColor.CGColor;
    _contentTextView.layer.borderWidth = 1.0;
    _contentTextView.layer.cornerRadius = 5.0;

    formatArray = [[NSMutableArray  alloc] initWithObjects:@".PDF",@".txt",@".docx",@".rtf", nil];
    
    formatPicker = [[UIPickerView alloc]init];
    
    formatPicker = [[UIPickerView alloc]init];
    formatPicker.dataSource = self;
    formatPicker.delegate = self;
    formatPicker.showsSelectionIndicator = YES;
    self.formatTextField.inputView = formatPicker;
    
    formatToolbar = [[UIToolbar alloc] init];
    formatToolbar.frame=CGRectMake(0,0,180,44);
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(setSelectedValue:)];
    [formatToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    _formatTextField.inputAccessoryView = formatToolbar;
}

- (void)setSelectedValue:(id)sender{
    NSInteger row = [formatPicker selectedRowInComponent:0];
    self.formatTextField.text = [formatArray objectAtIndex:row];
    [_formatTextField resignFirstResponder];
}

// Dismiss Keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:TRUE];
}
#pragma mark - UITextfield Delegate and Datasource
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.titleTextField resignFirstResponder];
    return YES;
}
#pragma mark - UITextView Delegate and Datasource
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.contentTextView resignFirstResponder];
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
#pragma mark - UIPickerView Delegate and Datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return formatArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = [formatArray objectAtIndex:row];
    return title;
}

//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    textStr = [formatArray objectAtIndex:row];
//}
-(void)showAlertMessage :(NSString *) errorMsg andTimeFlag:(BOOL) flag
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                    }];
    [alert addAction:defaultAction];
    if(flag)
        //        [self assignValuesToSessionTiming];
        [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)saveBtnAction:(id)sender {

    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *titleStr = self.titleTextField.text;
    NSString *trimmedTitleStr = [titleStr stringByTrimmingCharactersInSet:whitespace];
    NSString *contentTextStr = self.contentTextView.text;
    NSString *trimmedContentTextStr = [contentTextStr stringByTrimmingCharactersInSet:whitespace];
    NSString *formatStr = self.formatTextField.text;
    NSString *trimmedFormatStr = [formatStr stringByTrimmingCharactersInSet:whitespace];
    
    if([titleStr isEqualToString:@"" ] || [trimmedTitleStr length] == 0 ){
        [self showAlertMessage:@"Please enter your title" andTimeFlag:YES];
    }else if([contentTextStr isEqualToString:@"" ] || [trimmedContentTextStr length] == 0 ){
        [self showAlertMessage:@"Please enter any content" andTimeFlag:YES];
    }else if([formatStr isEqualToString:@""] || [trimmedFormatStr length] == 0){
        [self showAlertMessage:@"Please choose any format" andTimeFlag:YES];
    }else{
        self.valuableDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             [NSString stringWithFormat:@"%@",titleStr],@"title",
                                             [NSString stringWithFormat:@"%@",contentTextStr],@"content",
                                             [NSString stringWithFormat:@"%@",formatStr],@"format"
                                             , nil];
        NSLog(@"Valuable Dict %@",self.valuableDict);
        UploadViewController *uploadViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadViewController"];
        for (uploadViewController in self.navigationController.viewControllers)
        {
            if ([uploadViewController isKindOfClass:[UploadViewController class]])
            {
                uploadViewController.valuesDict = self.valuableDict;
                [self.navigationController popToViewController:uploadViewController animated:YES];
                break;
            }
        }
    }
}

- (IBAction)backBtnAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
@end
