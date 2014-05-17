//
//  LSHHTTPEngine.h
//  LuShiHelper
//
//  Created by Brian on 13-11-12.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHttpEngine.h"
#import "CTSerializeObject.h"
#import "BaseDefine.h"
#import "BaseHTTPCache.h"

#import "gm861ClientUpdateRequest.h"
#import "gm862_2GetVerifyImageRequest.h"
#import "gm862SendVerifyRequest.h"
#import "gm863VerifyRequest.h"
#import "gm864RegistRequest.h"
#import "gm865LoginRequest.h"
#import "gm865_2LoginRequest.h"
#import "gm866SetPasswordRequest.h"
#import "gm867RecommendElementRequest.h"
#import "gm868SendElementRequest.h"
#import "gm869RecommendAttRequest.h"
#import "gm8610AttManagerRequest.h"
#import "gm8610_2AttListRequest.h"
#import "gm8611HotTagRequest.h"
#import "gm8612SelfSettingRequest.h"
#import "gm8613NewsManagerRequest.h"
#import "gm8614NewsRequest.h"
#import "gm8615ZanRequest.h"
#import "gm8616ColManagerRequest.h"
#import "gm8617PersonDetailRequest.h"
#import "gm8618CommentListRequest.h"
#import "gm8619CommentManagerRequest.h"
#import "gm8620SearchRequest.h"
#import "gm8621InviteFriendsRequest.h"
#import "gm8622PushSettingRequest.h"
#import "gm8622_2PushSettingRequest.h"
#import "gm8623MessageManagerRequest.h"
#import "gm8624GameRecommendRequest.h"
#import "gm8625FocusFigureRequest.h"
#import "gm8626ClassificationRequest.h"
#import "gm8627ScreeningRequest.h"
#import "gm8628GameDetailRequest.h"
#import "gm8629SearchGameRequest.h"
#import "gm8630CollectManagerRequest.h"
#import "gm8631MyCollectGamesRequest.h"

#import "gm864_2NicknameCheckRequest.h"
@interface LSHHTTPEngine : NSObject
{
    BaseHTTPCache* httpCache;
}

@property (strong, nonatomic) BaseHttpEngine* httpEngine;
@property (nonatomic, copy) NSString* ipAddress;
@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* uuid;

+ (id)getInstance;

//- (void)getInfoDetail:(NSString*)urlString success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

#pragma mark - 1-9
- (void)sendUpdate:(gm861ClientUpdateRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendSendVerify:(gm862SendVerifyRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendGetVerifyImage:(gm862_2GetVerifyImageRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendVerify:(gm863VerifyRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendRegist:(gm864RegistRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendNicknameCheck:(gm864_2NicknameCheckRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendLogin:(gm865LoginRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendThirdLogin:(gm865LoginRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendSetPassword:(gm866SetPasswordRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendRecommendElement:(gm867RecommendElementRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendSendElement:(gm868SendElementRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendRecommendAtt:(gm869RecommendAttRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

#pragma mark - 10-19

- (void)sendAttList:(gm8610_2AttListRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendAttManager:(gm8610AttManagerRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendHotTag:(gm8611HotTagRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendSelfSetting:(gm8612SelfSettingRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendNewsManager:(gm8613NewsManagerRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail delegate:(id<ASIProgressDelegate>)delegate;

- (void)sendNews:(gm8614NewsRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendZan:(gm8615ZanRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendColManager:(gm8616ColManagerRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendPersonDetail:(gm8617PersonDetailRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendCommentList:(gm8618CommentListRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendCommentManager:(gm8619CommentManagerRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

#pragma mark - 20-29
- (void)sendSearch:(gm8620SearchRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendInviteFriends:(gm8621InviteFriendsRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendPushSetting:(gm8622PushSettingRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendPushSettingtwo:(gm8622_2PushSettingRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendMessageManager:(gm8623MessageManagerRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendGameRecommend:(gm8624GameRecommendRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendFocusFigure:(gm8625FocusFigureRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendClassification:(gm8626ClassificationRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendScreening:(gm8627ScreeningRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendGameDetail:(gm8628GameDetailRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendSearchGame:(gm8629SearchGameRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

#pragma mark - 30-39

- (void)sendCollectGameManager:(gm8630CollectManagerRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)sendMyCollectGame:(gm8631MyCollectGamesRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

@end
