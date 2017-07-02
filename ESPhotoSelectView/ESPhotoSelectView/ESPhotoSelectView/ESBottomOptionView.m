//
//  ESBottomOptionView.m
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import "ESBottomOptionView.h"

@implementation ESBottomOptionView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
}
- (IBAction)didClickCompleteButton:(id)sender {
    if (self.delegate) {
        [self.delegate ESBottomOptionViewDidClickCompleteButton:self];
    }
}

@end
