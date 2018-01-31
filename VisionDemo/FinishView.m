//
//  FinishView.m
//  VisionDemo
//
//  Created by 张宇行 on 2017/12/22.
//

#import "FinishView.h"
#import "VisionTableViewController.h"
#import "VisionFaceViewController.h"

@interface FinishView ()

@end

@implementation FinishView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //返回
    UIImage *backimg = [UIImage imageNamed:@"back.png"];
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, backimg.size.width, backimg.size.height)];
    [back setImage:backimg forState:UIControlStateNormal];
    [self.view addSubview:back];
    [self.view bringSubviewToFront:back];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    _oldview.image=_oldimg;
    _newview.image=_newimg;
    _oldview.contentMode = UIViewContentModeScaleAspectFit;
    _newview.contentMode = UIViewContentModeScaleAspectFit;
    
    _lbl.text=_name;
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BackHome:(id)sender {
    
    NSMutableArray *marr =[[NSMutableArray alloc] init] ;
    /*for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[VisionFaceViewController class]]||[vc isKindOfClass:[VisionTableViewController class]]) {
            [marr removeObject:vc];
            return;
        }
    }*/
    [marr addObject:self];
    self.navigationController.viewControllers = marr;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    VisionTableViewController *vc = [story instantiateViewControllerWithIdentifier:@"boardHome"];
    vc.iswait=1;
    [self.navigationController pushViewController:vc animated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self removeFromParentViewController];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dealloc{
    _oldimg=nil;
    [_oldview removeFromSuperview];
    _newimg=nil;
    [_newview removeFromSuperview];
    [self removeFromParentViewController];
}
@end
