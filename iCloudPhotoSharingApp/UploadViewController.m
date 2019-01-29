//
//  UploadViewController.m
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 11/01/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import "UploadViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
 #import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

@interface UploadViewController (){
    UIImage *image ;
    NSURL *videoURL;
    AVPlayer *player;
    NSString *videoUrlStr;
    NSString *moviePath;
    UIActivityIndicatorView *myActivityIndicator;
}

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self.avPlayerView setHidden:YES];
    [self.imageSuperView setHidden:YES];
    [self.initialView setHidden:NO];
    self.threeButtonView.layer.borderWidth = 0.5f;
    self.threeButtonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cameraView.layer.borderWidth =  0.5f;
    self.cameraView.layer.borderColor =  [UIColor lightGrayColor].CGColor;
    self.videoView.layer.borderWidth =  0.5f;
    self.videoView.layer.borderColor =  [UIColor lightGrayColor].CGColor;
    self.galleryView.layer.borderWidth =  0.5f;
    self.galleryView.layer.borderColor =  [UIColor lightGrayColor].CGColor;
    self.iCloudView.layer.borderWidth =  0.5f;
    self.iCloudView.layer.borderColor =  [UIColor lightGrayColor].CGColor;
    self.gDriveView.layer.borderWidth =  0.5f;
    self.gDriveView.layer.borderColor =  [UIColor lightGrayColor].CGColor;
    self.dropBoxView.layer.borderWidth =  0.5f;
    self.dropBoxView.layer.borderColor =  [UIColor lightGrayColor].CGColor;
    myActivityIndicator = [[UIActivityIndicatorView alloc]init];
}
- (void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:YES];
    

}
- (IBAction)cameraBtnAction:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.showsCameraControls = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)videoBtnAction:(id)sender {
    
//    UIImagePickerController *pickerVideo = [[UIImagePickerController alloc] init];
//    pickerVideo.sourceType = UIImagePickerControllerSourceTypeCamera;
//    pickerVideo.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, nil];
//    pickerVideo.delegate = self;
//    [self presentViewController:pickerVideo animated:YES completion:nil];
    
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self;
    videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    videoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    videoPicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,(NSString *)kUTTypeVideo, nil];
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    [self presentViewController:videoPicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];

    // For video
    videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    videoUrlStr = [NSString stringWithFormat:@"%@",videoURL];
    if([videoUrlStr containsString:@".MOV"]){
        player = [AVPlayer playerWithURL:videoURL];
        AVAsset *asset = [AVAsset assetWithURL:videoURL];
        
        // Calculate a time for the snapshot - I'm using the half way mark.
        CMTime duration = [asset duration];
        CMTime snapshot = CMTimeMake(duration.value / 2, duration.timescale);
        
        // Create a generator and copy image at the time.
        // I'm not capturing the actual time or an error.
        AVAssetImageGenerator *generator =
        [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        CGImageRef imageRef = [generator copyCGImageAtTime:snapshot
                                                actualTime:nil
                                                     error:nil];
        
        // Make a UIImage and release the CGImage.
        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        self.videoThumbnailImageView.image = thumbnail;
        CGImageRelease(imageRef);
        [self.view addSubview:self.avPlayerView];
        [self.avPlayerView setHidden:NO];
        [_initialView setHidden:YES];
        [_imageSuperView setHidden:YES];
        
    }else{
//         For Image
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.imageViewOutlet.image=image;
        [self.avPlayerView setHidden:YES];
        [self.initialView setHidden:YES];
        [self.imageSuperView setHidden:NO];
       
    }

    // For saving video to gallery
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];

    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        moviePath = [videoUrl path];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)closeBtnAction:(id)sender {
    
            if([videoUrlStr containsString:@".MOV"]){
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure want to clear the video" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          self->videoURL = [[NSURL alloc] init];
                            [self.avPlayerView setHidden:YES];
                            [self.initialView setHidden:NO];
                            [self.imageSuperView setHidden:YES];
                }];
                
                UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                }];
                
                [alertControl addAction:alertActionOk];
                [alertControl addAction:alertActionCancel];
                [self presentViewController:alertControl animated:YES completion:nil];
                
                
            }else{
                
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure want to clear the image" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            self.imageViewOutlet.image = nil;
                            [self.avPlayerView setHidden:YES];
                            [self.initialView setHidden:NO];
                            [self.imageSuperView setHidden:YES];
                }];
                
                UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                
                [alertControl addAction:alertActionOk];
                [alertControl addAction:alertActionCancel];
                [self presentViewController:alertControl animated:YES completion:nil];
                
            }
    
}

- (IBAction)iCloudBtnAction:(id)sender {
    // Import

    NSArray *types = @[(NSString*)kUTTypeImage,(NSString*)kUTTypeSpreadsheet,(NSString*)kUTTypePresentation,(NSString*)kUTTypeDatabase,(NSString*)kUTTypeFolder,(NSString*)kUTTypeZipArchive,(NSString*)kUTTypeVideo];

    //Create a object of document picker view and set the mode to Import
    UIDocumentPickerViewController *docPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeImport];

    //Set the delegate
    docPicker.delegate = self;
    //present the document picker
    [self presentViewController:docPicker animated:YES completion:nil];
    
    // Export
//    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"image" withExtension:@"jpg"] inMode:UIDocumentPickerModeExportToService];
//    documentPicker.delegate = self;
//    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self presentViewController:documentPicker animated:YES completion:nil];
    
}
#pragma mark - iCloud files
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        
        //Showing alert for success
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *alertMessage = [NSString stringWithFormat:@"Successfully downloaded file %@", [url lastPathComponent]];
            NSString *extraAlertMessage = [alertMessage stringByAppendingString:@". Now you can see the image in your view"];
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"UIDocumentView"
                                                  message:extraAlertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSData *fileData = [NSData dataWithContentsOfURL:url];
                self->image = [UIImage imageWithData:fileData];
                self.imageViewOutlet.image = self->image;
                [self.initialView setHidden:YES];
                [self.avPlayerView setHidden:YES];
                [self.imageSuperView setHidden:NO];
            }];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
        // Always this will not executed because we need to icloud permission in our developer account
    }else  if (controller.documentPickerMode == UIDocumentPickerModeExportToService)
    {
        // Called when user uploaded the file - Display success alert
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *alertMessage = [NSString stringWithFormat:@"Successfully uploaded file %@", [url lastPathComponent]];
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"UIDocumentView"
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
    }
    
    //        NSString *alertMessage = [NSString stringWithFormat:@"%@", [url lastPathComponent]];
    //        NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
    //        NSError *error = nil;
    //        [coordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
    //            NSData *data = [NSData dataWithContentsOfURL:newURL];
    //            // Do something
    //            NSLog(@"data %@",data);
    //
    //        }];
    //        if (error) {
    //            NSLog(@"Error %@",error);
    //        }
    
    // Condition called when user download the file
    
    // NSData of the content that was downloaded - Use this to upload on the server or save locally in directory
}
- (IBAction)saveBtnAction:(id)sender {
    if(_imageViewOutlet.image != nil || self.videoThumbnailImageView.image !=nil){
        if([videoUrlStr containsString:@".MOV"]){

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Video saved successfully to your gallery" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //button click event
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (self->moviePath)) {
                    UISaveVideoAtPathToSavedPhotosAlbum (self->moviePath, nil, nil, nil);
                }
                self.imageViewOutlet.image = nil;
                [self.avPlayerView setHidden:YES];
                [self.initialView setHidden:NO];
                [self.imageSuperView setHidden:YES];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Picture saved successfully to your gallery" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //button click event
                NSError *error;
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *oldDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *newDirectory = [oldDirectory stringByAppendingPathComponent:@"DriveStore"];
                if([fileManager createDirectoryAtPath:newDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
                    NSLog(@"File created successfully");
                    UIImageWriteToSavedPhotosAlbum(self->image, nil, nil, nil);
                    self.imageViewOutlet.image = nil;
                    [self.avPlayerView setHidden:YES];
                    [self.initialView setHidden:NO];
                    [self.imageSuperView setHidden:YES];
                }else{
                    NSLog(@"Error %@",error);
                }
               
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please choose image or video" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //button click event
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)galleryButtonAction:(id)sender {
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    pickerView.allowsEditing = YES;
    pickerView.delegate = self;
    [pickerView setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:pickerView animated:YES completion:nil];
}

- (IBAction)playVideo:(id)sender {
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = player;
    playerViewController.view.frame = self.avPlayerView.bounds;
    [player seekToTime:kCMTimeZero];
    [player play];
    [self presentViewController:playerViewController animated:YES completion:nil];
}
- (IBAction)gDriveSaveButtonAction:(id)sender {
    
}

- (IBAction)dropBoxButtonAction:(id)sender {
    [DBClientsManager authorizeFromController:[UIApplication sharedApplication]
                                   controller:[[self class] topMostController]
                                      openURL:^(NSURL *url) {
                                          [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
                                              NSLog(@"Successfully opened");
                                          }];
                                      }];
    
    //     Create a Folder into dropbox
    DBUserClient *client = [[DBUserClient alloc] initWithAccessToken:@"IDRSnqyzURAAAAAAAAAAK_RtLotUel8h9FJ2wx2O0YN228jQhZRUNTT7ogQCFYVU"];
//    NSData *imageData = UIImagePNGRepresentation(image);
    NSData *fileData = [@"Hi how are you" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    // For overriding on upload
    DBFILESWriteMode *mode = [[DBFILESWriteMode alloc] initWithOverwrite];
    [[[client.filesRoutes uploadData:@"/t/d/a.txt"
                                    mode:mode
                                    autorename:@(YES)
                                    clientModified:nil
                                    mute:@(NO)
                                    propertyGroups:nil
                                    strictConflict:@(NO)
                                    inputData:fileData]
      setResponseBlock:^(DBFILESFileMetadata *result, DBFILESUploadError *routeError, DBRequestError *networkError) {
          if (result) {
              NSLog(@"%@\n", result);
          } else {
              NSLog(@"%@\n%@\n", routeError, networkError);
          }
      }] setProgressBlock:^(int64_t bytesUploaded, int64_t totalBytesUploaded, int64_t totalBytesExpectedToUploaded) {
          NSLog(@"\n%lld\n%lld\n%lld\n", bytesUploaded, totalBytesUploaded, totalBytesExpectedToUploaded);
      }];
}
+ (UIViewController*)topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}
@end
