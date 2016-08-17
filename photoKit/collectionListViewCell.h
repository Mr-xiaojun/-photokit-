//
//  collectionListViewCell.h
//  photoKit
//
//  Created by xiaojun on 16/6/8.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface collectionListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *CntLabel;

@end
