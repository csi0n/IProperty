//
//  YeJiViewController.m
//  iadmin
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "YeJiViewController.h"
#import "Config.h"
#import "UserDataManager.h"
#import "YeJIModel.h"
@interface YeJiViewController (){
    UILabel *_titleLable,*ye_ji_text;
    UIButton *_back;
}

@end

@implementation YeJiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ALL_BACK_COLOR;
    // Do any additional setup after loading the view.
    [self initView];
    [self initData];
}
-(void)initView{
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 70)];
    backView.backgroundColor=THEME_COLOR;
    [self.view addSubview:backView];
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(screen_width/2-(30/2), backView.bounds.size.height/2, 40, 20)];
    _titleLable.text=@"业绩";
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    _back=[[UIButton alloc]initWithFrame:CGRectMake(10, backView.bounds.size.height/2-10, 40, 40)];
    [_back setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_back];
    UIView *layout_ye_ji=[[UIView alloc]initWithFrame:CGRectMake(0, 71, screen_width, 40)];
    layout_ye_ji.backgroundColor=[UIColor whiteColor];
    UIImageView *ye_ji_ico=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [ye_ji_ico setImage:[UIImage imageNamed:@"ico_feedback"]];
    ye_ji_text=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, screen_width-80, 30)];
    ye_ji_text.text=@"您当月共批准了0条,拒绝了0条";
    [layout_ye_ji addSubview:ye_ji_ico];
    [layout_ye_ji addSubview:ye_ji_text];
    [self.view addSubview:layout_ye_ji];
}
-(void)initData{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD showWithStatus:@"获取数据中..."];
    NSString *url=[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],[UserDataManager getObjectFromConfig:@"url_record"]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters =@{@"token":[UserDataManager getObjectFromConfig:@"DEFAULT_TOKEN"]};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
        manager.requestSerializer.HTTPShouldHandleCookies=YES;
        NSDictionary *resultDic=[StringUtils getDictionaryForJson:operation];
        if ([[resultDic objectForKey:@"status"] isEqualToString:[UserDataManager getObjectFromConfig:@"SUCCESS_CODE"]]) {
            [SVProgressHUD dismiss];
            YeJIModel *yeji=[YeJIModel yy_modelWithJSON:[resultDic objectForKey:@"data"]];
            ye_ji_text.text=[NSString stringWithFormat:@"您当月共批准了%@条,拒绝了%@条",yeji.approve_num,yeji.refuse_num];
        }else{
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showInfoWithStatus:[resultDic objectForKey:@"info"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:@"登录失败!"];
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
