//
//  PhotoBrowserViewCell.h
//  photoKit
//
//  Created by xiaojun on 16/6/13.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "photoBrowserImageScrollView.h"
#import "PhotoBrowserImageView.h"
@import Photos;
@interface PhotoBrowserViewCell : UICollectionViewCell<UIScrollViewDelegate>
@property (nonatomic,strong)PHAsset *asset;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)photoBrowserImageScrollView *scrollView;
@end
