//
//  ESPhotoCollectionViewCameraCell.m
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/3.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import "ESPhotoCollectionViewCameraCell.h"
#import <AVFoundation/AVFoundation.h>

@interface ESPhotoCollectionViewCameraCell ()

@property(nonatomic,strong)AVCaptureSession* captureSession;

@end

@implementation ESPhotoCollectionViewCameraCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self RealTimeScanning];
    }
    return self;
}

-(void)RealTimeScanning{
    
    AVCaptureDevice* video = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError* error;
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:video error:&error];
    if (error) {
        NSLog(@"创建输入端失败,%@",error);
        return;
    }
    
    self.captureSession = [[AVCaptureSession alloc] init];
    
    if (![self.captureSession canAddInput:input]) {
        NSLog(@"输入端添加失败");
        return;
    }
    [self.captureSession addInput:input];
    
    AVCaptureVideoPreviewLayer* layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    layer.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:layer];
    
    [self.captureSession startRunning];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
}

@end
