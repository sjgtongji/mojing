//
//  UIImage+GLProcessing.m
//  UIImageOperationDemo
//
//

#import "UIImage+GLProcessing.h"
#import <ImageIO/ImageIO.h>
#import <Vision/Vision.h>
#import "UiimageRotate.h"

@implementation UIImage (GLProcessing)

+ (UIImage*)gl_circleImage:(UIImage*)image withBorder:(CGFloat)border color:(UIColor *)color faceLandMarkPoints:(NSMutableArray *)landMarkPoints
{
    UIImage *newimg = [self imageWithColor:[UIColor redColor] size:image.size];;
    NSMutableArray *points=landMarkPoints;
    CGPoint sPoints [points.count];
    float maxx=0;
    float maxy=0;
    float minx=9999;
    float miny=9999;
    float _px=0;
    float _py=0;
    for (int i = 0;i <points.count;i++) {
        NSValue *pointValue = points[i];
        CGPoint point = pointValue.CGPointValue;
        sPoints[i] = point;
        if(point.x>maxx)
            maxx=point.x;
        if(point.y>maxy)
            maxy=point.y;
        if(point.x<minx)
            minx=point.x;
        if(point.y<miny)
            miny=point.y;
    }
    
    NSValue *pointValue = points[1];
    CGPoint point = pointValue.CGPointValue;
    _px=point.x;
    _py=point.y;
    
    //通过自己创建一个context来绘制,通常用于对图片的处理
    //在retian屏幕上要使用这个函数，才能保证不失真
    //该函数会自动创建一个context，并把它push到上下文栈顶，坐标系也经处理和UIKit的坐标系相同
    UIGraphicsBeginImageContextWithOptions(newimg.size, NO, [UIScreen mainScreen].scale);
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1, -1.0);
    float _x =(maxx-minx)/4+minx;
    float _y = (maxy-miny)/2+miny;
    CGRect rect = CGRectMake(_x, _y, 110, 110);
    CGRect rect2 = CGRectMake(_x+100, _y+100, 110, 110);
    //设置宽度
    CGContextSetLineWidth(context, 14*border);
    //设置边框颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.5 green:0.3 blue:0.1 alpha:0.1].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.5 green:0.3 blue:0.1 alpha:0.1].CGColor);
    //画椭圆 当宽和高一样的时候 为圆 此处设置可视范围
    CGContextAddEllipseInRect(context, rect);
    CGContextAddEllipseInRect(context, rect2);
    //剪切可视范围
    CGContextClip(context);
    
    //绘制图片
    [newimg drawInRect:rect];
    [newimg drawInRect:rect2];
    
    CGContextAddEllipseInRect(context, rect);
    CGContextAddEllipseInRect(context, rect2);
    // 绘制当前的路径 只描绘边框
    //CGContextStrokePath(context);
    CGContextDrawPath(context, kCGPathFill);
    newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}
+ (UIImage*)gl_circleImageSaihong:(UIImage*)image tag:(int)vtag faceLandMarkPoints:(NSMutableArray *)landMarkPoints
{
    UIImage *newimg = [self imageWithColor:[UIColor redColor] size:image.size];;
    NSMutableArray *points=landMarkPoints;
    CGPoint sPoints [points.count];
    float maxx=0;
    float maxy=0;
    float minx=9999;
    float miny=9999;
    for (int i = 0;i <points.count;i++) {
        NSValue *pointValue = points[i];
        CGPoint point = pointValue.CGPointValue;
        sPoints[i] = point;
        if(point.x>maxx)
            maxx=point.x;
        if(point.y>maxy)
            maxy=point.y;
        if(point.x<minx)
            minx=point.x;
        if(point.y<miny)
            miny=point.y;
    }
    
    float _x =(maxx-minx-60)/4+minx;
    float _y =(maxy-miny)/2+miny-35;
    float _x2 =maxx-(maxx-minx-60)/4;
    CGRect rect = CGRectMake(_x-100, _y, 200, 220);
    CGRect rect2 = CGRectMake(_x2-100, _y, 200, 220);
    newimg=[self gl_addAboveImage:newimg addImage:[UIImage imageNamed:[NSString stringWithFormat:@"saihong%d.png",vtag]] rect:rect];
    newimg=[self gl_addAboveImage:newimg addImage:[UIImage imageNamed:[NSString stringWithFormat:@"saihong%d.png",vtag]] rect:rect2];
    newimg=[newimg rotate:UIImageOrientationDownMirrored];
    
    return newimg;
}
+ (UIImage*) gl_circleImageLight:(UIImage*)image tag:(int)vtag
{
    UIImage *myImage = image;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *superImage = [CIImage imageWithCGImage:myImage.CGImage];
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:superImage forKey:kCIInputImageKey];
    
    // 修改亮度   -1---1   数越大越亮
    [lighten setValue:@(0.2) forKey:@"inputBrightness"];
    
    // 修改饱和度  0---2
    [lighten setValue:@(0.5) forKey:@"inputSaturation"];
    
    // 修改对比度  0---4
    [lighten setValue:@(2.5) forKey:@"inputContrast"];
    CIImage *result = [lighten valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
    
    // 得到修改后的图片
    myImage = [UIImage imageWithCGImage:cgImage];
    
    // 释放对象
    CGImageRelease(cgImage);
    return myImage;
}
+ (UIImage *)gl_circleImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width, image.size.height), NO, [UIScreen mainScreen].scale);
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);

    //画椭圆 当宽和高一样的时候 为圆
    CGContextAddEllipseInRect(context, rect);
    //剪切可视范围
    CGContextClip(context);
    
    //绘制图片
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage *)gl_imageWithColor:(UIColor *)color size:(CGSize)size{
    CGSize imageSize = size;
    //通过自己创建一个context来绘制，通常用于对图片的处理
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置填充颜色
    CGContextSetFillColorWithColor(context, color.CGColor);
    //直接按rect的范围覆盖
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage *)gl_circleImageWithColor:(UIColor *)color radius:(CGFloat)radius
{
    CGSize imageSize = CGSizeMake(radius, radius);
    //通过自己创建一个context来绘制，通常用于对图片的处理
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置填充颜色
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    //用当前的填充颜色或样式填充路径线段包围的区域
    CGContextFillPath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage*)gl_cornerImage:(UIImage*)image corner:(CGFloat)corner rectCorner:(UIRectCorner)rectCorner
{
    CGSize imageSize = image.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0,
                             0,
                             imageSize.width,
                             imageSize.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                               byRoundingCorners:rectCorner
                                                     cornerRadii:CGSizeMake(corner,
                                                                            corner)];
    //添加路径
    CGContextAddPath(context, [path CGPath]);
    //剪切可视范围
    CGContextClip(context);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage*)gl_compressImage:(UIImage *)image maxSize:(CGFloat)maxSize maxSizeWithKB:(CGFloat)maxSizeKB
{    
    if (maxSize <= 0) {
        return nil;
    }
    
    if (maxSizeKB <= 0) {
        return nil;
    }

    CGSize compressSize = image.size;
    //获取缩放比 进行比较 
    CGFloat widthScale = compressSize.width*1.0 / maxSize;
    CGFloat heightScale = compressSize.height*1.0 / maxSize;
    
    if (widthScale > 1 && widthScale > heightScale) {
        compressSize = CGSizeMake(image.size.width/widthScale, image.size.height/widthScale);
    }
    else if (heightScale > 1 && heightScale > widthScale){
        compressSize = CGSizeMake(image.size.width/heightScale, image.size.height/heightScale);
    }
    
    //创建图片上下文 并获取剪切尺寸后的图片
    UIGraphicsBeginImageContextWithOptions(compressSize, NO, 1);
    CGRect rect = {CGPointZero,compressSize};
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //循环缩小图片大小
    NSData *imageData = UIImageJPEGRepresentation(newImage, 1.0);
    //获取当前图片的大小
    CGFloat currentImageSizeOfKB = imageData.length/1024.0;
    
    //压缩比例
    CGFloat compress = 0.9;
    
    while (currentImageSizeOfKB > maxSizeKB && compress > 0.1) {
        imageData = UIImageJPEGRepresentation(newImage, compress);
        currentImageSizeOfKB = imageData.length/1024.0;
        compress -= 0.1;
    }
    return [UIImage imageWithData:imageData];
}

+ (UIImage *)gl_compressImage:(UIImage *)image maxSize:(CGFloat)maxSize
{
    if (maxSize <= 0) {
        return nil;
    }
    
    CGSize compressSize = image.size;
    //获取缩放比 进行比较
    CGFloat widthScale = compressSize.width*1.0 / maxSize;
    CGFloat heightScale = compressSize.height*1.0 / maxSize;
    
    if (widthScale > 1 && widthScale > heightScale) {
        compressSize = CGSizeMake(image.size.width/widthScale, image.size.height/widthScale);
    }
    else if (heightScale > 1 && heightScale > widthScale){
        compressSize = CGSizeMake(image.size.width/heightScale, image.size.height/heightScale);
    }
    
    //创建图片上下文 并获取剪切尺寸后的图片
    UIGraphicsBeginImageContextWithOptions(compressSize, NO, 1);
    CGRect rect = {CGPointZero,compressSize};
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark == GIF图片
+ (UIImage *)gl_animateGIFWithImagePath:(NSString *)imagePath
{
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    if (!data) {
        return nil;
    }
    
    //得到动态图片资源 用到create 后面需要释放
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //得到图片资源的数量
    size_t imageCount = CGImageSourceGetCount(imageSource);
    //如果只有一张图片 则返回
    if (imageCount <= 1) {
        
        UIImage *resultImage = [UIImage imageWithData:data];
        
        return resultImage;
    }
    
    return animatedImageWithAnimateImageSource(imageSource);
}

+ (UIImage *)gl_animateGIFWithImageData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    
    //得到动态图片资源 用到create 后面需要释放
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //得到图片资源的数量
    size_t imageCount = CGImageSourceGetCount(imageSource);
    //如果只有一张图片 则返回
    if (imageCount <= 1) {
        
        UIImage *resultImage = [UIImage imageWithData:data];
        
        return resultImage;
    }
    
    return animatedImageWithAnimateImageSource(imageSource);
}

+ (UIImage *)gl_animateGIFWithImageUrl:(NSURL *)url
{
    if (!url) {
        return nil;
    }
    //得到动态图片资源 用到create 后面需要释放
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
      
    return animatedImageWithAnimateImageSource(imageSource);
}

//动态图片处理
static UIImage *animatedImageWithAnimateImageSource(CGImageSourceRef imageSource)
{
    if (imageSource) {
        //得到图片资源的数量
        size_t imageCount = CGImageSourceGetCount(imageSource);
        
        //最终图片资源
        UIImage *resultImage = nil;
        
        //动态图片时间
        NSTimeInterval duration = 0.0;
        //取图片资源
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:imageCount];
        
        for (size_t i = 0; i < imageCount; i ++) {
            //此处用到了create  后面记得释放
            CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
            
            if (cgImage) {
                //将图片加入到数组中
                [images addObject:[UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            }
            
            duration += frameDuration(i, imageSource);
            
            //释放掉 不然会内存泄漏
            CGImageRelease(cgImage);
        }
        
        if (duration == 0.0) {
            duration = 0.1 * imageCount;
        }
        
        
        resultImage = [UIImage animatedImageWithImages:images duration:duration];
        
        CFRelease(imageSource);
        
        return resultImage;
    }
    return nil;
}

static CGFloat frameDuration(NSInteger index,CGImageSourceRef source)
{
    //获取每一帧的信息
    CFDictionaryRef frameProperties = CGImageSourceCopyPropertiesAtIndex(source,index, nil);
    //转换为dic
    NSDictionary *framePropertiesDic = (__bridge NSDictionary *)frameProperties;
    //获取每帧中关于GIF的信息
    NSDictionary *gifProperties = framePropertiesDic[(__bridge NSString *)kCGImagePropertyGIFDictionary];
    /*
     苹果官方文档中的说明
     kCGImagePropertyGIFDelayTime
     The amount of time, in seconds, to wait before displaying the next image in an animated sequence
     
     kCGImagePropertyGIFUnclampedDelayTime
     The amount of time, in seconds, to wait before displaying the next image in an animated sequence. This value may be 0 milliseconds or higher. Unlike the kCGImagePropertyGIFDelayTime property, this value is not clamped at the low end of the range.
     
     看了翻译瞬间蒙了 感觉一样 但是kCGImagePropertyGIFDelayTime 可能为0  所以我觉得可以先判断kCGImagePropertyGIFDelayTime
     */
    CGFloat duration = 0.1;
    
    NSNumber *unclampedPropdelayTime = gifProperties[(__bridge NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    NSNumber *delayTime = gifProperties[(__bridge NSString *)kCGImagePropertyGIFDelayTime];
    
    if (unclampedPropdelayTime) {
        duration = unclampedPropdelayTime.floatValue;
    }else{
        if (delayTime) {
            duration = delayTime.floatValue;
        }
    }
    
    CFRelease(frameProperties);
    
    return duration;
}


#pragma mark == 添加文字 截屏 擦除

+ (UIImage *)gl_addTitleAboveImage:(UIImage *)image addTitleText:(NSString *)text
                   attributeDic:(NSDictionary *)attributeDic point:(CGPoint)point
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    [image drawInRect:imageRect];
    
    [text drawAtPoint:point withAttributes:attributeDic];
    
    //获取上下文中的新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)gl_addAboveImage:(UIImage *)image addImage:(UIImage *)addImage rect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    [image drawInRect:imageRect];
    
    [addImage drawInRect:rect];
    
    //获取上下文中的新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)gl_snapScreenView:(UIView *)view
{
    //开启上下文
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //渲染图片
    [view.layer renderInContext:context];
    //得到新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    //避免内存泄漏
    view.layer.contents = nil;
    
    return newImage;
}

+ (UIImage *)gl_wipeImageWithView:(UIView *)view movePoint:(CGPoint)point brushSize:(CGSize)size
{
    //开启上下文
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //此方法不能渲染图片 只针对layer
    //[view.layer drawInContext:context];
    
    //以point为中心，然后size的一半向两边延伸  坐画笔  橡皮擦
    CGRect clearRect = CGRectMake(point.x - size.width/2.0, point.y - size.width/2.0, size.width, size.height);
    
    //渲染图片
    [view.layer renderInContext:context];
    //清除该区域
    CGContextClearRect(context, clearRect);
    //得到新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    //避免内存泄漏
    view.layer.contents = nil;
    
    return newImage;
}

+ (UIImage *)gl_drawImage:(UIImage *)image withRects:(NSArray *)rects
{
    UIImage *newImage = nil;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context,kCGLineCapRound); //边缘样式
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context,2); //线宽
    CGContextSetAllowsAntialiasing(context,YES); //打开抗锯齿
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    //绘制图片
    [image drawInRect:CGRectMake(0, 0,image.size.width, image.size.height)];
    CGContextBeginPath(context);
    for (int i = 0; i < rects.count; i ++) {
        CGRect rect = [rects[i] CGRectValue];
        CGPoint sPoints[4];//坐标点
        sPoints[0] = CGPointMake(rect.origin.x, rect.origin.y);//坐标1
        sPoints[1] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);//坐标2
        sPoints[2] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);//坐标3
        sPoints[3] = CGPointMake(rect.origin.x , rect.origin.y + rect.size.height);
        
        CGContextAddLines(context, sPoints, 4);//添加线
        CGContextClosePath(context); //封闭
    }
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
        
    }
    
}
+ (UIImage *)gl_drawImage:(UIImage *)image faceLandMarkPoints:(NSMutableArray *)points color:(UIColor *)cl
{
    UIImage * newImage =[self imageWithColor:[UIColor redColor] size:image.size];
   
        CGPoint sPoints [points.count];
        for (int i = 0;i <points.count;i++) {
            NSValue *pointValue = points[i];
            CGPoint point = pointValue.CGPointValue;
            sPoints[i] = point;
        }
        //画线
        UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineCap(context,kCGLineCapRound); //边缘样式
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineWidth(context,0.5); //线宽
        CGContextSetAllowsAntialiasing(context,YES); //打开抗锯齿
    //CGContextSetBlendMode(context, kCGBlendModeColorDodge);
    //CGContextSetShouldAntialias(context, YES);
        // 设置翻转
        CGContextTranslateCTM(context, 0, newImage.size.height);
        CGContextScaleCTM(context, 1, -1.0);
        CGContextSetStrokeColorWithColor(context, cl.CGColor);
        CGContextSetFillColorWithColor(context, cl.CGColor);
    //CGContextClipToMask(context, CGRectMake(30, 30, 50, 50), kCGImagePropertyDepth)
      CGContextDrawImage(context, CGRectMake(0, 0,newImage.size.width,newImage.size.height), newImage.CGImage);
        CGContextBeginPath(context);
        CGContextAddLines(context, sPoints,points.count);//添加线
        CGContextClosePath(context); //封闭
        CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
    
    GPUImageGaussianSelectiveBlurFilter *filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
    
    //    filter.texelSpacingMultiplier = 5.0;
    
    filter.excludeCircleRadius = -120 / 320.0;
    
    [filter forceProcessingAtSize:newImage.size];
    
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:newImage];
    
    [pic addTarget:filter];
    
    [pic processImage];
    
    [filter useNextFrameForImageCapture];
    
    newImage = [filter imageFromCurrentFramebuffer];
    return newImage;
}

+ (UIImage *)gl_drawImageEyeline:(UIImage *)image faceLandMarkPoints:(NSArray *)landMarkPoints color:(UIColor *)cl
{
    UIImage * newImage =[self imageWithColor:[UIColor redColor] size:image.size];
    for (NSMutableArray *points in landMarkPoints) {
        CGPoint sPoints [points.count-3];
        for (int i = 0;i <points.count-3;i++) {
            NSValue *pointValue = points[i];
            CGPoint point = CGPointMake(pointValue.CGPointValue.x, pointValue.CGPointValue.y+5);
            sPoints[i] = point;
        }
        //画线
        UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineCap(context,kCGLineCapRound); //边缘样式
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineWidth(context,3.0); //线宽
        CGContextSetAllowsAntialiasing(context,YES); //打开抗锯齿
        // 设置翻转
        CGContextTranslateCTM(context, 0, newImage.size.height);
        CGContextScaleCTM(context, 1, -1.0);
        CGContextSetStrokeColorWithColor(context, cl.CGColor);
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextDrawImage(context, CGRectMake(0, 0,newImage.size.width,newImage.size.height), newImage.CGImage);
        CGContextBeginPath(context);
        CGContextAddLines(context, sPoints,points.count-3);//添加线
        //CGContextClosePath(context); //封闭
        CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    GPUImageGaussianSelectiveBlurFilter *filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
    
    filter.blurRadiusInPixels = 3.5;
    filter.excludeCircleRadius = -120 / 320.0;
    
    [filter forceProcessingAtSize:newImage.size];
    
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:newImage];
    
    [pic addTarget:filter];
    
    [pic processImage];
    
    [filter useNextFrameForImageCapture];
    
    newImage = [filter imageFromCurrentFramebuffer];
    return newImage;
}
+ (UIImage *)gl_drawImageJiemao:(UIImage *)image faceLandMarkPoints:(NSArray *)landMarkPoints
{
    UIImage * newImage =[self imageWithColor:[UIColor redColor] size:image.size];
    int j=1;
    for (NSMutableArray *points in landMarkPoints) {
        float maxx=0;
        float maxy=0;
        float minx=9999;
        float miny=9999;
        for (int i = 0;i <points.count;i++) {
            NSValue *pointValue = points[i];
            CGPoint point = pointValue.CGPointValue;
            if(point.x>maxx)
                maxx=point.x;
            if(point.y>maxy)
                maxy=point.y;
            if(point.x<minx)
                minx=point.x;
            if(point.y<miny)
                miny=point.y;
        }
        NSValue *pointValue = points[0];
        float _y;
        float _x;
        CGPoint point = CGPointMake(pointValue.CGPointValue.x, pointValue.CGPointValue.y);
        if(j==1){
            _y=point.y+2;
            _x=point.x+5;
        }
        else{
            _y=point.y+(maxy-miny)/3-1;
            _x=point.x;
        }
        UIImage *Jimg = [UIImage imageNamed:[NSString stringWithFormat:@"jiemao%d.png",j]];
        float _width=Jimg.size.width;
        float _height=Jimg.size.height;
        if(maxy-miny<45){//眼睛比睫毛小 需要缩小
            Jimg = [UIImage imageNamed:[NSString stringWithFormat:@"jiemao_%d.png",j]];
            _width=Jimg.size.width;
            _height=Jimg.size.height;
            
            if(j==1){
                _y=_y-3;
            }
            else{
                _y=_y-7;
                _x=_x+4;
            }
        }
        newImage=[self gl_addAboveImage:newImage addImage:Jimg rect:CGRectMake(_x, _y, _width, _height)];
        NSLog(@"y=%f   %f",maxx-minx,maxy-miny);
        j++;
    }
    /*GPUImageGaussianSelectiveBlurFilter *filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
    
    filter.blurRadiusInPixels = 4;
    filter.excludeCircleRadius = -120 / 320.0;
    
    [filter forceProcessingAtSize:newImage.size];
    
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:newImage];
    
    [pic addTarget:filter];
    
    [pic processImage];
    
    [filter useNextFrameForImageCapture];
    
    newImage = [filter imageFromCurrentFramebuffer];*/
    newImage=[newImage rotate:UIImageOrientationDownMirrored];
    return newImage;
}
+ (UIImage *)gl_drawImage2:(UIImage *)image faceLandMarkPoints:(NSMutableArray *)landMarkPoints
{
    UIImage * newImage = image;
    //for (NSMutableArray *points in landMarkPoints) {
        NSMutableArray *points=landMarkPoints;
        CGPoint sPoints [points.count];
    float maxx=0;
    float maxy=0;
    float minx=9999;
    float miny=9999;
        for (int i = 0;i <points.count;i++) {
            NSValue *pointValue = points[i];
            CGPoint point = pointValue.CGPointValue;
            sPoints[i] = point;
            if(point.x>maxx)
                maxx=point.x;
            if(point.y>maxy)
                maxy=point.y;
            if(point.x<minx)
                minx=point.x;
            if(point.y<miny)
                miny=point.y;
                
        }
    
        //画线
        //UIGraphicsBeginImageContextWithOptions(newImage.size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        /*CGContextSetLineCap(context,kCGLineCapRound); //边缘样式
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineWidth(context,2); //线宽
        CGContextSetAllowsAntialiasing(context,YES); //打开抗锯齿
        // 设置翻转
        CGContextTranslateCTM(context, 0, newImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
        
        CGContextDrawImage(context, CGRectMake(0, 0,newImage.size.width,newImage.size.height), newImage.CGImage);
    
        CGContextBeginPath(context);
        CGContextAddLines(context, sPoints,points.count);//添加线
        CGContextClosePath(context); //封闭
        CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();*/
    
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
    
    CGContextSetLineWidth(context,1.0);//线的宽度
    
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π（≈57.3°）度＝弧度×180°/π 360°＝360×π/180＝2π弧度
    
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为结束的弧度，clockwise 0为顺时针，1为逆时针。
    float PI=3.1415;
    CGContextAddArc(context,100,20,15,0,2*PI,0);//添加一个圆
    
    CGContextDrawPath(context,kCGPathStroke);//绘制路径
    
    //填充圆，无边框
    
    CGContextAddArc(context,150,30,30,0,2*PI,0);//添加一个圆
    
    CGContextDrawPath(context,kCGPathFill);//绘制填充
    
    //画大圆并填充颜
    
    UIColor*aColor = [UIColor colorWithRed:1 green:0.0 blue:0 alpha:1];
    
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    
    CGContextSetLineWidth(context,3.0);//线的宽度
    
    CGContextAddArc(context,250,40,40,0,2*PI,0);//添加一个圆
    
    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
    
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径加填充
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsPushContext(context);
    //}
    return newImage;
}

+ (UIImage *)fixOrientationImage:(UIImage *)image {
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
