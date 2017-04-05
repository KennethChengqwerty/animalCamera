//
//  ViewController.m
//  AnimalCamera
//
//  Created by Kenneth Cheng on 05/04/2017.
//  Copyright © 2017 Kenneth Cheng. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet GPUImageView *liveView;
@property (weak, nonatomic) IBOutlet UIView *controlView;

//gpuimage
@property(nonatomic,strong) GPUImageVideoCamera *camera;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

-(void)setup{

    _camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    _camera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    [_camera addTarget:self.liveView];
    [_camera startCameraCapture];
    
}





@end
