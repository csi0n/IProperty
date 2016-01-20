
//
//  SearchViewController.m
//  IProperty
//
//  Created by csi0n on 1/20/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "SearchViewController.h"
#import "Config.h"
#import "FMDB.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITextField *_searchContent;
    UIButton *_back,*_search;
}

@end

@implementation SearchViewController

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
    _back=[[UIButton alloc]initWithFrame:CGRectMake(10, backView.bounds.size.height/2-10, 40, 40)];
    [_back setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_back];
    _searchContent=[[UITextField alloc]initWithFrame:CGRectMake(60, backView.bounds.size.height/2-5, screen_width-110, 30)];
    _searchContent.placeholder=@"请输入搜索内容";
     [_searchContent setBorderStyle:UITextBorderStyleRoundedRect];
    _searchContent.font=[UIFont systemFontOfSize:18];
    [backView addSubview:_searchContent];
    _search=[[UIButton alloc]initWithFrame:CGRectMake(screen_width-40, backView.bounds.size.height/2-5, 30, 30)];
    [_search setImage:[UIImage imageNamed:@"ico_search_white"] forState:UIControlStateNormal];
    [backView addSubview:_search];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 71, screen_width, screen_height)style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
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
