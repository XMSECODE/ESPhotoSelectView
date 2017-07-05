//
//  ESPhotoManager.m
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import "ESPhotoManager.h"
#import "ESPhotoAuthorizationStatusManager.h"


@interface ESPhotoManager ()

/**
 磁盘操作队列
 */
@property(nonatomic,strong)NSOperationQueue* operationQueue;

@property(nonatomic,strong)PHFetchResult* fetchResult;

@property(nonatomic,copy)void(^success)(NSArray* imageArray);

@property(nonatomic,strong)NSMutableArray* PHAssetInfoModelArray;

@property(nonatomic,strong)NSMutableArray<PHAsset *>* PHAssetArray;

@end


static ESPhotoManager* staticESPhotoManager;


@implementation ESPhotoManager

+ (instancetype)sharedPhotoManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticESPhotoManager = [[ESPhotoManager alloc] init];
        
        [ESPhotoAuthorizationStatusManager checkPhotoAuthorizationStatusSuccess:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:AuthorizationStatusSuccess object:nil];
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    });
    return staticESPhotoManager;
}

- (void)getPHAssetArrayFromUserPhotoLibraryBydefaultWithSuccess:(void(^)(NSArray<PHAsset *> *PHAssetArray))success failure:(void(^)(NSError* error))failure {
    //获取相册
    PHFetchOptions* option = [[PHFetchOptions alloc] init];
    PHFetchResult* result = [PHAsset fetchAssetsWithOptions:option];
    self.success = success;
    self.fetchResult = result;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        __weak typeof(self)weakSelf = self;
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset* asset = (PHAsset *)obj;
            if (asset.mediaType == PHAssetMediaTypeImage) {
                [weakSelf.PHAssetArray addObject:asset];
                if (weakSelf.PHAssetArray.count >= [weakSelf.fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage]) {
                    NSMutableArray* PHAssetArray = weakSelf.PHAssetArray;
                    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
                    NSArray *phAssetArray = [PHAssetArray sortedArrayUsingDescriptors:@[sortDescriptor]];
                    weakSelf.PHAssetArray = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(phAssetArray);
                        return ;
                    });
                }
            }
        }];
    });
}

-(NSOperationQueue *)operationQueue{
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}

-(NSMutableArray *)PHAssetInfoModelArray{
    if (_PHAssetInfoModelArray == nil) {
        _PHAssetInfoModelArray = [[NSMutableArray alloc] init];
    }
    return _PHAssetInfoModelArray;
}

-(NSMutableArray<PHAsset *> *)PHAssetArray{
    if (_PHAssetArray == nil) {
        _PHAssetArray = [[NSMutableArray alloc] init];
    }
    return _PHAssetArray;
}

@end
