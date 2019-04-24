//
//  WelcomeViewController.h
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 14/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WelcomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photographerImage;
@property (weak, nonatomic) IBOutlet UIButton *loginBtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *registerBtnOutlet;
- (IBAction)loginBtnAction:(id)sender;
- (IBAction)registerBtnAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
