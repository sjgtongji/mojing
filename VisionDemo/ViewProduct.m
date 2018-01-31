//
//  ViewProduct.m
//  VisionDemo
//
//  Created by 张宇行 on 2017/12/19.
//

#import "ViewProduct.h"

@interface ViewProduct ()

@end

@implementation ViewProduct

@synthesize mywebview;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://vdlporduct.bangdream.cn:8104/cat_list.asp"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [mywebview loadRequest:request];
    // Do any additional setup after loading the view.
    //返回
    UIImage *backimg = [UIImage imageNamed:@"back.png"];
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, backimg.size.width, backimg.size.height)];
    [back setImage:backimg forState:UIControlStateNormal];
    [self.view addSubview:back];
    [self.view bringSubviewToFront:back];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
