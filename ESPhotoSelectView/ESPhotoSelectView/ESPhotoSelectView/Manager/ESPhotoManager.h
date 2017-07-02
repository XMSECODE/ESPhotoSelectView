//
//  ESPhotoManager.h
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

static NSString *AuthorizationStatusSuccess = @"AuthorizationStatusSuccess";

@interface ESPhotoManager : NSObject

+ (instancetype)sharedPhotoManager;

- (void)getPHAssetArrayFromUserPhotoLibraryBydefaultWithSuccess:(void(^)(NSArray<PHAsset *> *PHAssetArray))success failure:(void(^)(NSError* error))failure;

@end
