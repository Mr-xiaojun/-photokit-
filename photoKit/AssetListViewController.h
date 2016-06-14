//
//  AssetListViewController.h
//  photoKit
//
//  Created by xiaojun on 16/6/7.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHAsset+Category.h"
@import Photos;
typedef void (^finishSelectBlock)(NSArray* selectedArr);

@interface AssetListViewController : UIViewController
@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic,strong)finishSelectBlock finishSelectBlock;
@end
