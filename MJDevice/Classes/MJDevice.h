//
//  MJDevice.h
//  Common
//
//  Created by 黄磊 on 16/4/20.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef FILE_NAME_DEVICE_MAP
#define FILE_NAME_DEVICE_MAP @"device_map"
#endif

@interface MJDevice : NSObject

/// 获取设备唯一标识
+ (NSString *)deviceUUID;

/// 获取设备版本
+ (NSString *)deviceVersion;
/// 获取设备版本
+ (NSString *)deviceVersionName;

/// 获取系统版本
+ (NSString *)sysVersion;

@end
