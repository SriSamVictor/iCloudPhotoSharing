//
//  UserListTableViewCell.h
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 18/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabelOutlet;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabelOutlet;
@property (weak, nonatomic) IBOutlet UILabel *emailLabelOutlet;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabelOutlet;

// Gallery View Controller
@property (weak, nonatomic) IBOutlet UIImageView *galleryListViewImageOutlet;

@end

NS_ASSUME_NONNULL_END
