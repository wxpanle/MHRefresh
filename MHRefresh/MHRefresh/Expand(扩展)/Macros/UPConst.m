//
//  UPConst.m
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPConst.h"


#pragma mark - ===== app config =====

NSString *const UPAppIDString = @"";
NSString *const UPAppURLStr = @"";

const NSInteger UPAppID = 1384344043;

#ifdef DEBUG
NSString *const UPAPIBaseURL = @"";
#else
NSString *const UPAPIBaseURL = @"";
#endif

NSString *const UPAPIBaseLineURL = @"";

NSString *const UmSocialAppkey = @"";
NSString *const UPWeChatAppID = @"";
NSString *const UPkWeChatAppSecret = @"";
NSString *const UPSinaAppID = @"";
NSString *const UPSinaAppSecret = @"";
NSString *const UPQQKey = @"";
NSString *const UPQQID = @"";

NSString *const UPTalkingDataAppID = @"";

NSString *const UPBuglyAppId = @"";

NSString *const UPCourseRefundUrl = @"";
NSString *const UPCourseObservesJSKey = @"";


#pragma mark - pay

NSString *const UPAlipayURLScheme = @"";

#pragma mark - value

const CGFloat UPDefaultEdgeSpace = 15.0;
const CGFloat UPDefaultTpBmSpace = 16.0;
const CGFloat UPDefaultLineNarrow = 0.5;
const CGFloat UPDefaultAnimationDuration = 0.25;

const NSInteger UPEditCardMinLength = 0;
const NSInteger UPEditCardMaxLength = 500;
const NSInteger UPEditCardRemindLength = 20;

const NSInteger UPEditPackageMinLength = 0;
const NSInteger UPEditPackageMaxLength = 15;

const CGFloat UPCardFilpAnimationDuration = 0.3;

const NSTimeInterval UPHUDDuration = 1.5;

const NSInteger UPDaySeconds = 60 * 60 * 24;
const NSInteger UPNMOSeconds = 60 * 60 * 8;

const NSInteger UPPictureMaxLength = 1024 * 1024 * 5;

const NSInteger UPMessageMaxLength = 300;

const NSInteger UPSignatureMaxLength = 30;

const NSInteger UPFeedbackMaxLength = 2048;
const NSInteger UPFeedbackMinLength = 5;

const NSInteger UPUserNickMaxLength = 20;
const NSInteger UPUserNickMinLength = 2;

const NSInteger UPNetworkUnenable = 404;

const NSInteger UPPasswordMinLength = 6;
const NSInteger UPPasswordMaxLength = 16;

const NSInteger UPDatabaeUpdateSpace = 5;

const NSInteger UPCourseAllowRefundTime = 30;

const CGFloat UPAudioProgressFloatRange = 0.05;

const CGFloat UPCourseLikeSpaceNumber = 1000;

const CGFloat UPMessageReportReasonMax = 50;

#pragma mark - qiniu

NSString *const UPQiNiuHttpsLink = @"";
NSString *const UPQiNiuHttpLink = @"";
const NSInteger UPQiNiuUpLoadTokenValidTime = 60 * 10;
NSString *const UPQiNiuAudioHttpsLink = @"";
const NSInteger UPQiNiuAudioLinkValidTime = 60 * 10;

#pragma mark - keychain

NSString *const UPKeychainUUIDKey = @"";

#pragma mark - 音频解密

NSString *const UPRNCryptorPassword = @"";

#pragma mark - 通知

NSString *const UPUserLoginOut = @"";
NSString *const UPNetworkStatusChange = @"";

NSString *const UPNewDayComing = @"";

NSString *const UPMeNewFeedbackMessage = @"";

NSString *const UPSyncDataStart = @"";
NSString *const UPSyncDataSuccess = @"";
NSString *const UPSyncDataFailure = @"";

NSString *const UPDownloadedAudioSuccess = @"";

NSString *const UPDownloadAudioSuccess = @"";
NSString *const UPDownloadAudioFailure = @"";
NSString *const UPDownloadAudioProgress = @"";
NSString *const UPDownloadAudioProgressKey = @"";

NSString *const UPDownloadedAudioChange = @"";
NSString *const UPPurchasedCourseChange = @"";

NSString *const UPCoursePrepareComplete = @"";

NSString *const UPSectionLearnRankChange = @"";
NSString *const UPSectionProgressChange = @"";
NSString *const UPSectionProgressKey = @"";
NSString *const UPSection_uuidKey = @"";
NSString *const UPSectionLearnStatusChange = @"";
NSString *const UPSectionLearnStatusKey = @"";

#pragma mark - 修改用户信息

NSString *const UPModifyUserInfoNickName = @"";
NSString *const UPModifyUserInfoAvatar = @"";
NSString *const UPModifyUserInfoGender = @"";
NSString *const UPModifyUserInfoBirthday = @"";
NSString *const UPModifyUserInfoAddress = @"";
NSString *const UPModifyUserInfoEducation = @"";
NSString *const UPModifyUserInfoTrade = @"";
NSString *const UPModifyUserInfoProfession = @"";
NSString *const UPModifyUserInfoIntro = @"";


//#pragma mark - share
//
NSString *const UPShareArticlePrefix = @"";
//
//
//#pragma mark - 文章外链
//
NSString *const UPArticleUrlTokenPrefix = @"";
