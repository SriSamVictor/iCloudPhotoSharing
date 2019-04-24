//
//  UserPhotosViewController.h
//  Collages
//
//  Created by Ekaterina Belinskaya on 14/03/15.
//  Copyright (c) 2015 Ekaterina Belinskaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPhotosViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSString *userID;

@end
