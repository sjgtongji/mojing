//
//  ContrastView.h
//  VisionDemo
//
//  Created by 张宇行 on 2017/12/23.
//  Copyright © 2017年 SYPJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContrastView : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *imgold;
@property (nonatomic, retain) IBOutlet UIImageView *imgnew;

@property (assign, nonatomic) UIImage *oldimg;
@property (assign, nonatomic) UIImage *newimg;
@end
