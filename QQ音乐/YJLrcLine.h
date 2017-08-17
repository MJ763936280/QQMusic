//
//  YJLrcLine.h
//  QQ音乐
//
//  Created by 包宇津 on 16/6/24.
//  Copyright © 2016年 BYJ_2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJLrcLine : NSObject
@property (copy,nonatomic) NSString *text;
@property (nonatomic,assign) NSTimeInterval time;
-(instancetype)initWithLrclineString:(NSString *)lrclineString;
+(instancetype)lrcLineWithLrclineString:(NSString *)lrclineString;
@end
