//
//  ViewController.m
//  AnimalCamera
//
//  Created by Kenneth Cheng on 05/04/2017.
//  Copyright © 2017 Kenneth Cheng. All rights reserved.
//

#import "MainViewController.h"
#import <GPUImage.h>
#import <Masonry.h>
#import "GPUImageBeautifyFilter.h"
#import "KCControlView.h"

#define cameraW 480
#define cameraH 640

@interface MainViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) GPUImageView *cameraView;
@property (weak, nonatomic) KCControlView *controlView;

//@property (weak, nonatomic) UIImageView *animalFaceView;

@property (strong, nonatomic) AVCaptureMetadataOutput *metadataOutput;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

//gpuimage
@property(nonatomic,strong) GPUImageVideoCamera *camera;

@end

@implementation MainViewController{
    //保存脸部数据
NSMutableDictionary *_facesDictionory;
}

- (void)viewDidLoad {
    _facesDictionory = [NSMutableDictionary dictionary];
    
    [super viewDidLoad];
    [self setupView];
    [self setupCamera];
}

- (CALayer *)faceLayerWithFaceID:(NSInteger)faceID {
    CALayer *faceLayer = _facesDictionory[@(faceID)];
    if(!faceLayer) {
        faceLayer = [CALayer new];
        faceLayer.borderWidth = 2.0;
        faceLayer.borderColor = [UIColor redColor].CGColor;
        [_facesDictionory setObject:faceLayer forKey:@(faceID)];
        [self.previewLayer addSublayer:faceLayer];
    }
    return faceLayer;
}

-(void)setupView{
    GPUImageView *cameraView = [[GPUImageView alloc] init];
    _cameraView = cameraView;
    [self.view addSubview:cameraView];
    
    KCControlView *controlView = [[KCControlView alloc] init];
    _controlView = controlView;
    [self.view addSubview:controlView];
    
    
    float scale = cameraH*1.0/cameraW;
    float viewW = self.view.frame.size.width;
    float viewH = scale * viewW;
    //layout
    [cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(viewH);
        make.width.equalTo(self.view);
    }];
   
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.view.frame.size.height-viewH);
        make.left.right.bottom.equalTo(self.view);
    }];
    
//    UIImageView *animalFaceView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    _animalFaceView = animalFaceView;
//    animalFaceView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:animalFaceView];
}

-(void)setupCamera{

    _camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    _camera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    //filter-beautyface
    GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    [_camera addTarget:beautifyFilter];
    
    //face-detection
    self.metadataOutput = [AVCaptureMetadataOutput new];
    if([_camera.captureSession canAddOutput:self.metadataOutput]) {
        [_camera.captureSession addOutput:self.metadataOutput];
        
        self.metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
        [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_global_queue(0, 0)];
    }
    
    [beautifyFilter addTarget:self.cameraView];
    
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_camera.captureSession];
    ;
    self.previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    
    [_camera startCameraCapture];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate -
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    for (NSNumber *faceID in _facesDictionory) {
        CALayer *faceLayer = _facesDictionory[faceID];
        faceLayer.hidden = YES;
    }
    
    
    // 解析识别对象
    for (AVMetadataObject *metadaObject in metadataObjects) {
        
        AVMetadataFaceObject * faceObjcet = (AVMetadataFaceObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:metadaObject];
        
        
        
        
//        NSLog(@"%@",NSStringFromCGRect(metadaObject.bounds));
        dispatch_async(dispatch_get_main_queue(), ^{
            CALayer *faceLayer = [self faceLayerWithFaceID:faceObjcet.faceID];
            faceLayer.frame = faceObjcet.bounds;
            faceLayer.hidden = NO;
        });
 
    }
    
    
}





@end
