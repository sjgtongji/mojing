//
//  VisionCheckViewController.m
//  VisionDemo
//

#import "VisionFaceViewController.h"

#import "GLTools.h"
#import "GLDiscernPointModel.h"
#import "UIImage+GLProcessing.h"
#import "NSObject+Define.h"
#import "FinishView.h"
#import "ListView.h"
#import "ContrastView.h"
#import "myScrollView.h"


@interface VisionFaceViewController (){
    int currentShow;
    GLDiscernPointModel * _Nonnull pointModelCur;
    UIView *clearclick;
    UIView *mainview;
    int l_zhuangdi1;
    int l_zhuangdi2;
    int l_saihong;
    int l_chuncai;
    int l_yanxian;
    int l_yanying;
    UIActivityIndicatorView *loading;
    UIView *loadingbg;
}

@property (strong, nonatomic) UIImageView *visionImageView;

@property (nonatomic,strong) UIImage *visonImage;

@property (nonatomic,strong) UIImage *visonImageOld;

@property (nonatomic,strong) UIImage *visonImageNew;

@property (nonatomic,assign) GLDiscernType discernType;

@end

@implementation VisionFaceViewController

- (id)initWithImage:(UIImage *)image discernType:(GLDiscernType)type{
    self = [super init];
    if (self) {
        self.visonImage = image;
        self.visonImageOld = image;
        
        self.discernType = type;
    }
    return self;
}

- (void)viewDidLoad {
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.visionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.78)];
    self.visionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    l_zhuangdi1=l_zhuangdi2=l_saihong=l_chuncai=l_yanying=l_yanxian=0;
    
    mainview = [[UIView alloc] initWithFrame:self.visionImageView.frame];
    [mainview addSubview:self.visionImageView];
    [self.view addSubview:mainview];
    
    self.visionImageView.image = self.visonImage;
    [self checkImage:self.visonImage];
    //底部工具背景
    UIImageView *underbg =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolunder.png"]];
    underbg.frame=CGRectMake(0, (SCREEN_HEIGHT-underbg.frame.size.height),underbg.frame.size.width,underbg.frame.size.height);
    [self.view addSubview:underbg];
    //返回
    UIImage *backimg = [UIImage imageNamed:@"back.png"];
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, backimg.size.width, backimg.size.height)];
    [back setImage:backimg forState:UIControlStateNormal];
    [self.view addSubview:back];
    [self.view bringSubviewToFront:back];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    //保存
    UIImage *saveimg = [UIImage imageNamed:@"finish"];
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-saveimg.size.width-20, 40, saveimg.size.width, saveimg.size.height)];
    [save setImage:saveimg forState:UIControlStateNormal];
    [self.view bringSubviewToFront:save];
    [self.view addSubview:save];
    [save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    //上妆
    for (int i=0; i<6; i++) {
        NSString *name;
        if(i==0)
            name=[NSString stringWithFormat:@"s%d_",i];
        else
            name=[NSString stringWithFormat:@"s%d",i];
        UIImage *img =[UIImage imageNamed:name];
        UIView *imgclick = [[UIView alloc] initWithFrame:CGRectMake(100*(i)+50,SCREEN_HEIGHT-underbg.frame.size.height+9,  img.size.width, img.size.height)];
        UIImageView *iv = [[UIImageView alloc] initWithImage:img];
        iv.frame=CGRectMake(0,0,  img.size.width, img.size.height);
        [imgclick setTag:100+i];
        [imgclick addSubview:iv];
        [self.view addSubview:imgclick];
    }
    //选择bg
    UIImageView *selectbg =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbg2.png"]];
    selectbg.frame=CGRectMake(0, (SCREEN_HEIGHT-underbg.frame.size.height-selectbg.frame.size.height),selectbg.frame.size.width,selectbg.frame.size.height);
    [self.view addSubview:selectbg];
    //主题装
    UIView *viewbox =[[UIView alloc] initWithFrame:selectbg.frame];
    [viewbox setTag:500];
    currentShow=500;
    for (int i=0; i<4; i++) {
        UIView *imgclick = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIImageView *img;
        img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"zhuti%d.png",(i+1)]]];
        imgclick.frame=CGRectMake(165+(94*i), 20, img.frame.size.width, img.frame.size.height);
        
        [imgclick setTag:5000+i+1];
        [imgclick addSubview:img];
        [viewbox addSubview:imgclick];
    }
    [self.view addSubview:viewbox];
    //贝壳提亮
    UIView *viewbox0 =[[UIView alloc] initWithFrame:selectbg.frame];
    [viewbox0 setTag:480];
    
    for (int i=0; i<2; i++) {
        UIView *imgclick = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIImageView *img;
        if(i==0){
            img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"f0_0.png"]];
            imgclick.frame=CGRectMake(28, 20, img.frame.size.width, img.frame.size.height);
        }
        else{
            img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"f0_1.png"]];
            imgclick.frame=CGRectMake(265+(160*(i-1)), 20, img.frame.size.width, img.frame.size.height);
        }
        [imgclick setTag:4800+i];
        [imgclick addSubview:img];
        [viewbox0 addSubview:imgclick];
    }
    [viewbox0 setHidden:YES];
    [self.view addSubview:viewbox0];
    //妆前乳
    UIView *viewbox00 =[[UIView alloc] initWithFrame:selectbg.frame];
    [viewbox00 setTag:490];
    
    for (int i=0; i<2; i++) {
        UIView *imgclick = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIImageView *img;
        if(i==0){
            img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"f1_0.png"]];
            imgclick.frame=CGRectMake(28, 20, img.frame.size.width, img.frame.size.height);
        }
        else{
            img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"f0_2.png"]];
            imgclick.frame=CGRectMake(265+(100*(i-1)), 20, img.frame.size.width, img.frame.size.height);
        }
        [imgclick setTag:4900+i];
        [imgclick addSubview:img];
        [viewbox00 addSubview:imgclick];
    }
    [viewbox00 setHidden:YES];
    [self.view addSubview:viewbox00];
    
    
    
    //腮红
    UIView *viewbox2 =[[UIView alloc] initWithFrame:selectbg.frame];
    [viewbox2 setTag:520];
    
    for (int i=0; i<6; i++) {
        UIView *imgclick = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"f2_%d.png",i]]];
        if(i==0)
            imgclick.frame=CGRectMake(28, 20, img.frame.size.width, img.frame.size.height);
        else{
            imgclick.frame=CGRectMake(265+(100*(i-1)), 20, img.frame.size.width, img.frame.size.height);
            [imgclick setTag:5200+i];
        }
        img.frame=CGRectMake(0, 0, imgclick.frame.size.width, imgclick.frame.size.height);
        [imgclick addSubview:img];
        [viewbox2 addSubview:imgclick];
    }
    [self.view addSubview:viewbox2];
    [viewbox2 setHidden:YES];
    //唇彩
    for (int j=1;j<=4; j++) {
        UITableView *viewbox3 =[[UITableView alloc] initWithFrame:CGRectMake(440, 620, selectbg.frame.size.height, 500)];
        [viewbox3 setTag:470-(j-1)*10];
        
        UIView *imgclick = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"k%d.png",j]]];
        
            imgclick.frame=CGRectMake(selectbg.frame.origin.x+28,selectbg.frame.origin.y+20, img.frame.size.width, img.frame.size.height);
            [imgclick setTag:4700-(j-1)*100];
        
        img.frame=CGRectMake(0, 0, imgclick.frame.size.width, imgclick.frame.size.height);
        [imgclick addSubview:img];
        [self.view addSubview:imgclick];
        [imgclick setHidden:YES];
        /*for (int i=0; i<s; i++) {
            UIView *imgclick = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            UIImageView *img;
            if(i==0){
                img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"k%d.png",j]]];
                imgclick.frame=CGRectMake(28, 20, img.frame.size.width, img.frame.size.height);
            }
            else{
                img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"k%d_%d.png",j,i+1]]];
                imgclick.frame=CGRectMake(265+(100*(i-1)), 20, img.frame.size.width, img.frame.size.height);
                
            }
            [imgclick setTag:4700-(j-1)*100+i];
            [imgclick addSubview:img];
            [viewbox3 addSubview:imgclick];
        }*/
        viewbox3.dataSource=self;
        viewbox3.delegate=self;
        //对TableView要做的设置
        viewbox3.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        viewbox3.showsVerticalScrollIndicator=NO;
        viewbox3.backgroundColor = [UIColor clearColor];
        viewbox3.userInteractionEnabled=YES;
        viewbox3.separatorStyle = UITableViewCellSeparatorStyleNone;
        //viewbox3.contentSize=CGSizeMake(100*(s-1), 110);
        [self.view addSubview:viewbox3];
        [viewbox3 setHidden:YES];
    }
    //唇彩种类
    UIView *viewbochuncai =[[UIView alloc] initWithFrame:selectbg.frame];
    [viewbochuncai setTag:530];
    for (int i=0; i<4; i++) {
        UIView *imgclick = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"k%d.png",i+1]]];
        if(i==0)
            imgclick.frame=CGRectMake(28, 20, img.frame.size.width, img.frame.size.height);
        else{
            imgclick.frame=CGRectMake(160+(100*(i-1)), 20, img.frame.size.width, img.frame.size.height);
        }
        [imgclick setTag:5300+i+1];
        [imgclick addSubview:img];
        [viewbochuncai addSubview:imgclick];
    }
    [self.view addSubview:viewbochuncai];
    [viewbochuncai setHidden:YES];
    //眼线
    UIView *viewboxyanxian =[[UIView alloc] initWithFrame:selectbg.frame];
    [viewboxyanxian setTag:540];
    for (int i=0; i<2; i++) {
        UIView *imgclick = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"f4_%d.png",i]]];
        if(i==0){
            
            imgclick.frame=CGRectMake(28, 20, img.frame.size.width, img.frame.size.height);
        }
        else{
            imgclick.frame=CGRectMake(265+(100*(i-1)), 20, img.frame.size.width, img.frame.size.height);
            [imgclick setTag:5400+i];
        }
        [imgclick addSubview:img];
        [viewboxyanxian addSubview:imgclick];
    }
    [self.view addSubview:viewboxyanxian];
    [viewboxyanxian setHidden:YES];
    //睫毛
    UIView *viewboxjiemao =[[UIView alloc] initWithFrame:selectbg.frame];
    [viewboxjiemao setTag:550];
    for (int i=0; i<2; i++) {
        UIView *imgclick = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"f5_%d.png",i]]];
        if(i==0){
            
            imgclick.frame=CGRectMake(28, 20, img.frame.size.width, img.frame.size.height);
        }
        else{
            imgclick.frame=CGRectMake(265+(100*(i-1)), 20, img.frame.size.width, img.frame.size.height);
            [imgclick setTag:5500+i];
        }
        [imgclick addSubview:img];
        [viewboxjiemao addSubview:imgclick];
    }
    [self.view addSubview:viewboxjiemao];
    [viewboxjiemao setHidden:YES];
    //清除
    UIImageView *clearbtn =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"f_clear.png"]];
    clearclick=[[UIView alloc] initWithFrame:CGRectMake(28, selectbg.frame.origin.y+19,clearbtn.frame.size.width,clearbtn.frame.size.height)];
    clearbtn.frame=CGRectMake(0, 0,clearbtn.frame.size.width,clearbtn.frame.size.height);
    [clearclick setTag:444];
    [clearclick addSubview:clearbtn];
    [self.view addSubview:clearclick];
    //[clearclick setHidden:YES];
    
    //妆底选择
    UIView *viewboxzhuangdi =[[UIView alloc] initWithFrame:selectbg.frame];
    [viewboxzhuangdi setTag:510];
    for (int i=1; i<3; i++) {
        UIView *imgclick = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"f%d_0.png",i-1]]];
        if(i==1)
            imgclick.frame=CGRectMake(28, 20, img.frame.size.width, img.frame.size.height);
        else{
            imgclick.frame=CGRectMake(160, 20, img.frame.size.width, img.frame.size.height);
        }
        [imgclick setTag:5100+i];
        [imgclick addSubview:img];
        [viewboxzhuangdi addSubview:imgclick];
    }
    [self.view addSubview:viewboxzhuangdi];
    [viewboxzhuangdi setHidden:YES];
    
    //浓淡
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(750-260, 360, 460, 30)];
    slider.minimumValue = 3;// 设置最小值
    slider.maximumValue = 10;// 设置最大值
    slider.value = (slider.minimumValue + slider.maximumValue) / 2;// 设置初始值
    slider.continuous = YES;
    slider.transform =  CGAffineTransformMakeRotation( M_PI * -0.5 );
    slider.maximumTrackTintColor=[UIColor whiteColor];
    slider.minimumTrackTintColor=[UIColor colorWithRed:255.0/255 green:83.0/255.0 blue:133.0/255.0 alpha:1];
    slider.thumbTintColor=[UIColor colorWithRed:255.0/255 green:83.0/255.0 blue:133.0/255.0 alpha:1];
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //清单
    UIImage *listimg = [UIImage imageNamed:@"btnlist.png"];
    UIButton *list = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-listimg.size.width-20, selectbg.frame.origin.y-160, listimg.size.width, listimg.size.height)];
    [list setImage:listimg forState:UIControlStateNormal];
    [self.view bringSubviewToFront:list];
    [self.view addSubview:list];
    [list addTarget:self action:@selector(list:) forControlEvents:UIControlEventTouchUpInside];
    //对比
    UIImage *contimg = [UIImage imageNamed:@"btncontrast.png"];
    UIButton *cont = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-listimg.size.width-20, selectbg.frame.origin.y-80, contimg.size.width, contimg.size.height)];
    [cont setImage:contimg forState:UIControlStateNormal];
    [self.view bringSubviewToFront:cont];
    [self.view addSubview:cont];
    [cont addTarget:self action:@selector(cont:) forControlEvents:UIControlEventTouchUpInside];
    
    loadingbg=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    loadingbg.backgroundColor=[UIColor clearColor];
    [self.view addSubview:loadingbg];
    loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loading.frame=CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 80, 80);
    loading.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    loading.backgroundColor = [UIColor blackColor];
    loading.alpha = 0.4;
    loading.layer.cornerRadius = 6;
    loading.layer.masksToBounds = YES;
    [loadingbg addSubview:loading];
    [loading stopAnimating];
    [loadingbg setHidden:YES];
}
- (void)cont:(id)sender {
    self.visonImageNew=[UIImage gl_snapScreenView:mainview];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ContrastView *vc = [story instantiateViewControllerWithIdentifier:@"boardContrast"];
    vc.oldimg=self.visonImageOld;
    vc.newimg=self.visonImageNew;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)list:(id)sender {
    NSLog(@"%d_%d_%d_%d_%d",l_zhuangdi1,l_zhuangdi2,l_saihong,l_chuncai,l_yanxian);
    self.visonImageNew=[UIImage gl_snapScreenView:mainview];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ListView *vc = [story instantiateViewControllerWithIdentifier:@"boardList"];
    vc.zhuangdivalue1=l_zhuangdi1;
    vc.zhuangdivalue2=l_zhuangdi2;
    vc.saihongvalue=l_saihong;
    vc.chuncaivalue=l_chuncai;
    vc.yanxianvalue=l_yanxian;
    vc.yanyingvalue=l_yanying;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int dk=currentShow;
    if(currentShow==440||currentShow==450||currentShow==460||currentShow==470)
        dk=530;
    UIImageView *_view = [self.view viewWithTag:900+(dk-500)/10];
    if(_view){
        [_view setAlpha:slider.value/10];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in event.allTouches) {
        UIView*v = touch.view;
        int tag = (int)v.tag;
        NSLog(@"tag=%d",tag);
        if(tag>99&&tag<=105){//选择种类
            int _cur=(tag-100)*10+500;
            if(_cur!=currentShow){
                UIView * showSelect = [self.view viewWithTag:(_cur)];
                [showSelect setHidden:NO];
                //隐藏旧的
                UIView * cur = [self.view viewWithTag:(currentShow)];
                [cur setHidden:YES];
                
                //旧的菜单选择状态
                int dk = currentShow;
                if(currentShow==480||currentShow==490)
                    dk=510;
                if(currentShow==440||currentShow==450||currentShow==460||currentShow==470){
                    dk=530;
                    //隐藏单独的品牌图标
                    UIView *showTitle = [self.view viewWithTag:currentShow*10];
                    [showTitle setHidden:YES];
                }
                UIView *old=[self.view viewWithTag:(dk-500)/10+100];
                for(UIView *subv in [old subviews])
                {
                    UIImageView *child=(UIImageView *)(subv);
                    child.image=[UIImage imageNamed:[NSString stringWithFormat:@"s%d",(dk-500)/10]];
                }
                
                //改变菜单选择状态
                for(UIView *subv in [v subviews])
                {
                    UIImageView *child=(UIImageView *)(subv);
                    child.image=[UIImage imageNamed:[NSString stringWithFormat:@"s%d_",(tag-100)]];
                }
                currentShow=_cur;
            }
            if(tag==101||tag==103)//切换妆底选择
                [clearclick setHidden:YES];
            else{
                [clearclick setHidden:NO];
            }
            
            if(tag==100){
                clearclick.frame=CGRectMake(28, clearclick.frame.origin.y,clearclick.frame.size.width,clearclick.frame.size.height);
            }else{
                clearclick.frame=CGRectMake(160, clearclick.frame.origin.y,clearclick.frame.size.width,clearclick.frame.size.height);
            }
        }else if(tag>=4400&&tag<6000){//选择颜色
            if(tag==5101){//切换选择贝壳提亮
                UIView * showSelect = [self.view viewWithTag:(480)];
                [showSelect setHidden:NO];
                //隐藏旧的
                UIView * cur = [self.view viewWithTag:(currentShow)];
                [cur setHidden:YES];
                currentShow=480;
                [clearclick setHidden:NO];
            }
            else if(tag==5102){//切换选择妆前乳
                UIView * showSelect = [self.view viewWithTag:(490)];
                [showSelect setHidden:NO];
                //隐藏旧的
                UIView * cur = [self.view viewWithTag:(currentShow)];
                [cur setHidden:YES];
                currentShow=490;
                [clearclick setHidden:NO];
            }
            else if(tag==4900||tag==4800){//切换返回选择妆底
                UIView * showSelect = [self.view viewWithTag:(510)];
                [showSelect setHidden:NO];
                //隐藏旧的
                UIView * cur = [self.view viewWithTag:(currentShow)];
                [cur setHidden:YES];
                currentShow=510;
                [clearclick setHidden:YES];
            }
            else if(tag>=5001&&tag<=5004){//主题装
                //添加选项选中状态
                UIImageView *_selected=[self.view viewWithTag:5099];
                if(_selected){
                    _selected.frame=v.frame;
                }
                else{
                    UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
                    selected.frame=v.frame;
                    [selected setTag:5099];
                    UIView *boxview=[self.view viewWithTag:500];
                    [boxview addSubview:selected];
                }
                [self Zhutizhuang:tag-5000];
            }
            else if(tag>=5301&&tag<=5398){//唇彩 种类切换
                UIView * showSelect = [self.view viewWithTag:(470-(tag-5300-1)*10)];
                [showSelect setHidden:NO];
                UIView *showTitle = [self.view viewWithTag:4700-(tag-5300-1)*100];
                [showTitle setHidden:NO];
                //隐藏旧的
                UIView * cur = [self.view viewWithTag:(currentShow)];
                [cur setHidden:YES];
                currentShow=470-(tag-5300-1)*10;
                [clearclick setHidden:NO];
                
                
            }
            else if(tag>=5201&&tag<=5205){//腮红
                [self ChangeFac:[UIColor clearColor] viewtag:2 colorindex:tag-5200];
                //添加选项选中状态
                UIImageView *_selected=[self.view viewWithTag:5299];
                if(_selected){
                    _selected.frame=v.frame;
                }
                else{
                    UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
                    selected.frame=v.frame;
                    [selected setTag:5299];
                    UIView *boxview=[self.view viewWithTag:520];
                    [boxview addSubview:selected];
                }
                l_saihong=tag-5200;
            }
            else if(tag>=5401&&tag<=5401){//眼线
                [self ChangeFac:[UIColor blackColor] viewtag:4 colorindex:0];
                //添加选项选中状态
                UIImageView *_selected=[self.view viewWithTag:5499];
                if(_selected){
                    _selected.frame=v.frame;
                }
                else{
                    UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
                    selected.frame=v.frame;
                    [selected setTag:5499];
                    UIView *boxview=[self.view viewWithTag:540];
                    [boxview addSubview:selected];
                }
                l_yanxian=tag-5400;
            }
            else if(tag>=5501&&tag<=5501){
                [self ChangeFac:[UIColor blackColor] viewtag:5 colorindex:0];
                //添加选项选中状态
                UIImageView *_selected=[self.view viewWithTag:5599];
                if(_selected){
                    _selected.frame=v.frame;
                }
                else{
                    UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
                    selected.frame=v.frame;
                    [selected setTag:5599];
                    UIView *boxview=[self.view viewWithTag:550];
                    [boxview addSubview:selected];
                }
                l_yanying=tag-5500;
            }
            else if(tag==4801){//贝壳提亮
                [self gl_circleImageLight:4801];
                 UIImageView *_selected=[self.view viewWithTag:4899];
                if(_selected){
                    _selected.frame=v.frame;
                }
                else{
                    UIView *selectclick =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                    UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
                    selectclick.frame=v.frame;
                    [selectclick setTag:4899];
                    [selectclick addSubview:selected];
                    UIView *boxview=[self.view viewWithTag:480];
                    [boxview addSubview:selectclick];
                }
                l_zhuangdi1=1;
            }
            else if(tag==4901){//妆底
                [self gl_circleImageLight:4901];
                UIImageView *_selected=[self.view viewWithTag:4999];
                if(_selected){
                    _selected.frame=v.frame;
                }
                else{
                    UIView *selectclick =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                    UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
                    selectclick.frame=v.frame;
                    [selectclick setTag:4999];
                    [selectclick addSubview:selected];
                    UIView *boxview=[self.view viewWithTag:490];
                    [boxview addSubview:selectclick];
                }
                l_zhuangdi2=1;
            }
            else if(tag==4400||tag==4500||tag==4600||tag==4700){//选择颜色界面返回唇彩种类
                UIView * showSelect = [self.view viewWithTag:(530)];
                [showSelect setHidden:NO];
                //隐藏旧的
                UIView * cur = [self.view viewWithTag:(currentShow)];
                [cur setHidden:YES];
                currentShow=530;
                
                [clearclick setHidden:YES];
            }
        }
        else if(tag==444){//清除选择
            //清除选中状态 99结束
            int dk=currentShow;
            if(currentShow==440||currentShow==450||currentShow==460||currentShow==470)
                dk=530;
            UIImageView *_selectedchuncai=[self.view viewWithTag:5399];
            int selectbg = (dk-500)*10+5099;
            UIImageView *sbg = [self.view viewWithTag:selectbg];
            if(sbg)
                [sbg removeFromSuperview];
            //清除选中颜色 900开头
            UIImageView *_view = [self.view viewWithTag:900+(dk-500)/10];
            if(_view)
                [_view removeFromSuperview];
            NSLog(@"rrr  %d",currentShow);
            
            if(currentShow==480||currentShow==490)
                self.visionImageView.image=self.visonImageOld;
            if(currentShow==480)
                l_zhuangdi1=0;
            else if(currentShow==490)
                l_zhuangdi2=0;
            else if(currentShow==520)
                l_saihong=0;
            else if(dk==530)
                l_chuncai=0;
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)save:(UIButton *)sender
{
    [loadingbg setHidden:NO];
    [loading startAnimating];
    self.visonImageNew=[UIImage gl_snapScreenView:mainview];
    [self upLoad1:self.visonImageNew];
    
}
- (void)checkImage:(UIImage *)image
{
    [[GLTools sharedInstance] glDiscernWithImageType:self.discernType image:image complete:^(GLDiscernPointModel * _Nonnull pointModel) {
        
        pointModelCur=pointModel;
        if(pointModel.outerLipsPoints.count>0){
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"面部识别完成" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"未发现人脸信息" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }];
}
-(void)ChangeFac:(UIColor *)color viewtag:(int)vtag colorindex:(int)cindex{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *_view = [self.view viewWithTag:900+vtag];
        if(_view){
            if(vtag==2)
                _view.image = [UIImage gl_circleImageSaihong:self.visonImageOld tag:cindex faceLandMarkPoints:pointModelCur.faceContourPoints];
            else if(vtag==3)
                _view.image = [UIImage gl_drawImage:_view.image faceLandMarkPoints:pointModelCur.outerLipsPoints color:color];
            else if(vtag==4){
                NSArray *_l = [NSArray arrayWithObjects:pointModelCur.leftEyePoints,pointModelCur.rightEyePoints, nil];
                _view.image=[UIImage gl_drawImageEyeline:self.visonImageOld faceLandMarkPoints:_l color:color];
            }
            else if(vtag==5){
                NSArray *_l = [NSArray arrayWithObjects:pointModelCur.leftEyePoints,pointModelCur.rightEyePoints, nil];
                _view.image=[UIImage gl_drawImageJiemao:self.visonImageOld faceLandMarkPoints:_l];
            }
            [loading stopAnimating];
            [loadingbg setHidden:YES];
        }else{
            UIImage *new;
            if(vtag==2)
                new = [UIImage gl_circleImageSaihong:self.visonImageOld tag:cindex faceLandMarkPoints:pointModelCur.faceContourPoints];
            else if(vtag==3)
                new = [UIImage gl_drawImage:self.visonImageOld faceLandMarkPoints:pointModelCur.outerLipsPoints color:color];
            else if(vtag==4){
                NSArray *_l = [NSArray arrayWithObjects:pointModelCur.leftEyePoints,pointModelCur.rightEyePoints, nil];
                new=[UIImage gl_drawImageEyeline:self.visonImageOld faceLandMarkPoints:_l color:color];
            }
            else if(vtag==5){
                NSArray *_l = [NSArray arrayWithObjects:pointModelCur.leftEyePoints,pointModelCur.rightEyePoints, nil];
                new=[UIImage gl_drawImageJiemao:self.visonImageOld faceLandMarkPoints:_l];
            }
            _view=[[UIImageView alloc] initWithImage:new];
            _view.frame=self.visionImageView.frame;
            _view.tag=900+vtag;
            _view.alpha=0.65;
            _view.contentMode = UIViewContentModeScaleAspectFit;
            [mainview addSubview:_view];
            
            [loading stopAnimating];
            [loadingbg setHidden:YES];
        }
    });
    
   
}
-(void)Zhutizhuang:(int)tag{
    [loading startAnimating];
    [loadingbg setHidden:NO];
    UIColor *chuncai;
    int chun;
    int saihong;
    if(tag==1){
        saihong=3;
        chun=4707;
    }else if(tag==2){
        saihong=2;
        chun=4709;
    }else if(tag==3){
        saihong=1;
        chun=4702;
    }else{
        saihong=4;
        chun=4703;
    }
    chuncai = [self getLipColor:chun];
    // 腮红
    [self ChangeFac:[UIColor clearColor] viewtag:2 colorindex:saihong];
    //添加选项选中状态
    UIImageView *_selectedsaihong=[self.view viewWithTag:5299];
    if(_selectedsaihong){
        _selectedsaihong.frame=CGRectMake(265+100*(saihong-1), 20, _selectedsaihong.frame.size.width, _selectedsaihong.frame.size.height);
    }
    else{
        UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
        selected.frame=CGRectMake(265+100*(saihong-1), 20, selected.frame.size.width, selected.frame.size.height);
        [selected setTag:5299];
        UIView *boxview=[self.view viewWithTag:520];
        [boxview addSubview:selected];
    }
    l_saihong=tag;
   
    //唇彩
    [self ChangeFac:chuncai viewtag:3 colorindex:1];
    l_chuncai=chun;
    //添加选项选中状态
    UIImageView *_selected=[self.view viewWithTag:5399];
    if(_selected){
        [_selected removeFromSuperview];
    }
    
    UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
    selected.frame=CGRectMake(25, 100*(chun-4700-1)-6.5, 90, 110);
    [selected setTag:5399];
    selected.transform=CGAffineTransformMakeRotation(M_PI / 2);
    UITableView *boxview=[self.view viewWithTag:470];
    CGSize itemSize = CGSizeMake(110, 90);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [selected.image drawInRect:imageRect];
    selected.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [boxview addSubview:selected];
    
}
- (void) gl_circleImageLight:(int)vtag
{
    UIImage *myImage = self.visionImageView.image;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *superImage = [CIImage imageWithCGImage:myImage.CGImage];
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:superImage forKey:kCIInputImageKey];
    
    // 修改亮度   -1---1   数越大越亮
    if(vtag==4801)
        [lighten setValue:@(0.01) forKey:@"inputBrightness"];
    
    // 修改饱和度  0---2
    if(vtag==4901)
        [lighten setValue:@(1.2) forKey:@"inputSaturation"];
    
    // 修改对比度  0---4
    //[lighten setValue:@(2.5) forKey:@"inputContrast"];
    CIImage *result = [lighten valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
    
    // 得到修改后的图片
    myImage = [UIImage imageWithCGImage:cgImage];
    
    // 释放对象
    CGImageRelease(cgImage);
    self.visionImageView.image=myImage;
}
- (UIColor *)getLipColor:(int)tag{
    UIColor *cl;
    switch (tag) {
        case 4712://k1 470
            cl=[UIColor colorWithRed:222.0/255.0 green:80.0/255.0 blue:69.0/255.0 alpha:0.22];
            break;
        case 4711:
            cl =[UIColor colorWithRed:144.0/255.0 green:55.0/255.0 blue:49.0/255.0 alpha:0.22];
            break;
        case 4710:
            cl =[UIColor colorWithRed:188.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:0.22];
            break;
        case 4709:
            cl =[UIColor colorWithRed:208.0/255.0 green:95.0/255.0 blue:86.0/255.0 alpha:0.22];
            break;
        case 4708:
            cl =[UIColor colorWithRed:176.0/255.0 green:78.0/255.0 blue:64.0/255.0 alpha:0.22];
            break;
        case 4707:
            cl =[UIColor colorWithRed:211.0/255.0 green:143.0/255.0 blue:117.0/255.0 alpha:0.22];
            break;
        case 4706:
            cl =[UIColor colorWithRed:205.0/255.0 green:75.0/255.0 blue:126.0/255.0 alpha:0.22];
            break;
        case 4705:
            cl =[UIColor colorWithRed:237.0/255.0 green:57.0/255.0 blue:122.0/255.0 alpha:0.22];
            break;
        case 4704:
            cl =[UIColor colorWithRed:251.0/255.0 green:83.0/255.0 blue:94.0/255.0 alpha:0.22];
            break;
        case 4703:
            cl =[UIColor colorWithRed:238.0/255.0 green:64.0/255.0 blue:74.0/255.0 alpha:0.22];
            break;
        case 4702:
            cl =[UIColor colorWithRed:251.0/255.0 green:121.0/255.0 blue:131.0/255.0 alpha:0.22];
            break;
        case 4701:
            cl =[UIColor colorWithRed:255.0/255.0 green:86.0/255.0 blue:105.0/255.0 alpha:0.22];
            break;
        case 4601://k2 460
            cl =[UIColor colorWithRed:237.0/255.0 green:39.0/255.0 blue:40.0/255.0 alpha:0.22];
            break;
        case 4602:
            cl =[UIColor colorWithRed:239.0/255.0 green:55.0/255.0 blue:74.0/255.0 alpha:0.22];
            break;
        case 4603:
            cl =[UIColor colorWithRed:204.0/255.0 green:75.0/255.0 blue:79.0/255.0 alpha:0.22];
            break;
        case 4604:
            cl =[UIColor colorWithRed:241.0/255.0 green:107.0/255.0 blue:132.0/255.0 alpha:0.22];
            break;
        case 4605:
            cl =[UIColor colorWithRed:241.0/255.0 green:79.0/255.0 blue:100.0/255.0 alpha:0.22];
            break;
        case 4606:
            cl =[UIColor colorWithRed:209.0/255.0 green:61.0/255.0 blue:88.0/255.0 alpha:0.22];
            break;
        case 4607:
            cl =[UIColor colorWithRed:228.0/255.0 green:56.0/255.0 blue:72.0/255.0 alpha:0.22];
            break;
        case 4608:
            cl =[UIColor colorWithRed:220.0/255.0 green:56.0/255.0 blue:119.0/255.0 alpha:0.22];
            break;
        case 4609:
            cl =[UIColor colorWithRed:143.0/255.0 green:41.0/255.0 blue:152.0/255.0 alpha:0.22];
            break;
        case 4610:
            cl =[UIColor colorWithRed:190.0/255.0 green:36.0/255.0 blue:44.0/255.0 alpha:0.22];
            break;
        case 4513://k3 4500
            cl =[UIColor colorWithRed:237.0/255.0 green:53.0/255.0 blue:61.0/255.0 alpha:0.22];
            break;
        case 4512:
            cl =[UIColor colorWithRed:221.0/255.0 green:50.0/255.0 blue:22.0/255.0 alpha:0.22];
            break;
        case 4511:
            cl =[UIColor colorWithRed:244.0/255.0 green:52.0/255.0 blue:37.0/255.0 alpha:0.22];
            break;
        case 4510:
            cl =[UIColor colorWithRed:202.0/255.0 green:107.0/255.0 blue:116.0/255.0 alpha:0.22];
            break;
        case 4509:
            cl =[UIColor colorWithRed:237.0/255.0 green:111.0/255.0 blue:114.0/255.0 alpha:0.22];
            break;
        case 4508:
            cl =[UIColor colorWithRed:184.0/255.0 green:25.0/255.0 blue:19.0/255.0 alpha:0.22];
            break;
        case 4507:
            cl =[UIColor colorWithRed:112.0/255.0 green:21.0/255.0 blue:29.0/255.0 alpha:0.22];
            break;
        case 4506:
            cl =[UIColor colorWithRed:235.0/255.0 green:91.0/255.0 blue:65.0/255.0 alpha:0.22];
            break;
        case 4505:
            cl =[UIColor colorWithRed:247.0/255.0 green:70.0/255.0 blue:134.0/255.0 alpha:0.22];
            break;
        case 4504:
            cl =[UIColor colorWithRed:206.0/255.0 green:112.0/255.0 blue:86.0/255.0 alpha:0.22];
            break;
        case 4503:
            cl =[UIColor colorWithRed:232.0/255.0 green:115.0/255.0 blue:132.0/255.0 alpha:0.22];
            break;
        case 4502:
            cl =[UIColor colorWithRed:233.0/255.0 green:86.0/255.0 blue:116.0/255.0 alpha:0.22];
            break;
        case 4501:
            cl =[UIColor colorWithRed:160.0/255.0 green:18.0/255.0 blue:51.0/255.0 alpha:0.22];
            break;
        case 4408://k4 440
            cl =[UIColor colorWithRed:133.0/255.0 green:54.0/255.0 blue:56.0/255.0 alpha:0.22];
            break;
        case 4407:
            cl =[UIColor colorWithRed:153.0/255.0 green:41.0/255.0 blue:81.0/255.0 alpha:0.22];
            break;
        case 4406:
            cl =[UIColor colorWithRed:205.0/255.0 green:41.0/255.0 blue:75.0/255.0 alpha:0.22];
            break;
        case 4405:
            cl =[UIColor colorWithRed:240.0/255.0 green:77.0/255.0 blue:68.0/255.0 alpha:0.22];
            break;
        case 4404:
            cl =[UIColor colorWithRed:180.0/255.0 green:71.0/255.0 blue:55.0/255.0 alpha:0.22];
            break;
        case 4403:
            cl =[UIColor colorWithRed:236.0/255.0 green:86.0/255.0 blue:82.0/255.0 alpha:0.22];
            break;
        case 4402:
            cl =[UIColor colorWithRed:205.0/255.0 green:67.0/255.0 blue:77.0/255.0 alpha:0.22];
            break;
        case 4401:
            cl =[UIColor colorWithRed:238.0/255.0 green:43.0/255.0 blue:126.0/255.0 alpha:0.22];
            break;
        default:
            break;
    }
    return cl;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int j=(470-tableView.tag)/10+1;
    if(j==1)
        return 12;
    else if(j==2)
        return 10;
    else if(j==3)
        return 13;
    else
        return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"FyCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FyCell"];
        }
        //对Cell要做的设置
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.image = [UIImage imageNamed:[NSString stringWithFormat:@"k%d_%d.png",(470-tableView.tag)/10+1, indexPath.row +1]];
        //NSLog(@"indexPath %d",indexPath.row);

    cell.imageView.transform=CGAffineTransformMakeRotation(M_PI / 2);
    
    CGSize itemSize = CGSizeMake(110, 90);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cell;
}
- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"选中didSelectRowAtIndexPath row = %ld %d", indexPath.row,tableView.tag);
    
    int _tag=(tableView.tag*10)+indexPath.row+1;
     UIColor *cl=[self getLipColor:_tag];
     
     [self ChangeFac:cl viewtag:3 colorindex:1];
     l_chuncai=_tag;
     //添加选项选中状态
     UIImageView *_selected=[self.view viewWithTag:5399];
     if(_selected){
         [_selected removeFromSuperview];
     }
    
         UIImageView *selected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
         selected.frame=CGRectMake(25, 100*indexPath.row-6.5, 90, 110);
         [selected setTag:5399];
         selected.transform=CGAffineTransformMakeRotation(M_PI / 2);
         UITableView *boxview=[self.view viewWithTag:tableView.tag];
         CGSize itemSize = CGSizeMake(110, 90);
         UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
         CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
         [selected.image drawInRect:imageRect];
         selected.image = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         [boxview addSubview:selected];
    
}
- (void)upLoad1:(UIImage *)img{
    NSString *retCode=@"";
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //2.上传文件
    NSDictionary *dict = @{@"username":@"1234"};
    
    NSString *urlString = @"http://www.beverlyplus.cn/vdl/photo.aspx";
    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件参数
        NSData *data = UIImagePNGRepresentation(img);
        //这个就是参数
        [formData appendPartWithFileData:data name:@"photo" fileName:@"photo.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        NSString *rst = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"请求成功：%@",rst);
        [loadingbg setHidden:YES];
        [loading stopAnimating];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
         FinishView *vc = [story instantiateViewControllerWithIdentifier:@"boardFinish"];
         vc.oldimg=self.visonImageOld;
         vc.newimg=img;
        vc.name=rst;
         [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        NSLog(@"请求失败：%@",[error localizedDescription]);
    }];
}
-(void)dealloc{
    NSLog(@"dealloc vision");
    self.visonImageNew=nil;
    self.visonImage=nil;
    self.visonImageOld=nil;
    [self.visionImageView removeFromSuperview];
    [mainview removeFromSuperview];
    [loadingbg removeFromSuperview];
    [self removeFromParentViewController];
}
@end

