//
//  SettingViewController.m
//  iadmin
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "SettingViewController.h"
#import "Config.h"
#import "UICKeyChainStore.h"
#import "AppStartViewController.h"
#import "FeedBackViewController.h"
#import "YeJiViewController.h"
@interface SettingViewController (){
    UILabel *_titleLable;
    UIButton *_back;
    UIScrollView *_scroll_main;
}
@end

@implementation SettingViewController

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
    _titleLable.text=@"设置";
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    _back=[[UIButton alloc]initWithFrame:CGRectMake(10, backView.bounds.size.height/2-10, 40, 40)];
    [_back setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_back];
    
    _scroll_main=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, screen_width, 1000)];

    
    UIView *layout_feed_back=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    layout_feed_back.backgroundColor=[UIColor whiteColor];
    UIImageView *feed_back_ico=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [feed_back_ico setImage:[UIImage imageNamed:@"ico_feedback"]];
    UILabel *feed_back_text=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
    feed_back_text.text=@"意见反馈";
    UITapGestureRecognizer *feed_back_onclick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickFeedBack:)];
    [layout_feed_back addGestureRecognizer:feed_back_onclick];
    [layout_feed_back addSubview:feed_back_ico];
    [layout_feed_back addSubview:feed_back_text];
   
    [_scroll_main addSubview:layout_feed_back];
    
    UIView *layout_check_update=[[UIView alloc]initWithFrame:CGRectMake(0, 41, screen_width, 40)];
    layout_check_update.backgroundColor=[UIColor whiteColor];
    UIImageView *check_update_ico=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [check_update_ico setImage:[UIImage imageNamed:@"ico_check_update"]];
    UILabel *check_update_text=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
    check_update_text.text=@"检查更新";
    UITapGestureRecognizer *check_update_onclick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickCheckUpdate:)];
    [layout_check_update addGestureRecognizer:check_update_onclick];
    [layout_check_update addSubview:check_update_ico];
    [layout_check_update addSubview:check_update_text];
    [_scroll_main addSubview:layout_check_update];
    
    UIView *layout_my_ye_ji=[[UIView alloc]initWithFrame:CGRectMake(0, 82, screen_width, 40)];
    layout_my_ye_ji.backgroundColor=[UIColor whiteColor];
    UIImageView *ye_ji_ico=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [ye_ji_ico setImage:[UIImage imageNamed:@"ico_my_form"]];
    UILabel *ye_ji_text=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
    ye_ji_text.text=@"我的业绩";
    [layout_my_ye_ji addSubview:ye_ji_ico];
    [layout_my_ye_ji addSubview:ye_ji_text];
    UITapGestureRecognizer *_ye_ji_click=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickYeJi:)];
    [layout_my_ye_ji addGestureRecognizer:_ye_ji_click];
    [_scroll_main addSubview:layout_my_ye_ji];
    
    UIButton *logout=[[UIButton alloc]initWithFrame:CGRectMake(20, 143, screen_width-40, 40)];
    logout.backgroundColor=[UIColor redColor];
    [logout setTitle:@"注销" forState:UIControlStateNormal];
    [logout.layer setCornerRadius:5.0];
    [logout addTarget:self action:@selector(onClickLogout:) forControlEvents:UIControlEventTouchUpInside];
    [_scroll_main addSubview:logout];
    
    _scroll_main.contentSize = CGSizeMake(screen_width, 223*2);
    [_scroll_main flashScrollIndicators];
    // 是否同时运动,lock
    _scroll_main.directionalLockEnabled = YES;
    _scroll_main.showsVerticalScrollIndicator = FALSE;
    _scroll_main.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:_scroll_main];
}
-(void)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onClickFeedBack:(id)sender{
    FeedBackViewController *feed_back=[[FeedBackViewController alloc]init];
    [self.navigationController pushViewController:feed_back animated:YES];
}
-(void)onClickCheckUpdate:(id)sender{
    
}
-(void)onClickYeJi:(id)sender{
    YeJiViewController *yeji=[[YeJiViewController alloc]init];
    [self.navigationController pushViewController:yeji animated:YES];
}
-(void)onClickLogout:(id)sender{
    UICKeyChainStore *keychain=[UICKeyChainStore keyChainStoreWithService:[UserDataManager getObjectFromConfig:@"keychain_all_info"]];
    keychain[[UserDataManager getObjectFromConfig:@"keychain_password"]]=nil;
    AppStartViewController *app_start=[[AppStartViewController alloc]init];
    [self.navigationController pushViewController:app_start animated:YES];
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
