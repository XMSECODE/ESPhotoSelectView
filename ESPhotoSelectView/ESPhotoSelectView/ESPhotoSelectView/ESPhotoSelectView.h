//
//  ESPhotoSelectView.h
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ESPhotoSelectViewDelegate <NSObject>

- (void)ESPhotoSelectViewDidSelectedPitureWithImageArray:(NSArray<UIImage *> *)imageArray;

@end

@interface ESPhotoSelectView : UIView

@property(nonatomic,assign)CGSize singlePhotoSize;

@property(nonatomic,weak)id<ESPhotoSelectViewDelegate> delegate;

@end
