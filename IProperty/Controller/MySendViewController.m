//
//  MySendViewController.m
//  IProperty
//
//  Created by csi0n on 1/18/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "MySendViewController.h"
#import "Config.h"
@interface MySendViewController (){
    UILabel *_titleLable;
    UIButton *_back;
}

@end

@implementation MySendViewController

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
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(screen_width/2-30, backView.bounds.size.height/2, 80, 20)];
    _titleLable.text=@"我的发布";
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    _back=[[UIButton alloc]initWithFrame:CGRectMake(10, backView.bounds.size.height/2-10, 40, 40)];
    [_back setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_back];
    NSArray *arrayStr=[[NSArray alloc]initWithObjects:@"全部分布",@"发布成功",@"发布失败",@"审核中", nil];
    UISegmentedControl *control=[[UISegmentedControl alloc]initWithItems:arrayStr];
    control.frame=CGRectMake(20, 80, screen_width-40, 30);
    control.selectedSegmentIndex = 1;
    control.tintColor = THEME_COLOR;
    [self.view addSubview:control];
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
