//
//  StringUtils.h
//  IProperty
//
//  Created by csi0n on 1/18/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface StringUtils : NSObject
+ (BOOL) isEmpty:(NSString *)string;
+(NSDictionary *)getDictionaryForJson:(AFHTTPRequestOperation *)op;
@end
