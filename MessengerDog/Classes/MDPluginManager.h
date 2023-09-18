////
//  MDPluginManager.h
//  Js2NativeDemo
//  Created by coooliang on 2023/5/18
//

#import <Foundation/Foundation.h>

@interface MDPluginManager : NSObject

+ (MDPluginManager *)sharedManager;

- (void)addPublicPlugins:(NSArray *)plugins;
- (void)configSingletonPlugins:(NSArray<NSString *> *)arr;

- (NSArray<NSString *> *)getClassArray;
- (NSArray<NSString *> *)getMethodArrayForClass:(NSString *)className;

//- (NSMutableDictionary<NSString *, NSArray<NSString *> *> *)getSingletonPluginConfig;

- (NSString *)pluginJS;

@property (nonatomic,strong)NSMutableDictionary<NSString *, NSArray<NSString *> *> *singletonPluginConfig;

@end
