//
//  myScrollView.m
//  VisionDemo
//
//  Created by 张宇行 on 2017/12/27.
//  Copyright © 2017年 SYPJ. All rights reserved.
//

#import "myScrollView.h"
@implementation myScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor yellowColor]];
    }
    return self;
}


- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    NSLog(@"用户点击了scroll上的视图%@,是否开始滚动scroll",view);
    //返回yes 是不滚动 scroll 返回no 是滚动scroll
    return YES;
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    
    NSLog(@"用户点击的视图 %@",view);
    
    //NO scroll不可以滚动 YES scroll可以滚动
    return NO;
}
@end
