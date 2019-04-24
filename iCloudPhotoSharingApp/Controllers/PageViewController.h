//
//  PageViewController.h
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 07/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PageViewController : UIPageViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (strong,nonatomic)NSArray *deviceArray;
@property (strong,nonatomic)NSString *particularImage;
@property NSInteger particularIndex;

@end

NS_ASSUME_NONNULL_END
