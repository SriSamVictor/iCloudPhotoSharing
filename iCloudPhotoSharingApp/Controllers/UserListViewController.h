//
//  UserListViewController.h
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 18/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *userListTableView;
- (IBAction)backBtnAction:(id)sender;
@property(strong,nonatomic)NSMutableDictionary *getDict;
@end

NS_ASSUME_NONNULL_END
