//
//  CLInjectionJS.h
//  Js2NativeDemo
//
//  Created by coooliang on 2022/6/27.
//  Copyright © 2022 chenl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ScanMDAnnotationType,
    LoadLocalAppPluginJSType
} MDInjectJSType;

static MDInjectJSType injectJSType;
@interface MDInjectJS : NSObject

+ (NSString *)js;

+ (NSString *)js:(MDInjectJSType)type;

@end
