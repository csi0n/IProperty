//
//  FeedBackViewController.m
//  IProperty
//
//  Created by csi0n on 1/18/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "FeedBackViewController.h"
#import "Config.h"
#import "UIPlaceholderTextView.h"
#import "SVProgressHUD.h"
#import "UserDataManager.h"
#import "AFNetWorking.h"
#import "StringUtils.h"
@interface FeedBackViewController (){
    UILabel *_titleLable;
    UIButton *_back,*_submit;
    UIPlaceholderTextView *_feed_content;
}

@end

@implementation FeedBackViewController

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
    _titleLable.text=@"意见反馈";
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    _back=[[UIButton alloc]initWithFrame:CGRectMake(10, backView.bounds.size.height/2-10, 40, 40)];
    [_back setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_back];
    _submit=[[UIButton alloc]initWithFrame:CGRectMake(screen_width-70, backView.bounds.size.height/2, 80, 20)];
    [_submit setTitle:@"发送" forState:UIControlStateNormal];
    [_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submit.titleLabel.font=[UIFont systemFontOfSize:15];
    UITapGestureRecognizer *_submit_onclick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickSend:)];
    [_submit addGestureRecognizer:_submit_onclick];
    [backView addSubview:_submit];
    _feed_content=[[UIPlaceholderTextView alloc]initWithFrame:CGRectMake(10, 80, screen_width-20, 200)];
    [_feed_content setContentOffset:CGPointZero];
    _feed_content.layer.borderWidth = 0.5;
    _feed_content.layer.borderColor = [UIColor grayColor].CGColor;
    _feed_content.layer.cornerRadius=5.0;
    _feed_content.font=[UIFont systemFontOfSize:15];
    _feed_content.contentInset = UIEdgeInsetsMake(0,0,0,0);

    _feed_content.placeholder=@"请输入您的意见";
    [self.view addSubview:_feed_content];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)onClickSend:(id)sender{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    if ([StringUtils isEmpty:_feed_content.text]) {
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showInfoWithStatus:@"反馈内容为空!"];
        return;
    }else{
        [self FeedContent:_feed_content.text];
    }
}
-(void)FeedContent:(NSString *)content{
    [SVProgressHUD showWithStatus:@"反馈中..."];
    NSString *url=[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],[UserDataManager getObjectFromConfig:@"url_feed_back"]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters =@{@"token":[UserDataManager getObjectFromConfig:@"DEFAULT_TOKEN"],@"content":content};
    NSLog(@"%@",url);
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
        manager.requestSerializer.HTTPShouldHandleCookies=YES;
        NSDictionary *resultDic=[StringUtils getDictionaryForJson:operation];
        if ([[resultDic objectForKey:@"status"] isEqualToString:[UserDataManager getObjectFromConfig:@"SUCCESS_CODE"]]) {
            [SVProgressHUD dismiss];
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showSuccessWithStatus:@"反馈成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showInfoWithStatus:[resultDic objectForKey:@"info"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error);
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:@"反馈失败!"];
    }];
}
- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
}
-(void)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
