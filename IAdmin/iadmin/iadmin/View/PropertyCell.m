//
//  PropertyCell.m
//  iadmin
//
//  Created by csi0n on 1/21/16.
//  Copyright © 2016 csi0n. All rights reserved.
//

#import "PropertyCell.h"
#import "Config.h"
@interface PropertyCell(){
    UILabel *title,*content;
}
@end
@implementation PropertyCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, screen_width-20, 30)];
        title.font=[UIFont systemFontOfSize:18];
        [self.contentView addSubview:title];
        content=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, screen_width-20, 50)];
        content.textColor=[UIColor grayColor];
        content.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:content];
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 80, screen_width, 0.5)];
        line.backgroundColor=ALL_BACK_COLOR;
        [self.contentView addSubview:line];
    }
    return self;
}
-(void)setSend_model:(SendModel *)send_model{
    _send_model=send_model;
    title.text=send_model.title;
    content.text=[StringUtils getTimeByUnix:send_model.add_time];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
