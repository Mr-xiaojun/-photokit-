//
//  RootListViewController.m
//  photoKit
//
//  Created by xiaojun on 16/6/8.
//  Copyright © 2016年 com.3lengjing. All rights reserved.
//

#import "RootListViewController.h"
#import "Masonry.h"
#import "AssetListViewController.h"
#import "collectionListViewCell.h"
@import Photos;
@interface RootListViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sectionFetchResults;

@end
@implementation RootListViewController
static NSString * const AllPhotosReuseIdentifier = @"AllPhotosCell";
static NSString * const CollectionCellReuseIdentifier = @"CollectionCell";

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"相册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
//    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
//    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
//    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
//    
//    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    
//    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
//    
//    // Store the PHFetchResult objects and localized titles for each section.
//    self.sectionFetchResults = @[allPhotos, smartAlbums, topLevelUserCollections];
    [self requestPhotoCollection];
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel) name:@"photoSelectCanceled" object:nil];
}
/**
 *  将需要的相册添加到数组
 */
-(void)requestPhotoCollection{
    

    _sectionFetchResults = [NSMutableArray array];
    PHFetchResult *allPhoto = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
   
    PHFetchResult *album = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular  options:nil];
    
//    PHFetchResult *moment = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeMoment subtype:PHAssetCollectionSubtypeAny options:nil];
    PHFetchResult *smartAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    
    //过滤相片数量为空的相册
    for(PHCollection*collection in allPhoto){
        PHAssetCollection *assetCollection = (PHAssetCollection*)collection;
        PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        if(assetResult.count>0){
            [_sectionFetchResults addObject:collection];
        }
    }
    
    for(PHCollection*collection in smartAlbum){
        PHAssetCollection *assetCollection = (PHAssetCollection*)collection;
        PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        if(assetResult.count>0){
            [_sectionFetchResults addObject:collection];
        }
    }
    
    for(PHCollection*collection in album){
        PHAssetCollection *assetCollection = (PHAssetCollection*)collection;
        PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        if(assetResult.count>0){
            [_sectionFetchResults addObject:collection];
        }
    }
    
}

-(void)initUI{
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewStylePlain;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return _sectionFetchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    collectionListViewCell  *cell = nil;
    UINib *nib = [UINib nibWithNibName:@"collectionListViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:AllPhotosReuseIdentifier];
    cell = [tableView dequeueReusableCellWithIdentifier:AllPhotosReuseIdentifier];
    PHCollection *collection = _sectionFetchResults[indexPath.row];
    cell.titleLabel.text = [self replaceEglishAssetCollectionName:collection.localizedTitle];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if(![collection isKindOfClass:[PHAssetCollection class]]){
        return nil;
    }
    PHAssetCollection *assetCollection = (PHAssetCollection*)collection;
    PHFetchResult *assetFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    PHAsset *asset = [assetFetchResult lastObject];
    cell.CntLabel.text = [NSString stringWithFormat:@"(%li)",assetFetchResult.count];
    CGFloat scale = [UIScreen mainScreen].scale;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(43*scale, 43*scale) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.thumbImage.image = result;
    }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AssetListViewController *ListVC = [[AssetListViewController alloc] init];
    PHCollection *collection = _sectionFetchResults[indexPath.row];
    if(![collection isKindOfClass:[PHAssetCollection class]]){
        return;
    }
    PHAssetCollection *assetCollection = (PHAssetCollection*)collection;
    PHFetchResult *assetFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    ListVC.assetsFetchResults = assetFetchResult;
    ListVC.assetCollection = assetCollection;
    ListVC.finishSelectBlock = ^(NSArray*selectedAssets){
        if(self.finishSelectBlock){
            self.finishSelectBlock(selectedAssets);
        }

        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    [self.navigationController pushViewController:ListVC animated:YES];
}

#pragma --mark q取消

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(NSString*)replaceEglishAssetCollectionName:(NSString*)EnName{
    if([EnName isEqualToString:@"My Photo Stream"]){
        return @"我的照片流";
    }
    if([EnName isEqualToString:@"Selfies"]){
        return @"自拍";
    }
    if([EnName isEqualToString:@"Bursts"]){
        return @"连拍";
    }
    if([EnName isEqualToString:@"Screenshots"]){
        return @"屏幕快照";
    }
    
    if([EnName isEqualToString:@"Favorites"]){
        return @"喜欢";
    }
    if([EnName isEqualToString:@"Recently Added"]){
        return @"最近添加";
    }
    if([EnName isEqualToString:@"Videos"]){
        return @"视频";
    }
    if([EnName isEqualToString:@"Panoramas"]){
        return @"全景";
    }
    if([EnName isEqualToString:@"Camera Roll"]){
        return @"相机胶卷";
    }
    return EnName;
}
@end
