//
//  ViewController.m
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/1.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import "ViewController.h"
#import "ESPhotoSelectView.h"

@interface ViewController () <ESPhotoSelectViewDelegate>

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

- (void)setupUI {
    [self setPhotoSelectView];
    [self setImageView];
}

- (void)setPhotoSelectView {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    ESPhotoSelectView *view = [[ESPhotoSelectView alloc] initWithFrame:CGRectMake(0, 20, screenSize.width, 200)];
    
    [self.view addSubview:view];
    
    view.allowMutibleSelect = YES;
    
    view.delegate = self;
}

- (void)setImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [self.view addSubview:imageView];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.imageView.frame = CGRectMake(0, 250, screenSize.width, screenSize.height - 300);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - ESPhotoSelectViewDelegate
- (void)ESPhotoSelectViewDidSelectedPictureWithImageArray:(NSArray<UIImage *> *)imageArray {
    NSLog(@"imageArray = %@",imageArray);
    self.imageView.image = imageArray.firstObject;
}



@end
