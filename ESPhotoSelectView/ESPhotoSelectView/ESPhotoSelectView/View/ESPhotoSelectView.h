//
//  ESPhotoSelectView.h
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ESPhotoSelectViewDelegate <NSObject>

- (void)ESPhotoSelectViewDidSelectedPictureWithImageArray:(NSArray<UIImage *> *)imageArray;

@optional
- (void)ESPhotoSelectViewDidSelectedPhotoButton;

- (void)ESPhotoSelectViewDidSelectedEditWithImageArray:(NSArray<UIImage *> *)imageArray;

- (void)ESPhotoSelectViewDidSelectedOriginalPictureWithImageArray:(NSArray<UIImage *> *)imageArray;

@end

@interface ESPhotoSelectView : UIView

@property(nonatomic,assign)CGSize singlePhotoSize;

@property(nonatomic,assign)BOOL allowMutibleSelect;

@property(nonatomic,weak)id<ESPhotoSelectViewDelegate> delegate;

@end
