//
//  photoManager.m
//  photoKit
//
//  Created by xiaojun on 16/6/7.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import "photoManager.h"

@implementation photoManager

+ (instancetype)sharedObject {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

@end
