//
//  StringUtils.m
//  iadmin
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils
+ (BOOL) isEmpty:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
+(NSDictionary *)getDictionaryForJson:(AFHTTPRequestOperation *)op{
    NSString *requestTmp=[NSString stringWithString:op.responseString];
    NSData *resData=[[NSData alloc]initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    return resultDic;
}
+(NSString *)getTimeByUnix:(NSString *)unixTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[unixTime floatValue]];
    return [formatter stringFromDate:confromTimesp];
}
+(NSString *)getUnixTime{
    NSTimeInterval timeinterval=[[NSDate date] timeIntervalSince1970];
    long dTime=[[NSNumber numberWithDouble:timeinterval]longValue];
    NSString *tempTime=[NSString stringWithFormat:@"%ld",dTime];
    return tempTime;
}
@end
