//
//  YJLrcCell.h
//  QQ音乐
//
//  Created by 包宇津 on 16/6/29.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJLrcLabel;
@interface YJLrcCell : UITableViewCell

@property (nonatomic,weak,readonly) YJLrcLabel *lrcLabel;
+(instancetype)lrcCellWithTableView:(UITableView *)tableView;
@end
