////
//  MDPluginManager.m
//  Js2NativeDemo
//  Created by coooliang on 2023/5/18
//

#import "MDBasePlugin.h"
#import "MessengerDog.h"
#import <objc/runtime.h>

@implementation MDPluginManager {
    NSMutableArray<NSString *> *_publicPlugins;

    NSArray<NSString *> *_classesCache;
    NSMutableDictionary<NSArray<NSString *> *, NSString *> *_methodsCache;
}

static MDPluginManager *instance = nil;
+ (MDPluginManager *)sharedManager {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _classesCache = @[];
        _methodsCache = [NSMutableDictionary dictionaryWithCapacity:0];
        _publicPlugins = [NSMutableArray arrayWithCapacity:0];
        _singletonPluginConfig = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (void)addPublicPlugins:(NSArray *)plugins {
    [_publicPlugins addObjectsFromArray:plugins];
}

- (void)configSingletonPlugins:(NSArray<NSString *> *)arr {
    for (NSString *s in arr) {
        NSArray *temp = [s componentsSeparatedByString:@"."];
        if (MDIsSafeArray(temp) && temp.count > 1) {
            NSString *className = temp.firstObject;
            NSString *methodName = temp[1];
            NSMutableArray *methods = [_singletonPluginConfig objectForKey:className];
            if (methods == nil) {
                methods = [NSMutableArray arrayWithObject:methodName];
            } else {
                [methods md_uniqueAdd:methodName];
            }
            [_singletonPluginConfig setObject:methods forKey:className];
        }
    }
}

#pragma mark - gets
- (NSArray<NSString *> *)getClassArray {
    if (_classesCache.count > 0) return _classesCache;
    NSMutableArray *classArray = [NSMutableArray arrayWithCapacity:_publicPlugins.count];
    for (NSString *s in _publicPlugins) {
        NSArray *temp = [s componentsSeparatedByString:@"."];
        if (MDIsSafeArray(temp)) {
            NSString *className = temp.firstObject;
            [classArray md_uniqueAdd:className];
        }
    }
    if (MDConfig.mdEnableLog) MDLog(@"Annotation classArray = %@", classArray);
    _classesCache = classArray;
    return _classesCache;
}

// 获取插件类中的所有方法，返回值为void,只有一个参数的
- (NSArray<NSString *> *)getMethodArrayForClass:(NSString *)className {
    NSArray *cacheMethods = [_methodsCache objectForKey:className];
    if (MDIsSafeArray(cacheMethods)) return cacheMethods;
    NSMutableArray *methodArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *s in _publicPlugins) {
        NSArray *temp = [s componentsSeparatedByString:@"."];
        if (temp && temp.count > 1) {
            NSString *name = temp.firstObject;
            if ([name isEqualToString:className]) {
                [methodArray addObject:temp[1]];
            }
        }
    }
    if (MDConfig.mdEnableLog) MDLog(@"Annotation methodArray for %@ = %@", className, methodArray);
    [_methodsCache setObject:methodArray forKey:className];
    return methodArray;
}

- (NSString *)pluginJS {
    NSArray *classArray = [self getClassArray];
    NSMutableString *js = [NSMutableString stringWithFormat:@"if(!window.%@){window.%@={};};", MDConfig.mdPlugins, MDConfig.mdPlugins];
    if (classArray) {
        for (NSString *className in classArray) {
            NSString *pluginName = [className md_pojo];
            NSString *pluginObj = MDJoinStrings(@"window.", MDConfig.mdPlugins, @".", pluginName, @"={};");
            [js appendString:pluginObj];
            NSArray *methods = [self getMethodArrayForClass:className];
            if (MDIsSafeArray(methods)) {
                NSArray *singletonPluginArray = [_singletonPluginConfig objectForKey:className];
                if (MDConfig.mdEnableLog) MDLog(@"className = %@ : gcArray = %@", className, singletonPluginArray);
                for (NSString *methodName in methods) {
                    [js appendString:[NSString stringWithFormat:@"window.%@.%@.%@ = function(params){", MDConfig.mdPlugins, pluginName, methodName]];
                    [js appendString:@"params = params || {};"]; // add gc flag
                    if (MDIsSafeArray(singletonPluginArray) && [singletonPluginArray containsObject:methodName]) {
                        [js appendString:@"params.gc='0';"];
                    } else {
                        [js appendString:@"params.gc='1';"];
                    }
                    [js appendString:[NSString stringWithFormat:@"window.%@.exec(\"%@\", \"%@\", params);", MDConfig.mdJs2native, className, methodName]];
                    [js appendString:@"};"];
                }
            }
        }
    }
    [self _printFormatJs:js];
    return js;
}

#pragma mark - private methods
- (void)_printFormatJs:(NSString *)js {
    if (MDConfig.mdEnableLog) {
        js = [js stringByReplacingOccurrencesOfString:@";window." withString:@";\n window."];
        MDLog(@"printFormatJs = \n %@", js);
    }
}

@end
