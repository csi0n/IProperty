//
//  SendCell.m
//  iadmin
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "SendCell.h"
#import "Config.h"
#import "UIImageView+AFNetWorking.h"
@interface SendCell(){
    UIImageView *_head;
    UILabel *_title,*_content,*_time;
}
@end
@implementation SendCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        _head=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        [self.contentView addSubview:_head];
        _title=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, screen_height-80, 20)];
        _content=[[UILabel alloc]initWithFrame:CGRectMake(80, 40, screen_height-80, 30)];
        _content.font=[UIFont systemFontOfSize:13];
        _content.textColor=[UIColor grayColor];
        _time=[[UILabel alloc]initWithFrame:CGRectMake(screen_width-90, 60, 80, 15)];
        _time.font=[UIFont systemFontOfSize:13];
        _time.textColor=[UIColor grayColor];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_content];
        [self.contentView addSubview:_time];
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 80, screen_width, 0.5)];
        line.backgroundColor=ALL_BACK_COLOR;
        [self.contentView addSubview:line];
    }
    return self;
}
-(void)setSend_model:(SendModel *)send_model{
    _send_model=send_model;
    NSURL *url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@",[UserDataManager getObjectFromConfig:@"BASE_URL"],send_model.photo]];
    [_head setImageWithURL:url];
    _title.text=send_model.title;
    _content.text=send_model.content;
    _time.text=[StringUtils getTimeByUnix:send_model.add_time];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
