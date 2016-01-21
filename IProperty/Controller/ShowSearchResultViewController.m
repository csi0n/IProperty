//
//  ShowSearchResultViewController.m
//  IProperty
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "ShowSearchResultViewController.h"
#import "Config.h"
#import "SendModel.h"
#import "YYModel.h"
#import "SendViewCell.h"
#import "DetailViewController.h"
@interface ShowSearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UILabel *_titleLable;
    UIButton *_back;
    NSMutableArray *data;
    SDRefreshHeaderView *refreshHeader;
    SDRefreshFooterView *refreshFooter;
}

@end
int SEARCH_PAGE=1;
@implementation ShowSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ALL_BACK_COLOR;
    [self initView];
    [self initData];
    // Do any additional setup after loading the view.
}
-(void)initView{
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 70)];
    backView.backgroundColor=THEME_COLOR;
    [self.view addSubview:backView];
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(screen_width/2-(30/2), backView.bounds.size.height/2, 40, 20)];
    _titleLable.text=@"搜索";
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    _back=[[UIButton alloc]initWithFrame:CGRectMake(10, backView.bounds.size.height/2-10, 40, 40)];
    [_back setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_back];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 71, screen_width, screen_height)style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self setupHeader];
    [self setupFooter];
}
-(void)initData{
    [self getSendData:SEARCH_PAGE isRefresh:YES];
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
    SEARCH_PAGE=1;
    NSLog(@"%@",@"开始刷新");
    [self getSendData:SEARCH_PAGE isRefresh:YES];
}
- (void)footerRefresh{
    SEARCH_PAGE++;
    [self getSendData:SEARCH_PAGE isRefresh:NO];
}
-(void)getSendData:(int)page isRefresh:(BOOL)isrefresh{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD showWithStatus:@"请求数据中..."];
    NSString *url=[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],[UserDataManager getObjectFromConfig:@"url_lists"]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters =@{@"token":[UserDataManager getObjectFromConfig:@"DEFAULT_TOKEN"],@"page":[NSString stringWithFormat:@"%d",page],@"keyword":_key,@"status":@"0"};
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
