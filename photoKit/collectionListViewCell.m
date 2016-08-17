//
//  collectionListViewCell.m
//  photoKit
//
//  Created by xiaojun on 16/6/8.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import "collectionListViewCell.h"

@implementation collectionListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)prepareForReuse{
    _thumbImage.image = nil;
    [super prepareForReuse];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
