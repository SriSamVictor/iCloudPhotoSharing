//
//  ImageViewController.h
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 06/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
- (IBAction)backBtnAction:(id)sender;
@property (strong,nonatomic) UIImage *imageView;
@property (strong, nonatomic)NSString *strImages;
@property NSUInteger pageIndex;
@property (strong, nonatomic) IBOutlet UIView *pageViewControllerSubView;
- (IBAction)editActionBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *displayHeaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *displayHeaderViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *longPressButton;
@end

NS_ASSUME_NONNULL_END
