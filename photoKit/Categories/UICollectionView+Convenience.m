//
//  UICollectionView+Convenience.m
//  photoKit
//
//  Created by xiaojun on 16/6/7.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import "UICollectionView+Convenience.h"

@implementation UICollectionView (Convenience)
-(NSArray*)indexPathsForElementsInRect:(CGRect)rect{
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if(allLayoutAttributes.count == 0){
        return nil;
    }
    NSMutableArray *indexsArr = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for(UICollectionViewLayoutAttributes *attributes in allLayoutAttributes){
        NSIndexPath *indexPath = attributes.indexPath;
        [indexsArr addObject:indexPath];
    }
    return  indexsArr;
}
@end
