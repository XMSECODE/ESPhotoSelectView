//
//  ESPhotoCollectionViewCameraCell.m
//  ESPhotoSelectView
//
//  Created by xiangmingsheng on 2017/7/3.
//  Copyright © 2017年 XMSECODE. All rights reserved.
//

#import "ESPhotoCollectionViewCameraCell.h"
#import <AVFoundation/AVFoundation.h>

@interface ESPhotoCollectionViewCameraCell () <AVCapturePhotoCaptureDelegate>

@property(nonatomic,strong)AVCaptureSession* captureSession;

@property(nonatomic,weak)UIButton* takePhotoButton;

@property(nonatomic,strong)AVCapturePhotoOutput* photoOutput;

@end

@implementation ESPhotoCollectionViewCameraCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self RealTimeScanning];
        
        UIButton *button = [[UIButton alloc] init];
        [self addSubview:button];
        [button addTarget:self action:@selector(didClickTakePhotoButton) forControlEvents:UIControlEventTouchUpInside];
        button.frame = frame;
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
    [self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    
    if (![self.captureSession canAddInput:input]) {
        NSLog(@"输入端添加失败");
        return;
    }
    [self.captureSession addInput:input];
    
    AVCaptureVideoPreviewLayer* layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    layer.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:layer];
    
    AVCapturePhotoOutput * photoOutput = [[AVCapturePhotoOutput alloc] init];
    if ([self.captureSession canAddOutput:photoOutput]) {
        [self.captureSession addOutput:photoOutput];
        self.photoOutput = photoOutput;
    }
    
    
    [self.captureSession startRunning];
    
}

- (void)didClickTakePhotoButton {

    AVCapturePhotoSettings * photoSetting = [AVCapturePhotoSettings photoSettings];
    [self.photoOutput capturePhotoWithSettings:photoSetting delegate:self];}

#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput willBeginCaptureForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings {
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput willCapturePhotoForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings {

}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didCapturePhotoForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings {
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    if (self.delegate) {
        [self.delegate getImageFromeCamera:image];
    }
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingRawPhotoSampleBuffer:(nullable CMSampleBufferRef)rawSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishRecordingLivePhotoMovieForEventualFileAtURL:(NSURL *)outputFileURL resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings {
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingLivePhotoToMovieFileAtURL:(NSURL *)outputFileURL duration:(CMTime)duration photoDisplayTime:(CMTime)photoDisplayTime resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings error:(nullable NSError *)error {
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishCaptureForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings error:(nullable NSError *)error {
    
}


@end
