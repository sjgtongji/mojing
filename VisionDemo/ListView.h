//
//  ListView.h
//  VisionDemo
//
//  Created by 张宇行 on 2017/12/23.
//

#import <UIKit/UIKit.h>

@interface ListView : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *imgzhuangdi1;
@property (nonatomic, retain) IBOutlet UIImageView *imgzhuangdi2;
@property (nonatomic, retain) IBOutlet UIImageView *imgsaihong;
@property (nonatomic, retain) IBOutlet UIImageView *imgchuncai;
@property (nonatomic, retain) IBOutlet UIImageView *imgyanxian;
@property (nonatomic, retain) IBOutlet UIImageView *imgyanying;


@property (nonatomic, retain) IBOutlet UILabel *lblzhuangdi1;
@property (nonatomic, retain) IBOutlet UILabel *lblzhuangdi2;
@property (nonatomic, retain) IBOutlet UILabel *lblsaihong1;
@property (nonatomic, retain) IBOutlet UILabel *lblsaihong2;
@property (nonatomic, retain) IBOutlet UILabel *lblchuncai1;
@property (nonatomic, retain) IBOutlet UILabel *lblchuncai2;
@property (nonatomic, retain) IBOutlet UILabel *lblyanxian1;
@property (nonatomic, retain) IBOutlet UILabel *lblyanxian2;
@property (nonatomic, retain) IBOutlet UILabel *lblyanying1;
@property (nonatomic, retain) IBOutlet UILabel *lblyanying2;


@property (nonatomic,assign) int zhuangdivalue1;
@property (nonatomic,assign) int zhuangdivalue2;
@property (nonatomic,assign) int saihongvalue;
@property (nonatomic,assign) int chuncaivalue;
@property (nonatomic,assign) int yanxianvalue;
@property (nonatomic,assign) int yanyingvalue;
@end
