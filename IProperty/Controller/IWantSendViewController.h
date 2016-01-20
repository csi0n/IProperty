//
//  IWantSendViewController.h
//  IProperty
//
//  Created by csi0n on 1/18/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "checkLogin.h"
#import "SendModel.h"
@interface IWantSendViewController : UIViewController
@property(nonatomic,strong) checkLogin *user_data;
@property(nonatomic,strong)SendModel *send_data;
@end
