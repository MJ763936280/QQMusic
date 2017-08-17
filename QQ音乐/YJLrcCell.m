

//
//  YJLrcCell.m
//  QQ音乐
//
//  Created by 包宇津 on 16/6/29.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import "YJLrcCell.h"
#import "YJLrcLabel.h"
#import "Masonry.h"
@implementation YJLrcCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        YJLrcLabel *lrcLabel=[[YJLrcLabel alloc]init];
        lrcLabel.textColor=[UIColor blackColor];
        lrcLabel.textAlignment=NSTextAlignmentCenter;
        lrcLabel.font=[UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:lrcLabel];
        _lrcLabel=lrcLabel;
        lrcLabel.translatesAutoresizingMaskIntoConstraints=NO;
        [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}


+(instancetype)lrcCellWithTableView:(UITableView *)tableView{
    static NSString *ID=@"LrcCell";
    YJLrcCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil){
        cell=[[YJLrcCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
       
       
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
         cell.backgroundColor=[UIColor clearColor];
    }
    return cell;
}
@end
