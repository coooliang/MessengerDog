//// 
//  MDAnnotation.h
//  Js2NativeDemo
//  Created by coooliang on 2023/5/18
//

#import <Foundation/Foundation.h>

#ifndef MDJSPluginNames

#define MDPluginNames "MDPluginNames"

#define MDSingletonNames "MDSingletonNames"

#endif


//将指定属性存储到执行文件的section中
//1：标记为attribute__((used))的函数被标记在目标文件中，以避免链接器删除未使用的节
//2：section关键字可以将变量定义到指定的输入段,分别存储在MACH-O中的Section __DATA (https://zhuanlan.zhihu.com/p/448976679)
#define MDPluginDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))

//char * kPublicPluginServiceImpl __attribute((used, section("__DATA,""MDJSPluginNames"" "))) = "{ \"""InfoPlugin""\" : \"""hello""\"}";
#define Public(servicename,impl) class NSObject; char * kMDPublic##servicename##impl MDPluginDATA(MDPluginNames) = ""#servicename"."#impl"";

#define Singleton(servicename,impl) class NSObject; char * kMDPublic##servicename##impl MDPluginDATA(MDSingletonNames) = ""#servicename"."#impl"";

//无法被继承(https://www.jianshu.com/p/1d82f18bcee4)(https://www.jianshu.com/p/7bbcf7595dcf)
__attribute__((objc_subclassing_restricted))
@interface MDAnnotation : NSObject

@end
