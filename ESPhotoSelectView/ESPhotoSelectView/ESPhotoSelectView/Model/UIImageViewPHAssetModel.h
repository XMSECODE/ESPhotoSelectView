//
//  UIImageViewPHAssetModel.h
//  photosFrame
//
//  Created by XiangMIngsheng on 2017/1/11.
//  Copyright © 2017年 xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageViewPHAssetModel : NSObject

@property(nonatomic,weak)UIImageView* imageView;

@property(nonatomic,copy)NSString* PHAssetLocalIdentifier;

@end
