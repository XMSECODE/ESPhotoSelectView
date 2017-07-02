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

@interface ESPhotoSelectView () <UICollectionViewDelegate, UICollectionViewDataSource, ESPhotoSelectCollectionViewCellDelegate, ESBottomOptionViewDelegate>

@property(nonatomic,weak)UICollectionView* collectionView;

@property(nonatomic,weak)UICollectionViewFlowLayout* flowLayout;

@property(nonatomic,weak)ESBottomOptionView* bottomOptionView;

@property(nonatomic,strong)NSArray<ESAsset *>* assetArray;

@property(nonatomic,strong)NSMutableArray<ESAsset *>* selectedAssetArray;

@property(nonatomic,strong)NSMutableArray<UIImage *>* selectedImageArray;

@property(nonatomic,assign)NSInteger loadImageCount;

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
    self.flowLayout.itemSize = CGSizeMake(self.bounds.size.width / 3, self.bounds.size.height - 30);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 30) collectionViewLayout:flowLayout];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ESPhotoSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ESPhotoSelectCollectionViewCellId];
}

- (void)setupBottomOptionView {
    CGFloat y = self.bounds.size.height - 30;
    ESBottomOptionView *bottomOptionView = [[UINib nibWithNibName:@"ESBottomOptionView" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
    bottomOptionView.frame = CGRectMake(0, y, self.bounds.size.width, 30);
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
    return self.assetArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ESPhotoSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ESPhotoSelectCollectionViewCellId forIndexPath:indexPath];
    cell.delegate = self;
    cell.asset = [self assetArrayAtIndex:indexPath.item];
    return cell;
}

- (ESAsset *)assetArrayAtIndex:(NSInteger)index {
    if (index >= self.assetArray.count) {
        return nil;
    }
    return [self.assetArray objectAtIndex:index];
}

#pragma mark - ESPhotoSelectCollectionViewCellDelegate
- (void)ESPhotoSelectCollectionViewCell:(ESPhotoSelectCollectionViewCell *)cell PHAsset:(ESAsset *)asset {
    if (asset.isSeleted) {
        [self.selectedAssetArray addObject:asset];
    }else {
        if ([self.selectedAssetArray containsObject:asset]) {
            [self.selectedAssetArray removeObject:asset];
        }
    }
}

#pragma mark - ESBottomOptionViewDelegate
- (void)ESBottomOptionViewDidClickCompleteButton:(ESBottomOptionView *)view {
    __weak __typeof(self)weakSelf = self;
    for (int i = 0; i < self.selectedAssetArray.count; i++) {
        ESAsset *asset = [self.selectedAssetArray objectAtIndex:i];
        [[ESPHAssetImageManager sharedManager] loadOriginalImageWithPHAsset:asset.asset success:^(UIImage *image) {
            weakSelf.loadImageCount += 1;
            [weakSelf.selectedImageArray addObject:image];
            if (weakSelf.loadImageCount >= weakSelf.selectedAssetArray.count) {
                [weakSelf.delegate ESPhotoSelectViewDidSelectedPitureWithImageArray:weakSelf.selectedImageArray];
                weakSelf.selectedImageArray = nil;
                weakSelf.loadImageCount = 0;
            }
        } failure:^(NSError *error) {
            weakSelf.loadImageCount += 1;
            if (weakSelf.loadImageCount >= weakSelf.selectedAssetArray.count) {
                [weakSelf.delegate ESPhotoSelectViewDidSelectedPitureWithImageArray:weakSelf.selectedImageArray];
                weakSelf.selectedImageArray = nil;
                weakSelf.loadImageCount = 0;
            }
        }];
    }
}

#pragma mark - setter && getter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.collectionView.frame = frame;
}

- (void)setSinglePhotoSize:(CGSize)singlePhotoSize {
    _singlePhotoSize = singlePhotoSize;
    self.flowLayout.itemSize = singlePhotoSize;
}

- (NSMutableArray *)selectedAssetArray {
    if (_selectedAssetArray == nil) {
        _selectedAssetArray = [NSMutableArray array];
    }
    return _selectedAssetArray;
}

- (NSMutableArray<UIImage *> *)selectedImageArray {
    if (_selectedImageArray == nil) {
        _selectedImageArray = [NSMutableArray array];
    }
    return _selectedImageArray;
}

@end
