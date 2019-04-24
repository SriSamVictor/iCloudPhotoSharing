//
//  UserListViewController.m
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 18/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import "UserListViewController.h"
#import "UserListTableViewCell.h"

@interface UserListViewController (){
    NSMutableArray *registrationArray;
}

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Get Dict %@",self.getDict);
    registrationArray = [[NSMutableArray alloc]init];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    registrationArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#(nonnull NSString *)#> forIndexPath:<#(nonnull NSIndexPath *)#>]
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (IBAction)backBtnAction:(id)sender {
}
@end
