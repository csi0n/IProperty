//
//  DetailViewController.m
//  IProperty
//
//  Created by csi0n on 1/20/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "DetailViewController.h"
#import "IWantSendViewController.h"
#import "Config.h"
@interface DetailViewController (){
    UILabel *_titleLable,*_contentLable;
    UIButton *_back,*_top,*_change,*_cancel;
    UIScrollView *_main_view;
}

@end

@implementation DetailViewController

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
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(screen_width/2-(30/2), backView.bounds.size.height/2, 40, 20)];
    _titleLable.text=@"详情";
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    
    _back=[[UIButton alloc]initWithFrame:CGRectMake(10, backView.bounds.size.height/2-10, 40, 40)];
    [_back setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_back];
    _main_view=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 80, screen_width, 1000)];
    NSString *content_text=[NSString stringWithFormat:@"%@ %@",[StringUtils getTimeByUnix:_send_data.add_time],_send_data.content];
    _contentLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, screen_width-20, 500)];
    _contentLable.textColor=[UIColor grayColor];
    _contentLable.font=[UIFont systemFontOfSize:15];
    [_contentLable setLineBreakMode:NSLineBreakByWordWrapping];  // 改行設定
    [_contentLable setNumberOfLines:0];  // 行数指定。0で指定なし
    [_contentLable setText:content_text];   // sizeToFitより前にテキストをセットする
    [_contentLable sizeToFit];   // テキストの量に応じて高さを変える
    _contentLable.text=content_text;
    [_main_view addSubview:_contentLable];
    float _content_height=_contentLable.bounds.size.height;
    _top=[[UIButton alloc]initWithFrame:CGRectMake(10, 10+_content_height, screen_width-20, 40)];
    _top.backgroundColor=THEME_COLOR;
    [_top setTitle:@"置顶" forState:UIControlStateNormal];
    [_top.layer setCornerRadius:5.0];
    [_top addTarget:self action:@selector(onClickTOP:) forControlEvents:UIControlEventTouchUpInside];
    [_main_view addSubview:_top];
    _change=[[UIButton alloc]initWithFrame:CGRectMake(10, 60+_content_height, screen_width-20, 40)];
    _change.backgroundColor=[UIColor orangeColor];
    [_change setTitle:@"修改" forState:UIControlStateNormal];
    [_change.layer setCornerRadius:5.0];
    [_change addTarget:self action:@selector(onClickChange:) forControlEvents:UIControlEventTouchUpInside];
    [_main_view addSubview:_change];
    _cancel=[[UIButton alloc]initWithFrame:CGRectMake(10, 110+_content_height, screen_width-20, 40)];
    _cancel.backgroundColor=[UIColor redColor];
    [_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [_cancel.layer setCornerRadius:5.0];
    [_cancel addTarget:self action:@selector(onClickCancel:) forControlEvents:UIControlEventTouchUpInside];
    [_main_view addSubview:_cancel];
    _main_view.contentSize = CGSizeMake(screen_width, (160+_content_height)*2);
    [_main_view flashScrollIndicators];
    // 是否同时运动,lock
    _main_view.directionalLockEnabled = YES;
    _main_view.showsVerticalScrollIndicator = FALSE;
    _main_view.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:_main_view];
    
}
-(void)onClickTOP:(id)sender{
    [self sendAcion:@"url_setTop" LoadingInfo:@"设置顶部"];
}
-(void)sendAcion:(NSString *)urlFrominfo LoadingInfo:(NSString *)loadinginfor{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD showInfoWithStatus:loadinginfor];
    NSString *url=[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],[UserDataManager getObjectFromConfig:urlFrominfo]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters =@{@"token":[UserDataManager getObjectFromConfig:@"DEFAULT_TOKEN"],@"publish_id":_send_data.id};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
        manager.requestSerializer.HTTPShouldHandleCookies=YES;
        NSDictionary *resultDic=[StringUtils getDictionaryForJson:operation];
        if ([[resultDic objectForKey:@"status"] isEqualToString:[UserDataManager getObjectFromConfig:@"SUCCESS_CODE"]]) {
            [SVProgressHUD dismiss];
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@%@",loadinginfor,@"成功!"]];
        }else{
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showInfoWithStatus:[resultDic objectForKey:@"info"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@%@",loadinginfor,@"失败!"]];
    }];
}
- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
}
-(void)onClickChange:(id)sender{
    IWantSendViewController *i_want_send=[[IWantSendViewController alloc]init];
    i_want_send.send_data=_send_data;
    [self.navigationController pushViewController:i_want_send animated:YES];
}
-(void)onClickCancel:(id)sender{
    [self sendAcion:@"url_cancel" LoadingInfo:@"取消"];
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
