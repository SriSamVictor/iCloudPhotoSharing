//
//  EditViewController.h
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 11/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : UIViewController<UINavigationBarDelegate,UIDocumentPickerDelegate,UITabBarDelegate,UIScrollViewDelegate,UIActionSheetDelegate>{
        IBOutlet __weak UIScrollView *_scrollView;
        IBOutlet __weak UIImageView *_imageView;
}
- (IBAction)backBtnAction:(id)sender;
@property (strong,nonatomic)UIImage *imageViewMine;
@property (weak, nonatomic) IBOutlet UIView *MainView;
@end

NS_ASSUME_NONNULL_END
