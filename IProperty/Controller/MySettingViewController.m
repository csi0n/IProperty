//
//  MySettingViewController.m
//  IProperty
//
//  Created by csi0n on 1/18/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "MySettingViewController.h"
#import "PasswrodChangeViewController.h"
#import "FeedBackViewController.h"
#import "AboutUSViewController.h"
#import "Config.h"
@interface MySettingViewController (){
    UILabel *_titleLable;
    UIButton *_back;
    UIScrollView *_scroll_main;
}

@end

@implementation MySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ALL_BACK_COLOR;
    [self initView];
    // Do any additional setup after loading the view.
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
    UIView *layout_password_change=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    layout_password_change.backgroundColor=[UIColor whiteColor];
    UIImageView *password_change_ico=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [password_change_ico setImage:[UIImage imageNamed:@"ico_password"]];
    UILabel *password_change_text=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
    password_change_text.text=@"密码修改";
    UIImageView *password_change_arrow=[[UIImageView alloc]initWithFrame:CGRectMake(screen_width-20, 10, 20, 20)];
    [password_change_arrow setImage:[UIImage imageNamed:@"ico_right_gray"]];
    [layout_password_change addSubview:password_change_ico];
    [layout_password_change addSubview:password_change_arrow];
    [layout_password_change addSubview:password_change_text];
    UITapGestureRecognizer *password_change_click=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickPasswordChange:)];
    [layout_password_change addGestureRecognizer:password_change_click];
    [_scroll_main addSubview:layout_password_change];
    
    UIView *layout_feed_back=[[UIView alloc]initWithFrame:CGRectMake(0, 41, screen_width, 40)];
    layout_feed_back.backgroundColor=[UIColor whiteColor];
    UIImageView *feed_back_ico=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [feed_back_ico setImage:[UIImage imageNamed:@"ico_feedback"]];
    UILabel *feed_back_text=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
    feed_back_text.text=@"意见反馈";
    [layout_feed_back addSubview:feed_back_ico];
    [layout_feed_back addSubview:feed_back_text];
    UITapGestureRecognizer *feed_back_onclick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickFeedBack:)];
    [layout_feed_back addGestureRecognizer:feed_back_onclick];
    [_scroll_main addSubview:layout_feed_back];
    
    UIView *layout_about_us=[[UIView alloc]initWithFrame:CGRectMake(0, 82, screen_width, 40)];
    layout_about_us.backgroundColor=[UIColor whiteColor];
    UIImageView *about_us_ico=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [about_us_ico setImage:[UIImage imageNamed:@"ico_about_us"]];
    UILabel *about_us_text=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
    about_us_text.text=@"关于我们";
    [layout_about_us addSubview:about_us_ico];
    [layout_about_us addSubview:about_us_text];
    UITapGestureRecognizer *_about_us_click=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickAbout:)];
    [layout_about_us addGestureRecognizer:_about_us_click];
    [_scroll_main addSubview:layout_about_us];
    
    UIView *layout_check_update=[[UIView alloc]initWithFrame:CGRectMake(0, 123, screen_width, 40)];
    layout_check_update.backgroundColor=[UIColor whiteColor];
    UIImageView *check_update_ico=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [check_update_ico setImage:[UIImage imageNamed:@"ico_check_update"]];
    UILabel *check_update_text=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
    check_update_text.text=@"检查更新";
    [layout_check_update addSubview:check_update_ico];
    [layout_check_update addSubview:check_update_text];
    [_scroll_main addSubview:layout_check_update];
    
    UIButton *logout=[[UIButton alloc]initWithFrame:CGRectMake(20, 183, screen_width-40, 40)];
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
-(void)onClickLogout:(id)sender{
    
}
-(void)onClickAbout:(id)sender{
    AboutUSViewController *_about_us=[[AboutUSViewController alloc]init];
    [self.navigationController pushViewController:_about_us animated:YES];
}
-(void)onClickPasswordChange:(id)sender{
    PasswrodChangeViewController *password_change=[[PasswrodChangeViewController alloc]init];
    [self.navigationController pushViewController:password_change animated:YES];
}
-(void)onClickFeedBack:(id)sender{
    FeedBackViewController *feed_back=[[FeedBackViewController alloc]init];
    [self.navigationController pushViewController:feed_back animated:YES];
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
