//
//  MySendViewController.m
//  IProperty
//
//  Created by csi0n on 1/18/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "MySendViewController.h"
#import "SendViewCell.h"
#import "DetailViewController.h"
#import "SearchViewController.h"
#import "Config.h"
#import "YYModel.h"
@interface MySendViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UILabel *_titleLable;
    UIButton *_back,*_search;
    NSMutableArray *data;
    SDRefreshHeaderView *refreshHeader;
    SDRefreshFooterView *refreshFooter;
}
@end
int TYPE_SEND=0;
int PAGE=1;
@implementation MySendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ALL_BACK_COLOR;
    data=[[NSMutableArray alloc]init];
    [self initView];
    [self initData];
    // Do any additional setup after loading the view.
}
-(void)initView{
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 70) ];
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
    _search=[[UIButton alloc]initWithFrame:CGRectMake(screen_width-40, backView.bounds.size.height/2-5, 30, 30)];
    [_search setImage:[UIImage imageNamed:@"ico_search_white"] forState:UIControlStateNormal];
    [_search addTarget:self action:@selector(onClickSearch:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_search];
    NSArray *arrayStr=[[NSArray alloc]initWithObjects:@"全部分布",@"发布成功",@"发布失败",@"审核中", nil];
    UISegmentedControl *control=[[UISegmentedControl alloc]initWithItems:arrayStr];
    control.frame=CGRectMake(20, 80, screen_width-40, 30);
    control.selectedSegmentIndex = 0;
    control.tintColor = THEME_COLOR;
    [control addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:control];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 120, screen_width, screen_height)style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self setupHeader];
    [self setupFooter];
    
}
-(void)initData{
    [self getSendData:PAGE isRefresh:YES];
}
-(void)setupHeader{
 refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:_tableView];
    [refreshHeader addTarget:self refreshAction:@selector(freshHeader)];
}
- (void)setupFooter{
    refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
}
-(void)freshHeader{
    PAGE=1;
    NSLog(@"%@",@"开始刷新");
    [self getSendData:PAGE isRefresh:YES];
}
- (void)footerRefresh{
    PAGE++;
    [self getSendData:PAGE isRefresh:NO];
}
-(void)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onClickSearch:(id)sender{
    SearchViewController *search=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getSendData:(int)page isRefresh:(BOOL)isrefresh{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD showWithStatus:@"请求数据中..."];
    NSString *url=[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],[UserDataManager getObjectFromConfig:@"url_lists"]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters =@{@"token":[UserDataManager getObjectFromConfig:@"DEFAULT_TOKEN"],@"status":[NSString stringWithFormat:@"%d",TYPE_SEND],@"page":[NSString stringWithFormat:@"%d",page]};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
        manager.requestSerializer.HTTPShouldHandleCookies=YES;
        NSDictionary *resultDic=[StringUtils getDictionaryForJson:operation];
        if ([[resultDic objectForKey:@"status"] isEqualToString:[UserDataManager getObjectFromConfig:@"SUCCESS_CODE"]]) {
             NSDictionary *data_data=[resultDic objectForKey:@"data"];
            if (isrefresh) {
                if (data.count!=0) {
                    [data removeAllObjects];
                }
            }
            NSMutableArray *arrayData=[data_data objectForKey:@"data"];
            for (int i=0; i<arrayData.count; i++) {
                SendModel *send_model=[SendModel yy_modelWithJSON:arrayData[i]];
                [data addObject:send_model];
            }
            [_tableView reloadData];
           
        }else{
        }
        [refreshFooter endRefreshing];
        [refreshHeader endRefreshing];
         [SVProgressHUD dismiss];

    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [refreshFooter endRefreshing];
        [refreshHeader endRefreshing];
         [SVProgressHUD dismiss];
    }];
}
//UITableView程序块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return data.count;
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"MainCell";
    SendViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==nil) {
        cell = [[SendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    SendModel *send=data[indexPath.row];
    [cell setSend_model:send];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detail=[[DetailViewController alloc]init];
    detail.send_data=data[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    PAGE=1;
    switch (Index) {
        case 0:
            TYPE_SEND=0;
            break;
        case 1:
            TYPE_SEND=3;
            break;
        case 2:
            TYPE_SEND=2;
            break;
        case 3:
            TYPE_SEND=1;
            break;
        default:
            break;
    }
    [self getSendData:PAGE isRefresh:YES];
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
