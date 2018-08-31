//
//  UPConst.h
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

///------------------------------
/// @name block
///------------------------------
@class UPNetworkErrorModel;
typedef void (^ UPDefBoolBlock) (BOOL flag);
typedef void (^ UPDefNilBlock) (void);
typedef void (^ UPDefStringBlock) (NSString *string);
typedef void (^ UPDefDataBlock) (NSData *data);
typedef void (^ UPDefIntegerBlock) (NSInteger integer);
typedef void (^ UPDefUIntegerBlock) (NSUInteger uinteger);
typedef void (^ UPDefFloatBlock) (CGFloat progress);
typedef void (^ UPDefDictionatyBlock) (NSDictionary *dictionary);
typedef void (^ UPDefArrayBlock) (NSArray *array);
typedef void (^ UPDefIdObjBlock) (id response);
typedef void (^ UPDefNetworkFailureBlock) (UPNetworkErrorModel *model);


///------------------------------
/// @name enum
///------------------------------
typedef NS_ENUM(NSInteger, UPCardDirection) {
    UPCardDirectionFront,
    UPCardDirectionBack
};

///------------------------------
/// @name app config
///------------------------------

/** AppleIDString */
UIKIT_EXTERN NSString *const UPAppIDString;
/** AppleURLStr */
UIKIT_EXTERN NSString *const UPAppURLStr;

/** AppleId number */
UIKIT_EXTERN const NSInteger UPAppID;

/** 服务器基地址 */
UIKIT_EXTERN NSString *const UPAPIBaseURL;
/** 服务器基准地址  */
UIKIT_EXTERN NSString *const UPAPIBaseLineURL;

/** UM app key */
UIKIT_EXTERN NSString *const UmSocialAppkey;
/** 微信AppleID */
UIKIT_EXTERN NSString *const UPWeChatAppID;
/** 微信私有key */
UIKIT_EXTERN NSString *const UPkWeChatAppSecret;
/** 新浪AppleId */
UIKIT_EXTERN NSString *const UPSinaAppID;
/** 新浪私有key */
UIKIT_EXTERN NSString *const UPSinaAppSecret;
/** QQ私有key */
UIKIT_EXTERN NSString *const UPQQKey;
/** QQAppleId */
UIKIT_EXTERN NSString *const UPQQID;

/** talkingdata ID */
UIKIT_EXTERN NSString *const UPTalkingDataAppID;

/** UPBuglyAppId */
UIKIT_EXTERN NSString *const UPBuglyAppId;

/** 课程退款服务器地址 */
UIKIT_EXTERN NSString *const UPCourseRefundUrl;
/** 课程退款js交互key */
UIKIT_EXTERN NSString *const UPCourseObservesJSKey;

///------------------------------
/// @name pay
///------------------------------

/** Alipay URL scheme */
UIKIT_EXTERN NSString *const UPAlipayURLScheme;


///------------------------------
/// @name value
///------------------------------

/** 布局默认左右空间 15.0 */
UIKIT_EXTERN const CGFloat UPDefaultEdgeSpace;
/** 布局默认上下空间 16.0 */
UIKIT_EXTERN const CGFloat UPDefaultTpBmSpace;
/** 线条默认窄距 0.5 */
UIKIT_EXTERN const CGFloat UPDefaultLineNarrow;
/** app默认动画时长 0.25 */
UIKIT_EXTERN const CGFloat UPDefaultAnimationDuration;

/** 自制卡片最小长度 0 */
UIKIT_EXTERN const NSInteger UPEditCardMinLength;
/** 自制卡片最大长度 500 */
UIKIT_EXTERN const NSInteger UPEditCardMaxLength;
/** 自制卡片文本开始提醒字数 20 */
UIKIT_EXTERN const NSInteger UPEditCardRemindLength;

/** 自制卡包最小长度 0 */
UIKIT_EXTERN const NSInteger UPEditPackageMinLength;
/** 自制卡包最大长度 15 */
UIKIT_EXTERN const NSInteger UPEditPackageMaxLength;

/** 卡片反转动画时长 0.3 */
UIKIT_EXTERN const CGFloat UPCardFilpAnimationDuration;

/** HUD默认展示时间 1.5s */
UIKIT_EXTERN const NSTimeInterval UPHUDDuration;

/** 每天包含的秒数 60 * 60 * 24 */
UIKIT_EXTERN const NSInteger UPDaySeconds;
/** 时区交错秒数 60 * 60 * 8 */
UIKIT_EXTERN const NSInteger UPNMOSeconds;

/** 1024 * 1024 * 5 */
UIKIT_EXTERN const NSInteger UPPictureMaxLength;

/** 编辑留言最大长度 300 */
UIKIT_EXTERN const NSInteger UPMessageMaxLength;

/** 个性签名最大长度 30 */
UIKIT_EXTERN const NSInteger UPSignatureMaxLength;

/** 反馈信息最大长度 2048 */
UIKIT_EXTERN const NSInteger UPFeedbackMaxLength;
/** 反馈信息最小长度 5 */
UIKIT_EXTERN const NSInteger UPFeedbackMinLength;

/** 昵称最大字符 20 */
UIKIT_EXTERN const NSInteger UPUserNickMaxLength;
/** 昵称最小字符 2 */
UIKIT_EXTERN const NSInteger UPUserNickMinLength;

/** 网络不可用 404 */
UIKIT_EXTERN const NSInteger UPNetworkUnenable;

/** 密码最小长度 6 */
UIKIT_EXTERN const NSInteger UPPasswordMinLength;
/** 密码最大长度 16 */
UIKIT_EXTERN const NSInteger UPPasswordMaxLength;

/** 数据库不重要数据更新间隔 5 */
UIKIT_EXTERN const NSInteger UPDatabaeUpdateSpace;

/** 课程允许退款时间 30d */
UIKIT_EXTERN const NSInteger UPCourseAllowRefundTime;

/** 音频章节浮动范围 0.05 */
UIKIT_EXTERN const CGFloat UPAudioProgressFloatRange;

/** 课程有用人数间隔 1000 */
UIKIT_EXTERN const CGFloat UPCourseLikeSpaceNumber;

/** 举报最大描述符 50 */
UIKIT_EXTERN const CGFloat UPMessageReportReasonMax;

///------------------------------
/// @name qiniu
///------------------------------
/** 七牛 HTTPS prefix */
UIKIT_EXTERN NSString *const UPQiNiuHttpsLink;
/** 七牛 HTTP prefix */
UIKIT_EXTERN NSString *const UPQiNiuHttpLink;
/** 七牛上传token有效时间 value = 60 * 10 */
UIKIT_EXTERN const NSInteger UPQiNiuUpLoadTokenValidTime;
/** 七牛音频基础url prefix */
UIKIT_EXTERN NSString *const UPQiNiuAudioHttpsLink;
/** 七牛音频下载链接过期时长 value = 60 * 10 */
UIKIT_EXTERN const NSInteger UPQiNiuAudioLinkValidTime;

///------------------------------
/// @name keychain
///------------------------------

/** 钥匙链 uuid 保存key */
UIKIT_EXTERN NSString *const UPKeychainUUIDKey;

///------------------------------
/// @name 音频解密
///------------------------------

/** 音频解密 密码 */
UIKIT_EXTERN NSString *const UPRNCryptorPassword;

///------------------------------
/// @name 通知
///------------------------------

/** 用户退出 */
UIKIT_EXTERN NSString *const UPUserLoginOut;
/** 网络状态改变通知 */
UIKIT_EXTERN NSString *const UPNetworkStatusChange;

/** 新的一天来临 */
UIKIT_EXTERN NSString *const UPNewDayComing;

/** 服务器有新消息提醒 */
UIKIT_EXTERN NSString *const UPMeNewFeedbackMessage;

/** 同步数据开始 */
UIKIT_EXTERN NSString *const UPSyncDataStart;
/** 同步数据成功 */
UIKIT_EXTERN NSString *const UPSyncDataSuccess;
/** 同步数据失败 */
UIKIT_EXTERN NSString *const UPSyncDataFailure;

/** 下载音频成功 */
UIKIT_EXTERN NSString *const UPDownloadAudioSuccess;
/** 下载音频失败 */
UIKIT_EXTERN NSString *const UPDownloadAudioFailure;
/** 下载音频进度 */
UIKIT_EXTERN NSString *const UPDownloadAudioProgress;
/** 下载音频进度 userinfo key */
UIKIT_EXTERN NSString *const UPDownloadAudioProgressKey;

/** 下载音频改变通知 */
UIKIT_EXTERN NSString *const UPDownloadedAudioChange;
/** 购买课程数量发生改变 */
UIKIT_EXTERN NSString *const UPPurchasedCourseChange;

/** 课程准备完成 */
UIKIT_EXTERN NSString *const UPCoursePrepareComplete;

/** 章节学习排序发成改变 */
UIKIT_EXTERN NSString *const UPSectionLearnRankChange;
/** 章节进度发生改变 */
UIKIT_EXTERN NSString *const UPSectionProgressChange;
/** 章节进度发生改变 进度key值 */
UIKIT_EXTERN NSString *const UPSectionProgressKey;
/** 章节进度发生改变 章节key值 */
UIKIT_EXTERN NSString *const UPSection_uuidKey;
/** 章节学习状态发生改变 */
UIKIT_EXTERN NSString *const UPSectionLearnStatusChange;
/** 章节学习状态发生改变 状态key值 */
UIKIT_EXTERN NSString *const UPSectionLearnStatusKey;


///------------------------------
/// @name 修改用户信息
///------------------------------
/** 昵称 */
UIKIT_EXTERN NSString *const UPModifyUserInfoNickName;
/** 头像 */
UIKIT_EXTERN NSString *const UPModifyUserInfoAvatar;
/** 性别 */
UIKIT_EXTERN NSString *const UPModifyUserInfoGender;
/** 出生年 */
UIKIT_EXTERN NSString *const UPModifyUserInfoBirthday;
/** 所在地 */
UIKIT_EXTERN NSString *const UPModifyUserInfoAddress;
/** 学历 */
UIKIT_EXTERN NSString *const UPModifyUserInfoEducation;
/** 行业 */
UIKIT_EXTERN NSString *const UPModifyUserInfoTrade;
/** 职业 */
UIKIT_EXTERN NSString *const UPModifyUserInfoProfession;
/** 一句话简介 */
UIKIT_EXTERN NSString *const UPModifyUserInfoIntro;


///------------------------------
/// @name share
///------------------------------

/** 分享文章的前缀 */
UIKIT_EXTERN NSString *const UPShareArticlePrefix;


///------------------------------
/// @name 文章外链
///------------------------------

/** 文章外链的前缀 token */
UIKIT_EXTERN NSString *const UPArticleUrlTokenPrefix;
