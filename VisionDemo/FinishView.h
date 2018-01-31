//
//  FinishView.h
//  VisionDemo
//
//  Created by 张宇行 on 2017/12/22.
//

#import <UIKit/UIKit.h>

@interface FinishView : UIViewController
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) UIImage *oldimg;
@property (assign, nonatomic) UIImage *newimg;


@property (nonatomic, retain) IBOutlet UIImageView *oldview;
@property (nonatomic, retain) IBOutlet UIImageView *newview;
@property (nonatomic, retain) IBOutlet UILabel *lbl;
@end
