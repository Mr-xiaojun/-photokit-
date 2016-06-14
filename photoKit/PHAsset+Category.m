//
//  PHAsset+Category.m
//  photoKit
//
//  Created by xiaojun on 16/6/14.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import "PHAsset+Category.h"
#define requestOriginkey @"requestOrigin"

@implementation PHAsset (Category)

-(void)setRequestOrigin:(BOOL)RequestOrigin{
    NSNumber *booNum = [NSNumber numberWithBool:RequestOrigin];
    objc_setAssociatedObject(self, requestOriginkey, booNum, OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)RequestOrigin{
    NSNumber *boolNum = objc_getAssociatedObject(self, requestOriginkey);
    return [boolNum boolValue];
}
@end
