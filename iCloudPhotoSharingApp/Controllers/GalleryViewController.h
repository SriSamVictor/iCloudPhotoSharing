//
//  GalleryViewController.h
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 05/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GalleryViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
- (IBAction)galleryBackBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(strong,nonatomic)NSMutableArray *collectedImageArray;
@property (weak, nonatomic) IBOutlet UIView *noRecordsFoundView;
@property (weak, nonatomic) IBOutlet UIView *collectionImagesView;
- (IBAction)deleteBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *cancelButtonOutlet;
@end

NS_ASSUME_NONNULL_END
