//
//  MainViewController.m
//  IProperty
//
//  Created by csi0n on 1/17/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "MainViewController.h"
#import "Config.h"
@interface MainViewController (){
    UILabel *_titleLable,*_unamelable;
    UIImageView *_headimageview,*_rightGrayArrow;
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
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(backView.bounds.size.width/2-(130/2), backView.bounds.size.height/2-(20/2)+5, 130, 20)];
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

}
-(void)initData{
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
