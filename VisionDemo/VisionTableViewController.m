//
//  VisionTableViewController.m
//  VisionDemo
//
//

#import "VisionTableViewController.h"
#import "VisionFaceViewController.h"
#import "VisionCameraViewController.h"

#import "OpenCameraOrPhoto.h"
#import "UIImage+GLProcessing.h"
#import "ViewAbstract.h"
#import "GPUImageBeautifyFilter.h"

@interface VisionTableViewController ()

@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,assign) int isclick;

@end

@implementation VisionTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isclick=0;
    if(_iswait==0){
        [_waiting setHidden:YES];
     
    }
    else
        [_waiting setHidden:NO];
    _waiting.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapWaiting)];
    [_waiting addGestureRecognizer:tapGesturRecognizer];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home.png"]];
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imgView atIndex:0];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 11.0) {
        
    } else {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的系统版本过低，请升级至最新版本！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tapWaiting
{
    [_waiting setHidden:YES];
}
- (IBAction)GoFace:(id)sender {
    __weak typeof(self)weakSelf = self;
    if(self.isclick==0){
        [OpenCameraOrPhoto showOpenCameraOrPhotoWithView:self.view withBlock:^(UIImage *image) {
            
            //图片进行旋转
            UIImage *upImage = [UIImage fixOrientationImage:image];
            upImage=[self editPhotoByBilateralWithLevel:4.0 UImage:upImage];//磨皮
            //upImage=[self editPhotoByBrightnessWithLevel:0.01 UImage:upImage];//美白
            
            VisionFaceViewController *visionFaceVc = [[VisionFaceViewController alloc] initWithImage:upImage discernType:GLDiscernFaceLandmarkType];
            [weakSelf.navigationController pushViewController:visionFaceVc animated:YES];
            
        }];
    }
}
- (IBAction)GoAbs:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"boardAbstract"];
    [self.navigationController.view.layer addAnimation:transition forKey:@"topush"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)GoPro:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"boardProduct"];
    [self.navigationController.view.layer addAnimation:transition forKey:@"topush2"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
//磨皮
- (UIImage *)editPhotoByBilateralWithLevel:(CGFloat)level  UImage:(UIImage *)image{
    
    /*GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    
    // 磨皮滤镜
    GPUImageBilateralFilter *filter = [[GPUImageBilateralFilter alloc] init];
    

    //设置磨皮参数值越小，磨皮效果越好，默认为8
    [filter setDistanceNormalizationFactor:level];
    
    [filter forceProcessingAtSize:image.size];
    
    [pic addTarget:filter];
    
    [pic processImage];
    
    [filter useNextFrameForImageCapture];
    
    image = [filter imageFromCurrentFramebuffer];*/
    
    
    
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    
    GPUImageBeautifyFilter *filter = [[GPUImageBeautifyFilter alloc] init];
    
    [filter forceProcessingAtSize:image.size];
    
    [pic addTarget:filter];
    
    [pic processImage];
    
    [filter useNextFrameForImageCapture];
    
    image =[filter imageFromCurrentFramebuffer];
    
    
    return image;
    
}

//美白
- (UIImage *)editPhotoByBrightnessWithLevel:(CGFloat)level  UImage:(UIImage *)image{
    
    
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    
    // 美白滤镜
    GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
    
    //设置美白参数 0-1
    filter.brightness = level;
    
    [filter forceProcessingAtSize:image.size];
    
    [pic addTarget:filter];
    
    [pic processImage];
    
    [filter useNextFrameForImageCapture];
    
    image = [filter imageFromCurrentFramebuffer];
    
    return image;
    
}
/*
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"visionCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.titles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    switch (indexPath.row) {
        case 0:
        {
            __weak typeof(self)weakSelf = self;

            [OpenCameraOrPhoto showOpenCameraOrPhotoWithView:self.view withBlock:^(UIImage *image) {
                
                //图片进行旋转
                UIImage *upImage = [UIImage fixOrientationImage:image];;
                VisionFaceViewController *visionFaceVc = [[VisionFaceViewController alloc] initWithImage:upImage discernType:GLDiscernFaceRectType];
                [weakSelf.navigationController pushViewController:visionFaceVc animated:YES];
            }];

        }
            break;
        case 1:
        {
            __weak typeof(self)weakSelf = self;

            [OpenCameraOrPhoto showOpenCameraOrPhotoWithView:self.view withBlock:^(UIImage *image) {
                
                //图片进行旋转
                UIImage *upImage = [UIImage fixOrientationImage:image];;
                VisionFaceViewController *visionFaceVc = [[VisionFaceViewController alloc] initWithImage:upImage discernType:GLDiscernFaceLandmarkType];
                [weakSelf.navigationController pushViewController:visionFaceVc animated:YES];

            }];
        }
            break;
        case 2:
        {
            VisionCameraViewController *visionCameraVc = [[VisionCameraViewController alloc] initWithDiscernType:GLDiscernFaceDynamicSceneType];
            [self.navigationController pushViewController:visionCameraVc animated:YES];
        }
            break;
        case 3:
        {
            VisionCameraViewController *visionCameraVc = [[VisionCameraViewController alloc] initWithDiscernType:GLDiscernFaceRectDynamicType];
            [self.navigationController pushViewController:visionCameraVc animated:YES];
        }
            break;
        default:
            break;
    }
}

*/
-(void)dealloc{
    
    [self removeFromParentViewController];
}
@end
