//
//  AboutViewController.m
//  Collages
//
//  Created by Ekaterina Belinskaya on 04/06/15.
//  Copyright (c) 2015 Ekaterina Belinskaya. All rights reserved.
//

#import "AboutViewController.h"
#import 

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
//@property (weak, nonatomic) IBOutlet UIView *logoFrameView;
//@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIButton *ratingMyAppOutlet;

@end


@implementation AboutViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
}

+ (void)initialize
{
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
    //[iRate sharedInstance].applicationBundleID = @"com.charcoaldesign.RainbowBlocksLite";
    
    //enable preview mode
    [iRate sharedInstance].previewMode = YES;
    
    //prevent automatic prompt
    [iRate sharedInstance].promptAtLaunch = NO;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = 100.0;
    self.logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.logoImageView.layer.borderWidth = 3.0f;
    self.logoImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.logoImageView.layer.shouldRasterize = YES;
    
    self.feedbackButton.layer.cornerRadius = 20.0;
    self.feedbackButton.clipsToBounds = YES;
    
    self.ratingMyAppOutlet.layer.cornerRadius = 20.0;
    self.ratingMyAppOutlet.clipsToBounds = YES;

}

- (IBAction)sendFeedback:(id)sender {
    // From within your active view controller
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@"Feedback of my application"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"sri.persnl@gmail.com"]];
        //[mailCont setMessageBody:@"Email message" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
    if(result == MFMailComposeResultSent)
    {
        UIAlertController *alertcontrol = [UIAlertController alertControllerWithTitle:@"" message:@"Mail Sent Successfully" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok  = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertcontrol addAction:ok];
        [self.navigationController presentViewController:alertcontrol animated:YES completion:nil];
    }
}
- (IBAction)rateApp:(id)sender {
    [[iRate sharedInstance] promptIfNetworkAvailable];
}
- (IBAction)backBtnAction:(id)sender {
    UploadViewController *uploadViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadViewController"];
    for (uploadViewController in self.navigationController.viewControllers)
    {
        if ([uploadViewController isKindOfClass:[UploadViewController class]])
        {
            [self.navigationController popToViewController:uploadViewController animated:YES];
            break;
        }
    }
}

@end
