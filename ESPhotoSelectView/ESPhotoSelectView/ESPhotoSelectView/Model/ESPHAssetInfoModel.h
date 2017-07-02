//
//  ESPHAssetInfoModel.h
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESPHAssetInfoModel : NSObject

@property(nonatomic,copy)NSString* PHImageFileSandboxExtensionTokenKey;

@property(nonatomic,strong)NSURL* PHImageFileURLKey;

@property(nonatomic,copy)NSString* PHImageFileURLString;

@property(nonatomic,assign)NSInteger PHImageResultDeliveredImageFormatKey;

@property(nonatomic,assign)NSInteger PHImageResultIsDegradedKey;

@property(nonatomic,assign)NSInteger PHImageResultIsInCloudKey;

@property(nonatomic,assign)NSInteger PHImageResultIsPlaceholderKey;

@property(nonatomic,assign)NSInteger PHImageResultOptimizedForSharing;

@property(nonatomic,assign)NSInteger PHImageResultRequestIDKey;

@property(nonatomic,assign)NSInteger PHImageResultWantedImageFormatKey;

+ (instancetype)PHAssetInfoModelWithDictionary:(NSDictionary *)dictionary;

+ (NSArray<ESPHAssetInfoModel *> *)PHAssetInfoModelArrayWithDictionaryArray:(NSArray<NSDictionary *> *)dictionaryArray;

- (NSDictionary *)dictionaryWitPHAssetInfoModel;

+ (NSArray<NSDictionary *> *)arrayDictionaryWithPHAssetInfoModelArray:(NSArray<ESPHAssetInfoModel *> *)ModelArray;

@end
