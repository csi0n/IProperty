//
//  DealSendViewController.m
//  iadmin
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "DealSendViewController.h"
#import "Config.h"
#import "UIImageView+AFNetWorking.h"
#import "UserDataManager.h"
#import "RefuseViewController.h"
#import "ProductUser.h"
@interface DealSendViewController (){
    UILabel *_titleLable,*title,*content,*Ncontent,*Nshop,*shop,*Nphone,*phone,*Nadd_time,*add_time;
    UIButton *_back,*approve,*refuse;
    UIScrollView *_main_scroll;
    UIImageView *_head;
}

@end

@implementation DealSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ALL_BACK_COLOR;
    // Do any additional setup after loading the view.
    [self initView];
    [self initData];
}
-(void)initView{
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 70)];
    backView.backgroundColor=THEME_COLOR;
    [self.view addSubview:backView];
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(screen_width/2-(30/2), backView.bounds.size.height/2, 40, 20)];
    _titleLable.text=@"详情";
    _titleLable.textColor=[UIColor whiteColor];
    [backView addSubview:_titleLable];
    _back=[[UIButton alloc]initWithFrame:CGRectMake(10, backView.bounds.size.height/2-10, 40, 40)];
    [_back setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_back];
    
    _main_scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 71, screen_width, screen_height-71)];
    _head=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_width)];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],_send_data.photo]];
    [_head setImageWithURL:url];
    [_main_scroll addSubview:_head];
    UIView *layout_title_contet=[[UIView alloc]initWithFrame:CGRectMake(0, screen_width+1, screen_width, 60)];
    layout_title_contet.backgroundColor=[UIColor whiteColor];
    title=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    title.textColor=THEME_COLOR;
    title.font=[UIFont systemFontOfSize:15];
    title.text=_send_data.title;
    [layout_title_contet addSubview:title];
    Ncontent=[[UILabel alloc]initWithFrame:CGRectMake(10, 35, 80, 20)];
    Ncontent.text=@"商品详情:";
    Ncontent.font=[UIFont systemFontOfSize:15];
    [layout_title_contet addSubview:Ncontent];
    content=[[UILabel alloc]initWithFrame:CGRectMake(95, 35, screen_width-95, 20)];
    content.text=_send_data.content;
    content.textColor=[UIColor grayColor];
    content.font=[UIFont systemFontOfSize:13];
    [layout_title_contet addSubview:content];
    [_main_scroll addSubview:layout_title_contet];
    
    UIView *layout_shop=[[UIView alloc]initWithFrame:CGRectMake(0, screen_width+72, screen_width, 40)];
    layout_shop.backgroundColor=[UIColor whiteColor];
    Nshop=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
    Nshop.text=@"店铺名称:";
    Nshop.font=[UIFont systemFontOfSize:15];
    [layout_shop addSubview:Nshop];
    shop=[[UILabel alloc]initWithFrame:CGRectMake(95, 10, screen_width-95, 20)];
    shop.text=@"呵呵哒商店";
    shop.textColor=[UIColor grayColor];
    shop.font=[UIFont systemFontOfSize:13];
    [layout_shop addSubview:shop];
    [_main_scroll addSubview:layout_shop];
    
    UIView *layout_phone=[[UIView alloc]initWithFrame:CGRectMake(0, screen_width+113, screen_width, 40)];
    layout_phone.backgroundColor=[UIColor whiteColor];
    Nphone=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
    Nphone.text=@"手机号码:";
    Nphone.font=[UIFont systemFontOfSize:15];
    [layout_phone addSubview:Nphone];
    phone=[[UILabel alloc]initWithFrame:CGRectMake(95, 10, screen_width-95, 20)];
    phone.text=@"18012486671";
    phone.textColor=[UIColor grayColor];
    phone.font=[UIFont systemFontOfSize:13];
    [layout_phone addSubview:phone];
    [_main_scroll addSubview:layout_phone];
    
    UIView *layout_send_time=[[UIView alloc]initWithFrame:CGRectMake(0, screen_width+163, screen_width, 40)];
    layout_send_time.backgroundColor=[UIColor whiteColor];
    Nadd_time=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
    Nadd_time.text=@"添加时间:";
    Nadd_time.font=[UIFont systemFontOfSize:15];
    [layout_send_time addSubview:Nadd_time];
    add_time=[[UILabel alloc]initWithFrame:CGRectMake(95, 10, screen_width-95, 20)];
    add_time.text=[StringUtils getTimeByUnix:_send_data.add_time];
    add_time.textColor=[UIColor grayColor];
    add_time.font=[UIFont systemFontOfSize:13];
    [layout_send_time addSubview:add_time];
    [_main_scroll addSubview:layout_send_time];
    
    approve=[[UIButton alloc]initWithFrame:CGRectMake(10, screen_width+213, screen_width/2-15, 40)];
    approve.backgroundColor=THEME_COLOR;
    [approve setTitle:@"批准" forState:UIControlStateNormal];
    [approve.layer setCornerRadius:5.0];
    [approve addTarget:self action:@selector(onClickApprove:) forControlEvents:UIControlEventTouchUpInside];
    [_main_scroll addSubview:approve];
    
    refuse=[[UIButton alloc]initWithFrame:CGRectMake(screen_width/2+5, screen_width+213, screen_width/2-15, 40)];
    refuse.backgroundColor=[UIColor redColor];
    [refuse setTitle:@"拒绝" forState:UIControlStateNormal];
    [refuse.layer setCornerRadius:5.0];
    [refuse addTarget:self action:@selector(onClickRefuse:) forControlEvents:UIControlEventTouchUpInside];
    [_main_scroll addSubview:refuse];
    _main_scroll.contentSize = CGSizeMake(screen_width, screen_width+253);
    [_main_scroll flashScrollIndicators];
    // 是否同时运动,lock
    _main_scroll.directionalLockEnabled = YES;
    _main_scroll.showsVerticalScrollIndicator = FALSE;
    _main_scroll.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:_main_scroll];
}
-(void)onClickApprove:(id)sender{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD showWithStatus:@"批准中..."];
    NSString *url=[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],[UserDataManager getObjectFromConfig:@"url_checkPost"]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters =@{@"token":[UserDataManager getObjectFromConfig:@"DEFAULT_TOKEN"],@"status":@"3",@"publish_id":_send_data.id};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
        manager.requestSerializer.HTTPShouldHandleCookies=YES;
        NSDictionary *resultDic=[StringUtils getDictionaryForJson:operation];
        if ([[resultDic objectForKey:@"status"] isEqualToString:[UserDataManager getObjectFromConfig:@"SUCCESS_CODE"]]) {
            [SVProgressHUD dismiss];
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showErrorWithStatus:@"批准成功!"];
        }else{
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showInfoWithStatus:[resultDic objectForKey:@"info"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:@"批准失败!"];
    }];
}
-(void)initData{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD showWithStatus:@"获取详细数据..."];
    NSString *url=[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],[UserDataManager getObjectFromConfig:@"url_getBusinessInfo"]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters =@{@"token":[UserDataManager getObjectFromConfig:@"DEFAULT_TOKEN"],@"user_id":_send_data.user_id};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject) {
        manager.requestSerializer.HTTPShouldHandleCookies=YES;
        NSDictionary *resultDic=[StringUtils getDictionaryForJson:operation];
        if ([[resultDic objectForKey:@"status"] isEqualToString:[UserDataManager getObjectFromConfig:@"SUCCESS_CODE"]]) {
            [SVProgressHUD dismiss];
            ProductUser *product_user=[ProductUser yy_modelWithJSON:[resultDic objectForKey:@"data"]];
            phone.text=product_user.phone;
            shop.text=product_user.address;
        }else{
            [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
            [SVProgressHUD showInfoWithStatus:[resultDic objectForKey:@"info"]];
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:3];
        [SVProgressHUD showErrorWithStatus:@"获取详细信息失败!"];
    }];
}
- (void)dismiss:(id)sender {
    [SVProgressHUD dismiss];
}
-(void)onClickRefuse:(id)sender{
    RefuseViewController *refuse=[[RefuseViewController alloc]init];
    refuse.send_data=_send_data;
    [self.navigationController pushViewController:refuse animated:YES];
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
