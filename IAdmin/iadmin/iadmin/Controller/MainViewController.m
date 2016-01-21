//
//  MainViewController.m
//  iadmin
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "MainViewController.h"
#import "Config.h"
#import "SendModel.h"
#import "PropertyCell.h"
#import "SendCell.h"
#import "SettingViewController.h"
#import "SearchViewController.h"
#import "DealPropertyViewController.h"
#import "DealSendViewController.h"
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UILabel *_titleLable;
    UIButton *_search,*_setting;
    NSMutableArray *data;
    SDRefreshHeaderView *refreshHeader;
    SDRefreshFooterView *refreshFooter;
}
@end
int TYPE_SEND=0;
int PAGE=1;
@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ALL_BACK_COLOR;
    data=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [self initView];
    [self initData];
}
-(void)initView{
    //顶部状态栏
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 70)];
    backView.backgroundColor=THEME_COLOR;
    [self.view addSubview:backView];
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(10, backView.bounds.size.height/2, 80, 20)];
    _titleLable.text=_user_data.account;
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    _setting=[[UIButton alloc]initWithFrame:CGRectMake(screen_width-30, backView.bounds.size.height/2, 20, 20)];
    [_setting setImage:[UIImage imageNamed:@"ico_setting"] forState:UIControlStateNormal];
    [_setting addTarget:self action:@selector(onClickSetting:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_setting];
    _search=[[UIButton alloc]initWithFrame:CGRectMake(screen_width-60, backView.bounds.size.height/2, 20, 20)];
    [_search setImage:[UIImage imageNamed:@"ico_search_white"] forState:UIControlStateNormal];
    [_search addTarget:self action:@selector(onClickSearch:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_search];
    NSArray *arrayStr=[[NSArray alloc]initWithObjects:@"所有分布",@"已批准",@"已拒绝",@"未处理", nil];
    UISegmentedControl *control=[[UISegmentedControl alloc]initWithItems:arrayStr];
    control.frame=CGRectMake(20, 80, screen_width-40, 30);
    control.selectedSegmentIndex = 0;
    control.tintColor = THEME_COLOR;
    [control addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:control];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 120, screen_width, screen_height-120)style:UITableViewStylePlain];
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
-(void)onClickSetting:(id)sender{
    SettingViewController *setting=[[SettingViewController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}
-(void)onClickSearch:(id)sender{
    SearchViewController *search_view=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:search_view animated:YES];
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
        NSLog(@"%@",responseObject);
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SendModel *send=data[indexPath.row];
    if ([send.type_id isEqualToString:@"2"]||[send.type_id isEqualToString:@"3"]) {
        static NSString *property_cellIndentifier=@"PropertyCell";
        PropertyCell *propertycell=[tableView dequeueReusableCellWithIdentifier:property_cellIndentifier];
        if (propertycell==nil) {
            propertycell = [[PropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:property_cellIndentifier];
        }
        [propertycell setSend_model:send];
        return propertycell;
    }else{
        static NSString *send_cellIndentifier=@"SendCell";
        SendCell *sendcell=[tableView dequeueReusableCellWithIdentifier:send_cellIndentifier];
        if (sendcell==nil) {
            sendcell=[[SendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:send_cellIndentifier];
        }
        [sendcell setSend_model:send];
        return sendcell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SendModel *send_model=data[indexPath.row];
    if ([send_model.type_id isEqualToString:@"2"]||[send_model.type_id isEqualToString:@"3"]) {
        DealPropertyViewController *dealproperty=[[DealPropertyViewController alloc]init];
        dealproperty.send_data=send_model;
        [self.navigationController pushViewController:dealproperty animated:YES];
    }else{
        DealSendViewController *deal_send=[[DealSendViewController alloc]init];
        deal_send.send_data=send_model;
        [self.navigationController pushViewController:deal_send animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
