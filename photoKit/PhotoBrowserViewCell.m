//
//  PhotoBrowserViewCell.m
//  photoKit
//
//  Created by xiaojun on 16/6/13.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import "PhotoBrowserViewCell.h"
#import "photoBrowserImageScrollView.h"
#import "PhotoBrowserImageView.h"


@implementation PhotoBrowserViewCell{
   
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _scrollView = [[photoBrowserImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_scrollView];
    }
    return self;
}

-(void)prepareForReuse{
    self.image = nil;
    self.asset = nil;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.contentSize = self.scrollView.frame.size;
}

-(void)setAsset:(PHAsset *)asset{
    
    _scrollView.asset = asset;
    
}


-(void)setImage:(UIImage *)image{
    
    _scrollView.image = image;
    
}



@end
