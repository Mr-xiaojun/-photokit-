//
//  photoBrowserImageScrollView.m
//  photoKit
//
//  Created by xiaojun on 16/6/13.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import "photoBrowserImageScrollView.h"

@implementation photoBrowserImageScrollView{
    PhotoBrowserImageView *imageView;
    
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor blackColor];
//        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        imageView = [[PhotoBrowserImageView alloc] initWithFrame:frame];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
        __weak typeof(self)weakSelf = self;
        imageView.doubleClickBlock = ^(CGFloat scale){
//            if(scale>1.0){
//                if(imageView.frame.size.width/imageView.frame.size.height >self.frame.size.width/self.frame.size.height){//横条形状
//                    [weakSelf setImageViewFrame:CGRectMake(0, 0, imageView.frame.size.width/imageView.frame.size.height*weakSelf.frame.size.height, weakSelf.frame.size.height)];
//                }else{
//                    [weakSelf setImageViewFrame:CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height/imageView.frame.size.width*self.frame.size.width)];
//                }
//                self.contentSize = imageView.frame.size;
//            }else{
//               [weakSelf resetImageViewFrame:weakSelf.frame.size imageSize:imageView.image.size];
//                self.contentSize = self.frame.size;
//            }
            [UIView animateWithDuration:0.3 animations:^{
                
            weakSelf.zoomScale = scale;
            }];
        };
        
        imageView.singleClickBlock = ^{
            weakSelf.singleClickBlock();
        };
        self.delegate = self;
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        self.zoomScale = YES;
        [self addSubview:imageView];
    }
    
    return self;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    imageView.image = image;
    [self resetImageViewFrame:self.frame.size imageSize:image.size];
}

-(void)setAsset:(PHAsset *)asset{
    _asset = asset;
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeNone;
        option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        [[PHImageManager defaultManager] requestImageForAsset:_asset targetSize:imageView.frame.size contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            imageView.image = result;
            [self resetImageViewFrame:self.frame.size imageSize:result.size];
        }];
    
}

-(void)setSingleClickBlock:(singleClickBlock)singleClickBlock{
    _singleClickBlock = singleClickBlock;
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    [imageView setCenter:CGPointMake(xcenter, ycenter)];
}

-(void)resetImageViewFrame:(CGSize)viewSize  imageSize:(CGSize)imageSize{
    if(imageSize.width>0 &&imageSize.height>0){
        if((imageSize.width/imageSize.height)>(viewSize.width/viewSize.height)){//横条形状的图片
            viewSize = CGSizeMake(self.frame.size.width, imageSize.height/imageSize.width*viewSize.width);
        }else{//竖条形状的图片
            viewSize = CGSizeMake(imageSize.width/imageSize.height*viewSize.height, self.frame.size.height);
        }
        imageView.frame = CGRectMake((self.frame.size.width - viewSize.width)/2, (self.frame.size.height - viewSize.height)/2, viewSize.width, viewSize.height);
    }
}

-(void)setImageViewFrame:(CGRect)frame{
    imageView.frame = frame;
}
@end
