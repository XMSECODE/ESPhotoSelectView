//
//  ESPhotoSelectCollectionViewCell.m
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import "ESPhotoSelectCollectionViewCell.h"
#import "UIImageView+PHAsset.h"

static NSString *ESPhotoSelectCollectionViewCellDidSelectedNotificationName = @"ESPhotoSelectCollectionViewCellDidSelectedNotificationName";

@interface ESPhotoSelectCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation ESPhotoSelectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setState) name:ESPhotoSelectCollectionViewCellDidSelectedNotificationName object:nil];
    
}

- (void)setAsset:(ESAsset *)asset {
    _asset = asset;
    CGFloat scale = [UIScreen mainScreen].scale;
    [self.imageView PHASSET:asset.asset placeholderImage:[UIImage new] andSize:CGSizeMake(self.bounds.size.width * scale, self.bounds.size.height * scale)];
    
    if (asset.isSeleted) {
        [self.selectButton setImage:[UIImage imageNamed:@"photo_sel_photoPicker"] forState:UIControlStateNormal];
    }else {
        [self.selectButton setImage:[UIImage imageNamed:@"photo_def_photoPicker"] forState:UIControlStateNormal];
    }
}

- (void)setState {
    if (self.asset.isSeleted) {
        [self.selectButton setImage:[UIImage imageNamed:@"photo_sel_photoPicker"] forState:UIControlStateNormal];
    }else {
        [self.selectButton setImage:[UIImage imageNamed:@"photo_def_photoPicker"] forState:UIControlStateNormal];
    }
}

#pragma mark - Action
- (IBAction)didClickSelectButton:(id)sender {
    self.asset.isSeleted = !self.asset.isSeleted;

    if (self.delegate) {
        [self.delegate ESPhotoSelectCollectionViewCell:self PHAsset:self.asset];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ESPhotoSelectCollectionViewCellDidSelectedNotificationName object:nil];
}

@end
