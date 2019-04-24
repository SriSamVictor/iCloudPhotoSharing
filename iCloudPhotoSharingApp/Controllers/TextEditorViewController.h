//
//  TextEditorViewController.h
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 31/01/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextEditorViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *formatTextField;
- (IBAction)saveBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backBtnAction;
- (IBAction)backBtnAction:(id)sender;

@property(strong,nonatomic)NSMutableDictionary *valuableDict;
@end

NS_ASSUME_NONNULL_END
