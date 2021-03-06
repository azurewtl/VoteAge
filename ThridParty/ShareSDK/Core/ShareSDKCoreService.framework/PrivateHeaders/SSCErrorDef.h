//
//  SSErrorDef.h
//  ShareSDKCoreService
//
//  Created by 冯 鸿杰 on 13-3-12.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#ifndef ShareSDKCoreService_SSCErrorDef_h
#define ShareSDKCoreService_SSCErrorDef_h

/**
 *	@brief	取得ShareSDK国际化字符串描述
 *
 *	@param 	name 	字符串Key名称
 *	@param 	comment 	备注信息
 *
 *	@return	国际化字符串
 */
#define ShareSDKLocalizableString(name,comment) NSLocalizedStringFromTable(name, @"ShareSDKLocalizable", comment)

#define ERROR_CODE_UNREGISTER -100
#define ERROR_DESC_UNREGISTER ShareSDKLocalizableString(@"ERROR_DESC_UNREGISTER", @"尚未初始化SDK")

#define ERROR_CODE_INVALID_PARAM -101
#define ERROR_DESC_INVALID_PARAM ShareSDKLocalizableString(@"ERROR_DESC_INVALID_PARAM", @"传入参数无效")

#define ERROR_CODE_API_NOT_SUPPORT -102
#define ERROR_DESC_API_NOT_SUPPORT ShareSDKLocalizableString(@"ERROR_DESC_API_NOT_SUPPORT", @"不支持此功能")

#define ERROR_CODE_UNAUTH -103
#define ERROR_DESC_UNAUTH ShareSDKLocalizableString(@"ERROR_DESC_UNAUTH", @"尚未授权")

#define ERROR_CODE_SYS_VER_LOW_THAN -104
#define ERROR_DESC_SYS_VER_LOW_THAN ShareSDKLocalizableString(@"ERROR_DESC_SYS_VER_LOW_THAN", @"该功能不支持iOS %@以下系统版本")

#define ERROR_CODE_NOT_CONNECT -105
#define ERROR_DESC_NOT_CONNECT ShareSDKLocalizableString(@"ERROR_DESC_NOT_CONNECT", @"尚未集成该平台!")

#define ERROR_CODE_NO_NETWORK -106
#define ERROR_DESC_NO_NETWORK ShareSDKLocalizableString(@"ERROR_DESC_NO_NETWORK", @"设备尚未连接网络!")

#define ERROR_CODE_NOT_SUPPORTED_MULTITASKING_ERROR -107
#define ERROR_DESC_NOT_SUPPORTED_MULTITASKING_ERROR ShareSDKLocalizableString(@"ERROR_DESC_NOT_SUPPORTED_MULTITASKING_ERROR", @"不支持多任务处理")

#define ERROR_CODE_UNKNOWN -999
#define ERROR_DESC_UNKNOWN ShareSDKLocalizableString(@"ERROR_DESC_UNKNOWN", @"未知错误")

#define ERROR_CODE_SINA_WEIBO_NOT_INTEGRATED -1001
#define ERROR_DESC_SINA_WEIBO_NOT_INTEGRATED ShareSDKLocalizableString(@"ERROR_DESC_SINA_WEIBO_NOT_INTEGRATED", @"尚未集成新浪微博分享接口")

#define ERROR_CODE_SINA_WEIBO_NOT_INSTALL -1002
#define ERROR_DESC_SINA_WEIBO_NOT_INSTALL ShareSDKLocalizableString(@"ERROR_DESC_SINA_WEIBO_NOT_INSTALL", @"尚未安装新浪微博客户端");

#define ERROR_CODE_SINA_WEIBO_IS_NOT_SUPPORT -1003
#define ERROR_DESC_SINA_WEIBO_IS_NOT_SUPPORT ShareSDKLocalizableString(@"ERROR_DESC_SINA_WEIBO_IS_NOT_SUPPORT", @"当前新浪微博客户端版本不支持该功能");

#define ERROR_CODE_SINA_WEIBO_SEND_FAIL -1004
#define ERROR_DESC_SINA_WEIBO_SEND_FAIL ShareSDKLocalizableString(@"ERROR_DESC_SINA_WEIBO_SEND_FAIL", @"发送失败");

#define ERROR_CODE_PRINT_NOT_SUPPORT -20001
#define ERROR_DESC_PRINT_NOT_SUPPORT ShareSDKLocalizableString(@"ERROR_DESC_PRINT_NOT_SUPPORT", @"该设备不允许进行打印")

#define ERROR_CODE_MAIL_NOT_SUPPORT -18001
#define ERROR_DESC_MAIL_NOT_SUPPORT ShareSDKLocalizableString(@"ERROR_DESC_MAIL_NOT_SUPPORT", @"该设备不支持邮件分享或尚未设置邮件帐号")

#define ERROR_CODE_SMS_NOT_SUPPORT -19001
#define ERROR_DESC_SMS_NOT_SUPPORT ShareSDKLocalizableString(@"ERROR_DESC_SMS_NOT_SUPPORT", @"该设备不支持短信分享")

#define ERROR_CODE_FACEBOOK_CANCEL_ADD_FRIEND -10001
#define ERROR_DESC_FACEBOOK_CANCEL_ADD_FRIEND ShareSDKLocalizableString(@"ERROR_DESC_FACEBOOK_CANCEL_ADD_FRIEND", @"取消添加好友")

#define ERROR_CODE_FACEBOOK_NOT_INSTALL -10002
#define ERROR_DESC_FACEBOOK_NOT_INSTALL ShareSDKLocalizableString(@"ERROR_DESC_FACEBOOK_NOT_INSTALL", @"尚未安装Facebook客户端")

#define ERROR_CODE_TWITTER_GET_FRIENDS_API_DEPRECATED -11001
#define ERROR_DESC_TWITTER_GET_FRIENDS_API_DEPRECATED ShareSDKLocalizableString(@"ERROR_DESC_TWITTER_GET_FRIENDS_API_DEPRECATED", @"此方法已过时，请使用getFriendsWithPage方法代替")

#define ERROR_CODE_GOOGLE_PLUS_SEND_FAIL -14001
#define ERROR_DESC_GOOGLE_PLUS_SEND_FAIL ShareSDKLocalizableString(@"ERROR_DESC_GOOGLE_PLUS_SEND_FAIL", @"分享失败!")

#define ERROR_CODE_WEIXIN_NOT_INTEGRATED -22001
#define ERROR_DESC_WEIXIN_NOT_INTEGRATED ShareSDKLocalizableString(@"ERROR_DESC_WEIXIN_NOT_INTEGRATED", @"尚未集成微信接口")

#define ERROR_CODE_WEIXIN_UNKNOWN_MEDIA_TYPE -22002
#define ERROR_DESC_WEIXIN_UNKNOWN_MEDIA_TYPE ShareSDKLocalizableString(@"ERROR_DESC_WEIXIN_UNKNOWN_MEDIA_TYPE", @"未知的消息发送类型")

#define ERROR_CODE_WEIXIN_NOT_INSTALL -22003
#define ERROR_DESC_WEIXIN_NOT_INSTALL ShareSDKLocalizableString(@"ERROR_DESC_WEIXIN_NOT_INSTALL", @"尚未安装微信")

#define ERROR_CODE_WEIXIN_API_IS_NOT_SUPPORT -22004
#define ERROR_DESC_WEIXIN_API_IS_NOT_SUPPORT ShareSDKLocalizableString(@"ERROR_DESC_WEIXIN_API_IS_NOT_SUPPORT", @"当前微信版本不支持该功能")

#define ERROR_CODE_WEIXIN_SEND_REQUEST_ERROR -22005
#define ERROR_DESC_WEIXIN_SEND_REQUEST_ERROR ShareSDKLocalizableString(@"ERROR_DESC_WEIXIN_SEND_REQUEST_ERROR", @"请求微信OpenApi失败")

#define ERROR_CODE_WEIXIN_NOT_SET_URL_SCHEME -22006
#define ERROR_DESC_WEIXIN_NOT_SET_URL_SCHEME ShareSDKLocalizableString(@"ERROR_DESC_WEIXIN_NOT_SET_URL_SCHEME", @"尚未设置微信的URL Scheme")

#define ERROR_CODE_QQ_SEND_FAIL -24001
#define ERROR_DESC_QQ_SEND_FAIL ShareSDKLocalizableString(@"ERROR_DESC_QQ_SEND_FAIL", @"发送失败")

#define ERROR_CODE_QQ_NOT_INSTALLED -24002
#define ERROR_DESC_QQ_NOT_INSTALLED ShareSDKLocalizableString(@"ERROR_DESC_QQ_NOT_INSTALLED", @"尚未安装QQ")

#define ERROR_CODE_QQ_API_IS_NOT_SUPPORT -24003
#define ERROR_DESC_QQ_API_IS_NOT_SUPPORT ShareSDKLocalizableString(@"ERROR_DESC_QQ_API_IS_NOT_SUPPORT", @"当前QQ版本不支持该功能")

#define ERROR_CODE_QQ_UNKNOWN_MEDIA_TYPE -24004
#define ERROR_DESC_QQ_UNKNOWN_MEDIA_TYPE ShareSDKLocalizableString(@"ERROR_DESC_QQ_UNKNOWN_MEDIA_TYPE", @"未知的消息发送类型")

#define ERROR_CODE_QQ_NOT_INTEGRATED -24005
#define ERROR_DESC_QQ_NOT_INTEGRATED ShareSDKLocalizableString(@"ERROR_DESC_QQ_NOT_INTEGRATED", @"尚未集成QQ接口")

#define ERROR_CODE_QQ_NOT_SET_URL_SCHEME -24006
#define ERROR_DESC_QQ_NOT_SET_URL_SCHEME ShareSDKLocalizableString(@"ERROR_DESC_QQ_NOT_SET_URL_SCHEME", @"尚未设置QQ的URL Scheme")

#endif
