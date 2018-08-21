//
//  CheckAuthorizationTool.m
//  CheckAuthorization
//
//  Created by Rainy on 2017/12/18.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "CheckAuthorizationTool.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>

@implementation CheckAuthorizationTool

+ (void)checkAudioAuthorizationGrand:(void (^)(void))permissionGranted
                    withNoPermission:(void (^)(void))noPermission
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (videoAuthStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                granted ? permissionGranted() : noPermission();
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            permissionGranted();
            break;
        }
        case AVAuthorizationStatusRestricted:
            NSLog(@"不能完成授权，可能开启了访问限制");
            noPermission();
        case AVAuthorizationStatusDenied:{
            NSLog(@"请到设置授权访问麦克风");
            noPermission();
        }
            break;
        default:
            break;
    }
}

+ (void)checkCameraAuthorizationGrand:(void (^)(void))permissionGranted
                     withNoPermission:(void (^)(void))noPermission
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (videoAuthStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                granted ? permissionGranted() : noPermission();
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            permissionGranted();
            break;
        }
        case AVAuthorizationStatusRestricted:
            NSLog(@"不能完成授权，可能开启了访问限制");
            noPermission();
        case AVAuthorizationStatusDenied:{
            NSLog(@"请到设置授权访问相机");
            noPermission();
        }
            break;
        default:
            break;
    }
}

+ (void)checkPhotoAlbumAuthorizationGrand:(void (^)(void))permissionGranted
                         withNoPermission:(void (^)(void))noPermission
{
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthStatus) {
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                status == PHAuthorizationStatusAuthorized ? permissionGranted() : noPermission();
            }];
            break;
        }
        case PHAuthorizationStatusAuthorized:
        {
            permissionGranted();
            break;
        }
        case PHAuthorizationStatusRestricted:
            NSLog(@"不能完成授权，可能开启了访问限制");
            noPermission();
        case PHAuthorizationStatusDenied:{
            NSLog(@"请到设置授权访问相册");
            noPermission();
            break;
        }
        default:
            break;
            
    }
}
+ (void)checkLocationServiceAuthorization:(void(^)(BOOL authorizationAllow))checkFinishBack
{
    if ([CLLocationManager locationServicesEnabled])
    {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:
                checkFinishBack(NO);
                break;
            case kCLAuthorizationStatusRestricted:
                checkFinishBack(NO);
                break;
            case kCLAuthorizationStatusDenied:
                NSLog(@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启)");
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                checkFinishBack(YES);
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                checkFinishBack(YES);
                break;
                
            default:
                break;
        }
    }else
    {
        NSLog(@"此设备不支持定位服务");
    }
}

@end
