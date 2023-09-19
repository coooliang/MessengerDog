# MessengerDog

<img src="./MessengerDog.png"/><br/>

 MessengerDog是Hybrid App开发中，用于iOS的javascript与native通信的实现方案，吸收了Struts2框架Interceptor的理念来实现模块间的耦合。

--------------------------

![License](https://img.shields.io/github/license/coooliang/MessengerDog)
![Version](https://img.shields.io/github/v/tag/coooliang/MessengerDog)
![platforms](https://img.shields.io/cocoapods/p/MessengerDog)
![language](https://img.shields.io/github/languages/top/coooliang/MessengerDog)


### 1.继承MDBasePlugin

```objective-c
#import "MDBasePlugin.h"

@interface InfoPlugin : MDBasePlugin

```

### 2.使用注解将插件的方法公开

```objective-c

//使用注解公开插件
@Public(InfoPlugin,hello)
- (void)hello {
    NSLog("message = %@",self.message);
    [self toSuccessCallback];//callback自动回收插件
}

//单例模式需要自己管理内存，手动调用[self gc]回收插件
@Singleton(InfoPlugin,keyboard)
- (void)keyboard {
    //show keyboard
}

@end
```

### 3.[MDInjectJS js]获得js内容，并向WKWebView注入js

```objective-c
MDConfig.mdEnableLog = YES;
WKUserScript *userScript = [[WKUserScript alloc] initWithSource:[MDInjectJS js] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
```

### 4.WKWebView拦截url

```objective-c
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = navigationAction.request.URL.absoluteString;
    if ([_urlFilter mapping:url webView:webView viewController:self]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([MDConfig.mdScriptMessageName isEqualToString:message.name]) {
        [_urlFilter mapping:message.body webView:_webView viewController:self];
    }
}

@end
```

### 5.HTML中调用插件

```js
function globalSuccessCallback(rs){
    alert(rs);
}

function globalFailCallback(rs){
    alert(rs);
}

function world(){
    var params = {
        success:globalSuccessCallback,
        fail:globalFailCallback,
        message:{
            name:"coooliang",
            "value":"123"
        }
    };
    window.yyptPlugins.infoPlugin.world(params);
}
```
