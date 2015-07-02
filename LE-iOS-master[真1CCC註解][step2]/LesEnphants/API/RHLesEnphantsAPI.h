//
//  RHLesEnphantsAPI.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/7/21.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
@protocol RHLesEnphantsAPIDelegate <NSObject>

@optional
- ( void )callBackKeepAliveStatus:( NSDictionary * )pStatusDic;
- ( void )callBackResetPasswordStatus:( NSDictionary * )pStatusDic;
- ( void )callBackLoginStatus:( NSDictionary * )pStatusDic;
- ( void )callBackSetLoginTypeStatus:( NSDictionary * )pStatusDic;
- ( void )callBackUpdateDeviceTokenStatus:( NSDictionary * )pStatusDic;
- ( void )callBackSetUserProfileStatus:( NSDictionary * )pStatusDic;
- ( void )callBackSetUserPhotoStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetUserProfileStatus:( NSDictionary * )pStatusDic;
- ( void )callBackAddPregnantRecordStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetPregnantRecordStatus:( NSDictionary * )pStatusDic;
- ( void )callBackDelPregnantRecordStatus:( NSDictionary * )pStatusDic;

- ( void )callBackAddPregnantEventStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetPregnantEventStatus:( NSDictionary * )pStatusDic;
- ( void )callBackAddPregnantWeightStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetPregnantWeightStatus:( NSDictionary * )pStatusDic;

- ( void )callBackGetKnowledgeListStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetKnowledgeContentStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetNewsListStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetNewsContentStatus:( NSDictionary * )pStatusDic;
- ( void )callBackSetmatchIdStatus:( NSDictionary * )pStatusDic;
- ( void )callBackSetRecommandIdStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetUserByMatchID:( NSDictionary * )pStatusDic;
- ( void )callBackAddUserToFriendByMatchID:( NSDictionary * )pStatusDic;
- ( void )callBackDeleteUserToFriendByMatchID:( NSDictionary * )pStatusDic;
- ( void )callBackAddNewTotoStatus:( NSDictionary * )pStatusDic;
- ( void )callBackDeleteTotoStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetTodoList:( NSDictionary * )pStatusDic;
- ( void )callBackReadTodoStatus:( NSDictionary * )pStatusDic;
- ( void )callBackReportTodoStatus:( NSDictionary * )pStatusDic;
- ( void )callBackConfirmTodoStatus:( NSDictionary * )pStatusDic;
- ( void )callBackUploadFileForChatStatus:( NSDictionary * )pStatusDic;
- ( void )callBackQrCodeImage:( NSDictionary * )pStatusDic;
- ( void )callBackQrCodeImage2:( NSDictionary * )pStatusDic;
- ( void )callBackuploadMoodImage:( NSDictionary * )pStatusDic;
- ( void )callBackSetMotherMoodImage:( NSDictionary * )pStatusDic;
- ( void )callBackGetMotherMoodImage:( NSDictionary * )pStatusDic;
- ( void )callBackGetMotherMoodStatistics:( NSDictionary * )pStatusDic;
- ( void )callBackPushMotherMoodStatus:( NSDictionary * )pStatusDic;
- ( void )callBackExchangePointStatus:( NSDictionary * )pStatusDic;
- ( void )callBackSetRegardStatus:( NSDictionary * )pStatusDic;
- ( void )callBackUpdateEventStatus:( NSDictionary * )pStatusDic;
- ( void )callBackUpdateNotesStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetEmontionDBStatus:( NSDictionary * )pStatusDic;
- ( void )callBackShareRecordStatus:( NSDictionary * )pStatusDic;
- ( void )callBackShareAppStatus:( NSDictionary * )pStatusDic;
- ( void )callBackCommentPostStatus:( NSDictionary * )pStatusDic;

/********   Association   *******/
- ( void )callBackGetAssociationListStatus:( NSDictionary * )pStatusDic;
- ( void )callBackNewAssociationByClassStatus:( NSDictionary * )pStatusDic;
- ( void )callBackUpdateAssociationByClassStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetMyAssociationListStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetAssociationByClassStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetAssociationPostStatus:( NSDictionary * )pStatusDic;
- ( void )callBackDeleteAssociationPostStatus:( NSDictionary * )pStatusDic;
- ( void )callBackDeleteAssociationCommentStatus:( NSDictionary * )pStatusDic;
- ( void )callBackLikeAssociationPostStatus:( NSDictionary * )pStatusDic;
- ( void )callBackReportAssociationPostStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGerAssociationTopListStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetAssociationByIdStatus:( NSDictionary * )pStatusDic;
- ( void )callBackSearchAssociationStatus:( NSDictionary * )pStatusDic;
- ( void )callBackNewAssociationPostStatus:( NSDictionary * )pStatusDic;
- ( void )callBackJoinAssociationPostStatus:( NSDictionary * )pStatusDic;
- ( void )callBackLeaveAssociationPostStatus:( NSDictionary * )pStatusDic;
- ( void )callBackAcceptAssociationStatus:( NSDictionary * )pStatusDic;
- ( void )callBackSetAssociationPermissionStatus:( NSDictionary * )pStatusDic;
- ( void )callBackKickMemberFromAssociationStatus:( NSDictionary * )pStatusDic;
- ( void )callBackGetAssociationCommentStatus:( NSDictionary * )pStatusDic;
@end

@interface RHLesEnphantsAPI : NSObject
{

}

#pragma mark - Utility
+ ( NSInteger )getDeviceTypeID;
+ ( NSInteger )getLoginTypeID:( NSString * )pstrType;
+ ( void )printPostData:( ASIFormDataRequest * )pRequest;
+( NSString * )getLanID;

#pragma mark - Class Methods

/**
 @Server : http://itri-le-s.xtremeapp.com.tw
 */


/**
 @函式編號 : #[API00]
 @函式說明 : Keep Alive
 @URL : /user/keep-alive.api
 @傳入參數 : NSDictionary ( psid )
 @回傳參數 : NONE
 **/
+ ( void )KeepAlive:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_5.2]
 @函式說明 : 登入
 @URL : /reset-password.api
 @傳入參數 : NSDictionary ( email )
 @回傳參數 : NONE
 **/
+ ( void )ResetPassword:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API01]
 @函式說明 : 登入
 @URL : /login.api
 @傳入參數 : NSDictionary ( Account, Password, Type )
 @回傳參數 : NONE
 **/
+ ( void )Login:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API02]
 @函式說明 : 設定身份，guest不需呼叫
 @URL : /user/set-login-type.api
 @傳入參數 : NSDictionary ( psid, loginType )
 @回傳參數 : NONE
 **/
+ ( void )setLoginType:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API03]
 @函式說明 : Update Device Token
 @URL : /user/update-device-token.api
 @傳入參數 : NSDictionary ( psid, deviceToken )
 @回傳參數 : NONE
 **/
+ ( void )updateDeviceToken:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API04]
 @函式說明 : 設定Prifle
 @URL : /user/set-profile.api
 @傳入參數 : NSDictionary ( psid, nickname, gestation, mobile, email, birthday, height )
 @回傳參數 : NONE
 **/
+ ( void )setUserProfile:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API05]
 @函式說明 : 設定大頭貼
 @URL : /user/upload-photo.api
 @傳入參數 : NSDictionary ( psid, photo )
 @回傳參數 : NONE
 **/
+ ( void )setuserPhoto:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API06]
 @函式說明 : Get User Profile
 @URL : /user/get-profile.api
 @傳入參數 : NSDictionary ( psid )
 @回傳參數 : NONE
 **/
+ ( void )getUserProfile:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API07]
 @函式說明 : 懷孕記事，新增記錄 ( 胎心音，超音波，身型 )
 @URL : /user/new-record.api
 @傳入參數 : NSDictionary ( psid, type, file, time, meta )
 Type -> 
 0 unknow
 1 mother’s body
 2 ￼baby’s heart
 3 baby’s ultrasonic photo
 @回傳參數 : NONE
 **/
+ ( void )addPreganatRecord:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API08]
 @函式說明 : 懷孕記事，取回記錄
 @URL : /user/get-record.api
 @傳入參數 : NSDictionary ( psid, type, filter, keyword )
 @回傳參數 : NONE
 **/
+ ( void )getPreganatRecord:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API09]
 @函式說明 : 懷孕記事，刪除記錄
 @URL : /user/delete-record.api
 @傳入參數 : NSDictionary ( psid, recordID )
 @回傳參數 : NONE
 **/
+ ( void )deletePreganatRecord:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API10]
 @函式說明 : 懷孕記事，新增行事曆
 @URL : /user/new-event.api
 @傳入參數 : NSDictionary ( psid, isPrenatalExamination, date, start, end, subject )
 @回傳參數 : NONE
 **/
+ ( void )addPregnantEvent:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API11]
 @函式說明 : 懷孕記事，取回行事曆
 @URL : /user/get-event.api
 @傳入參數 : NSDictionary ( psid, type, filter, keyword )
 @回傳參數 : NONE
 **/
+ ( void )getPregnantEvent:( NSDictionary * )pParameter Source:( id )sourceDelegate;
/**
 @函式編號 : #[API12]
 @函式說明 : 懷孕記事，新增體重
 @URL : /user/new-weight.api
 @傳入參數 : NSDictionary ( psid, date, weight )
 @回傳參數 : NONE
 **/
+ ( void )addWeightRecord:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API13]
 @函式說明 : 懷孕記事，取回體重
 @URL : /user/get-weight.api
 @傳入參數 : NSDictionary ( psid )
 @回傳參數 : NONE
 **/
+ ( void )getWeightRecord:( NSDictionary * )pParameter Source:( id )sourceDelegate;
/**
 @函式編號 : #[API14]
 @函式說明 : 取得寶典列表
 @URL : /user/get-knowledge-category.api
 @傳入參數 : NSDictionary ( psid )
 @回傳參數 : NONE
 **/
+ ( void )getKnowledgeList:( NSDictionary * )pParameter Source:( id )sourceDelegate;
/**
 @函式編號 : #[API15]
 @函式說明 : 取得寶典內容
 @URL : /user/get-knowledge-content.api
 @傳入參數 : NSDictionary ( psid, filter, keyword )
 @回傳參數 : NONE
 **/
+ ( void )getKnowledgeContent:( NSDictionary * )pParameter Source:( id )sourceDelegate;
/**
 @函式編號 : #[API16]
 @函式說明 : 取得好康資訊列表
 @URL : /user/get-news-category.api
 @傳入參數 : NSDictionary ( psid )
 @回傳參數 : NONE
 **/
+ ( void )getNewsList:( NSDictionary * )pParameter Source:( id )sourceDelegate;
/**
 @函式編號 : #[API17]
 @函式說明 : 取得好康資訊內容
 @URL : /user/get-news-content-1.api
 /user/get-news-content-2.api
 /user/get-news-content-3.api
 /user/get-news-content-4.api
 /user/get-news-content-5.api
 /user/get-news-content-6.api
 @傳入參數 : NSDictionary ( psid, ContentType )
 @回傳參數 : NONE
 **/
+ ( void )getNewsContent:( NSDictionary * )pParameter Source:( id )sourceDelegate CntType:( NSInteger )nType;

/**
 @函式編號 : #[API18]
 @函式說明 : 修改用者的MatchID
 @URL : /user/set-match-id.api
 @傳入參數 : NSDictionary ( psid, MatchID )
 @回傳參數 : NONE
 **/
+ ( void )setMatchID:( NSDictionary * )pParameter Source:( id )sourceDelegate;
/**
 @函式編號 : #[API19]
 @函式說明 : Set Recommend ID
 @URL : /user/set-recommand-id.api
 @傳入參數 : NSDictionary ( psid, recommandID )
 @回傳參數 : NONE
 **/
+ ( void )setRecommandID:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.24]
 @函式說明 : 依ID搜尋好友
 @URL : /user/get-user-by-match-id.api
 @傳入參數 : NSDictionary ( psid, matchId )
 @回傳參數 : NONE
 **/
+ ( void )getUserByMatchID:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.25]
 @函式說明 :加入好友
 @URL : /user/add-user-to-friend-by-match-id.api
 @傳入參數 : NSDictionary ( psid, matchId )
 @回傳參數 : NONE
 **/
+ ( void )AddUserToFreindByMatchID:( NSDictionary * )pParameter Source:( id )sourceDelegate;


/**
 @函式編號 : #[API_6.25]
 @函式說明 :刪除好友
 @URL :  /user/delete-user-from-friend-by-match-id.api
 @傳入參數 : NSDictionary ( psid, matchId )
 @回傳參數 : NONE
 **/
+ ( void )DeleteUserToFreindByMatchID:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.26]
 @函式說明 :新增待辦事項
 @URL : /user/new-todo.api
 @傳入參數 : NSDictionary ( psid, todo )
 @回傳參數 : NONE
 **/
+ ( void )AddNewTodo:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.27]
 @函式說明 :刪除待辦事項
 @URL : /user/delete-todo.api
 @傳入參數 : NSDictionary ( psid, todoID )
 @回傳參數 : NONE
 **/
+ ( void )DeleteTodo:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.28]
 @函式說明 :取得待辦事項
 @URL : /user/get-todo.api
 @傳入參數 : NSDictionary ( psid, filter, keyword )
 @回傳參數 : NONE
 **/
+ ( void )GetTodoList:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.29]
 @函式說明 :讀取待辦事項
 @URL : /user/read-todo.api
 @傳入參數 : NSDictionary ( psid, todoID )
 @回傳參數 : NONE
 **/
+ ( void )ReadTodoWithID:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.30]
 @函式說明 :回覆待辦事項
 @URL : /user/report-todo.api
 @傳入參數 : NSDictionary ( psid, todoID )
 @回傳參數 : NONE
 **/
+ ( void )ReportTodoWithID:( NSDictionary * )pParameter Source:( id )sourceDelegate;


/**
 @函式編號 : #[API_6.31]
 @函式說明 :確認待辦事項
 @URL : /user/confirm-todo.api
 @傳入參數 : NSDictionary ( psid, todoID )
 @回傳參數 : NONE
 **/
+ ( void )ConfirmTodoWithID:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.32]
 @函式說明 :傳聲筒傳 for send file。
 @URL : /user/upoad-file-for-chat.api
 @傳入參數 : NSDictionary ( psid, file )
 @回傳參數 : NONE
 **/
+ ( void )UploadFileForChat:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.33]
 @函式說明 :get QrCode Iamge
 @URL : /user/qrcode-generator.api
 @傳入參數 : NSDictionary ( psid, str )
 @回傳參數 : NONE
 **/
+ ( void )getQrCodeImage:( NSDictionary * )pParameter Source:( id )sourceDelegate;


/**
 @函式編號 : #[API_6.34]
 @函式說明 :get QrCode Iamge 2
 @URL : /user/qrcode-generator-v2.api
 @傳入參數 : NSDictionary ( psid, str )
 @回傳參數 : NONE
 **/
+ ( void )getQrCodeImage2:( NSDictionary * )pParameter Source:( id )sourceDelegate;


/**
 @函式編號 : #[API_6.35]
 @函式說明 :
 @URL : /user/set-regard.api
 @傳入參數 : NSDictionary ( psid, Logs of )
 @回傳參數 : NONE
 **/
+ ( void )setRegard:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.36]
 @函式說明 : Upload Mood Image
 @URL : /user/upload-mood-image.api
 @傳入參數 : NSDictionary ( psid, mood, image )
 @回傳參數 : NONE
 **/
+ ( void )uploadMoodImage:( NSDictionary * )pParameter Source:( id )sourceDelegate;\

/**
 @函式編號 : #[API_6.37]
 @函式說明 : Set Mother Mood
 @URL : /user/set-mother-mood.api
 @傳入參數 : NSDictionary ( psid, mood )
 @回傳參數 : NONE
 **/
+ ( void )setMotherMood:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.38]
 @函式說明 : Get Mother Mood
 @URL : /user/get-mother-mood.api
 @傳入參數 : NSDictionary ( psid, mood )
 @回傳參數 : NONE
 **/
+ ( void )getMotherMood:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.39]
 @函式說明 : Get Mood Statistics
 @URL : /user/get-mood-statistics.api
 @傳入參數 : NSDictionary ( psid, filter, Keyword )
 @回傳參數 : NONE
 **/
+ ( void )getMoodStatistics:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.40]
 @函式說明 : Push Mother Mood
 @URL : /user/push-mother-mood.api
 @傳入參數 : NSDictionary ( psid, body )
 @回傳參數 : NONE
 **/
+ ( void )pushMotherMood:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.41]
 @函式說明 : Exchange Point
 @URL : /user/exchange-point.api
 @傳入參數 : NSDictionary ( psid, point )
 @回傳參數 : NONE
 **/
+ ( void )exchangePoint:( NSDictionary * )pParameter Source:( id )sourceDelegate;

//update-event.api
/**
 @函式編號 : #[API_6.11]
 @函式說明 : Update Event
 @URL : /user/update-event.api
 @傳入參數 : NSDictionary ( psid, eventID, notes )
 @回傳參數 : NONE
 **/
+ ( void )updateEvent:( NSDictionary * )pParameter Source:( id )sourceDelegate;


/**
 @函式編號 : #[API_6.12]
 @函式說明 : Update Notes
 @URL : /user/update-event-notes.api
 @傳入參數 : NSDictionary ( psid, eventID, notes )
 @回傳參數 : NONE
 **/
+ ( void )updateNotes:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.47]
 @函式說明 : Get Emotion DB
 @URL : /user/get-emotion-db.api
 @傳入參數 : NSDictionary ( psid )
 @回傳參數 : NONE
 **/
+ ( void )getEmotionDB:( id )sourceDelegate;


/**
 @函式編號 : #[API_6.48]
 @函式說明 : Share Record
 @URL : /user/share-record.api
 @傳入參數 : NSDictionary ( psid )
 @回傳參數 : NONE
 **/
+ ( void )shareRecordLog:( id )sourceDelegate;

/**
 @函式編號 : #[API_6.49]
 @函式說明 : Share Record
 @URL : /user/share-app.api
 @傳入參數 : NSDictionary ( psid )
 @回傳參數 : NONE
 **/
+ ( void )shareAppLog:( id )sourceDelegate;

#pragma mark - 社群

/**
 @函式編號 : #[API_7.1]
 @函式說明 : Get Association List
 @URL : /user/get-association-class-list.api
 @傳入參數 : NSDictionary ( psid )
 @回傳參數 : NONE
 **/
+ ( void )getAssociationList:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.2]
 @函式說明 : New association
 @URL : /user/new-association.api
 @傳入參數 : NSDictionary ( psid,name, signStar, signChina, expectedDate, city, associationClass,
 associationPurpose, image, isPrivate)
 @回傳參數 : NONE
 **/
+ ( void )newAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.3]
 @函式說明 : Update association
 @URL : /user/update-association.api
 @傳入參數 : NSDictionary ( psid, asid, signStar, signChina, expectedDate, city, associationClass, associationPurpose, image, isPrivate)
 @回傳參數 : NONE
 **/
+ ( void )updateAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate;


/**
 @函式編號 : #[API_7.4]
 @函式說明 : Get My Association
 @URL : /user/get-my-association.api
 @傳入參數 : NSDictionary ( psid )
 @回傳參數 : NONE
 **/
+ ( void )getMyAssociation:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.5]
 @函式說明 : Get association list by class
 @URL : /user/get-association-list-by-class.api
 @傳入參數 : NSDictionary ( psid, class )
 @回傳參數 : NONE
 **/
+ ( void )getAssociationListByClass:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.6]
 @函式說明 : get Top association List
 @URL : /user/get-association-top-list.api
 @傳入參數 : NSDictionary ( psid )
 @回傳參數 : NONE
 **/
+ ( void )getAssociationTopList:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.7]
 @函式說明 : get  association by ID
 @URL : /user/get-association-by-id.api
 @傳入參數 : NSDictionary ( psid, asid )
 @回傳參數 : NONE
 **/
+ ( void )getAssociationByID:(NSString * )pstrASID Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.8]
 @函式說明 : Search association
 @URL : /user/search-association.api
 @傳入參數 : NSDictionary ( psid, city, signStar, signChina, keyword )
 @回傳參數 : NONE
 **/
+ ( void )searchAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate;


/**
 @函式編號 : #[API_7.9]
 @函式說明 : Report association
 @URL : /user/report-association.api
 @傳入參數 : NSDictionary ( psid, associationId )
 @回傳參數 : NONE
 **/
+ ( void )reportAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.10]
 @函式說明 : Join association
 @URL : /user/join-association.api
 @傳入參數 : NSDictionary ( psid, associationId )
 @回傳參數 : NONE
 **/
+ ( void )joinAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.11]
 @函式說明 : Leave association
 @URL : /user/leave-association.api
 @傳入參數 : NSDictionary ( psid, associationId )
 @回傳參數 : NONE
 **/
+ ( void )leaveAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.12]
 @函式說明 : Set member permission
 @URL : /user/set-member-permission.api
 @傳入參數 : NSDictionary ( psid, associationId, uid, isManager )
 @回傳參數 : NONE
 **/
+ ( void )SetAssociationMeberPermission:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.13]
 @函式說明 : Accept association apply
 @URL : /user/accept-association-apply.api
 @傳入參數 : NSDictionary ( psid, associationId, matchId )
 @回傳參數 : NONE
 **/
+ ( void )acceptAssociationApply:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.14]
 @函式說明 : 刪除會員
 @URL : /user/kick-out-association.api
 @傳入參數 : NSDictionary ( psid, associationId, matchId )
 @回傳參數 : NONE
 **/
+ ( void )kickMemberFromAssociation:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.15]
 @函式說明 : New association post
 @URL : /user/new-association-post.api
 @傳入參數 : NSDictionary ( psid, associationId, subject, content, image )
 @回傳參數 : NONE
 **/
+ ( void )newAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.16]
 @函式說明 : Get association post
 @URL : /user/get-association-post.api
 @傳入參數 : NSDictionary ( psid, associationId )
 @回傳參數 : NONE
 **/
+ ( void )getAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.17]
 @函式說明 : Delete association post
 @URL : /user/delete-association-post.api
 @傳入參數 : NSDictionary ( psid, associationId, postId )
 @回傳參數 : NONE
 **/
+ ( void )deleteAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate;

+ ( void )deleteAssociationComment:( NSDictionary * )pParameter Source:( id )sourceDelegate;


/**
 @函式編號 : #[API_7.18]
 @函式說明 : Report association post
 @URL : /user/report-association-post.api
 @傳入參數 : NSDictionary ( psid, associationId, postId )
 @回傳參數 : NONE
 **/
+ ( void )reportAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.19]
 @函式說明 :  Like association post
 @URL : /user/like-association-post.api
 @傳入參數 : NSDictionary ( psid, associationId, postId )
 @回傳參數 : NONE
 **/
+ ( void )likeAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.20]
 @函式說明 : Comment association post
 @URL : /user/comment-association-post.api
 @傳入參數 : NSDictionary ( psid, associationId, postId, comment, image )
 @回傳參數 : NONE
 **/
+ ( void )commentAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.21]
 @函式說明 : 統計社團文章瀏覽次數之用,每次使用者進入文章時需呼叫此 API
 @URL : /user/visit-association-post.api
 @傳入參數 : NSDictionary ( psid, associationId, postId )
 @回傳參數 : NONE
 **/
+ ( void )visitAssociationPost:( NSDictionary * )pParameter Source:( id )sourceDelegate;

/**
 @函式編號 : #[API_7.22]
 @函式說明 : get Post comment
 @URL : /user/get-association-comment-by-post-id.api
 @傳入參數 : NSDictionary ( psid, associationId, postId )
 @回傳參數 : NONE
 **/
+ ( void )getAssociationComment:( NSDictionary * )pParameter Source:( id )sourceDelegate;

@end
