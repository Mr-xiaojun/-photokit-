//
//  PhotoBrowserImageView.h
//  photoKit
//
//  Created by xiaojun on 16/6/13.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^doubleClickBlock)(CGFloat scale);
typedef void (^singleClickBlock)();
@interface PhotoBrowserImageView : UIImageView
@property (nonatomic,strong)doubleClickBlock doubleClickBlock;
@property (nonatomic,strong)singleClickBlock singleClickBlock;
@end
