//
//  ESPhotoAuthorizationStatusManager.h
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESPhotoAuthorizationStatusManager : NSObject

+ (void)checkPhotoAuthorizationStatusSuccess:(void(^)())success failure:(void(^)(NSError *error))failure;

@end
