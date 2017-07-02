//
//  ESPHAssetInfoModel.m
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import "ESPHAssetInfoModel.h"

@implementation ESPHAssetInfoModel

+ (instancetype)PHAssetInfoModelWithDictionary:(NSDictionary *)dictionary {
    ESPHAssetInfoModel* assetInfoModel = [[ESPHAssetInfoModel alloc] init];
    [assetInfoModel setValuesForKeysWithDictionary:dictionary];
    assetInfoModel.PHImageFileURLString = assetInfoModel.PHImageFileURLKey.absoluteString;
    return assetInfoModel;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

+ (NSArray<ESPHAssetInfoModel *> *)PHAssetInfoModelArrayWithDictionaryArray:(NSArray<NSDictionary *> *)dictionaryArray {
    NSMutableArray* modelArray = [NSMutableArray array];
    for (NSDictionary* dictionary in dictionaryArray) {
        ESPHAssetInfoModel* assetInfoModel = [[ESPHAssetInfoModel alloc] init];
        [assetInfoModel setValuesForKeysWithDictionary:dictionary];
        [modelArray addObject:assetInfoModel];
    }
    return modelArray;
}

- (NSDictionary *)dictionaryWitPHAssetInfoModel {
    NSDictionary* dict = [self dictionaryWithValuesForKeys:@[@"PHImageFileSandboxExtensionTokenKey",
                                                             @"PHImageFileURLString",
                                                             @"PHImageResultDeliveredImageFormatKey",
                                                             @"PHImageResultIsDegradedKey",
                                                             @"PHImageResultIsInCloudKey",
                                                             @"PHImageResultIsPlaceholderKey",
                                                             @"PHImageResultOptimizedForSharing",
                                                             @"PHImageResultRequestIDKey",
                                                             @"PHImageResultWantedImageFormatKey"
                                                             ]];
    return dict;
}

+ (NSArray<NSDictionary *> *)arrayDictionaryWithPHAssetInfoModelArray:(NSArray<ESPHAssetInfoModel *> *)ModelArray {
    NSMutableArray* array = [NSMutableArray array];
    for (ESPHAssetInfoModel* model in ModelArray) {
        [array addObject:[model dictionaryWitPHAssetInfoModel]];
    }
    return array;
}

@end
