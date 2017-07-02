//
//  ESAsset.h
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import <Photos/Photos.h>

@interface ESAsset : NSObject

@property(nonatomic,assign)BOOL isSeleted;

@property(nonatomic,strong)PHAsset* asset;

@end
