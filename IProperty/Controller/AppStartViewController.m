//
//  AppStartViewController.m
//  IProperty
//
//  Created by csi0n on 1/17/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "AppStartViewController.h"
#import "LoginViewController.h"
@interface AppStartViewController ()

@end

@implementation AppStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self initView];
    [self initData];
    // Do any additional setup after loading the view from its nib.
}
-(void)initView{
    UIImageView *app_start_pic=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [app_start_pic setImage:[UIImage imageNamed:@"start_pic1"]];
    [app_start_pic setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:app_start_pic];
}
-(void)initData{
    LoginViewController *login=[[LoginViewController alloc]init];
    login.ID=@"1";
    login.TITLE=@"123";
    [self.navigationController pushViewController:login animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
