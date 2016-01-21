//
//  DealPropertyViewController.m
//  iadmin
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "DealPropertyViewController.h"
#import "RefuseViewController.h"
#import "Config.h"
@interface DealPropertyViewController (){
    UILabel *_titleLable,*title,*content,*add_time;
    UIButton *_back,*_approve,*_refuse;
    UIScrollView *_main_scroll;
}
@end

@implementation DealPropertyViewController

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
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(screen_width/2-(30/2), backView.bounds.size.height/2, 40, 20)];
    _titleLable.text=@"详情";
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    _back=[[UIButton alloc]initWithFrame:CGRectMake(10, backView.bounds.size.height/2-10, 40, 40)];
    [_back setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_back];
    
    _main_scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 71, screen_width, 1000)];
    title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width-20, 20)];
    title.text=_send_data.title;
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont systemFontOfSize:15];
    [_main_scroll addSubview:title];
    add_time=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, screen_width-20, 20)];
    add_time.text=[StringUtils getTimeByUnix:_send_data.add_time];
    add_time.textAlignment=NSTextAlignmentCenter;
    add_time.font=[UIFont systemFontOfSize:13];
    add_time.textColor=[UIColor grayColor];
    
    [_main_scroll addSubview:add_time];
    content=[[UILabel alloc]init];
    content.numberOfLines = 0;
    content.lineBreakMode = NSLineBreakByWordWrapping;
    content.text=_send_data.content;
    CGSize size = [content sizeThatFits:CGSizeMake(content.frame.size.width, MAXFLOAT)];
    content.frame =CGRectMake(10, 60, screen_width-20, size.height);
    content.font = [UIFont systemFontOfSize:14];
    [_main_scroll addSubview:content];
    _approve=[[UIButton alloc]initWithFrame:CGRectMake(10, 70+content.bounds.size.height, screen_width/2-20, 40)];
    _approve.backgroundColor=THEME_COLOR;
    [_approve setTitle:@"批准" forState:UIControlStateNormal];
    [_approve.layer setCornerRadius:5.0];
    [_approve addTarget:self action:@selector(onClickApprove:) forControlEvents:UIControlEventTouchUpInside];
    [_main_scroll addSubview:_approve];
    _refuse=[[UIButton alloc]initWithFrame:CGRectMake(screen_width/2, 70+content.bounds.size.height, screen_width/2-10, 40)];
    _refuse.backgroundColor=[UIColor redColor];
    [_refuse setTitle:@"拒绝" forState:UIControlStateNormal];
    [_refuse.layer setCornerRadius:5.0];
    [_refuse addTarget:self action:@selector(onClickrefuse:) forControlEvents:UIControlEventTouchUpInside];
    [_main_scroll addSubview:_refuse];
    _main_scroll.contentSize = CGSizeMake(screen_width, (120+content.bounds.size.height)*2);
    [_main_scroll flashScrollIndicators];
    // 是否同时运动,lock
    _main_scroll.directionalLockEnabled = YES;
    _main_scroll.showsVerticalScrollIndicator = FALSE;
    _main_scroll.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:_main_scroll];
}
-(void)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onClickApprove:(id)sender{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD showWithStatus:@"批准中..."];
    NSString *url=[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],[UserDataManager getObjectFromConfig:@"url_checkPost"]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters =@{@"token":[UserDataManager getObjectFromConfig:@"DEFAULT_TOKEN"],@"status":@"3",@"publish_id":_send_data.id};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
        manager.requestSerializer.HTTPShouldHandleCookies=YES;
        NSDictionary *resultDic=[StringUtils getDictionaryForJson:operation];
        if ([[resultDic objectForKey:@"status"] isEqualToString:[UserDataManager getObjectFromConfig:@"SUCCESS_CODE"]]) {
            [SVProgressHUD dismiss];
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showErrorWithStatus:@"批准成功!"];
        }else{
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showInfoWithStatus:[resultDic objectForKey:@"info"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:@"批准失败!"];
    }];
}
- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
}
-(void)onClickrefuse:(id)sender{
    RefuseViewController *refuse=[[RefuseViewController alloc]init];
    refuse.send_data=_send_data;
    [self.navigationController pushViewController:refuse animated:YES];
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
