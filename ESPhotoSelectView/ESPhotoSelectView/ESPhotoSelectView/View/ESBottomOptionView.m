//
//  ESBottomOptionView.m
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import "ESBottomOptionView.h"

@interface ESBottomOptionView ()

@property(nonatomic,assign)BOOL isSelected;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSeparatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSeparatorView;

@end

@implementation ESBottomOptionView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bottomSeparatorView.constant = 1 / ([UIScreen mainScreen].scale);
    self.topSeparatorView.constant = 1 / ([UIScreen mainScreen].scale);
}

#pragma mark - Action
- (IBAction)didClickCompleteButton:(id)sender {
    if (self.delegate) {
        [self.delegate ESBottomOptionViewDidClickCompleteButton:self];
    }
}

- (IBAction)didClickPhotoButton:(id)sender {
    if (self.delegate) {
        [self.delegate ESBottomOptionViewDidClickPhotoButton:self];
    }
}

- (IBAction)didClickEditButton:(id)sender {
    if (self.delegate) {
        [self.delegate ESBottomOptionViewDidClickEditButton:self];
    }
}

- (IBAction)didClickOriginalButton:(UIButton *)sender {
    self.isSelected = !self.isSelected;
    self.selectedImageView.hidden = !self.isSelected;
    if (self.delegate) {
        [self.delegate ESBottomOptionViewDidClickOriginalButton:self state:self.isSelected];
    }
}

@end
