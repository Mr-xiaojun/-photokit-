//
//  RootListViewController.h
//  photoKit
//
//  Created by xiaojun on 16/6/8.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHAsset+Category.h"
typedef void (^finishSelectBlock)(NSArray* selectedArr);
@interface RootListViewController : UIViewController
@property (nonatomic,strong)finishSelectBlock finishSelectBlock;
@end
