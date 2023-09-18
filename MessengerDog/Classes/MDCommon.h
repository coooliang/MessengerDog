//// 
//  MDCommon.h
//  Js2NativeDemo
//  Created by coooliang on 2023/5/23
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
    #define MDLog(FORMAT,...) fprintf(stderr,"[%s]:[line %d] %s %s \n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithUTF8String:__PRETTY_FUNCTION__] UTF8String], [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
    #define MDLog(...) (void)0
#endif

#define MDJoinStrings(str,...) [MDCommon joinStrings:str,__VA_ARGS__,nil]

#define MDSafeString(str) [MDSafe stringSafe:str]
#define MDIsSafeArray(arr) [MDSafe isSafeArray:arr]
#define MDIsSafeDictionary(dict) [MDSafe isSafeDictionary:dict]

#define MD_GC_PLUGIN_NOTIFICATION @"MDGCPluginNotificationName"

@interface MDCommon : NSObject

+ (NSString *)joinStrings:(NSString *)str, ... NS_REQUIRES_NIL_TERMINATION;

@end

