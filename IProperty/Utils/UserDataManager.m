//
//  UserDataManager.m
//  IProperty
//
//  Created by csi0n on 1/18/16.
//  Copyright © 2016 csi0n. All rights reserved.
//
#import "UserDataManager.h"
@implementation UserDataManager
+(id)getObjectFromConfig:(NSString *)key{
    NSDictionary *plistDic=[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"];
    NSMutableDictionary *data=[[NSMutableDictionary alloc]initWithContentsOfFile:plistDic];
    return [data objectForKey:key];
}
@end
