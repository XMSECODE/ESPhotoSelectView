//
//  ESPHAssetImageManager.m
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import "ESPHAssetImageManager.h"
#import "UIImageViewPHAssetModel.h"

@interface ESPHAssetImageManager ()

/**
 *  下载的队列
 */
@property (nonatomic,strong) NSOperationQueue *queue;

/**
 *  使用字典来缓存图片,一个图片地址对应一张图片,key = 图片地址, value = 图片内容
 */
@property (nonatomic,strong) NSMutableDictionary *cacheImages;

/**
 *  保存正在下载的操作, key = 图片地址, value = 下载图片的操作
 */
@property (nonatomic,strong) NSMutableDictionary *cacheOperation;

@property(nonatomic,strong)NSMutableArray<UIImageViewPHAssetModel *>* cachePHAssetModelArray;

@end

static ESPHAssetImageManager *staticESPHAssetImageManager;

@implementation ESPHAssetImageManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticESPHAssetImageManager = [[ESPHAssetImageManager alloc] init];
    });
    return staticESPHAssetImageManager;
}

- (void)loadOriginalImageWithPHAsset:(PHAsset *)asset imageView:(UIImageView *)imageView {
    UIImageViewPHAssetModel* model = [[UIImageViewPHAssetModel alloc] init];
    model.imageView = imageView;
    model.PHAssetLocalIdentifier = asset.localIdentifier;
    [self.cachePHAssetModelArray addObject:model];
    
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage* image = [UIImage imageWithData:imageData];
        model.imageView.image = image;
        [self.cachePHAssetModelArray removeObject:model];
    }];
}

- (void)loadImageWithPHAsset:(PHAsset *)asset imageView:(UIImageView *)imageView size:(CGSize)size {
    UIImageViewPHAssetModel* model = [[UIImageViewPHAssetModel alloc] init];
    model.imageView = imageView;
    model.PHAssetLocalIdentifier = asset.localIdentifier;
    [self.cachePHAssetModelArray addObject:model];
    PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        model.imageView.image = result;
        [self.cachePHAssetModelArray removeObject:model];
    }];
}

- (void)loadOriginalImageWithPHAsset:(PHAsset *)asset success:(void(^)(UIImage *image))success failure:(void(^)(NSError *error))failure {
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage* image = [UIImage imageWithData:imageData];
        if (image) {
            success(image);
        }else {
            NSError *error = [NSError errorWithDomain:@"ESPHAssetImageManager" code:-1 userInfo:@{}];
            failure(error);
        }
    }];
}

- (void)loadImageWithPHAsset:(PHAsset *)asset size:(CGSize)size success:(void(^)(UIImage *image))success failure:(void(^)(NSError *error))failure {
    PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            success(result);
        }else {
            NSError *error = [NSError errorWithDomain:@"ESPHAssetImageManager" code:-1 userInfo:@{}];
            failure(error);
        }
    }];
}

#pragma mark - setter & getter
-(NSMutableArray<UIImageViewPHAssetModel *> *)cachePHAssetModelArray{
    if (_cachePHAssetModelArray == nil) {
        _cachePHAssetModelArray = [[NSMutableArray alloc] init];
    }
    return _cachePHAssetModelArray;
}

@end
