//
//  PhotoBrowserViewController.m
//  photoKit
//
//  Created by xiaojun on 16/6/13.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import "PhotoBrowserViewController.h"
#import "PhotoBrowserViewCell.h"
#define  selectedLabelTag 10
#define originImageSizeTag 10
@interface PhotoBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)PHAsset *currentAsset;
@end

@implementation PhotoBrowserViewController{
    UIToolbar *topToolBar;
    UIToolbar *bottomToolBar;
    UIButton *backButton;
    UIButton *selectButton;
    UIButton *originButton;
    UIButton *senderButton;
}
static NSString *const cellIdentifiel = @"PhotoBroswerCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
      [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(collectionViewScrollToItemAtIndexpath) userInfo:nil repeats:NO];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    
}

-(void)initCollectionView{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layOut.minimumLineSpacing = 0;
    layOut.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layOut];
    [_collectionView registerClass:[PhotoBrowserViewCell class] forCellWithReuseIdentifier:cellIdentifiel];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    
    [self.view addSubview:_collectionView];
    
}



-(void)initToolBar{
    topToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    topToolBar.barTintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 64)];
    [backButton setImage:[UIImage imageNamed:@"btn_back_imagePicker"] forState:UIControlStateNormal];
    [backButton addTarget:selectButton action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 64)];
    [selectButton setImage:[UIImage imageNamed:@"checkbox_pic_non"] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selected) forControlEvents:UIControlEventTouchUpInside];
    [self setSelectButtonState];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectButton];
      UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spaceButtonItem setWidth:self.view.frame.size.width - 120 -30];
    [topToolBar setItems:@[backItem,spaceButtonItem,selectItem]];
    [self.view addSubview:topToolBar];
    
    bottomToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    bottomToolBar.barTintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    originButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [originButton setTitle:@"原图" forState:UIControlStateNormal];
    originButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
    [originButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [originButton addTarget:self action:@selector(requestOriginImage) forControlEvents:UIControlEventTouchUpInside];
//    originButton.userInteractionEnabled = NO;
    
    senderButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [senderButton setTitle:@"发送" forState:UIControlStateNormal];
    [senderButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:200.0/255.0 blue:0.0/255.0 alpha:1.0 ] forState:UIControlStateNormal];
    senderButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
    senderButton.userInteractionEnabled = NO;
    [senderButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *originItem = [[UIBarButtonItem alloc] initWithCustomView:originButton];
    UIBarButtonItem *senderItem = [[UIBarButtonItem alloc] initWithCustomView:senderButton];
    UIBarButtonItem *spaceButtonItem2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spaceButtonItem2 setWidth:self.view.frame.size.width - 140 -30];
    [bottomToolBar setItems:@[originItem,spaceButtonItem2,senderItem]];
    [self.view addSubview:bottomToolBar];
    [self setSendButtonAlpha];
    originButton.alpha = 0.3;
}


-(void)setAssets:(NSMutableArray *)assets{
    _assets = assets;
    [self initToolBar];
}

#pragma  --mark collectionviewdatasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(_images.count>0){
        return _images.count;
    }else if(_assets.count>0){
        return  _assets.count;
    }else{
        return 0;
    }
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoBrowserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifiel forIndexPath:indexPath];

    cell.scrollView.singleClickBlock = ^{
        if(topToolBar.alpha>0.0){
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear  animations:^{
                topToolBar.alpha = 0.0;
                bottomToolBar.alpha = 0.0;
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear   animations:^{
                topToolBar.alpha = 1.0;
                bottomToolBar.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
        }
    };
    cell.asset = _assets[indexPath.item];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

   self.currentIndex = scrollView.contentOffset.x/scrollView.bounds.size.width;
}

#pragma  --mark setmethod

-(void)setCurrentIndex:(NSUInteger)currentIndex{
    _currentIndex = currentIndex;
    _currentAsset = _assets[_currentIndex];
    [self setSelectButtonState];
}

-(void)setSelectedAssets:(NSMutableArray *)selectedAssets{
    _selectedAssets = selectedAssets;
    [self setSendButtonAlpha];
}

#pragma --mark methods
-(void)collectionViewScrollToItemAtIndexpath{
    if(_collectionView.superview&&_collectionView.window){
    NSIndexPath *index = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
    [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}


-(void)selected{
    if(![_selectedAssets containsObject:_assets[_currentIndex]]){
        [_selectedAssets addObject:_assets[_currentIndex]];
    }else{
        [_selectedAssets removeObject:_assets[_currentIndex]];
    }
    [self setSelectButtonState];
    [self setSendButtonAlpha];
}

-(void)requestOriginImage{
    if(![_selectedAssets containsObject:_assets[_currentIndex]]){
        [_selectedAssets addObject:_assets[_currentIndex]];
    }//如果没有选择。则先选择，再标记为选择原图
    [self setSelectButtonState];
    [self setSendButtonAlpha];
    PHAsset *currentAsset = _assets[_currentIndex];
    PHAsset *changedAsset = currentAsset;
    changedAsset.RequestOrigin = !changedAsset.RequestOrigin;
    [self.assets replaceObjectAtIndex:_currentIndex withObject:changedAsset];//替换正在展示的列表
    if(_selectedAssets.count>0){
        NSInteger index = [_selectedAssets indexOfObject:currentAsset];
        if(index>0){
            [_selectedAssets replaceObjectAtIndex:index withObject:changedAsset];//替换已经选择的列表
        }
    }
    [self setOriginSize];//显示或隐藏原图大小
}

-(void)setOriginSize{
    PHAsset *currentAsset = _assets[_currentIndex];
    if(currentAsset.RequestOrigin){
        UIView *view = [originButton viewWithTag:originImageSizeTag];
        if(!view){
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
            option.resizeMode = PHImageRequestOptionsResizeModeNone;
            option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            option.version =  PHImageRequestOptionsVersionOriginal;
            [[PHImageManager defaultManager]requestImageDataForAsset:currentAsset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                unsigned long size = imageData.length/1024;
                NSString *sizeString = [NSString stringWithFormat:@"%liK",size];
                if(size>1024){
                    NSInteger zhengshu = size/1024.0;
                    NSInteger xiaoshu = size%1024;
                    NSString *xiaoshuString = [NSString stringWithFormat:@"%li",xiaoshu];
                    if(xiaoshu>100){//取两位
                        xiaoshuString = [xiaoshuString substringToIndex:2];
                    }
                    sizeString = [NSString stringWithFormat:@"%li.%@M",zhengshu,xiaoshuString];
                }
                UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 50, originButton.frame.size.height)];
                sizeLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:200.0/255.0 blue:0.0/255.0 alpha:1.0 ];
                sizeLabel.tag = originImageSizeTag;
                sizeLabel.text = sizeString;
                [originButton addSubview:sizeLabel];
                originButton.alpha = 1.0;
            }];
        }
  
    }else{
        UIView *view = [originButton viewWithTag:originImageSizeTag];
        if(view){
            [view removeFromSuperview];
        }
        originButton.alpha = 0.3;
    }
}


-(void)send{
    [self dismissViewControllerAnimated:YES completion:^{
//        NSMutableDictionary *obj = [[NSMutableDictionary alloc] init];
//        [obj setValue:_selectedAssets forKey:@"selectedAssets"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"preViewFinishSelected" object:_selectedAssets];
    }];
}

-(void)setSelectButtonState{
    if(_assets.count>_currentIndex){
        PHAsset *currentAsset = _assets[_currentIndex];
        if([_selectedAssets containsObject:currentAsset]){
            [selectButton setImage:[UIImage imageNamed:@"checkbox_pic"] forState:UIControlStateNormal];
          
        }else{
           [selectButton setImage:[UIImage imageNamed:@"checkbox_pic_non"] forState:UIControlStateNormal];

        }
          [self setOriginSize];
    }
}

-(void)setSendButtonAlpha{
    if(_selectedAssets.count>0){
        senderButton.alpha = 1.0;
        senderButton.userInteractionEnabled = YES;
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 20,20)];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:200.0/255.0 blue:0.0/255.0 alpha:1.0 ];
        countLabel.textColor = [UIColor whiteColor];
        countLabel.layer.cornerRadius = 10;
        countLabel.layer.masksToBounds = YES;
        countLabel.text = [NSString stringWithFormat:@"%li",_selectedAssets.count];
        countLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
        countLabel.tag = selectedLabelTag;
        [senderButton addSubview:countLabel];
        
        [UIView animateWithDuration:0.2 animations:^{
            countLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
               countLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        UILabel *countLabel = (UILabel*)[senderButton viewWithTag:selectedLabelTag];
        [UIView animateWithDuration:0.2 animations:^{
            countLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                countLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
            } completion:^(BOOL finished) {
                [countLabel removeFromSuperview];
            }];
        }];
        senderButton.alpha = 0.3;
        senderButton.userInteractionEnabled = NO;
    }
}
-(void)back{
    self.finishBlock(self.selectedAssets);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
