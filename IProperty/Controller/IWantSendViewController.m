//
//  IWantSendViewController.m
//  IProperty
//
//  Created by csi0n on 1/18/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "IWantSendViewController.h"
#import "UIPlaceholderTextView.h"
#import "ZYRadioButton.h"
#import "Config.h"
@interface IWantSendViewController (){
    UILabel *_titleLable;
    UIButton *_back,*_submit;
    UITextField *_title_send,*_code_send,*_name_send;
    UIPlaceholderTextView *_content_send;
    UIScrollView *_main_scroll;
    ZYRadioButton *rb1,*rb2;
}

@end
int SEND_TYPE=0;
@implementation IWantSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=ALL_BACK_COLOR;
    [self initView];
}
-(void)initView{
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 70)];
    backView.backgroundColor=THEME_COLOR;
    [self.view addSubview:backView];
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(screen_width/2-(70/2), backView.bounds.size.height/2, 100, 20)];
    _titleLable.text=@"我要发布";
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    _back=[[UIButton alloc]initWithFrame:CGRectMake(10, backView.bounds.size.height/2-10, 40, 40)];
    [_back setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_back];
    _main_scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 90, screen_width, 1000)];
    _title_send=[[UITextField alloc]initWithFrame:CGRectMake(20, 0, screen_width-40, 40)];
    [_title_send setBorderStyle:UITextBorderStyleRoundedRect];
    _title_send.placeholder=@"请输入标题";
    [_main_scroll addSubview:_title_send];
    _content_send=[[UIPlaceholderTextView alloc]initWithFrame:CGRectMake(20, 60, screen_width-40, 300)];
    [_content_send setContentOffset:CGPointZero];
    _content_send.layer.borderWidth = 0.5;
    _content_send.layer.borderColor = [UIColor grayColor].CGColor;
    _content_send.layer.cornerRadius=5.0;
    _content_send.font=[UIFont systemFontOfSize:15];
    _content_send.contentInset = UIEdgeInsetsMake(0,0,0,0);
    _content_send.placeholder=@"请输入内容";
    [_main_scroll addSubview:_content_send];
    _code_send=[[UITextField alloc]initWithFrame:CGRectMake(20, 380, screen_width-40, 40)];
    [_code_send setBorderStyle:UITextBorderStyleRoundedRect];
    _code_send.placeholder=@"请输入身份证号码";
    [_main_scroll addSubview:_code_send];
    _name_send=[[UITextField alloc]initWithFrame:CGRectMake(20, 440, screen_width-40, 40)];
    [_name_send setBorderStyle:UITextBorderStyleRoundedRect];
    _name_send.placeholder=@"请输入姓名";
    [_main_scroll addSubview:_name_send];
    _submit=[[UIButton alloc]initWithFrame:CGRectMake(20, 550, screen_width-40, 40)];
    _submit.backgroundColor=THEME_COLOR;
    [_submit setTitle:@"发布" forState:UIControlStateNormal];
    [_submit.layer setCornerRadius:5.0];
    [_submit addTarget:self action:@selector(onClickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [_main_scroll addSubview:_submit];
    
    rb1 = [[ZYRadioButton alloc] initWithGroupId:@"11" index:0];
    rb2 = [[ZYRadioButton alloc] initWithGroupId:@"11" index:1];
    rb1.frame=CGRectMake(20, 500, 30, 30);
    rb2.frame=CGRectMake(screen_width-150, 500, 30, 30);
    UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(60, 500, 80, 20)];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"小区消息";
    UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(screen_width-120, 500, 80, 20)];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"重要消息";
    [_main_scroll addSubview:rb1];
    [_main_scroll addSubview:rb2];
    [_main_scroll addSubview:label1];
    [_main_scroll addSubview:label2];
    [ZYRadioButton addObserverForGroupId:@"11" observer:self];

    _main_scroll.contentSize = CGSizeMake(screen_width, 600*2);
    [_main_scroll flashScrollIndicators];
    // 是否同时运动,lock
    _main_scroll.directionalLockEnabled = YES;
    _main_scroll.showsVerticalScrollIndicator = FALSE;
    _main_scroll.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:_main_scroll];
}
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    if (index==0) {
        SEND_TYPE=2;
    }else if (index==1){
        SEND_TYPE=3;
    }
}
-(void)onClickSubmit:(id)sender{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    if ([StringUtils isEmpty:_title_send.text]) {
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:@"请填写标题！"];
        return;
    }else if ([StringUtils isEmpty:_content_send.text]){
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:@"请填写内容！"];
        return;
    }else if ([StringUtils isEmpty:_code_send.text]){
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:@"请填写身份证！"];
        return;
    }else if ([StringUtils isEmpty:_name_send.text]){
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:@"请填写姓名！"];
        return;
    }else if (SEND_TYPE==0){
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:@"请选择发布类型！"];
        return;
    }else if([StringUtils isEmpty:_user_data.village_id]){
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:@"发布城市未设置,请联系管理员！"];
        return;
    }else{
        [self Title:_title_send.text Content:_content_send.text Code:_code_send.text Name:_name_send.text];
    }
}
-(void)Title:(NSString *)title Content:(NSString *)content Code:(NSString *)code Name:(NSString *)name{
    [SVProgressHUD showWithStatus:@"发表中..."];
    NSString *url=[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],[UserDataManager getObjectFromConfig:@"url_insert"]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters =@{@"token":[UserDataManager getObjectFromConfig:@"DEFAULT_TOKEN"],@"title":title,@"content":content,@"type_id":[NSString stringWithFormat:@"%d",SEND_TYPE],@"village_id":_user_data.village_id,@"realname":name,@"uid":code};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
        manager.requestSerializer.HTTPShouldHandleCookies=YES;
        NSDictionary *resultDic=[StringUtils getDictionaryForJson:operation];
        if ([[resultDic objectForKey:@"status"] isEqualToString:[UserDataManager getObjectFromConfig:@"SUCCESS_CODE"]]) {
            [SVProgressHUD dismiss];
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showInfoWithStatus:@"发表成功！"];
            [self onClickBack:_back];
        }else{
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showInfoWithStatus:[resultDic objectForKey:@"info"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:@"发表失败!"];
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
