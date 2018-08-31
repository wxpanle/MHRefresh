//
//  UPConst.m
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPConst.h"


#pragma mark - ===== app config =====

NSString *const UPAppIDString = @"1384344043";
NSString *const UPAppURLStr = @"https://itunes.apple.com/us/app/ji-yi-guan-jia/id1384344043?l=zh&ls=1&mt=8";

const NSInteger UPAppID = 1384344043;

#ifdef DEBUG
NSString *const UPAPIBaseURL = @"https://api.wupup.com/v1";
#else
NSString *const UPAPIBaseURL = @"https://api.wupup.com/v1";
#endif

NSString *const UPAPIBaseLineURL = @"https://api.wupup.com/";

NSString *const UmSocialAppkey = @"571f5e7d67e58e052e000745";
NSString *const UPWeChatAppID = @"wxedaa23e8c4c1fbcc";
NSString *const UPkWeChatAppSecret = @"75a5860141615d31a48290b05c7f5964";
NSString *const UPSinaAppID = @"206245323";
NSString *const UPSinaAppSecret = @"f7a336e38cee4c0c9dfd2db7a49d007a";
NSString *const UPQQKey = @"TYuWlWodtzbQlEiY";
NSString *const UPQQID = @"1106820828";

NSString *const UPTalkingDataAppID = @"76874D57CADB481F914C2EF397843EA0";

NSString *const UPBuglyAppId = @"b3207858b8";

NSString *const UPCourseRefundUrl = @"https://s.wupup.com/question/refund?os=1";
NSString *const UPCourseObservesJSKey = @"Mobile";


#pragma mark - pay

NSString *const UPAlipayURLScheme = @"upslgailpay";

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

NSString *const UPQiNiuHttpsLink = @"https://up-static.wupup.com/";
NSString *const UPQiNiuHttpLink = @"http://up-static.wupup.com/";
const NSInteger UPQiNiuUpLoadTokenValidTime = 60 * 10;
NSString *const UPQiNiuAudioHttpsLink = @"https://audio.wupup.com";
const NSInteger UPQiNiuAudioLinkValidTime = 60 * 10;

#pragma mark - keychain

NSString *const UPKeychainUUIDKey = @"up_keychainUUID_key";

#pragma mark - 音频解密

NSString *const UPRNCryptorPassword = @"com.lg.audio.play.password";

#pragma mark - 通知

NSString *const UPUserLoginOut = @"UPUserLoginOut";
NSString *const UPNetworkStatusChange = @"UPNetworkStatusChange";

NSString *const UPNewDayComing = @"UPNewDayComing";

NSString *const UPMeNewFeedbackMessage = @"UPMeNewFeedbackMessage";

NSString *const UPSyncDataStart = @"UPSyncDataStart";
NSString *const UPSyncDataSuccess = @"UPSyncDataSuccess";
NSString *const UPSyncDataFailure = @"UPSyncDataFailure";

NSString *const UPDownloadedAudioSuccess = @"UPDownloadedAudioSuccess";

NSString *const UPDownloadAudioSuccess = @"UPDownloadAudioSuccess";
NSString *const UPDownloadAudioFailure = @"UPDownloadAudioFailure";
NSString *const UPDownloadAudioProgress = @"UPDownloadAudioProgress";
NSString *const UPDownloadAudioProgressKey = @"UPDownloadAudioProgressKey";

NSString *const UPDownloadedAudioChange = @"UPDownloadedAudioChange";
NSString *const UPPurchasedCourseChange = @"UPPurchasedCourseChange";

NSString *const UPCoursePrepareComplete = @"UPCoursePrepareComplete";

NSString *const UPSectionLearnRankChange = @"UPSectionLearnRankChange";
NSString *const UPSectionProgressChange = @"UPSectionProgressChange";
NSString *const UPSectionProgressKey = @"UPSectionProgressKey";
NSString *const UPSection_uuidKey = @"UPSection_uuidKey";
NSString *const UPSectionLearnStatusChange = @"UPSectionLearnStatusChange";
NSString *const UPSectionLearnStatusKey = @"UPSectionLearnStatusKey";

#pragma mark - 修改用户信息

NSString *const UPModifyUserInfoNickName = @"UPModifyUserInfoNickName";
NSString *const UPModifyUserInfoAvatar = @"UPModifyUserInfoAvatar";
NSString *const UPModifyUserInfoGender = @"UPModifyUserInfoGender";
NSString *const UPModifyUserInfoBirthday = @"UPModifyUserInfoBirthday";
NSString *const UPModifyUserInfoAddress = @"UPModifyUserInfoAddress";
NSString *const UPModifyUserInfoEducation = @"UPModifyUserInfoEducation";
NSString *const UPModifyUserInfoTrade = @"UPModifyUserInfoTrade";
NSString *const UPModifyUserInfoProfession = @"UPModifyUserInfoProfession";
NSString *const UPModifyUserInfoIntro = @"UPModifyUserInfoIntro";


#pragma mark - share

NSString *const UPShareArticlePrefix = @"https://s.wupup.com/share/course?cid=";


#pragma mark - 文章外链

NSString *const UPArticleUrlTokenPrefix = @"https://s.wupup.com/display/article?token=";
