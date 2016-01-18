//
//  CKeyChain.h
//  IProperty
//
//  Created by csi0n on 1/18/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <security/security.h>
@interface CKeyChain : NSObject
// save username and password to keychain
+ (void)save:(NSString *)service data:(id)data;

// take out username and passwore from keychain
+ (id)load:(NSString *)service;

// delete username and password from keychain
+ (void)delete:(NSString *)service;
@end
