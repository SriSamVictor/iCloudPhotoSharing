//
//  DBOperation.h
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 20/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBOperation : NSObject{
    AppDelegate *appDelegate;
    sqlite3 *database;
}
@property(strong, nonatomic)NSMutableArray *arrData;
@property(strong ,nonatomic)NSString *strData;
-(NSMutableArray *)getAllUser:(NSString *)queryStr;    
@end

NS_ASSUME_NONNULL_END
