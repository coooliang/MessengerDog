//
//  MDURLFilter.m
//
//  Created by chenliang on 2018/7/17.
//


#import "MDPluginFilter.h"
#import "MDBasePlugin.h"
#import "MessengerDog.h"

@implementation MDPluginFilter {
    NSMutableArray *_plugins;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _plugins = [NSMutableArray arrayWithCapacity:0];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gc:) name:MD_GC_PLUGIN_NOTIFICATION object:nil];
    }
    return self;
}

- (BOOL)mapping:(NSString *)url webView:(WKWebView *)webView viewController:(UIViewController *)viewController{
    url = MDSafeString(url);
    if ([url hasPrefix:MDConfig.mdCallfunctionPrefix]) {
        [self doFilter:url webView:webView viewController:viewController];
        return YES;
    }
    return NO;
}

- (void)doFilter:(NSString *)url webView:(WKWebView *)webView viewController:(UIViewController *)viewController {
    NSDictionary *params = [self urlParams:url];
    if (MDIsSafeDictionary(params)) {
        NSString *callBackId = MDSafeString([params objectForKey:@"callbackId"]);
        NSString *className = MDSafeString([params objectForKey:@"className"]);
        NSString *methodName = MDSafeString([params objectForKey:@"method"]);
        NSString *jsonString = MDSafeString([params objectForKey:@"message"]);
        jsonString = [jsonString stringByRemovingPercentEncoding];
        jsonString = [jsonString md_filterArgument];
        NSDictionary *message = [jsonString md_dictionaryFromJSONString];
        BOOL gc = [MDSafeString([params objectForKey:@"gc"])boolValue];
        if([self isSecure:className methodName:methodName]){
            MDBasePlugin *plugin = [self loadSingletonPlugin:className methodName:methodName];
            if(!plugin){
                Class cls = NSClassFromString(className);
                plugin = [[cls alloc] init];
                [_plugins addObject:plugin];
            }
            plugin.callbackId = callBackId;
            plugin.viewController = viewController;
            plugin.wkWebView = webView;
            plugin.message = message;
            plugin.execName = MDJoinStrings(className,@".",methodName);
            plugin.autoGC = gc;
            if(MDConfig.mdEnableLog)MDLog(@"handle plugins.count = %d , plugins = %@",_plugins.count,_plugins);
            SEL selector = NSSelectorFromString(methodName);
            [plugin performSelector:selector withObject:nil afterDelay:0.0];
        }
    }
}

#pragma mark - private methods
//判断请求是否安全
- (BOOL)isSecure:(NSString *)className methodName:(NSString *)methodName {
    BOOL isSecureRequest = NO;
    if(injectJSType == LoadLocalAppPluginJSType){
        Class cls = NSClassFromString(className);
        id tempObj = [[cls alloc] init];
        if([tempObj isKindOfClass:[MDBasePlugin class]]){
            isSecureRequest = YES;
        }
    }else {
        MDPluginManager *pluginManager = [MDPluginManager sharedManager];
        NSArray *classArray = [pluginManager getClassArray];
        if([classArray containsObject:className]){
            NSArray *methodArray = [pluginManager getMethodArrayForClass:className];
            if([methodArray containsObject:methodName]){
                isSecureRequest = YES;
            }
        }
    }
    return isSecureRequest;
}

- (MDBasePlugin *)loadSingletonPlugin:(NSString *)className methodName:(NSString *)methodName {
    if(injectJSType == LoadLocalAppPluginJSType){
        for (MDBasePlugin *plugin in _plugins) {
            if([NSStringFromClass(plugin.class) isEqualToString:className]){
                return plugin;
            }
        }
    }else{
        NSArray *methods = [[MDPluginManager sharedManager].singletonPluginConfig objectForKey:className];
        if(MDIsSafeArray(methods) && [methods containsObject:methodName]){
            for (MDBasePlugin *plugin in _plugins) {
                if([plugin.execName isEqualToString:MDJoinStrings(className,@".",methodName)]){
                    return plugin;
                }
            }
        }
    }
    return nil;
}

- (NSDictionary *)urlParams:(NSString *)url {
    NSString *temp = [url substringFromIndex:MDConfig.mdCallfunctionPrefix.length];
    return [temp md_urlParmas];
}

#pragma mark - NSNotification
- (void)gc:(NSNotification *)notif {
    NSString *callBackId = notif.object;
    [_plugins enumerateObjectsUsingBlock:^(MDBasePlugin *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.callbackId isEqualToString:callBackId]){
            [_plugins removeObject:obj];
            if(MDConfig.mdEnableLog)MDLog(@"gc obj = %@ ",[obj class]);
        }
    }];
    if(MDConfig.mdEnableLog)MDLog(@"gc plugins.count = %d , plugins = %@",_plugins.count,_plugins);
}

- (void)dealloc {
    if(MDConfig.mdEnableLog)MDLog(@"%@ dealloc",[self class]);
    [_plugins removeAllObjects];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MD_GC_PLUGIN_NOTIFICATION object:nil];
}

@end
