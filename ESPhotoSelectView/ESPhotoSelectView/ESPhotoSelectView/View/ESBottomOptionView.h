//
//  ESBottomOptionView.h
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ESBottomOptionView;

@protocol ESBottomOptionViewDelegate <NSObject>

- (void)ESBottomOptionViewDidClickCompleteButton:(ESBottomOptionView *)view;

- (void)ESBottomOptionViewDidClickPhotoButton:(ESBottomOptionView *)view;

- (void)ESBottomOptionViewDidClickEditButton:(ESBottomOptionView *)view;

- (void)ESBottomOptionViewDidClickOriginalButton:(ESBottomOptionView *)view state:(BOOL)isSelected;

@end

@interface ESBottomOptionView : UIView

@property(nonatomic,weak)id<ESBottomOptionViewDelegate> delegate;

@end
