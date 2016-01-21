//
//  MainViewController.h
//  iadmin
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "ViewController.h"
#import "checkLogin.h"
#import "SDRefresh.h"
@interface MainViewController : ViewController
@property (nonatomic,strong) checkLogin *user_data;
@property(nonatomic,strong)UITableView *tableView;
@end
