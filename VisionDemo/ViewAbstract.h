//
//  ViewAbstract.h
//  VisionDemo
//
//  Created by 张宇行 on 2017/12/19.
//

#import <UIKit/UIKit.h>

@interface ViewAbstract : UIViewController{
    UIWebView *mywebview;
}

@property (nonatomic, retain) IBOutlet UIWebView *mywebview;
@end
