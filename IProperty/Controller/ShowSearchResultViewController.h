//
//  ShowSearchResultViewController.h
//  IProperty
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface ShowSearchResultViewController : UIViewController
@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)UITableView *tableView;
@end
