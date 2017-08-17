//
//  YJTableView.m
//  QQ音乐
//
//  Created by 包宇津 on 16/6/29.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import "YJTableView.h"

@implementation YJTableView
+(YJTableView *)createTableView{
    YJTableView *tableView=[[YJTableView alloc]init];
    tableView.backgroundColor=[UIColor clearColor];
    return tableView;
}
@end
