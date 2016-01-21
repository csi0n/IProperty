//
//  SearchViewController.m
//  iadmin
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "SearchViewController.h"
#import "Config.h"
#import "FMDB.h"
#import "SearchKeyModel.h"
#import "ShowSearchResultViewController.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIButton *_back,*_search;
    UITextField *_searchContent;
    FMDatabase *db;
    NSMutableArray *data;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=ALL_BACK_COLOR;
    // Do any additional setup after loading the view.
    [self initView];
    [self initDB];
    [self initData];
}
-(void)initDB{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[paths objectAtIndex:0];
    NSString *dbPath=[documentDirectory stringByAppendingPathComponent:@"iadmin.db"];
    db=[FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"无法打开数据库!");
        return;
    }
    if ([db executeUpdate:@"CREATE TABLE IF NOT EXISTS SEARCH_KEY (key text,create_time integer)"]) {
        NSLog(@"成功创建数据库");
    }else{
        NSLog(@"创建数据库失败");
    }
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
    [_search addTarget:self action:@selector(onClickSearch:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_search];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 71, screen_width, screen_height)style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
}
-(void)initData{
    data=[[NSMutableArray alloc]init];
    FMResultSet *resultSet=[db executeQuery:@"SELECT * FROM SEARCH_KEY ORDER BY create_time desc;"];
    while ([resultSet next]) {
        SearchKeyModel *search_key=[[SearchKeyModel alloc]init];
        search_key.key=[resultSet stringForColumn:@"key"];
        search_key.create_time=[resultSet stringForColumn:@"create_time"];
        [data addObject:search_key];
    }
    
}
-(void)onClickSearch:(id)sender{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    if ([StringUtils isEmpty:_searchContent.text]) {
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showInfoWithStatus:@"搜索内容不能为空!"];
        return;
    }else{
        [db executeUpdate:@"DELETE FROM SEARCH_KEY WHERE key='?';",_searchContent.text];
        [db executeUpdate:@"INSERT INTO SEARCH_KEY (key,create_time) values (?,?);",_searchContent.text,[StringUtils getUnixTime]];
        ShowSearchResultViewController *show_search=[[ShowSearchResultViewController alloc]init];
        show_search.key=_searchContent.text;
        [self.navigationController pushViewController:show_search animated:YES];
    }
    
}
//UITableView程序块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return data.count;
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (data.count==0) {
        return 0;
    }else{ return data.count+1;}
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.textAlignment=UITextAlignmentCenter;
    if (indexPath.row==data.count) {
        cell.textLabel.text=@"清除记录";
        cell.textLabel.textColor=THEME_COLOR;
    }else{
        SearchKeyModel *search_key=data[indexPath.row];
        cell.textLabel.text=search_key.key;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==data.count) {
        [self showOkayCancelAlert];
    }else{
        ShowSearchResultViewController *show_search=[[ShowSearchResultViewController alloc]init];
        SearchKeyModel *searchkey=data[indexPath.row];
        show_search.key=searchkey.key;
        [self.navigationController pushViewController:show_search animated:YES];
    }
}
- (void)showOkayCancelAlert {
    NSString *title = NSLocalizedString(@"是否清楚记录?", nil);
    NSString *message = NSLocalizedString(@"是否要清楚搜索记录?", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确认", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([db executeUpdate:@"DROP TABLE IF EXISTS SEARCH_KEY;"]) {
            NSLog(@"删除搜索表成功");
            [data removeAllObjects];
            [_tableView reloadData];
        }else{
            NSLog(@"删除搜索表失败");
        }
    }];
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
