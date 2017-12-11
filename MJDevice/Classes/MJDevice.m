//
//  MJDevice.m
//  Common
//
//  Created by 黄磊 on 16/4/20.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import "MJDevice.h"
#import <UIKit/UIKit.h>
#include <sys/sysctl.h>
#import HEADER_FILE_SOURCE
#import HEADER_KEYCHAIN


static NSString *s_curDeviceUUID = nil;

@implementation MJDevice

#pragma mark - DeviceId

+ (NSString *)deviceUUID
{
    if (s_curDeviceUUID) {
        return s_curDeviceUUID;
    }
    // 首先读取NSUserDefaults
    NSString *uuidStr = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultDeviceUUID];
    if (uuidStr) {
        s_curDeviceUUID = uuidStr;
        return s_curDeviceUUID;
    }
    
    // 然后读取Keychain中的
    uuidStr = [self deviceUUIDFromeKeychain];
    
    if (!uuidStr) {
        NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
        NSString *uuidStrVendor = [uuid UUIDString];
        uuidStr = uuidStrVendor;
    }
    [[NSUserDefaults standardUserDefaults] setObject:uuidStr forKey:kDefaultDeviceUUID];
    s_curDeviceUUID = uuidStr;
    
    return uuidStr;
}

+ (NSString *)deviceUUIDFromeKeychain
{
    NSString *deviceUUID = keychainDefaultSharedObjectForKey(kDefaultDeviceUUID);
    if (deviceUUID.length > 0) {
        LogTrace(@"Keychain Device UUID : %@", deviceUUID);
    } else {
        NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
        deviceUUID = [uuid UUIDString];
        LogTrace(@"New Device UUID: %@", deviceUUID);
        keychainSetDefaultSharedObject(deviceUUID, kDefaultDeviceUUID);
    }
    return deviceUUID;
}


#pragma mark - DeviceVersion

+ (NSString *)deviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

+ (NSString *)deviceVersionName
{
    NSString* device = [self deviceVersion];
    // From https://github.com/squarefrog/UIDeviceIdentifier
    NSDictionary *dicDevices = @{
#if !defined(TARGET_OS_IOS) || TARGET_OS_IOS
                                 @"iPhone1,1"   : @"iPhone 1G",
                                 @"iPhone1,2"   : @"iPhone 3G",
                                 @"iPhone2,1"   : @"iPhone 3GS",
                                 @"iPhone3,1"   : @"iPhone 4 (GSM)",
                                 @"iPhone3,2"   : @"iPhone 4 (GSM Rev A)",
                                 @"iPhone3,3"   : @"iPhone 4 (CDMA)",
                                 @"iPhone4,1"   : @"iPhone 4S",
                                 @"iPhone5,1"   : @"iPhone 5 (GSM)",
                                 @"iPhone5,2"   : @"iPhone 5 (GSM+CDMA)",
                                 @"iPhone5,3"   : @"iPhone 5C (GSM)",
                                 @"iPhone5,4"   : @"iPhone 5C (GSM+CDMA)",
                                 @"iPhone6,1"   : @"iPhone 5S (GSM)",
                                 @"iPhone6,2"   : @"iPhone 5S (GSM+CDMA)",
                                 @"iPhone7,1"   : @"iPhone 6 Plus",
                                 @"iPhone7,2"   : @"iPhone 6",
                                 @"iPhone8,1"   : @"iPhone 6s",
                                 @"iPhone8,2"   : @"iPhone 6s Plus",
                                 @"iPhone8,4"   : @"iPhone SE",
                                 @"iPhone9,1"   : @"iPhone 7",
                                 @"iPhone9,2"   : @"iPhone 7 Plus",
                                 @"iPhone9,3"   : @"iPhone 7",
                                 @"iPhone9,4"   : @"iPhone 7 Plus",
                                 
                                 @"iPhone10,1"   : @"iPhone 8",
                                 @"iPhone10,2"   : @"iPhone 8 Plus",
                                 @"iPhone10,3"   : @"iPhone X",
                                 @"iPhone10,4"   : @"iPhone 8",
                                 @"iPhone10,5"   : @"iPhone 8 Plus",
                                 @"iPhone10,6"   : @"iPhone X",
                                
                                 @"iPod1,1"     : @"iPod Touch 1G",
                                 @"iPod2,1"     : @"iPod Touch 2G",
                                 @"iPod3,1"     : @"iPod Touch 3G",
                                 @"iPod4,1"     : @"iPod Touch 4G",
                                 @"iPod5,1"     : @"iPod Touch 5G",
                                 @"iPod7,1"     : @"iPod Touch 6G",

                                 @"iPad1,1"     : @"iPad 1",
                                 @"iPad2,1"     : @"iPad 2 (WiFi)",
                                 @"iPad2,2"     : @"iPad 2 (GSM)",
                                 @"iPad2,3"     : @"iPad 2 (CDMA)",
                                 @"iPad2,4"     : @"iPad 2",
                                 @"iPad2,5"     : @"iPad Mini (WiFi)",
                                 @"iPad2,6"     : @"iPad Mini (GSM)",
                                 @"iPad2,7"     : @"iPad Mini (GSM+CDMA)",
                                 @"iPad3,1"     : @"iPad 3 (WiFi)",
                                 @"iPad3,2"     : @"iPad 3 (GSM+CDMA)",
                                 @"iPad3,3"     : @"iPad 3 (GSM)",
                                 @"iPad3,4"     : @"iPad 4 (WiFi)",
                                 @"iPad3,5"     : @"iPad 4 (GSM)",
                                 @"iPad3,6"     : @"iPad 4 (GSM+CDMA)",
                                 @"iPad4,1"     : @"iPad Air (WiFi)",
                                 @"iPad4,2"     : @"iPad Air (WiFi/Cellular)",
                                 @"iPad4,3"     : @"iPad Air (China)",
                                 @"iPad4,4"     : @"iPad Mini Retina (WiFi)",
                                 @"iPad4,5"     : @"iPad Mini Retina (WiFi/Cellular)",
                                 @"iPad4,6"     : @"iPad Mini Retina (China)",
                                 @"iPad4,7"     : @"iPad Mini 3 (WiFi)",
                                 @"iPad4,8"     : @"iPad Mini 3 (WiFi/Cellular)",
                                 @"iPad5,1"     : @"iPad Mini 4 (WiFi)",
                                 @"iPad5,2"     : @"iPad Mini 4 (WiFi/Cellular)",
                                 @"iPad5,3"     : @"iPad Air 2 (WiFi)",
                                 @"iPad5,4"     : @"iPad Air 2 (WiFi/Cellular)",
                                 @"iPad6,3"     : @"iPad Pro 9.7-inch (WiFi)",
                                 @"iPad6,4"     : @"iPad Pro 9.7-inch (WiFi/Cellular)",
                                 @"iPad6,7"     : @"iPad Pro 12.9-inch (WiFi)",
                                 @"iPad6,8"     : @"iPad Pro 12.9-inch (WiFi/Cellular)",
                                 
                                 @"iPad6,11"     : @"iPad 5 (WiFi)",
                                 @"iPad6,12"     : @"iPad 5 (WiFi/Cellular)",
#endif
#if TARGET_OS_TV
                                 @"AppleTV5,3"  : @"Apple TV 4G",
#endif
#if !defined(TARGET_OS_SIMULATOR) || TARGET_OS_SIMULATOR
                                 @"i386"        : @"Simulator",
                                 @"x86_64"      : @"Simulator",
#endif
                                      };
    NSDictionary *dicAddition = getFileData(FILE_NAME_DEVICE_MAP);
    if (dicAddition.allKeys.count > 0) {
        NSMutableDictionary *aDic = [dicDevices mutableCopy];
        [aDic addEntriesFromDictionary:dicAddition];
        dicDevices = aDic;
    }
    return dicDevices[device] ?: @"";
}


#pragma mark - SysVersion 

+ (NSString *)sysVersion
{
    return [@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
}

@end
