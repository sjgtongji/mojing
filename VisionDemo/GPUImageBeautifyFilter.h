//
//  GPUImageBeautifyFilter.h
//  VisionDemo
//
//  Created by 张宇行 on 2017/12/24.
//  Copyright © 2017年 SYPJ. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@class GPUImageCombinationFilter;

@interface GPUImageBeautifyFilter : GPUImageFilterGroup {
    GPUImageBilateralFilter *bilateralFilter;
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
    GPUImageCombinationFilter *combinationFilter;
    GPUImageHSBFilter *hsbFilter;
}

@end
