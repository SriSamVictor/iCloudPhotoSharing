//
//  UploadViewController.h
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 11/01/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIDocumentPickerDelegate>
@property (weak, nonatomic) IBOutlet UIView *imageSuperView;
- (IBAction)cameraBtnAction:(id)sender;
- (IBAction)videoBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOutlet;
- (IBAction)closeBtnAction:(id)sender;
- (IBAction)iCloudBtnAction:(id)sender;
- (IBAction)saveBtnAction:(id)sender;
- (IBAction)galleryButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *avPlayerView;
- (IBAction)playVideo:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *initialView;
- (IBAction)gDriveSaveButtonAction:(id)sender;
- (IBAction)dropBoxButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *threeButtonView;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIView *galleryView;
@property (weak, nonatomic) IBOutlet UIImageView *videoThumbnailImageView;
@property (weak, nonatomic) IBOutlet UIView *iCloudView;
@property (weak, nonatomic) IBOutlet UIView *gDriveView;
@property (weak, nonatomic) IBOutlet UIView *dropBoxView;
@property(strong,nonatomic)NSError *error;
@end

NS_ASSUME_NONNULL_END