//
//  ListView.m
//  VisionDemo
//
//  Created by 张宇行 on 2017/12/23.
//

#import "ListView.h"

@interface ListView ()

@end

@implementation ListView

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arraysaihong = [NSArray arrayWithObjects:@"101#",@"102#",@"301#",@"601#",@"602#", nil];
    NSArray *arraychuncai = [NSArray arrayWithObjects:@"606#",@"101#",@"505#",@"106#",@"108#", nil];
    NSLog(@"gg - %d",_zhuangdivalue1);
    if(_zhuangdivalue1!=0){
        _imgzhuangdi1.image=[UIImage imageNamed:@"dizhuang1.png"];
        _lblzhuangdi1.text=@"贝壳提亮液";
    }
    if(_zhuangdivalue2!=0){
        _imgzhuangdi2.image=[UIImage imageNamed:@"dizhuang2.png"];
        _lblzhuangdi2.text=@"清新亮肤妆前乳";
    }
    if(_saihongvalue!=0){
        _imgsaihong.image=[UIImage imageNamed:[NSString stringWithFormat:@"fsaihong%d.png",_saihongvalue]];
        _lblsaihong1.text=@"炫彩盛典腮红";
        _lblsaihong2.text=[arraysaihong objectAtIndex:_saihongvalue-1];
    }
    if(_chuncaivalue!=0){
        int t = 0;
        int t2=0;
        NSString *cname=@"";
        if(_chuncaivalue>4700){//k1
            t=_chuncaivalue-4700;
            t2=1;
            cname=@"炫色立方体唇膏";
        }
        else if(_chuncaivalue>4600){//k2
            t=_chuncaivalue-4600;
            t2=2;
            cname=@"炫色立体唇膏";
        }
        else if(_chuncaivalue>4500){//k3
            t=_chuncaivalue-4500;
            t2=3;
            cname=@"炫彩盛典唇膏";
        }
        else{//k4
            t=_chuncaivalue-4400;
            t2=4;
            cname=@"炫彩保湿唇膏";
        }
        _imgchuncai.image=[UIImage imageNamed:[NSString stringWithFormat:@"k%d_%d.png",t2,t]];
        _lblchuncai1.text=cname;
        _lblchuncai2.text=@"";
    }
    if(_yanxianvalue!=0){
        _imgyanxian.image=[UIImage imageNamed:@"yanxian.png"];
        _lblyanxian1.text=@"炫彩盛典眼线液";
        _lblyanxian2.text=@"01BLACK MASCARA";
    }
    if(_yanyingvalue!=0){
        _imgyanying.image=[UIImage imageNamed:@"listjiemao.png"];
        _lblyanying1.text=@"炫色浓密睫毛膏";
        _lblyanying2.text=@"01EYESHADO MASCARA";
    }
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
}
-(void)dealloc{
    _imgzhuangdi1=nil;
    _imgzhuangdi2=nil;
    _imgsaihong=nil;
    _imgchuncai=nil;
    _imgyanxian=nil;
    _imgyanying=nil;
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
