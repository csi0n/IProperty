//
//  AppStartViewController.m
//  iadmin
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "AppStartViewController.h"
#import "UICKeyChainStore.h"
#import "AFNetWorking.h"
#import "AppStartViewController.h"
#import "StringUtils.h"
#import "LoginViewController.h"
#import "UserDataManager.h"
#import "MainViewController.h"
#import "checkLogin.h"
#import "YYModel.h"
@interface AppStartViewController (){
NSString *_username,*_password;}
@end

@implementation AppStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self initView];
    [self initData];
}
-(void)initView{
    UIImageView *app_start_pic=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [app_start_pic setImage:[UIImage imageNamed:@"start_pic1"]];
    [app_start_pic setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:app_start_pic];
}
-(void)initData{
    UICKeyChainStore *keychain=[UICKeyChainStore keyChainStoreWithService:[UserDataManager getObjectFromConfig:@"keychain_all_info"]];
    _username=keychain[[UserDataManager getObjectFromConfig:@"keychain_username"]];
    _password=keychain[[UserDataManager getObjectFromConfig:@"keychain_password"]];
    if (![StringUtils isEmpty:_username]&&![StringUtils isEmpty:_password]) {
        NSLog(@"检测到保存的用户名:%@,密码:%@,开始自动登录!",_username,_password);
        [self UserName:_username Password:_password];
    }else{
        [self PushLogin];
    }
}
-(void)PushLogin{
    LoginViewController *login=[[LoginViewController alloc]init];
    if ([StringUtils isEmpty:_username]) {
        login.username=_username;
    }
    [self.navigationController pushViewController:login animated:YES];
}
-(void)UserName:(NSString *)username Password:(NSString *)password{
    NSString *url=[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],[UserDataManager getObjectFromConfig:@"url_login"]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters =@{@"token":[UserDataManager getObjectFromConfig:@"DEFAULT_TOKEN"],@"loginUsername":username,@"loginPassword":password};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSDictionary *resultDic=[StringUtils getDictionaryForJson:operation];
        if ([[resultDic objectForKey:@"status"] isEqualToString:[UserDataManager getObjectFromConfig:@"SUCCESS_CODE"]]) {
            checkLogin *check_login=[checkLogin yy_modelWithJSON:[resultDic objectForKey:@"data"]];
            MainViewController *main=[[MainViewController alloc]init];
            main.user_data=check_login;
            [self.navigationController pushViewController:main animated:YES];
        }else{
            [self PushLogin];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [self PushLogin];
    }];
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
