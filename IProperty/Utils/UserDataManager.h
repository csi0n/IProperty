//
//  UserDataManager.h
//  IProperty
//
//  Created by csi0n on 1/18/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataManager : NSObject
+(void)saveUsername:(NSString *)username;
+(id)readUsername;
+(void)savePassWord:(NSString *)password;
+(id)readPassWord;
+(void)deleteUserInfo;
+(id)getObjectFromConfig:(NSString *)key;
@end
