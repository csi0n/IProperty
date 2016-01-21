//
//  LoginViewController.m
//  IProperty
//
//  Created by csi0n on 1/17/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "LoginViewController.h"
#import "Config.h"
#import "MainViewController.h"
#import "RegisterViewController.h"
#import "StringUtils.h"
#import "UserDataManager.h"
#import "SVProgressHUD.h"
#import "AFNetWorking.h"
#import "checkLogin.h"
#import "YYModel.h"
#import "UICKeyChainStore.h"
@interface LoginViewController (){
    UILabel *_titleLable;
    UITextField *_usernamefield,*_passwordfield;
    UIButton *_submit,*_forgetpassword,*_reglable;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ALL_BACK_COLOR;
    [self initView];
    [self initData];
    // Do any additional setup after loading the view from its nib.
}
-(void)initView{
    //顶部状态栏
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 70)];
    backView.backgroundColor=THEME_COLOR;
    [self.view addSubview:backView];
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(screen_width/2-(30/2), backView.bounds.size.height/2, 40, 20)];
    _titleLable.text=@"登录";
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    //登录框
    UIView *layout_login=[[UIView alloc]initWithFrame:CGRectMake(0, 71, screen_width, 400)];
    [self.view addSubview:layout_login];
    _usernamefield=[[UITextField alloc]initWithFrame:CGRectMake(20, 20, screen_width-40, 40)];
    if ([StringUtils isEmpty:_username]) {
        _usernamefield.text=_username;
    }
    _usernamefield.placeholder=@"请输入用户名";
    [_usernamefield setBorderStyle:UITextBorderStyleRoundedRect];
    _usernamefield.backgroundColor=[UIColor whiteColor];
    [layout_login addSubview:_usernamefield];
    _passwordfield=[[UITextField alloc]initWithFrame:CGRectMake(20, 70, screen_width-40, 40)];
    _passwordfield.placeholder=@"请输入密码";
    [_passwordfield setBorderStyle:UITextBorderStyleRoundedRect];
    _passwordfield.backgroundColor=[UIColor whiteColor];
    [layout_login addSubview:_passwordfield];
    _reglable=[[UIButton alloc]initWithFrame:CGRectMake(40, 110, 50, 30)];
    [_reglable setTitle:@"注册" forState:UIControlStateNormal];
    [_reglable setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _reglable.titleLabel.font=[UIFont systemFontOfSize:12];
    [_reglable addTarget:self action:@selector(onClickReg:) forControlEvents:UIControlEventTouchUpInside];
    [layout_login addSubview:_reglable];
    _forgetpassword=[[UIButton alloc]initWithFrame:CGRectMake(screen_width-90, 110, 50, 30)];
    [_forgetpassword setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetpassword setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _forgetpassword.titleLabel.font=[UIFont systemFontOfSize:12];
    [layout_login addSubview:_forgetpassword];
    _submit=[[UIButton alloc]initWithFrame:CGRectMake(20, 150, screen_width-40, 40)];
    _submit.backgroundColor=THEME_COLOR;
    [_submit setTitle:@"登录" forState:UIControlStateNormal];
    [_submit.layer setCornerRadius:5.0];
    [_submit addTarget:self action:@selector(onClickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [layout_login addSubview:_submit];
}
-(void)initData{
}
-(void)onClickReg:(id)sender{
//    RegisterViewController *reg=[[RegisterViewController alloc]init];
//    [self.navigationController pushViewController:reg animated:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
    [SVProgressHUD showInfoWithStatus:@"接口未开放!"];
}
-(void)onClickSubmit:(id)sender{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
       if ([StringUtils isEmpty:_usernamefield.text]) {
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showInfoWithStatus:@"用户名不能为空!"];
        return;
    }else if ([StringUtils isEmpty:_passwordfield.text]) {
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showInfoWithStatus:@"密码不能为空!"];
        return;
    }
    [self Username:_usernamefield.text Password:_passwordfield.text];
}
- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
}
-(void)Username:(NSString *)username Password:(NSString *)password{
    [SVProgressHUD showWithStatus:@"登录中..."];
    NSString *url=[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],[UserDataManager getObjectFromConfig:@"url_login"]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters =@{@"token":[UserDataManager getObjectFromConfig:@"DEFAULT_TOKEN"],@"loginUsername":username,@"loginPassword":password};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
        manager.requestSerializer.HTTPShouldHandleCookies=YES;
        NSDictionary *resultDic=[StringUtils getDictionaryForJson:operation];
        if ([[resultDic objectForKey:@"status"] isEqualToString:[UserDataManager getObjectFromConfig:@"SUCCESS_CODE"]]) {
            checkLogin *check_login=[checkLogin yy_modelWithJSON:[resultDic objectForKey:@"data"]];
            [SVProgressHUD dismiss];
            UICKeyChainStore *keychain=[UICKeyChainStore keyChainStoreWithService:[UserDataManager getObjectFromConfig:@"keychain_all_info"]];
            [keychain setString:username forKey:[UserDataManager getObjectFromConfig:@"keychain_username"] error:nil];
            [keychain setString:password forKey:[UserDataManager getObjectFromConfig:@"keychain_password"] error:nil];
            MainViewController *main=[[MainViewController alloc]init];
            main.user_data=check_login;
            [self.navigationController pushViewController:main animated:YES];
        }else{
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showInfoWithStatus:[resultDic objectForKey:@"info"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showErrorWithStatus:@"登录失败!"];
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
