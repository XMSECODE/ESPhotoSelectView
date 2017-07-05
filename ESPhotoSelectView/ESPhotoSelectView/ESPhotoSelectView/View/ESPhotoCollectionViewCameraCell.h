//
//  ESPhotoCollectionViewCameraCell.h
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/3.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ESPhotoCollectionViewCameraCellDelegate <NSObject>

- (void)getImageFromeCamera:(UIImage *)image;

@end

static NSString *ESPhotoCollectionViewCameraCellId = @"ESPhotoCollectionViewCameraCellId";

@interface ESPhotoCollectionViewCameraCell : UICollectionViewCell

@property(nonatomic,weak)id<ESPhotoCollectionViewCameraCellDelegate> delegate;

@end
