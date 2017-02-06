//
//  DEMDataSevice.h
//  DEM
//
//  Created by 王宝 on 15/5/12.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

typedef void(^FinishLoadHandle) (id result);
typedef void (^erro) (id erro);
@interface DEMDataSevice : NSObject

+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url
                                    params:(NSDictionary *)params
                                httpMethod:(NSString *)httpMethod
                               finishBlock:(FinishLoadHandle)block
                                      erro:(erro)block1;



@end
