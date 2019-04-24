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
#import <SVProgressHUD/SVProgressHUD.h>
#import <NSGIF/NSGIF.h>
#import "TextEditorViewController.h"
#import "GalleryViewController.h"
#import "SignUpViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "AppDelegate.h"
#import "UIViewController+LMSideBarController.h"

@interface UploadViewController (){
    UIImage *savedImage ;
    NSURL *videoURL;
    AVPlayer *player;
    NSString *videoUrlStr;
    NSString *moviePath;
    UIActivityIndicatorView *myActivityIndicator;
    NSString *newFileDirectory;
    NSString *newVideoPath;
}

@end

@implementation UploadViewController
@synthesize collectionImageArray;

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
    
    UIColor *borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
    _contentTextView.layer.borderColor = borderColor.CGColor;
    _contentTextView.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    _contentTextView.layer.borderWidth = 1.0;
    _contentTextView.layer.cornerRadius = 5.0;
    
    _formatTextField.layer.borderColor = borderColor.CGColor;
    _formatTextField.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    _formatTextField.layer.borderWidth = 1.0;
    _formatTextField.layer.cornerRadius = 5.0;
    
    _titleTextField.layer.borderColor = borderColor.CGColor;
    _titleTextField.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    _titleTextField.layer.borderWidth = 1.0;
    _titleTextField.layer.cornerRadius = 5.0;
    
    self.profileImageViewOutlet.layer.cornerRadius = 25.0;
    self.profileImageViewOutlet.clipsToBounds = YES;
    
    collectionImageArray = [[NSMutableArray alloc]init];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _nameStr = appDelegate.givenName;
    _urlProfileImage = appDelegate.urlProfileImage;//..to read
    NSLog(@"Name %@",_nameStr);
    NSLog(@"url %@",_urlProfileImage);
    NSString *urlProfileImageStr = _urlProfileImage.absoluteString;
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlProfileImageStr]];
    if(imageData != nil){
        self.nameLabelOutlet.hidden = YES;
        self.profileImageViewOutlet.hidden = NO;
        self.profileImageViewOutlet.image = [UIImage imageWithData:imageData];
    }else{
        self.nameLabelOutlet.hidden = NO;
        self.profileImageViewOutlet.hidden = YES;
        self.nameLabelOutlet.text = [[UIDevice currentDevice]name];
    }
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.profileImageViewOutlet setUserInteractionEnabled:YES];
    [self.profileImageViewOutlet addGestureRecognizer:singleTap];
}
-(void)singleTapping:(UIGestureRecognizer *)recognizer {
    NSLog(@"Hello");
    [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionLeft];
}
- (void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:YES];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *oldDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSMutableArray *fileCreationArray = [NSMutableArray arrayWithObjects:@"Others",@"Video",@"Pictures", nil];
    NSString *newDirectory;
    for(int i = 0; i < [fileCreationArray count];i++){
        newDirectory = [fileCreationArray objectAtIndex:i];
        newFileDirectory = [oldDirectory stringByAppendingPathComponent:newDirectory];
        NSError *error;
        if([fileManager createDirectoryAtPath:newFileDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            NSLog(@"File created successfully");
        }else{
            NSLog(@"File Already Exists");
        };
    }
    if(self.imageViewOutlet.image != nil){
        self.initialView.hidden = YES;
        self.avPlayerView.hidden = YES;
        self.imageSuperView.hidden = NO;
        self.textEditorView.hidden = YES;
    }else if(videoURL.absoluteString.length != 0){
        self.initialView.hidden = YES;
        self.avPlayerView.hidden = NO;
        self.imageSuperView.hidden = YES;
        self.textEditorView.hidden = YES;
    }else{
        if(_valuesDict != NULL && ![self.valuesDict isEqualToDictionary:@{}]){
                self.initialView.hidden = YES;
                self.avPlayerView.hidden = YES;
                self.imageSuperView.hidden = YES;
                self.textEditorView.hidden = NO;
                self.titleTextField.text = [_valuesDict valueForKey:@"title"];
                self.contentTextView.text = [_valuesDict valueForKey:@"content"];
                self.formatTextField.text = [_valuesDict valueForKey:@"format"];
                self.imageViewOutlet.image = nil;
                videoURL = [NSURL URLWithString:@""];
            }else if(self.imageViewOutlet.image != nil){
                self.initialView.hidden = YES;
                self.avPlayerView.hidden = YES;
                self.imageSuperView.hidden = NO;
                self.textEditorView.hidden = YES;
            }else if(videoURL.absoluteString.length != 0){
                self.initialView.hidden = YES;
                self.avPlayerView.hidden = NO;
                self.imageSuperView.hidden = YES;
                self.textEditorView.hidden = YES;
            }else{
                self.initialView.hidden = NO;
                self.avPlayerView.hidden = YES;
                self.imageSuperView.hidden = YES;
                self.textEditorView.hidden = YES;
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

}
- (IBAction)cameraBtnAction:(id)sender {
    if(![self.textEditorView isHidden]){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure want to clear your text editor or click to save..!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.titleTextField.text = @"";
            self.contentTextView.text = @"";
            self.formatTextField.text = @"";
            self.imageSuperView.hidden = YES;
            self.textEditorView.hidden = YES;
            self.avPlayerView.hidden = NO;
            self.videoThumbnailImageView.hidden = YES;
            [self cameraMethod];
        }];
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:alertActionOk];
        [alertControl addAction:alertActionCancel];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else if(self.imageViewOutlet.image != nil){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Already your image was there. Are you sure you want to clear..!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.imageViewOutlet.image = nil;
            [self cameraMethod];
        }];
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:alertActionOk];
        [alertControl addAction:alertActionCancel];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else if(videoURL.absoluteString.length != 0){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure want to clear the video or else click to save..!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             self->videoURL = [NSURL URLWithString:@""];
            [self cameraMethod];
        }];
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:alertActionOk];
        [alertControl addAction:alertActionCancel];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else{
        [self cameraMethod];
    }
}
-(void)cameraMethod{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.showsCameraControls = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)videoBtnAction:(id)sender {
    if(![self.textEditorView isHidden]){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure want to clear your text editor or click to save..!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.titleTextField.text = @"";
            self.contentTextView.text = @"";
            self.formatTextField.text = @"";
            self.imageSuperView.hidden = YES;
            self.textEditorView.hidden = YES;
            self.avPlayerView.hidden = NO;
            self.videoThumbnailImageView.hidden = YES;
            [self videoCamMethod];
        }];
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:alertActionOk];
        [alertControl addAction:alertActionCancel];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else if(self.imageViewOutlet.image != nil){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure want to clear the image or else click to save..!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.imageViewOutlet.image = nil;
            [self videoCamMethod];
        }];
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:alertActionOk];
        [alertControl addAction:alertActionCancel];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else if(videoURL.absoluteString.length != 0){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Already your video was there. Are you sure you want to clear..!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->videoURL = [NSURL URLWithString:@""];
            [self videoCamMethod];
        }];
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:alertActionOk];
        [alertControl addAction:alertActionCancel];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else{
        [self videoCamMethod];
    }
}
-(void)videoCamMethod{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
        videoPicker.delegate = self;
        videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        videoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        videoPicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,(NSString *)kUTTypeVideo, nil];
        videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        [self presentViewController:videoPicker animated:YES completion:nil];
    });
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];

    // For video
    videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    videoUrlStr = [NSString stringWithFormat:@"%@",videoURL];
    if([videoUrlStr containsString:@".MOV"]){
        player = [AVPlayer playerWithURL:videoURL];
        [SVProgressHUD showWithStatus:@"Please wait"];
        
        // Thumbnail images as gif
        [NSGIF optimalGIFfromURL:videoURL loopCount:0 completion:^(NSURL *GifURL) {
            
            NSLog(@"Finished generating GIF: %@", GifURL);
            [SVProgressHUD dismiss];
            [UIView animateWithDuration:0.3 animations:^{
                self.webView.alpha = 1.0f;
            }];
            [self.webView loadRequest:[NSURLRequest requestWithURL:GifURL]];
        }];
        
        // Thumbnail Images
//        AVAsset *asset = [AVAsset assetWithURL:videoURL];
//
//        // Calculate a time for the snapshot - I'm using the half way mark.
//        CMTime duration = [asset duration];
//        CMTime snapshot = CMTimeMake(duration.value / 2, duration.timescale);
//
//        // Create a generator and copy image at the time.
//        // I'm not capturing the actual time or an error.
//        AVAssetImageGenerator *generator =
//        [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
//        CGImageRef imageRef = [generator copyCGImageAtTime:snapshot
//                                                actualTime:nil
//                                                     error:nil];
//
//        // Make a UIImage and release the CGImage.
//        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
//        self.videoThumbnailImageView.image = thumbnail;
//        CGImageRelease(imageRef);
//
//        [self.view addSubview:self.avPlayerView];
        
        [self.avPlayerView setHidden:NO];
        [_initialView setHidden:YES];
        [_imageSuperView setHidden:YES];
        [_textEditorView setHidden:YES];
        
    }else{
//     For Image
        savedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.imageViewOutlet.contentMode = UIViewContentModeScaleAspectFill;
        self.imageViewOutlet.clipsToBounds = YES;
        self.imageViewOutlet.image=savedImage;
        [self.avPlayerView setHidden:YES];
        [self.initialView setHidden:YES];
        [self.imageSuperView setHidden:NO];
        [self.textEditorView setHidden:YES];
       
    }
    // For saving video to gallery
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];

    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        moviePath = [videoUrl path];
    }
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    self.valuesDict = [[NSMutableDictionary alloc]init];
    self.textEditorView.hidden =YES;
    self.initialView.hidden = NO;
    self.avPlayerView.hidden = YES;
    self.imageSuperView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)closeBtnAction:(id)sender {
    
    if(![self.textEditorView isHidden]){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure want to clear all the textfields" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.titleTextField.text = @"";
            self.contentTextView.text = @"";
            self.formatTextField.text = @"";
            self.valuesDict = [[NSMutableDictionary alloc] init];
            [self.avPlayerView setHidden:YES];
            [self.initialView setHidden:NO];
            [self.imageSuperView setHidden:YES];
            [self.textEditorView setHidden:YES];
        }];
        
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertControl addAction:alertActionOk];
        [alertControl addAction:alertActionCancel];
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }else{

        if(self.imageViewOutlet.image != nil || videoURL.absoluteString.length != 0){
            if([videoUrlStr containsString:@".MOV"]){
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure want to clear the video" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self->videoURL = [[NSURL alloc] init];
                    [self.avPlayerView setHidden:YES];
                    [self.initialView setHidden:NO];
                    [self.imageSuperView setHidden:YES];
                    [self.textEditorView setHidden:YES];
                }];
                
                UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertControl addAction:alertActionOk];
                [alertControl addAction:alertActionCancel];
                [self presentViewController:alertControl animated:YES completion:nil];
                
            }else{
                
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Already you placed the image from gallery. Are you sure you want to clear..!!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    self.imageViewOutlet.image = nil;
                    [self.avPlayerView setHidden:YES];
                    [self.initialView setHidden:NO];
                    [self.imageSuperView setHidden:YES];
                    [self.textEditorView setHidden:YES];
                }];
                
                UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                
                [alertControl addAction:alertActionOk];
                [alertControl addAction:alertActionCancel];
                [self presentViewController:alertControl animated:YES completion:nil];
                
            }
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"There is no more image or video. why you click clear button. Its paining for clear button...!!!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //button click event
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
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
#pragma mark - iCloud delegate and datasource
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
                self->savedImage = [UIImage imageWithData:fileData];
                self.imageViewOutlet.contentMode = UIViewContentModeScaleAspectFill;
                self.imageViewOutlet.clipsToBounds = YES;
                self.imageViewOutlet.image = self->savedImage;
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
    
    if(![self.textEditorView isHidden]){
        
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Your text will be saved in the others folder in local storage..!!!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //button click event
            
                [SVProgressHUD show];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *searchFolderName = @"Others";
                    NSString *newOthersDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    
                    NSPredicate *predicateOtherFolder = [NSPredicate predicateWithFormat:@"self.lastPathComponent == %@", searchFolderName];
                    NSArray *matchingPaths = [[[NSFileManager defaultManager] subpathsAtPath:newOthersDirectory] filteredArrayUsingPredicate:predicateOtherFolder];
                    NSString *OtherFolderStr = [matchingPaths objectAtIndex:0];
                    NSString *newOtherPath = [newOthersDirectory stringByAppendingPathComponent:OtherFolderStr];
                    NSString *newFilePath = [newOtherPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@%@",self.titleTextField.text,self.formatTextField.text]];
                    NSData *fileData = [self.contentTextView.text dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
                    BOOL successData = [fileData writeToFile:newFilePath atomically:YES];
                    NSLog(@"sucess data-- %d",successData);
                    self.valuesDict = [@{} mutableCopy];
                });
                });
                [SVProgressHUD dismiss];
                self.initialView.hidden = NO;
                self.avPlayerView.hidden = YES;
                self.imageSuperView.hidden = YES;
                self.textEditorView.hidden = YES;
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        
    }else if(_imageViewOutlet.image != nil || videoURL.absoluteString.length != 0){
        if([videoUrlStr containsString:@".MOV"]){

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Video saved successfully to your gallery and files app...!!!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //button click event
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (self->moviePath)) {
                    UISaveVideoAtPathToSavedPhotosAlbum (self->moviePath, nil, nil, nil);
                }
                    [self.avPlayerView setHidden:YES];
                    [self.initialView setHidden:NO];
                    [self.imageSuperView setHidden:YES];
                NSString *searchFolderName = @"Video";
                NSString *newVideoDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.lastPathComponent == %@", searchFolderName];
                NSArray *matchingPaths = [[[NSFileManager defaultManager] subpathsAtPath:newVideoDirectory] filteredArrayUsingPredicate:predicate];
                NSLog(@"%@", matchingPaths);
                NSString *videoStr = [matchingPaths objectAtIndex:0];
                self->newVideoPath = [newVideoDirectory stringByAppendingPathComponent:videoStr];
                [self saveVideo:self->moviePath pathString:self->newVideoPath];
                self->videoURL = [[NSURL alloc] init];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Picture saved successfully to your gallery and files app...!!!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //button click event
                        UIImageWriteToSavedPhotosAlbum(self->savedImage, nil, nil, nil);
                        [self saveImage:self->savedImage pathString:self->newFileDirectory];
                        self.imageViewOutlet.image = nil;
                        [self.avPlayerView setHidden:YES];
                        [self.imageSuperView setHidden:YES];
                        [self.initialView setHidden:NO];
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
// Generate Random string
- (NSString *)genRandStringLength:(int)len {
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}
// Save the image in the files
- (void)saveImage: (UIImage*)image pathString:(NSString *)pathString
{
    if (image != nil)
    {
        if([pathString containsString:@"Pictures"]){
            NSString *randomString =  [self genRandStringLength:5];
            NSString *randomStringGenerator = [randomString stringByAppendingString:@".JPEG"];
            NSString* path = [pathString stringByAppendingPathComponent:randomStringGenerator];
            NSData* data = UIImagePNGRepresentation(image);
            [data writeToFile:path atomically:YES];
            [collectionImageArray addObject:savedImage];
        }else{
            NSLog(@"We can't support another file");
        }
    }
}
// Save the video in the files
-(void)saveVideo: (NSString *)movieUrl pathString:(NSString *)pathString
{
        if([pathString containsString:@"Video"]){
            NSURL *videourl = [NSURL URLWithString:videoUrlStr];
            NSData *videoData = [NSData dataWithContentsOfURL:videourl];
           NSString *newRandomStr =  [NSString stringWithFormat:@"%@/%@%@",pathString,[self genRandStringLength:5],@".mp4"];
            BOOL success = [videoData writeToFile:newRandomStr atomically:NO];
            NSLog(@"success %d",success);
        }else{
             NSLog(@"We can't support another file");
        }
}

- (IBAction)galleryButtonAction:(id)sender {
    if(![self.textEditorView isHidden]){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure want to clear your text editor or click to save..!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.titleTextField.text = @"";
            self.contentTextView.text = @"";
            self.formatTextField.text = @"";
            self.imageSuperView.hidden = YES;
            self.textEditorView.hidden = YES;
            self.avPlayerView.hidden = NO;
            self.videoThumbnailImageView.hidden = YES;
            [self galleryMethod];
        }];
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:alertActionOk];
        [alertControl addAction:alertActionCancel];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else if(self.imageViewOutlet.image != nil){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Already your image was there. Are you sure you want to clear!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.imageViewOutlet.image = nil;
            [self galleryMethod];
        }];
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:alertActionOk];
        [alertControl addAction:alertActionCancel];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else if(videoURL.absoluteString.length != 0){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure want to clear the video or else click to save..!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->videoURL = [NSURL URLWithString:@""];
            [self galleryMethod];
        }];
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:alertActionOk];
        [alertControl addAction:alertActionCancel];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else{
        [self galleryMethod];
    }
}
-(void)galleryMethod{
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
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Coming soon...!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertControl addAction:alertActionOk];
    [self presentViewController:alertControl animated:YES completion:nil];
}
#pragma mark - Dropbox Methods
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
    [[[client.filesRoutes uploadData:@"/t/d"
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
#pragma mark - Other Button Action
- (IBAction)OthersButtonAction:(id)sender {
    if(![self.textEditorView isHidden]){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Already you edit something. Do you want to clear it. Click ok to clear..!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.titleTextField.text = @"";
            self.contentTextView.text = @"";
            self.formatTextField.text = @"";
            self.imageSuperView.hidden = YES;
            self.textEditorView.hidden = YES;
            self.avPlayerView.hidden = NO;
            self.videoThumbnailImageView.hidden = YES;
            [self galleryMethod];
        }];
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:alertActionOk];
        [alertControl addAction:alertActionCancel];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else if(self.imageViewOutlet.image != nil){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Click to save the image or click to clear the image. Decision is yours" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIImageWriteToSavedPhotosAlbum(self->savedImage, nil, nil, nil);
                [self saveImage:self->savedImage pathString:self->newFileDirectory];
                [self redirectOthersViewController];
                self.imageViewOutlet.image = nil;
            }];
        
        UIAlertAction *alertActionClear = [UIAlertAction actionWithTitle:@"Clear" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self redirectOthersViewController];
                self.imageViewOutlet.image = nil;
        }];
        
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertControl addAction:alertActionOk];
        [alertControl addAction:alertActionClear];
        [alertControl addAction:alertActionCancel];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else if(videoURL.absoluteString.length != 0){
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Click to save the video or click to clear the video. Decision is yours" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (self->moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum (self->moviePath, nil, nil, nil);
            }
            [self saveVideo:self->moviePath pathString:self->newVideoPath];
            [self redirectOthersViewController];
           }];
        
        UIAlertAction *alertActionClear = [UIAlertAction actionWithTitle:@"Clear" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self redirectOthersViewController];
            self->videoURL = [NSURL URLWithString:@""];
        }];
        
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:alertActionOk];
        [alertControl addAction:alertActionClear];
        [alertControl addAction:alertActionCancel];
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }else{
        [self redirectOthersViewController];
    }
}
-(void)redirectOthersViewController{
    TextEditorViewController *textEditorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TextEditorViewController"];
    [self.navigationController pushViewController:textEditorViewController animated:YES];
}
- (IBAction)EditBtnAction:(id)sender {
    TextEditorViewController *textEditorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TextEditorViewController"];
    textEditorViewController.valuableDict = _valuesDict;
    [self.navigationController pushViewController:textEditorViewController animated:YES];
}

- (IBAction)galleryBtnAction:(id)sender {
    GalleryViewController *galleryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryViewController"];
    galleryViewController.collectedImageArray = collectionImageArray;
    [self.navigationController pushViewController:galleryViewController animated:YES];
}
- (IBAction)cancelBtnAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
