//
//  CLInjectionJS.m
//  Js2NativeDemo
//
//  Created by coooliang on 2022/6/27.
//  Copyright © 2022 chenl. All rights reserved.
//


#import "MDInjectJS.h"
#import "MDBasePlugin.h"
#import "MDPluginFilter.h"
#import "MessengerDog.h"
#import <objc/runtime.h>

#define __md_common_js_func__(x) #x
static NSString *_commonJS = @__md_common_js_func__(
    (function (window) {
         var runtime = (function () {
           return {
             createFrame: function (url) {
               var iframe = document.createElement('iframe');
               iframe.style.display = 'none';
               iframe.src = url;
               document.body.appendChild(iframe);

               setTimeout(function () {
                 iframe.parentNode.removeChild(iframe);
                 iframe = null;
               }, 0);
             },
             callFunctionMessage: function (url) {
               if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.yypt && window.webkit.messageHandlers.yypt.postMessage) {
                 window.webkit.messageHandlers.yypt.postMessage(url);
               } else {
                 runtime.createFrame(url);
               }
             }
           }
         }());

         window.yyptJs2native = (function () {
           var uniqueId = 1;       // 回调方法唯一id
           var callbackCache = {}; // 回调方法容器
           return {
             exec:
               function (className, methodName, params) {
                 params = params || {};
                 var callback = params['success'] || params['fail'] ? {
                   success: params['success'],
                   fail: params['fail']
                 } :
                   null;
                 delete params['success'];
                 delete params['fail'];
                 var time = new Date().getTime();
                 var callbackId = ['cid', className, methodName, uniqueId++, time].join('_');
                 if (callback) {
                   callbackCache[callbackId] = callback;
                 }
                 var messageJsonString = "";
                 if (params.message) {
                     messageJsonString = JSON.stringify(params.message);
                 }
                 var gc = params["gc"];
                 var url = "https://www.yypt.com/callfunction/callbackId=" + callbackId + "&className=" + className + "&method=" + methodName + "&gc=" + gc + "&message=" + encodeURIComponent(messageJsonString) + "&tt=" + time;
                 runtime.callFunctionMessage(url);
               },
             callbackFromNative: function (result) {
               if (result) {
                 var callback = callbackCache[result.callbackId];
                 if (callback) {
                   var message = result.message;
                   if (result.callbackType == 1 && callback.success) {
                       if(message){
                           callback.success(message);
                       }else{
                           callback.success();
                       }
                   } else if (result.callbackType == 0 && callback.fail) {
                       if(message){
                           callback.fail(message);
                       }else{
                           callback.fail();
                       }
                   }
                   if (result.gc == 1) {
                     delete callbackCache[result.callbackId];
                   }
                 }
               }
             }
           }
         }());
    })(window);
); // END preprocessorJSCode
#undef __md_common_js_func__
 
#define __md_util_js_func__(x) #x
static NSString *_utilJS = @__md_util_js_func__(
    function mdHasObject(path){
        let result = window;
        const paths = path.split(".");
        for(const p of paths){
            result = Object(result)[p];
            if(result == undefined){
                return result;
            }
        }
        return result;
    };
//mdHasObject("yyptPlugins.infoPlugin.show")
); // END preprocessorJSCode

#undef __md_util_js_func__

@implementation MDInjectJS


+ (NSString *)js {
    injectJSType = ScanMDAnnotationType;
    return [self js:injectJSType];
}

static NSString *_injectJS;
+ (NSString *)js:(MDInjectJSType)type {
    injectJSType = type;
    if (_injectJS == nil) {
        _injectJS = [NSString stringWithFormat:@"%@%@%@", _commonJS,_utilJS, [self loadJS]];
    }
    if(MDConfig.mdEnableLog)MDLog(@"inject JS = %@",_injectJS);
    return _injectJS;
}

/**
 创建注入的JS内容
 if(!window.yyptPlugins){window.yyptPlugins={};};
 window.yyptPlugins.infoPlugin = {};
 window.yyptPlugins.infoPlugin.world = function(params){ window.yyptJs2native.exec("InfoPlugin", "world", params); };
 window.yyptPlugins.infoPlugin.keyboard = function(params){ window.yyptJs2native.exec("InfoPlugin", "keyboard", params); };
 window.yyptPlugins.infoPlugin.privateMethod3 = function(params){ window.yyptJs2native.exec("InfoPlugin", "privateMethod3", params); };
 window.yyptPlugins.infoPlugin.hello = function(params){ window.yyptJs2native.exec("InfoPlugin", "hello", params); };
 
 window.yyptPlugins.urlPlugin = {};
 window.yyptPlugins.urlPlugin.nextStepJson = function(params){ window.yyptJs2native.exec("UrlPlugin", "nextStepJson", params); };
 */
+ (NSString *)loadJS {
    if(injectJSType == LoadLocalAppPluginJSType){
        return [self loadLocalAppPluginJS];
    }else{
        return [[MDPluginManager sharedManager]pluginJS];
    }
}

+ (NSString *)loadLocalAppPluginJS {
    NSString *jsPath = [[NSBundle mainBundle]pathForResource:MDConfig.mdAppPluginsJSFileName ofType:@"js"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:jsPath];
    NSString *js = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if(MDSafeString(js)){
        js = [js md_trim];
    }
    if(MDConfig.mdEnableLog)MDLog(@"%@ = %@",MDConfig.mdAppPluginsJSFileName,js);
    return js;
}

@end
