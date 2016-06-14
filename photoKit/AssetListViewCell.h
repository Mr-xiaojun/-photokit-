//
//  AssetListViewCell.h
//  photoKit
//
//  Created by xiaojun on 16/6/7.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AssetListViewCell;
typedef void(^selectImageClick)(AssetListViewCell *selectCell);

@interface AssetListViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (nonatomic,strong)UIImage *detailImage;
@property (nonatomic,strong)NSString *representedAssetIdentifier;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImage;
@property (nonatomic,strong)selectImageClick selectImageClick;
@end
