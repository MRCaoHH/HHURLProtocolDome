//
//  HHURLProtocol.m
//  HHTest
//
//  Created by caohuihui on 2016/10/18.
//  Copyright © 2016年 caohuihui. All rights reserved.
//

#import "HHURLProtocol.h"

static NSString *kUserAgent = @"User-Agent";
static NSString *kPropertyKey = @"kPropertyKey";
@interface HHURLProtocol()<NSURLSessionDataDelegate,NSURLSessionTaskDelegate,NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionTask *task;
@end

@implementation HHURLProtocol

- (NSURLSession *)session{
    if (_session == nil) {
        NSURLSessionConfiguration *configuration =  [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.protocolClasses = @[[self class]];
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    return _session;
}

+ (void)load{
    [NSURLProtocol registerClass:[HHURLProtocol class]];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    return [self checkRequest:request];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    
    return  [self settingHttpHeader:request];
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:kPropertyKey inRequest:mutableReqeust];
    _task = [self.session dataTaskWithRequest:mutableReqeust];
    [_task resume];
}

- (void)stopLoading
{
    [_task cancel];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (!error) {
        [self.client URLProtocolDidFinishLoading:self];
    }
    else {
        [self.client URLProtocol:self didFailWithError:error];
    }
}


#pragma mark - check request 
+ (BOOL)checkRequest:(NSURLRequest *)request{
    if ([NSURLProtocol propertyForKey:kPropertyKey inRequest:request]) {
        return NO;
    }
    return YES;//通过
}

+ (NSURLRequest *)settingHttpHeader:(NSURLRequest *)request{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [mutableReqeust setValue:@"HHURLProtocolDome/1.0.0" forHTTPHeaderField:kUserAgent];
    return mutableReqeust;
}

@end
