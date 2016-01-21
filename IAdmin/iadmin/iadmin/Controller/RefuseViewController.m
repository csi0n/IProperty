//
//  RefuseViewController.m
//  iadmin
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "RefuseViewController.h"
#import "Config.h"
#import "StringUtils.h"
#import "UIPlaceholderTextView.h"
@interface RefuseViewController (){
    UILabel *_titleLable;
    UIButton *_back,*_submit;
    UIPlaceholderTextView *content;
}

@end

@implementation RefuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=ALL_BACK_COLOR;
    [self initView];
}
-(void)initView{
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 70)];
    backView.backgroundColor=THEME_COLOR;
    [self.view addSubview:backView];
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(screen_width/2-50, backView.bounds.size.height/2, 100, 20)];
    _titleLable.textAlignment=NSTextAlignmentCenter;
    _titleLable.text=@"拒绝理由";
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    _back=[[UIButton alloc]initWithFrame:CGRectMake(10, backView.bounds.size.height/2-10, 40, 40)];
    [_back setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_back];
    
    content=[[UIPlaceholderTextView alloc]initWithFrame:CGRectMake(10, 80, screen_width-20, 200)];
    [content setContentOffset:CGPointZero];
    content.layer.borderWidth = 0.5;
    content.layer.borderColor = [UIColor grayColor].CGColor;
    content.layer.cornerRadius=5.0;
    content.font=[UIFont systemFontOfSize:15];
    content.contentInset = UIEdgeInsetsMake(0,0,0,0);
    content.placeholder=@"请输入拒绝理由";
    [self.view addSubview:content];
    _submit=[[UIButton alloc]initWithFrame:CGRectMake(10, 290, screen_width-20, 40)];
    _submit.backgroundColor=THEME_COLOR;
    [_submit setTitle:@"提交" forState:UIControlStateNormal];
    [_submit.layer setCornerRadius:5.0];
    [_submit addTarget:self action:@selector(onClickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submit];
}
-(void)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onClickSubmit:(id)sender{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    if ([StringUtils isEmpty:content.text]) {
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showInfoWithStatus:@"拒绝内容为空!"];
        return;
    }else{
        [SVProgressHUD showWithStatus:@"提交中..."];
        NSString *url=[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],[UserDataManager getObjectFromConfig:@"url_checkPost"]];
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *parameters =@{@"token":[UserDataManager getObjectFromConfig:@"DEFAULT_TOKEN"],@"refuse_reason":content.text,@"status":@"2",@"publish_id":_send_data.id};
        NSLog(@"%@",url);
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
            manager.requestSerializer.HTTPShouldHandleCookies=YES;
            NSDictionary *resultDic=[StringUtils getDictionaryForJson:operation];
            if ([[resultDic objectForKey:@"status"] isEqualToString:[UserDataManager getObjectFromConfig:@"SUCCESS_CODE"]]) {
                [SVProgressHUD dismiss];
                [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
                [SVProgressHUD showSuccessWithStatus:@"拒绝成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
                [SVProgressHUD showInfoWithStatus:[resultDic objectForKey:@"info"]];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            NSLog(@"%@",error);
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showErrorWithStatus:@"拒绝失败!"];
        }];
    }
}
- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
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
