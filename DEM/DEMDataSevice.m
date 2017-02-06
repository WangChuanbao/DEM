//
//  DEMDataSevice.m
//  DEM
//
//  Created by 王宝 on 15/5/12.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "DEMDataSevice.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkReachabilityManager.h"
#import "MD5.h"

@implementation DEMDataSevice

+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url
                                    params:(NSDictionary *)params
                                httpMethod:(NSString *)httpMethod
                               finishBlock:(FinishLoadHandle)block
                                      erro:(erro)block1 {
    
    //拼接url
    url = [NSString stringWithFormat:@"%@%@",BaseURL,url];
    
    //设置参数
    NSArray *array = [url componentsSeparatedByString:@"/"];
    NSString *key = [MD5 md5:[array lastObject]];
    
    if (params != nil) {
        params = [NSMutableDictionary dictionaryWithDictionary:params];
        [params setValue:key forKey:@"key"];
    }
    else {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:key,@"key", nil];
    }
    
    //uuid
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [params setValue:uuid forKey:@"uuid"];
    [params setValue:@"ios" forKey:@"device"];
    //网络状态
    NSString *state = [self getNetWorkStates];
    [params setValue:state forKey:@"network_type"];
    //版本
    NSString *version = kVersion;
    [params setValue:version forKey:@"app_version"];
    //token
    NSDictionary *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    NSString *token = [login objectForKey:@"token"];
    [params setValue:token forKey:@"token"];

    
    //请求数据
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    if ([httpMethod isEqualToString:@"GET"] || [httpMethod isEqualToString:@"get"]) {
        
        operation = [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (block) {
                block(responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block1) {
                block1(error);
            }
        }];
        
    }
    else if ([httpMethod isEqualToString:@"post"] || [httpMethod isEqualToString:@"POST"]) {
        
        //NSString *para = [self dictionaryToJson:params];
        
        //NSDictionary *dic = [NSDictionary dictionaryWithObject:para forKey:@"data"];
        
        operation = [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (block) {
                block(responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block1) {
                block1(error);
            }
        }];
        
    }
    return operation;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

//获取网络状态，隐藏状态栏则无法获取
+(NSString *)getNetWorkStates{
    /*
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSString *state = @"";
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                state = @"无网络";
            }
                break;
                
            case 1:
                state = @"移动网络";
                break;
                
            case 2:
                state = @"WIFI";
                break;
                
            default:
                break;
        }
        
    }
     */
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc] init];
    
    int netType =0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2g";
                    break;
                case 2:
                    state = @"3g";
                    break;
                case 3:
                    state = @"4g";
                    break;
                case 5:
                {
                    state = @"wifi";
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    //根据状态选择
    return state;
}

-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end
