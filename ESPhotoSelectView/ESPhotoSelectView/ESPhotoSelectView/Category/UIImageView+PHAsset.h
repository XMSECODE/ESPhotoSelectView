//
//  UIImageView+PHAsset.h
//  photosFrame
//
//  Created by XiangMIngsheng on 2017/1/11.
//  Copyright © 2017年 xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface UIImageView (PHAsset)

/**
 加载原图
 */
- (void)PHAsset:(PHAsset *)asset placeholderImage:(UIImage *)placeholderImage;

/**
 加载指定大小的缩略图
 */
- (void)PHASSET:(PHAsset *)asset placeholderImage:(UIImage *)placeholderImage andSize:(CGSize)size;

@end
