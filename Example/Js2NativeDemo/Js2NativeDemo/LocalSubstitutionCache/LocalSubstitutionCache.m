
#import "LocalSubstitutionCache.h"

#define app_plugin_js @"app-plugin.js"
@implementation LocalSubstitutionCache

#pragma mark - override NSURLCache
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request{
    NSURL *requestUrl = [request URL];
    NSString *pathString = [requestUrl absoluteString];//full path
    NSLog(@"cachedResponseForRequest pathString = %@",pathString);
    if(pathString && [pathString rangeOfString:app_plugin_js].location != NSNotFound){
        NSString *js = [[NSBundle mainBundle] pathForResource:@"app-plugin" ofType:@"js"];
        NSData *data = [js dataUsingEncoding:NSUTF8StringEncoding];
        if(data != nil){
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[request URL]
                                                                MIMEType:@"application/javascript"
                                                   expectedContentLength:[data length]
                                                        textEncodingName:nil];
            NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
            return cachedResponse;
        }
    }
    return [super cachedResponseForRequest:request];
}
@end
