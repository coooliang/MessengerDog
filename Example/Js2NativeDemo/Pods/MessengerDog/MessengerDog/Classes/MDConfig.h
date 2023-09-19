//// 
//  MDConfig.h
//  Js2NativeDemo
//  Created by coooliang on 2023/5/23
//

#import <Foundation/Foundation.h>

@interface MDConfig : NSObject

+ (NSString *)mdCallfunctionPrefix;
+ (void)setMdCallfunctionPrefix:(NSString *)mdCallfunctionPrefix;

+ (NSString *)mdJs2native;
+ (void)setMdJs2native:(NSString *)mdJs2native;

+ (NSString *)mdPlugins;
+ (void)setMdPlugins:(NSString *)mdPlugins;

+ (NSString *)mdScriptMessageName;
+ (void)setMdScriptMessageName:(NSString *)mdScriptMessageName;


+ (NSString *)mdAppPluginsJSFileName;
+ (void)setMdAppPluginsJSFileName:(NSString *)mdAppPluginsJSFileName;

+ (BOOL)mdEnableLog;
+ (void)setMdEnableLog:(BOOL)mdEnableLog;

@end

