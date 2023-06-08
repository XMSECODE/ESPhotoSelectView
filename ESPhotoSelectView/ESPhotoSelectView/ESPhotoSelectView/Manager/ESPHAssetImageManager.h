//
//  ESPHAssetImageManager.h
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ESPHAssetImageManager : NSObject

+ (instancetype)sharedManager;

- (void)loadOriginalImageWithPHAsset:(PHAsset *)asset imageView:(UIImageView *)imageView;

- (void)loadImageWithPHAsset:(PHAsset *)asset imageView:(UIImageView *)imageView size:(CGSize)size;

- (void)loadOriginalImageWithPHAsset:(PHAsset *)asset success:(void(^)(UIImage *image))success failure:(void(^)(NSError *error))failure;

- (void)loadImageWithPHAsset:(PHAsset *)asset size:(CGSize)size success:(void(^)(UIImage *image))success failure:(void(^)(NSError *error))failure;


@end
