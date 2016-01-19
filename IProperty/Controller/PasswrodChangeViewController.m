//
//  PasswrodChangeViewController.m
//  IProperty
//
//  Created by csi0n on 1/18/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "PasswrodChangeViewController.h"
#import "Config.h"
@interface PasswrodChangeViewController (){
    UILabel *_titleLable,*_send_yzm;
    UIButton *_back,*_sumbit;
    UITextField *_old_password,*_new_password,*_enter_yzm;
}

@end

@implementation PasswrodChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ALL_BACK_COLOR;
    // Do any additional setup after loading the view.
    [self initView];
}
-(void)initView{
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 70)];
    backView.backgroundColor=THEME_COLOR;
    [self.view addSubview:backView];
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(screen_width/2-30, backView.bounds.size.height/2, 100, 20)];
    _titleLable.text=@"修改密码";
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    _back=[[UIButton alloc]initWithFrame:CGRectMake(10, backView.bounds.size.height/2-10, 40, 40)];
    [_back setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_back];
    _old_password=[[UITextField alloc]initWithFrame:CGRectMake(20, 90, screen_width-40, 40)];
    [_old_password setBorderStyle:UITextBorderStyleRoundedRect];
    _old_password.placeholder=@"请输入旧密码";
    [self.view addSubview:_old_password];
    _new_password=[[UITextField alloc]initWithFrame:CGRectMake(20, 150, screen_width-40, 40)];
    [_new_password setBorderStyle:UITextBorderStyleRoundedRect];
    _new_password.placeholder=@"请输入新密码";
    [self.view addSubview:_new_password];
    _send_yzm=[[UILabel alloc]initWithFrame:CGRectMake(screen_width-100, 210, 80, 20)];
    _send_yzm.textColor=[UIColor grayColor];
    _send_yzm.text=@"发送验证码";
    _send_yzm.font=[UIFont systemFontOfSize:15];
    UITapGestureRecognizer *_send_yzm_click=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickSendYZM:)];
    [_send_yzm addGestureRecognizer:_send_yzm_click];
    [self.view addSubview:_send_yzm];
    _enter_yzm=[[UITextField alloc]initWithFrame:CGRectMake(20, 250, screen_width-40, 40)];
    [_enter_yzm setBorderStyle:UITextBorderStyleRoundedRect];
    _enter_yzm.placeholder=@"请输入验证码";
    [self.view addSubview:_enter_yzm];
    _sumbit=[[UIButton alloc]initWithFrame:CGRectMake(20, 310, screen_width-40, 40)];
    _sumbit.backgroundColor=THEME_COLOR;
    [_sumbit setTitle:@"修改" forState:UIControlStateNormal];
    [_sumbit.layer setCornerRadius:5.0];
    [_sumbit addTarget:self action:@selector(onClickChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sumbit];

}
-(void)onClickChange:(id)sender{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    if ([StringUtils isEmpty:_old_password.text]) {
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showInfoWithStatus:@"旧密码为空!"];
        return;
    }else if ([StringUtils isEmpty:_new_password.text]){
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showInfoWithStatus:@"新密码为空!"];
        return;
    }else{
        [self OldPassword:_old_password.text NewPassword:_new_password.text];
    }
    
}
-(void)onClickSendYZM:(id)sender{

}
-(void)OldPassword:(NSString *)oldpassword NewPassword:(NSString *)newpassword{
    [SVProgressHUD showWithStatus:@"密码修改中..."];
    NSString *url=[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],[UserDataManager getObjectFromConfig:@"url_changePwd"]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters =@{@"token":[UserDataManager getObjectFromConfig:@"DEFAULT_TOKEN"],@"account":_user_data.account,@"oldPwd":oldpassword,@"newPwd":newpassword};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
        manager.requestSerializer.HTTPShouldHandleCookies=YES;
        NSDictionary *resultDic=[StringUtils getDictionaryForJson:operation];
        if ([[resultDic objectForKey:@"status"] isEqualToString:[UserDataManager getObjectFromConfig:@"SUCCESS_CODE"]]) {
            [SVProgressHUD dismiss];
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showInfoWithStatus:@"密码修改成功!"];
            [self onClickBack:_back];
        }else{
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showInfoWithStatus:[resultDic objectForKey:@"info"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:@"密码修改失败!"];
    }];
}
- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
}
-(void)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
