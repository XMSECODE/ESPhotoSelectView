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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    ESPhotoSelectView *view = [[ESPhotoSelectView alloc] initWithFrame:CGRectMake(0, 20, screenSize.width, 200)];
    
    [self.view addSubview:view];
    
    view.allowMutibleSelect = YES;
    
    view.delegate = self;
    
}

#pragma mark - ESPhotoSelectViewDelegate
- (void)ESPhotoSelectViewDidSelectedPictureWithImageArray:(NSArray<UIImage *> *)imageArray {
    NSLog(@"imageArray = %@",imageArray);
}

@end
