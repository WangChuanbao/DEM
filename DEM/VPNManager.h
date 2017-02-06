//
//  AN.h
//  SecBrowser
//
//  Created by huangjl on 12-7-3.
//  Copyright (c) 2012年 ArrayNetworks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DISABLE_VPN_COMPAT_SOCKET_API
#import "arrayapi.h"
#import "vpn_error.h"

#define kVPNMessageNotification  @"vpn_notification"


typedef enum {
    FieldTypePasswordText,
    FieldTypeUsernameText,
    FieldTypeDeviceNameText
} InputFieldType;

@interface AAAMethod : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *methodDescription;
@property (nonatomic, strong) NSMutableArray *inputFields;
@end

@interface InputField : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fieldDescription;
@property (nonatomic) InputFieldType type;
@property (nonatomic, strong) NSString *inputString;
@end

#pragma mark - VPNAccount
/*  VPNAccount
 *
 *  store the information to login to vpn server
 */

@interface VPNAccount :NSObject <NSCoding,NSCopying>

@property(nonatomic, strong) NSString *host;
@property(nonatomic, strong) NSString *port;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *passWord;
@property(nonatomic, strong) NSString *passWord2;
@property(nonatomic, strong) NSString *passWord3;
@property(nonatomic, strong) NSString *alias;
@property(nonatomic, strong) NSString *certificatePath;
@property(nonatomic, strong) NSString *certificatePassword;

@property(nonatomic, strong) NSString *methodName;
@property(nonatomic, strong) NSString *deviceName;

- (VPNAccount *)initWithHost:(NSString *)host userName:(NSString *)user passWord:(NSString *)passwd;

- (VPNAccount *)initWithHost:(NSString *)host
                        port:(NSString *)port
                       alias:(NSString *)alias
                    userName:(NSString *)user
                    passWord:(NSString *)passwd
                   passWord2:(NSString *)passwd2
                   passWord3:(NSString *)passwd3;

- (VPNAccount *)initWithHost:(NSString *)host
                        port:(NSString *)port
                       alias:(NSString *)alias
                    userName:(NSString *)user
                    passWord:(NSString *)passwd
                   passWord2:(NSString *)passwd2
                   passWord3:(NSString *)passwd3
             certificatePath:(NSString *)cert
         certificatePassword:(NSString *)certpass;

@end


#pragma mark - VPNMessage
/* VPNMessage
 *
 * These messages will send by VPNManager
 */

@interface VPNMessage :NSObject

- (NSInteger)code;
- (NSInteger)error; //reference to vpn_error.h

//not use
- (id)object;
@end


#pragma mark - VPNManager
/*  VPNManager
 *  
 *  Olny one instance
 */

@interface VPNManager : NSObject

@property (nonatomic, strong, readonly) VPNAccount * account;
@property (nonatomic, strong, readonly) NSString *deviceID;

@property (nonatomic, readonly) NSInteger errorCode;                //refer to vpn_error.h
@property (nonatomic, readonly) NSInteger status;                   //refer to  /* vpn status */ in arrayapi.h

+ (VPNManager *)sharedVPNManager;
+ (NSString *)version;

- (int)startVPN:(VPNAccount *)account;
- (void)stopVPN;

- (void)loginWithMethod:(AAAMethod *)accout;
- (void)registerWithMethod:(AAAMethod *)accout;
- (void)cancelLogin;

- (void)setLogLevel:(int)level;
- (void)getVPNSend:(uint64_t *)sendBytes Recived:(uint64_t *)recivedBytes;

- (int)createTCPProxyEntry:(NSString *)host port:(int)port;
- (int)httpProxyPort;

//login methods, contain a list of class AAAMethod 
- (NSArray *)allAAAMehtods;
@end


