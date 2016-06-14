//
//  AssetListViewController.m
//  photoKit
//
//  Created by xiaojun on 16/6/7.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import "AssetListViewController.h"
#import "AssetListViewCell.h"
#import "UICollectionView+Convenience.h"
#import "PhotoBrowserViewController.h"

@interface AssetListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property CGRect previousPreheatRect;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *selectedAssets;
@property (nonatomic,strong)UIButton *previewButton;
@property (nonatomic,strong)UIButton *selectButton;
#define  selectedLabelTag 10
@end

@implementation AssetListViewController

static NSString * const reuseIdentifier = @"AssetListViewCell";
static CGSize AssetGridThumbnailSize;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.title = self.assetCollection.localizedTitle;
   
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self resetCachedAssets];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preViewFinishSelected:) name:@"preViewFinishSelected" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initUI{
    // Register cell classes
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(80, 80);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) collectionViewLayout:flowLayout];
    UINib *cellNib = [UINib nibWithNibName:reuseIdentifier bundle:[NSBundle mainBundle]];
    
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setCollectionViewContentOffset) userInfo:nil repeats:NO];

    _selectedAssets = [NSMutableArray array];
    
    UIToolbar*tabBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    
    _previewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _previewButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
    [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [_previewButton addTarget:self action:@selector(showPreView) forControlEvents:UIControlEventTouchUpInside];
    _previewButton.userInteractionEnabled = NO;
    
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [_selectButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:200.0/255.0 blue:0.0/255.0 alpha:1.0 ] forState:UIControlStateNormal];
    _selectButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:16.0];
    [_selectButton setTitle:@"确定" forState:UIControlStateNormal];
    [_selectButton addTarget:self action:@selector(finishSelected) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.userInteractionEnabled = NO;
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_previewButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_selectButton];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [spaceButtonItem setWidth:self.view.frame.size.width - 140 -40];
    [tabBar setItems:@[leftItem,spaceButtonItem,rightItem]];
    [self.view addSubview:tabBar];
    _selectButton.alpha = 0.3;
    _previewButton.alpha = 0.3;
    
}

-(void)viewWillAppear:(BOOL)animated{
    CGFloat scale = [UIScreen mainScreen].scale;
    AssetGridThumbnailSize = CGSizeMake(80*scale, 80*scale);//请求图片的大小，retina屏幕需要放大
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Begin caching assets in and around collection view's visible rect.
    [self updateCachedAssets];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)setCollectionViewContentOffset{
    if(self.collectionView.superview&&self.collectionView.window&&self.collectionView.contentSize.height>self.collectionView.frame.size.height){
    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.frame.size.height)];
    }
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PHAsset *asset = _assetsFetchResults[indexPath.item];
    if([_selectedAssets containsObject:asset]){
       cell.selectionImage.image = [UIImage imageNamed:@"checkbox_pic"];
    }else{
       cell.selectionImage.image = [UIImage imageNamed:@"checkbox_pic_non"];
    }
    
    cell.representedAssetIdentifier = asset.localIdentifier;
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                      cell.detailImage = result;
                                  }
                              }];
    
    //选择照片后的处理
    cell.selectImageClick = ^(AssetListViewCell *selectedCell){
        NSIndexPath *selectIndex = [_collectionView indexPathForCell:selectedCell];
        PHAsset *asset = _assetsFetchResults[selectIndex.row];
        if([_selectedAssets containsObject:asset]){
            [_selectedAssets removeObject:asset];
            selectedCell.selectionImage.image = [UIImage imageNamed:@"checkbox_pic_non"];
        }else{
            [_selectedAssets addObject:asset];
            selectedCell.selectionImage.image = [UIImage imageNamed:@"checkbox_pic"];
        };
        [self setToolBarItemState];
    };
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoBrowserViewController *browserViewController = [[PhotoBrowserViewController alloc] init];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:_assetsFetchResults.count];
    for(PHAsset *asset in _assetsFetchResults){
        [arr addObject:asset];
    }
    browserViewController.assets = arr;
    browserViewController.currentIndex = indexPath.item;
    browserViewController.selectedAssets = _selectedAssets;
    browserViewController.finishBlock=^(NSMutableArray *selectedAssets){
        _selectedAssets = selectedAssets;
        [self setToolBarItemState];
        [self.collectionView reloadData];
        
    };
    [self presentViewController:browserViewController animated:YES completion:^{
        
    }];
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


#pragma --mark 缓存代码


- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {//滑动屏幕三分之一的距离后进行缓存
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        //向上滑动
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (newMinY > oldMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
        
        
        //向下滑动
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (oldMaxY > newMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }
    
    return assets;
}


#pragma --mark method

-(void)preViewFinishSelected:(NSNotification*)notif{
//    NSLog(@"%@",[notif object]);//array
    _selectedAssets = (NSMutableArray*)[notif object];
    [self finishSelected];
}

-(void)finishSelected{
    if(self.finishSelectBlock){
        self.finishSelectBlock(self.selectedAssets);
    }
}
-(void)showPreView{
//    NSLog(@"showPreView");
    PhotoBrowserViewController *browserViewController = [[PhotoBrowserViewController alloc] init];
    browserViewController.assets = _selectedAssets;
    browserViewController.selectedAssets = _selectedAssets;
    browserViewController.currentIndex = 0;
    browserViewController.finishBlock=^(NSMutableArray *selectedAssets){
        _selectedAssets = selectedAssets;
        [self setToolBarItemState];
        [self.collectionView reloadData];
    };
    [self presentViewController:browserViewController animated:YES completion:^{
        
    }];
}



-(void)setToolBarItemState{
    if(_selectedAssets.count>0){
        _previewButton.alpha = 1.0;
        _previewButton.userInteractionEnabled = YES;
        _selectButton.alpha = 1.0;
        _selectButton.userInteractionEnabled = YES;
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 20,20)];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:200.0/255.0 blue:0.0/255.0 alpha:1.0 ];
        countLabel.textColor = [UIColor whiteColor];
        countLabel.layer.cornerRadius = 10;
        countLabel.layer.masksToBounds = YES;
        countLabel.text = [NSString stringWithFormat:@"%li",_selectedAssets.count];
        countLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
        countLabel.tag = selectedLabelTag;
        [_selectButton addSubview:countLabel];
        
        [UIView animateWithDuration:0.2 animations:^{
            countLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                countLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        UILabel *countLabel = (UILabel*)[_selectButton viewWithTag:selectedLabelTag];
        [UIView animateWithDuration:0.2 animations:^{
            countLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                countLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
            } completion:^(BOOL finished) {
                [countLabel removeFromSuperview];
            }];
        }];
        _selectButton.alpha = 0.3;
        _selectButton.userInteractionEnabled = NO;
        _previewButton.userInteractionEnabled = NO;
        _previewButton.alpha = 0.3;
    }

}

/**
 *  cancel
 */
-(void)cancel{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoSelectCanceled" object:nil];
    
}

#pragma --mark oritation
-(BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskPortrait;
}//当前viewcontroller支持哪些转屏方向

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return   UIInterfaceOrientationPortrait ;
}//当前viewcontroller默认的屏幕方向
@end
