//
//  MainViewController.m
//  IProperty
//
//  Created by csi0n on 1/17/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "MainViewController.h"
#import "MySettingViewController.h"
#import "MySendViewController.h"
#import "IWantSendViewController.h"
#import "Config.h"
@interface MainViewController (){
    UILabel *_titleLable,*_unamelable,*_my_send;
    UIImageView *_headimageview,*_rightGrayArrow,*_rightGrayArrow_send;
    UIButton *_i_want_send;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor=ALL_BACK_COLOR;
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self initData];
}
-(void)initView{
    //顶部状态栏
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 70)];
    backView.backgroundColor=THEME_COLOR;
    [self.view addSubview:backView];
    
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(backView.bounds.size.width/2-60, backView.bounds.size.height/2, 130, 20)];
    _titleLable.text=@"智慧社区物业版";
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    //头像一栏
    UIView *layout_head=[[UIView alloc]initWithFrame:CGRectMake(0, 71, screen_width, 100)];
    layout_head.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:layout_head];
    //头像
    _headimageview=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    [_headimageview setImage:[UIImage imageNamed:@"ic_launcher"]];
    _headimageview.layer.masksToBounds=YES;
    _headimageview.layer.cornerRadius=30;
    UITapGestureRecognizer *layout_head_click=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickMySetting:)];
    [layout_head addGestureRecognizer:layout_head_click];
    [layout_head addSubview:_headimageview];
    //昵称
    _unamelable=[[UILabel alloc] initWithFrame:CGRectMake(90, 40, 100, 20)];
    _unamelable.text=@"csi0n";
    _unamelable.textColor=[UIColor blackColor];
    [layout_head addSubview:_unamelable];
    //头像一栏箭头
    _rightGrayArrow=[[UIImageView alloc] initWithFrame:CGRectMake(screen_width-30, 40, 20, 20)];
    [_rightGrayArrow setImage:[UIImage imageNamed:@"ico_right_gray"]];
    [layout_head addSubview:_rightGrayArrow];
    UIView *layout_my_send=[[UIView alloc]initWithFrame:CGRectMake(0, 172, screen_width, 50)];
    layout_my_send.backgroundColor=[UIColor whiteColor];
    UITapGestureRecognizer *layout_my_send_click=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickMySend:)];
    [layout_my_send addGestureRecognizer:layout_my_send_click];
    [self.view addSubview:layout_my_send];
    _my_send=[[UILabel alloc]initWithFrame:CGRectMake(20, 13, 100, 25)];
    _my_send.text=@"我的发布";
    _rightGrayArrow_send=[[UIImageView alloc]initWithFrame:CGRectMake(screen_width-30, 13, 20, 20)];
    [_rightGrayArrow_send setImage:[UIImage imageNamed:@"ico_right_gray"]];
    [layout_my_send addSubview:_rightGrayArrow_send];
    [layout_my_send addSubview:_my_send];
    _i_want_send=[[UIButton alloc]initWithFrame:CGRectMake(20, 253, screen_width-40, 40)];
    _i_want_send.backgroundColor=THEME_COLOR;
    [_i_want_send setTitle:@"我要发布" forState:UIControlStateNormal];
    [_i_want_send.layer setCornerRadius:5.0];
    [_i_want_send addTarget:self action:@selector(onClickIwantSend:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_i_want_send];
}
-(void)initData{
}
-(void)onClickMySend:(id)sender{
    MySendViewController *my_send=[[MySendViewController alloc]init];
    [self.navigationController pushViewController:my_send animated:YES];
}
-(void)onClickIwantSend:(id)sender{
    IWantSendViewController *i_want_send=[[IWantSendViewController alloc]init];
    [self.navigationController pushViewController:i_want_send animated:YES];
}
-(void)onClickMySetting:(id)sender{
    MySettingViewController *setting=[[MySettingViewController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
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
