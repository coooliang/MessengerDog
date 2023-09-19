////
//  MDAnnotation.h
//  Js2NativeDemo
//  Created by coooliang on 2023/5/18
//

#import "MDAnnotation.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <mach-o/ldsyms.h>

#import "MessengerDog.h"

NSArray<NSString *>* MDScanPluginConfiguration(char *sectionName,const struct mach_header *mhp);
static void md_dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    //register services
    NSArray<NSString *> *services = MDScanPluginConfiguration(MDPluginNames,mhp);
    //garbage collection
    NSArray<NSString *> *sps = MDScanPluginConfiguration(MDSingletonNames,mhp);
    [[MDPluginManager sharedManager]addPublicPlugins:services];
    [[MDPluginManager sharedManager]addPublicPlugins:sps];
    [[MDPluginManager sharedManager]configSingletonPlugins:sps];
}

//load->constructor->main
//constructor修饰的函数会在main函数之前执行,destructor修饰的函数会在程序exit前调用
__attribute__((constructor))
void md_before_main_init_prophet() {
    _dyld_register_func_for_add_image(md_dyld_callback);//在dyld加载镜像时，会执行注册过的回调函数
}


//LP64 代表的是数据模型(data models)：(https://www.yotrolz.com/posts/1c118e9a/)
//LP64 其实就是 long integers 和 pointers 是 64 bits
NSArray<NSString *>* MDScanPluginConfiguration(char *sectionName,const struct mach_header *mhp) {
    NSMutableArray *configs = [NSMutableArray array];
    unsigned long size = 0;
#ifndef __LP64__
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
#endif
    
    unsigned long counter = size/sizeof(void*);
    for(int idx = 0; idx < counter; ++idx){
        char *string = (char*)memory[idx];
        NSString *str = [NSString stringWithUTF8String:string];
        if(!str)continue;
        if(str) [configs addObject:str];
    }
    return configs;
}

@implementation MDAnnotation

//+ (void)load{
//  MDLog(@"load");
//}

@end

