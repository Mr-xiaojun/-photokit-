//
//  PhotoBrowserImageView.m
//  photoKit
//
//  Created by xiaojun on 16/6/13.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import "PhotoBrowserImageView.h"

@implementation PhotoBrowserImageView{
    BOOL isDoubleScale;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
        doubleTap.numberOfTapsRequired = 2;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
        singleTap.numberOfTapsRequired = 1;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:singleTap];
        [self addGestureRecognizer:doubleTap];
        isDoubleScale = NO;
    }
    return self;
}


-(void)setDoubleClickBlock:(doubleClickBlock)doubleClickBlock{
    _doubleClickBlock = doubleClickBlock;
}


-(void)doubleClick:(UITapGestureRecognizer*)tap{
    if(tap.numberOfTapsRequired == 1){
        
        if(_singleClickBlock){
            _singleClickBlock();
        }
        
    }else if(tap.numberOfTapsRequired == 2){
        
        if(isDoubleScale){
            if(_doubleClickBlock){
                _doubleClickBlock(1.0);
            }
        }else{
            if(_doubleClickBlock){
                _doubleClickBlock(2.0);
            }
        }
        isDoubleScale = !isDoubleScale;
    }
}


@end
