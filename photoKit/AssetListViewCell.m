//
//  AssetListViewCell.m
//  photoKit
//
//  Created by xiaojun on 16/6/7.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import "AssetListViewCell.h"

@implementation AssetListViewCell{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectImageClick)];
    [_selectionImage addGestureRecognizer:tap];
    
}
-(void)prepareForReuse{
    
   self.detailImage = nil;
    [super prepareForReuse];
}

-(void)setDetailImage:(UIImage *)detailImage{
    _detailImage = detailImage;
    self.detailImageView.image = detailImage;
}

-(void)didSelectImageClick{
    if(self.selectImageClick){
        self.selectImageClick(self);
    }
}
@end
