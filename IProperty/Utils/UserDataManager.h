//
//  UserDataManager.h
//  IProperty
//
//  Created by csi0n on 1/18/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataManager : NSObject
+(id)getObjectFromConfig:(NSString *)key;
@end
