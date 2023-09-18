//// 
//  MDConfig.m
//  Js2NativeDemo
//  Created by coooliang on 2023/5/23
//

#import "MDConfig.h"


static NSString *kMDCallfunctionPrefix = @"https://www.yypt.com/callfunction/";
static NSString *kMDJs2native = @"yyptJs2native";
static NSString *kMDPlugins = @"yyptPlugins";
static NSString *kMDScriptMessageName = @"yypt";

//当项目中存在名为md-app-plugins.js时，使用这个js文件中的内容
static NSString *kMDAppPluginsJSFileName = @"md-app-plugins";
//是否打印日志
static BOOL kMDEnableLog = NO;

@implementation MDConfig

+ (NSString *)mdCallfunctionPrefix {
    return kMDCallfunctionPrefix;
}

+ (void)setMdCallfunctionPrefix:(NSString *)mdCallfunctionPrefix {
    kMDCallfunctionPrefix = mdCallfunctionPrefix;
}

+ (NSString *)mdJs2native {
    return kMDJs2native;
}
+ (void)setMdJs2native:(NSString *)mdJs2native {
    kMDJs2native = mdJs2native;
}

+ (NSString *)mdPlugins {
    return kMDPlugins;
}
+ (void)setMdPlugins:(NSString *)mdPlugins {
    kMDPlugins = mdPlugins;
}

+ (NSString *)mdScriptMessageName {
    return kMDScriptMessageName;
}
+ (void)setMdScriptMessageName:(NSString *)mdScriptMessageName {
    kMDScriptMessageName = mdScriptMessageName;
}


+ (NSString *)mdAppPluginsJSFileName {
    return kMDAppPluginsJSFileName;
}
+ (void)setMdAppPluginsJSFileName:(NSString *)mdAppPluginsJSFileName {
    kMDAppPluginsJSFileName = mdAppPluginsJSFileName;
}

+ (BOOL)mdEnableLog {
    return kMDEnableLog;
}
+ (void)setMdEnableLog:(BOOL)mdEnableLog {
    kMDEnableLog = mdEnableLog;
}

@end
