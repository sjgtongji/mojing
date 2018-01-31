//
//  ContrastView.m
//  VisionDemo
//
//  Created by 张宇行 on 2017/12/23.
//  Copyright © 2017年 SYPJ. All rights reserved.
//

#import "ContrastView.h"

@interface ContrastView ()

@end

@implementation ContrastView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    //返回
    UIImage *backimg = [UIImage imageNamed:@"back.png"];
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, backimg.size.width, backimg.size.height)];
    [back setImage:backimg forState:UIControlStateNormal];
    [self.view addSubview:back];
    [self.view bringSubviewToFront:back];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    _imgold.image=_oldimg;
    _imgnew.image=_newimg;
    _imgold.contentMode = UIViewContentModeScaleAspectFit;
    _imgnew.contentMode = UIViewContentModeScaleAspectFit;
}
- (void)back:(UIButton *)sender
{
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
