//
//  ESPhotoAuthorizationStatusManager.m
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import "ESPhotoAuthorizationStatusManager.h"
#import <Photos/Photos.h>

@implementation ESPhotoAuthorizationStatusManager

+ (void)checkPhotoAuthorizationStatusSuccess:(void(^)())success failure:(void(^)(NSError *error))failure {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        success();
        return;
    }
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusNotDetermined:{
                NSError *error = [NSError errorWithDomain:@"ESPhotoAuthorizationStatusManager" code:PHAuthorizationStatusNotDetermined userInfo:@{NSLocalizedDescriptionKey:@"NotDetermined"}];
                failure(error);
            }
                break;
            case PHAuthorizationStatusRestricted:{
                NSError *error = [NSError errorWithDomain:@"ESPhotoAuthorizationStatusManager" code:PHAuthorizationStatusRestricted userInfo:@{NSLocalizedDescriptionKey:@"Restricted"}];
                failure(error);
            }
                break;
            case PHAuthorizationStatusDenied:{
                NSError *error = [NSError errorWithDomain:@"ESPhotoAuthorizationStatusManager" code:PHAuthorizationStatusRestricted userInfo:@{NSLocalizedDescriptionKey:@"Denied"}];
                failure(error);
            }
                break;
            case PHAuthorizationStatusAuthorized:
                success();
                break;
        }
    }];
}

@end
