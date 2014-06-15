//
//  BrianMainViewController.m
//  MagicalTools
//
//  Created by 陆 文杰 on 14-4-26.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import "BrianMainViewController.h"
#import "BrianPayCountViewController.h"
#import "BrianScanViewController.h"
#import "BrianExchangeViewController.h"

@interface BrianMainViewController ()

@end

@implementation BrianMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoPayCount:(id)sender {
    BrianPayCountViewController* payCount = [[BrianPayCountViewController alloc] initWithNibName:@"BrianPayCountViewController" bundle:nil];
    
    [self.navigationController pushViewController:payCount animated:YES];
}

- (IBAction)gotoScan:(id)sender {
    BrianScanViewController* scanVC = [[BrianScanViewController alloc] initWithNibName:@"BrianScanViewController" bundle:nil];
    
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (IBAction)gotoLight:(id)sender {
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
//    if (!lightOn) {
//        lightOn = YES;
        if (device.torchMode == AVCaptureTorchModeOff) {
            //Create an AV session
//            AVCaptureSession * session = [[AVCaptureSession alloc]init];
//            
//            // Create device input and add to current session
//            AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//            [session addInput:input];
//            
//            // Create video output and add to current session
//            AVCaptureVideoDataOutput * output = [[AVCaptureVideoDataOutput alloc]init];
//            [session addOutput:output];
//            
//            // Start session configuration
//            [session beginConfiguration];
            if ([device lockForConfiguration:nil]) {
                // Set torch to on
                [device setTorchMode:AVCaptureTorchModeOn];
                [device unlockForConfiguration];
            }
            
//            [session commitConfiguration];
//            
//            // Start the session
//            [session startRunning];
            
            // Keep the session around
//            AVSession = session;
        }
//    }
    else{
        lightOn = NO;
        
        if ([device lockForConfiguration:nil]) {
            [device setTorchMode:AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
        
//        [AVSession stopRunning];
    }
}

- (IBAction)gotoExchange:(id)sender {
    BrianExchangeViewController* exchangeVC = [[BrianExchangeViewController alloc] initWithNibName:@"BrianExchangeViewController" bundle:nil];
    
    [self.navigationController pushViewController:exchangeVC animated:YES];
}

@end
