//
//  ESPhotoSelectCollectionViewCell.h
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ESAsset.h"

@class ESPhotoSelectCollectionViewCell;

static NSString *ESPhotoSelectCollectionViewCellId = @"ESPhotoSelectCollectionViewCellId";

@protocol ESPhotoSelectCollectionViewCellDelegate <NSObject>

- (void)ESPhotoSelectCollectionViewCell:(ESPhotoSelectCollectionViewCell *)cell PHAsset:(ESAsset *)asset;

@end

@interface ESPhotoSelectCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)ESAsset* asset;

@property(nonatomic,weak)id<ESPhotoSelectCollectionViewCellDelegate> delegate;

@end
