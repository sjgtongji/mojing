//
//  VisionCheckViewController.h
//  VisionDemo
//
//

#import <UIKit/UIKit.h>
#import <Vision/Vision.h>
#import "GLTools.h"
#import <AFNetworking.h>

@interface VisionFaceViewController : UIViewController

- (id)initWithImage:(UIImage *)image discernType:(GLDiscernType)type;

@end
