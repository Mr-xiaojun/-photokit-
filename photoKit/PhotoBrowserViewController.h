//
//  PhotoBrowserViewController.h
//  photoKit
//
//  Created by xiaojun on 16/6/13.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHAsset+Category.h"
@import Photos;
typedef void (^finishSelectedAssetsBlock)(NSMutableArray *selectedAsset);
@interface PhotoBrowserViewController : UIViewController


@property (nonatomic,strong)NSMutableArray *images;
@property (nonatomic,strong)NSMutableArray *assets;
@property (nonatomic,strong)NSMutableArray *selectedAssets;
@property (nonatomic,assign) NSUInteger currentIndex;
@property (nonatomic,strong)finishSelectedAssetsBlock finishBlock;
@end
