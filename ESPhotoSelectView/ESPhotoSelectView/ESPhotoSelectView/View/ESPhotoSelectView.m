//
//  ESPhotoSelectView.m
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import "ESPhotoSelectView.h"
#import "ESPhotoSelectCollectionViewCell.h"
#import "ESPhotoManager.h"
#import "ESAsset.h"
#import "ESBottomOptionView.h"
#import "ESPHAssetImageManager.h"
#import "ESPhotoCollectionViewCameraCell.h"

@interface ESPhotoSelectView () <UICollectionViewDelegate, UICollectionViewDataSource, ESPhotoSelectCollectionViewCellDelegate, ESBottomOptionViewDelegate>

@property(nonatomic,weak)UICollectionView* collectionView;

@property(nonatomic,weak)UICollectionViewFlowLayout* flowLayout;

@property(nonatomic,weak)ESBottomOptionView* bottomOptionView;

@property(nonatomic,strong)NSArray<ESAsset *>* assetArray;

@property(nonatomic,strong)NSMutableArray<ESAsset *>* selectedAssetArray;

@property(nonatomic,strong)NSMutableArray<UIImage *>* selectedImageArray;

@property(nonatomic,assign)NSInteger loadImageCount;

@property(nonatomic,assign)BOOL isSelectedOriginal;

@property(nonatomic,assign)BOOL loadingImage;

@end

@implementation ESPhotoSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCollectionVeiw];
        
        [self setupBottomOptionView];
        
        [self loadLocalPhotoData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLocalPhotoData) name:AuthorizationStatusSuccess object:nil];
    }
    return self;
}

- (void)setupCollectionVeiw {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout = flowLayout;
    self.flowLayout.minimumLineSpacing = 10;
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.itemSize = CGSizeMake(self.bounds.size.width / 3, self.bounds.size.height - 35);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 35) collectionViewLayout:flowLayout];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ESPhotoSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ESPhotoSelectCollectionViewCellId];
    [self.collectionView registerClass:[ESPhotoCollectionViewCameraCell class] forCellWithReuseIdentifier:ESPhotoCollectionViewCameraCellId];
}

- (void)setupBottomOptionView {
    CGFloat height = 35;
    CGFloat y = self.bounds.size.height - height;
    ESBottomOptionView *bottomOptionView = [[UINib nibWithNibName:@"ESBottomOptionView" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
    bottomOptionView.frame = CGRectMake(0, y, self.bounds.size.width, height);
    self.bottomOptionView = bottomOptionView;
    self.bottomOptionView.delegate = self;
    [self addSubview:bottomOptionView];
}

#pragma mark - init data
- (void)loadLocalPhotoData {
    __weak __typeof(self)weakSelf = self;
    [[ESPhotoManager sharedPhotoManager] getPHAssetArrayFromUserPhotoLibraryBydefaultWithSuccess:^(NSArray<PHAsset *> *PHAssetArray) {
        NSMutableArray *temArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < PHAssetArray.count; i++) {
            ESAsset *esAsset = [[ESAsset alloc] init];
            esAsset.asset = [PHAssetArray objectAtIndex:i];
            [temArray addObject:esAsset];
        }
        weakSelf.assetArray = temArray;
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetArray.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        ESPhotoCollectionViewCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ESPhotoCollectionViewCameraCellId forIndexPath:indexPath];
        return cell;
    }
    ESPhotoSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ESPhotoSelectCollectionViewCellId forIndexPath:indexPath];
    cell.delegate = self;
    cell.asset = [self assetArrayAtIndex:indexPath.item - 1];
    return cell;
}

- (ESAsset *)assetArrayAtIndex:(NSInteger)index {
    if (index >= self.assetArray.count && index < 0) {
        return nil;
    }
    return [self.assetArray objectAtIndex:index];
}

#pragma mark - ESPhotoSelectCollectionViewCellDelegate
- (void)ESPhotoSelectCollectionViewCell:(ESPhotoSelectCollectionViewCell *)cell PHAsset:(ESAsset *)asset {
    if (self.allowMutibleSelect) {
        if (asset.isSeleted) {
            [self.selectedAssetArray addObject:asset];
        }else {
            if ([self.selectedAssetArray containsObject:asset]) {
                [self.selectedAssetArray removeObject:asset];
            }
        }
    }else {
        if (asset.isSeleted) {
            if (self.selectedAssetArray.count > 0) {
                ESAsset *lastAsset = self.selectedAssetArray.lastObject;
                lastAsset.isSeleted = NO;
                [self.selectedAssetArray removeObject:lastAsset];
                [self.selectedAssetArray addObject:asset];
                [self.collectionView reloadData];
            }else {
                [self.selectedAssetArray addObject:asset];
            }
        }else {
            if ([self.selectedAssetArray containsObject:asset]) {
                [self.selectedAssetArray removeObject:asset];
            }
        }
    }
}

#pragma mark - ESBottomOptionViewDelegate
- (void)ESBottomOptionViewDidClickCompleteButton:(ESBottomOptionView *)view {
    if (self.loadingImage == YES) {
        return;
    }
    self.loadingImage = YES;
    if (self.isSelectedOriginal) {
        [self completeSelectOriginalImage];
    }else {
        [self completeSelectThumbnailImage];
    }
}

- (void)completeSelectOriginalImage {
    __weak __typeof(self)weakSelf = self;
    for (int i = 0; i < self.selectedAssetArray.count; i++) {
        ESAsset *asset = [self.selectedAssetArray objectAtIndex:i];
        [[ESPHAssetImageManager sharedManager] loadOriginalImageWithPHAsset:asset.asset success:^(UIImage *image) {
            weakSelf.loadImageCount += 1;
            [weakSelf.selectedImageArray addObject:image];
            if (weakSelf.loadImageCount >= weakSelf.selectedAssetArray.count) {
                [weakSelf.delegate ESPhotoSelectViewDidSelectedPictureWithImageArray:weakSelf.selectedImageArray];
                weakSelf.selectedImageArray = nil;
                weakSelf.loadImageCount = 0;
                self.loadingImage = NO;
            }
        } failure:^(NSError *error) {
            weakSelf.loadImageCount += 1;
            if (weakSelf.loadImageCount >= weakSelf.selectedAssetArray.count) {
                [weakSelf.delegate ESPhotoSelectViewDidSelectedPictureWithImageArray:weakSelf.selectedImageArray];
                weakSelf.selectedImageArray = nil;
                weakSelf.loadImageCount = 0;
                self.loadingImage = NO;
            }
        }];
    }
}

- (void)completeSelectThumbnailImage {
    __weak __typeof(self)weakSelf = self;
    for (int i = 0; i < self.selectedAssetArray.count; i++) {
        ESAsset *asset = [self.selectedAssetArray objectAtIndex:i];
        [[ESPHAssetImageManager sharedManager] loadImageWithPHAsset:asset.asset size:self.singlePhotoSize success:^(UIImage *image) {
            if (weakSelf.singlePhotoSize.width != 60 && weakSelf.singlePhotoSize.height != 40) {
                CGSize imageSize = image.size;
                if (imageSize.width == 60 && imageSize.height == 40) {
                    return ;
                }
            }
            weakSelf.loadImageCount += 1;
            [weakSelf.selectedImageArray addObject:image];
            if (weakSelf.loadImageCount >= weakSelf.selectedAssetArray.count) {
                [weakSelf.delegate ESPhotoSelectViewDidSelectedPictureWithImageArray:weakSelf.selectedImageArray];
                weakSelf.selectedImageArray = nil;
                weakSelf.loadImageCount = 0;
                self.loadingImage = NO;
            }
        } failure:^(NSError *error) {
            weakSelf.loadImageCount += 1;
            if (weakSelf.loadImageCount >= weakSelf.selectedAssetArray.count) {
                [weakSelf.delegate ESPhotoSelectViewDidSelectedPictureWithImageArray:weakSelf.selectedImageArray];
                weakSelf.selectedImageArray = nil;
                weakSelf.loadImageCount = 0;
                self.loadingImage = NO;
            }
        }];
    }
}

- (void)ESBottomOptionViewDidClickPhotoButton:(ESBottomOptionView *)view {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(ESPhotoSelectViewDidSelectedPhotoButton)]) {
            [self.delegate ESPhotoSelectViewDidSelectedPhotoButton];
        }
    }
}

- (void)ESBottomOptionViewDidClickEditButton:(ESBottomOptionView *)view {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(ESPhotoSelectViewDidSelectedEditWithImageArray:)]) {
            __weak __typeof(self)weakSelf = self;
            for (int i = 0; i < self.selectedAssetArray.count; i++) {
                ESAsset *asset = [self.selectedAssetArray objectAtIndex:i];
                [[ESPHAssetImageManager sharedManager] loadOriginalImageWithPHAsset:asset.asset success:^(UIImage *image) {
                    weakSelf.loadImageCount += 1;
                    [weakSelf.selectedImageArray addObject:image];
                    if (weakSelf.loadImageCount >= weakSelf.selectedAssetArray.count) {
                        [weakSelf.delegate ESPhotoSelectViewDidSelectedEditWithImageArray:weakSelf.selectedImageArray];
                        weakSelf.selectedImageArray = nil;
                        weakSelf.loadImageCount = 0;
                    }
                } failure:^(NSError *error) {
                    weakSelf.loadImageCount += 1;
                    if (weakSelf.loadImageCount >= weakSelf.selectedAssetArray.count) {
                        [weakSelf.delegate ESPhotoSelectViewDidSelectedEditWithImageArray:weakSelf.selectedImageArray];
                        weakSelf.selectedImageArray = nil;
                        weakSelf.loadImageCount = 0;
                    }
                }];
            }
        }
    }
}

- (void)ESBottomOptionViewDidClickOriginalButton:(ESBottomOptionView *)view state:(BOOL)isSelected {
    self.isSelectedOriginal = isSelected;
}

#pragma mark - setter && getter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.collectionView.frame = frame;
}

- (NSMutableArray *)selectedAssetArray {
    if (_selectedAssetArray == nil) {
        _selectedAssetArray = [NSMutableArray array];
    }
    return _selectedAssetArray;
}

- (CGSize)singlePhotoSize {
    if (_singlePhotoSize.height == 0 || _singlePhotoSize.width == 0) {
        _singlePhotoSize = CGSizeMake(1960, 1080);
    }
    return _singlePhotoSize;
}

- (NSMutableArray<UIImage *> *)selectedImageArray {
    if (_selectedImageArray == nil) {
        _selectedImageArray = [NSMutableArray array];
    }
    return _selectedImageArray;
}

@end
