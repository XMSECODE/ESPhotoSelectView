//
//  UIImageView+PHAsset.m
//  photosFrame
//
//  Created by XiangMIngsheng on 2017/1/11.
//  Copyright © 2017年 xiang. All rights reserved.
//

#import "UIImageView+PHAsset.h"
#import "ESPHAssetImageManager.h"

@implementation UIImageView (PHAsset)

- (void)PHAsset:(PHAsset *)asset placeholderImage:(UIImage *)placeholderImage {

    if (placeholderImage == nil) {
        self.image = [[UIImage alloc] init];
    }else {
        self.image = placeholderImage;
    }
    [[ESPHAssetImageManager sharedManager] loadOriginalImageWithPHAsset:asset imageView:self];
    
}

- (void)PHASSET:(PHAsset *)asset placeholderImage:(UIImage *)placeholderImage andSize:(CGSize)size {
    if (placeholderImage == nil) {
        self.image = [[UIImage alloc] init];
    }else {
        self.image = placeholderImage;
    }
    [[ESPHAssetImageManager sharedManager] loadImageWithPHAsset:asset imageView:self size:size];
}

@end
