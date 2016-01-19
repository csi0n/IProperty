//
//  Config.h
//  IProperty
//
//  Created by csi0n on 1/17/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#ifndef Config_h
#define Config_h
#import "AFNetWorking.h"
#import "StringUtils.h"
#import "UserDataManager.h"
#import "SVProgressHUD.h"
// UIColor Helper Macro
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
// App Colors
#define THEME_COLOR UIColorFromRGB(0x269a13)
#define ALL_BACK_COLOR UIColorFromRGB(0xf0eff5)
// 4.屏幕大小尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
#endif /* Config_h */
