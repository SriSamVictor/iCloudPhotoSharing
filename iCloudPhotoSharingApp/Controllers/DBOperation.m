//
//  DBOperation.m
//  iCloudPhotoSharingApp
//
//  Created by jeanmartin on 20/02/19.
//  Copyright © 2019 jeanmartin. All rights reserved.
//

#import "DBOperation.h"


@implementation DBOperation
@synthesize arrData,strData;

-(id)init{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    strData = appDelegate.strPath;
    return self;
}

- (NSMutableArray *)getAllUser:(NSString *)queryStr{
    arrData = [[NSMutableArray alloc]init];
    
    if(sqlite3_open([strData UTF8String], &database) == SQLITE_OK){
        sqlite3_stmt *connection;
        if(sqlite3_prepare_v2(database, [queryStr UTF8String], -1, &connection, nil) == SQLITE_OK){
            while (sqlite3_step(connection) == SQLITE_ROW) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                NSString *email = [[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(connection,0)];
                NSString *password = [[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(connection,1)];
                NSString *phone = [[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(connection,2)];
                [dict setObject:email forKey:@"email"];
                [dict setObject:password forKey:@"password"];
                [dict setObject:phone forKey:@"phone"];
                [arrData addObject:dict];
            }
        }
        sqlite3_finalize(connection);
    }
    sqlite3_close(database);
    return arrData;
}

@end
