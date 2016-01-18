//
//  UserDataManager.m
//  IProperty
//
//  Created by csi0n on 1/18/16.
//  Copyright © 2016 csi0n. All rights reserved.
//
#import "UserDataManager.h"
#import "CKeyChain.h"
static NSString * const KEY_IN_KEYCHAIN = @"cn.csi0n.iproperty.allinfo";
static NSString * const KEY_USERNAME=@"cn.csi0n.iproperty.username";
static NSString * const KEY_PASSWORD = @"cn.csi0n.iproperty.password";
@implementation UserDataManager
+(void)saveUsername:(NSString *)username{
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:username forKey:KEY_USERNAME];
    [CKeyChain save:KEY_IN_KEYCHAIN data:usernamepasswordKVPairs];
}
+(id)readUsername{
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[CKeyChain load:KEY_IN_KEYCHAIN];
    return [usernamepasswordKVPair objectForKey:KEY_USERNAME];
}
+(void)savePassWord:(NSString *)password{
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:password forKey:KEY_PASSWORD];
    [CKeyChain save:KEY_IN_KEYCHAIN data:usernamepasswordKVPairs];
}
+(id)readPassWord{
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[CKeyChain load:KEY_IN_KEYCHAIN];
    return [usernamepasswordKVPair objectForKey:KEY_PASSWORD];
}
+(void)deleteUserInfo{
    [CKeyChain delete:KEY_IN_KEYCHAIN];
}
+(id)getObjectFromConfig:(NSString *)key{
    NSDictionary *plistDic=[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"];
    NSMutableDictionary *data=[[NSMutableDictionary alloc]initWithContentsOfFile:plistDic];
    return [data objectForKey:key];
}
@end
