/*
  Array Networks SSL VPN API
  Copyright (c) 2012 Array Networks, Inc. All rights reserved.
*/

#pragma once

#include <stddef.h>
#include <stdint.h>

#ifndef _WIN32
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include <netdb.h>
#else
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#undef  FD_SETSIZE
#define FD_SETSIZE      1024
#include <winsock2.h>
typedef int socklen_t;

#endif

#ifdef _WINDLL
#define ARRAYAPI_DECL __declspec(dllexport)
#else
#define ARRAYAPI_DECL
#endif

/* level parameter of array_vpn_set_log_level */
#ifdef __ANDROID__
#include <android/log.h>
#define	LOG_ERROR     ANDROID_LOG_ERROR
#define	LOG_WARNING   ANDROID_LOG_WARN
#define	LOG_INFO      ANDROID_LOG_INFO
#define	LOG_DEBUG     ANDROID_LOG_DEBUG
#else
#define	LOG_ERROR     3
#define	LOG_WARNING   2
#define	LOG_INFO      1
#define	LOG_DEBUG     0
#endif

/* vpn status */
#define VPN_IDLE			0
#define VPN_CONNECTING		1
#define VPN_CONNECTED		2
#define VPN_DISCONNECTING	3
#define VPN_RECONNECTING	4

/* VPN callback's 'cmd' */
#define VPN_CB_CONNECTING            1  /* connecting */
#define VPN_CB_CONN_FAILED           2  /* connect failed */
#define VPN_CB_CONNECTED             3  /* connected */
#define VPN_CB_DISCONNECTING         4  /* disconecting */
#define VPN_CB_DISCONNECTED          5  /* disconected */
#define VPN_CB_CONFIG_REQUEST        6  /* internal used */
#define VPN_CB_RECONNECTING          7  /* reconnecting */
#define VPN_CB_CHOOSE_CLIENT_CERT    8  /* choose certificate */
#define VPN_CB_INPUT_CERT_PASS		 9  /* input certificate password */
#define VPN_CB_SERVER_CERT           10 /* verify server certificate  */
#define VPN_CB_CHOOSE_SITE           11 /* choose site */
#define VPN_CB_CV_GLOBAL             12 /* prelogin CV rules  */
#define VPN_CB_LOGIN                 13 /* login */
#define VPN_CB_CHANGPASSWORD         14 /* localdb change password */
#define VPN_CB_NEW_PIN               15 /* New Pin */
#define VPN_CB_NEW_TOKEN             16 /* New Token */
#define VPN_CB_SMX                   17 /* SMX */
#define VPN_CB_SMX_CHANGEPASS        18 /* SMX change password */
#define VPN_CB_SMS                   19 /* SMS */
#define VPN_CB_CV_USER               20 /* CV postlogin rules */
#define VPN_CB_DEVID_REG			 21 /* device register */
#define VPN_CB_RESOURCES             22 /* resources */
#define VPN_CB_SSO                   23 /* SSO */
#define VPN_CB_PROTECT_SOCK					 24 /* protect socket */

/* default bind port of vpn http proxy */
#define VPN_HTTP_PROXY_DEFAULT_PORT  8080

/* array_vpn_start disp */  
#define VPN_DISP_AlltoTCP	0 	
#define VPN_DISP_TCPtoTCP	1 	
#define VPN_DISP_TCPtoUDP	2 	
#define VPN_DISP_AlltoUDP	3 	

/* array_vpn_start falgs */  
#define VPN_FLAG_HTTP_PROXY            1   /* enable http proxy */
#define VPN_FLAG_SOCK_PROXY            2   /* enable sock proxy */
#define VPN_FLAG_PROXY_SCOPE_PROCESS   4   /* allow clients from the same process*/
#define VPN_FLAG_PROXY_SCOPE_LOCALHOST 8   /* allow clients from the same localhost */
#define VPN_FLAG_PROXY_SCOPE_ALL       16  /* allow all clients */
#define VPN_FLAG_DISABLE_SKIP_LOGIN    32  /* disable app use devid to skip normal login */
#define VPN_FLAG_SKIP_MOTIONPRO_RES    64  /* don't get cv and motionpro resources */
#define VPN_FLAG_LOGOUT_DEV_SESSION    128 /* logout device's all session before login */

/* copy from an_defines.h  */
#define METHOD_MAX					5
#define MULTI_NUM					2
#define USERNAME_LEN				64
#define PASSWORD_LEN				32
#define AAA_SEV_NAME_LEN			32
#define AAA_SEV_DISPLAY_LEN			127
#define VSITE_NAME_LEN				63
#define ROLE_NAME_LEN				63
#define CLIENTCERT_MAX_FIELDSLEN	256
#define DEVID_LEN					255
#define DEVNAME_LEN					512

typedef enum  {
	AUTH_LDAP			= 0,
	AUTH_LOCALDB		= 1,
	AUTH_RADIUS			= 2,
	AUTH_CERTIFICATE	= 3,
	AUTH_RADIUS_ACCOUNT	= 4,
	AUTH_KERVEROS		= 5,
	AUTH_EXTERNAL		= 6,
	AUTH_SMS            = 7,
	AUTH_DEVID          = 8
} auth_type_t;

typedef enum  {
	CERT_ANONYMOUS = 0,
	CERT_CHALLENGE = 1,
	DEVID_BINDUSER = 2,
} auth_action_t;

typedef enum {
	CERTID_NONE	= 0,
	CERTID_SHOW	= 1,
	CERTID_GET	= 2,
} auth_cert_id_type_t;

typedef enum {
    INVALID_DEVICE = 0,
    SPX_VPN_DEVICE = 1,
    AG_VPN_DEVICE = 2,
	MN_DEVICE = 3,
    DUMMY_DEVICE = 4
} vpn_device_type_t;

#pragma pack(push, 1)
typedef struct {
	char server[AAA_SEV_NAME_LEN + 1];
	char desc[AAA_SEV_DISPLAY_LEN + 1];	
	auth_type_t type;
	auth_action_t action;		
} auth_multi_method_t;

typedef struct  {
	char name[AAA_SEV_NAME_LEN + 1];
	char desc[AAA_SEV_DISPLAY_LEN + 1];
	char server[AAA_SEV_NAME_LEN + 1];
	char server_desc[AAA_SEV_DISPLAY_LEN + 1];
	auth_type_t		    type;
	auth_action_t		action;	
	auth_cert_id_type_t	cert_id_type;
	char				cert_id_value[CLIENTCERT_MAX_FIELDSLEN+1];	 
	unsigned int		multi_step_num;
	auth_multi_method_t	multi_steps[MULTI_NUM];
} auth_method_t;

typedef struct {
    vpn_device_type_t   dev_type;
	uint8_t				hwid_on;
	uint8_t				client_security_on;
	uint8_t				rank_on;
	int8_t  			rank_method_idx;
    int8_t				def_method_idx;
	uint8_t				method_num;
	int32_t             err_msd_id;
	auth_method_t		methods[METHOD_MAX];
} aaa_auth_info_t;

typedef struct {
	char method[AAA_SEV_NAME_LEN + 1];
	char user[USERNAME_LEN + 1];
	char pass[PASSWORD_LEN + 1];
	char pass2[PASSWORD_LEN + 1];
	char pass3[PASSWORD_LEN + 1];
	char devid[DEVID_LEN + 1];
	char devname[DEVNAME_LEN + 1];
} aaa_auth_input_t;
#pragma pack(pop)

typedef struct {
    char *domain;
    char *cookie;
}cookie_entry_t;

typedef void* vpn_vsite_conn_t;


#ifdef __cplusplus
extern "C" {
#endif

typedef int (*array_vpn_callback) (int			cmd,
								   int			error, 
								   const void  *in_data,  
								   uint32_t		in_data_len,
                                   void        *out_data, 
								   uint32_t    *out_data_len);

ARRAYAPI_DECL int  array_vpn_start(const char *host,
                     int         port,
                     const char *alias,
                     const char *aaa_method,
                     const char *user,
                     const char *pass,
                     const char *pass2,
                     const char *pass3,
                     const char *sess,
                     const char *validcode,
                     const char *devid,
                     const char *cert_path,
                     const char *cert_pass,
                     const char *cert_data,
                     uint32_t    cert_data_len,
                     int         udp_enable,
                     int         udp_encrypt,
                     int         tunnel_disp,
                     int         reconn_count,
                     int         reconn_max_time,
                     uint32_t    flags,
                     array_vpn_callback cb);

#define array_vpn_start_mn(host, port, user, pass, devid, udp, reconn_count, reconn_time, cb) \
		array_vpn_start(host, port, NULL, NULL, user, pass, NULL, NULL, NULL, NULL, devid, \
		                NULL, NULL, NULL, 0, udp, 1, VPN_DISP_AlltoUDP, reconn_count, reconn_time, \
						VPN_FLAG_HTTP_PROXY | VPN_FLAG_SOCK_PROXY | VPN_FLAG_PROXY_SCOPE_PROCESS, cb)

#define array_vpn_start_mini(host, user, pass, reconn_count, reconn_time, cb) \
		array_vpn_start(host, 443, NULL, NULL, user, pass, NULL, NULL, NULL, NULL, NULL, \
		                NULL, NULL, NULL, 0, 1, 1, VPN_DISP_AlltoUDP, reconn_count, reconn_time, \
						VPN_FLAG_HTTP_PROXY | VPN_FLAG_SOCK_PROXY | VPN_FLAG_PROXY_SCOPE_ALL, cb)

ARRAYAPI_DECL int  array_vpn_stop();

/* rport & vip & vport is in network byte order */
ARRAYAPI_DECL int array_vpn_tcp_proxy_entry_create(const char *rhost, uint16_t rport, uint32_t *vip, uint16_t *vport);
ARRAYAPI_DECL int array_vpn_udp_proxy_entry_create(const char *rhost, uint16_t rport, uint32_t *vip, uint16_t *vport);
ARRAYAPI_DECL int array_vpn_tcp_proxy_entry_close(uint32_t vip, uint16_t vport);
ARRAYAPI_DECL int array_vpn_udp_proxy_entry_close(uint32_t vip, uint16_t vport);

ARRAYAPI_DECL void array_vpn_set_log_level(int level, unsigned char reserved);

ARRAYAPI_DECL int  array_vpn_get_status();

ARRAYAPI_DECL int  array_vpn_get_stats(uint64_t *send_bytes,  uint64_t *recv_bytes);

ARRAYAPI_DECL int  array_vpn_http_proxy_get_port(uint16_t *port);

void array_vpn_enter_background();

void array_vpn_enter_foreground();

ARRAYAPI_DECL int array_vpn_get_devid(char *devid, uint32_t len);
    
#ifdef __cplusplus
}
#endif
