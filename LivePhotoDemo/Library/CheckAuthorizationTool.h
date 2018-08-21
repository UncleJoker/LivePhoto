//
//  CheckAuthorizationTool.h
//  CheckAuthorization
//
//  Created by Rainy on 2017/12/18.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckAuthorizationTool : NSObject
/** 检测访问相册的权限 */
+ (void)checkPhotoAlbumAuthorizationGrand:(void (^)(void))permissionGranted
                         withNoPermission:(void (^)(void))noPermission;
/** 检测访问麦克风的权限 */
+ (void)checkAudioAuthorizationGrand:(void (^)(void))permissionGranted
                    withNoPermission:(void (^)(void))noPermission;
/** 检测访问相机的权限 */
+ (void)checkCameraAuthorizationGrand:(void (^)(void))permissionGranted
                    withNoPermission:(void (^)(void))noPermission;
/** 检测访问定位的权限
 
 if (!authorizationAllow) {
     [locationManager requestWhenInUseAuthorization];
 }
 
 */
+ (void)checkLocationServiceAuthorization:(void(^)(BOOL authorizationAllow))checkFinishBack;

@end
