//
//  NavigateViewController.m
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 11/01/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import "NavigateViewController.h"

@interface NavigateViewController ()

@end

@implementation NavigateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskAll;
}


@end
