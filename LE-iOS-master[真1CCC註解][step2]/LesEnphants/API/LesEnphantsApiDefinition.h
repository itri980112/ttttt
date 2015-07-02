//
//  LesEnphantsApiDefinition.h
//  LesEnphants
//
//  Created by Rusty Huang on 2014/8/14.
//  Copyright (c) 2014年 Rusty Huang. All rights reserved.
//

#ifndef LesEnphants_LesEnphantsApiDefinition_h
#define LesEnphants_LesEnphantsApiDefinition_h


#define kServer             @"http://itri-le-s.xtremeapp.com.tw"
//#define kServer             @"http://mommybook-api.phland.com.tw"
#define kChatServer         @"itri-le-chat-s.xtremeapp.com.tw"
//#define kChatServer         @"mommybook-chat.phland.com.tw"

#define kKeepAliveAPI                               @"user/keep-alive.api"
#define kResetPasswordAPI                           @"reset-password.api"
#define kLoginAPI                                   @"login.api"
#define kLoginTypeAPI                               @"user/set-login-type.api"
#define kUpdateDeviceTokenAPI                       @"user/update-device-token.api"
#define kSetProfileAPI                              @"user/set-profile.api"
#define kSetPhotoAPI                                @"user/upload-photo.api"
#define kGetProfileAPI                              @"user/get-profile.api"
#define kAddPregnantRecordAPI                       @"user/new-record.api"
#define kGetPregnantRecordAPI                       @"user/get-record.api"
#define kdelPregnantRecordAPI                       @"user/delete-record.api"

#define kAddPregnantEventAPI                        @"user/new-event.api"
#define kGetPregnantEventAPI                        @"user/get-event.api"
#define kAddPregnantWeightAPI                       @"user/new-weight.api"
#define kGetPregnantWeightAPI                       @"user/get-weight.api"


#define kGetKnowledgeListAPI                        @"user/get-knowledge-category.api"
#define kGetKnowledgeContentAPI                     @"user/get-knowledge-content.api"
#define kGetNewsListAPI                             @"user/get-news-category.api"
#define kGetNewsContentAPI                          @"user/get-news-content"

#define kSetMatchIdAPI                              @"user/set-match-id.api"
#define kSetRecommandIdAPI                          @"user/set-recommand-id.api"
#define kGetUserByMatchID                           @"user/get-user-by-match-id.api"
#define kAddUsertoFriendByMatchID                   @"user/add-user-to-friend-by-match-id.api"
#define kDeleteUsertoFriendByMatchID                @"user/delete-user-from-friend-by-match-id.api"

//Todo
#define kAddNewTodo                                 @"user/new-todo.api"
#define kDeleteTodo                                 @"user/delete-todo.api"
#define kGetTodoList                                @"user/get-todo.api"
#define kReadTodo                                   @"user/read-todo.api"
#define kReportTodo                                 @"user/report-todo.api"
#define kConfirmTodo                                @"user/confirm-todo.api"
#define kUploadFileForChat                          @"user/upoad-file-for-chat.api"
#define kQrCodeImage                                @"user/qrcode-generator.api"
#define kQrCodeImage2                               @"user/qrcode-generator-v2.api"
#define kUploadIamge                                @"user/upload-mood-image.api"
#define kSetMotherMood                              @"user/set-mother-mood.api"
#define kGetMotherMood                              @"user/get-mother-mood.api"
#define kGetMotherStatistics                        @"user/get-mood-statistics.api"
#define kPushMotherMood                             @"user/push-mother-mood.api"
#define kExchangePoint                              @"user/exchange-point.api"
#define kSetRegard                                  @"user/set-regard.api"
#define kUpdateEvent                                @"user/update-event.api"
#define kUpdateNotes                                @"user/update-event-notes.api"

#define kGetEmotionDB                               @"user/get-emotion-db.api"
#define kShareRecord                                @"user/share-record.api"
#define kShareApp                                   @"user/share-app.api"


/*****  Association      ****/
#define kGetAssociationTopList                      @"user/get-association-top-list.api"
#define kGetAssociationList                         @"user/get-association-class-list.api"
#define kNewAssociation                             @"user/new-association.api"
#define kUpdateAssociation                          @"user/update-association.api"
#define kGetMyAssociation                           @"user/get-my-association.api"
#define kGetAssociationListByClass                  @"user/get-association-list-by-class.api"
#define kSearchAssociation                          @"user/search-association.api"
#define kReportAssociation                          @"user/report-association.api"
#define kJoinAssociation                            @"user/join-association.api"
#define kLeaveAssociation                           @"user/leave-association.api"
#define kSetAssociationMemberPermission             @"user/set-member-permission.api"
#define kAcceptAssociationApply                     @"user/accept-association-apply.api"
#define kNewAssociationPost                         @"user/new-association-post.api"
#define kGetAssociationPost                         @"user/get-association-post.api"
#define kDeleteAssociationPost                      @"user/delete-association-post.api"
#define kReportAssociationPost                      @"user/report-association-post.api"
#define kLikeAssociationPost                        @"user/like-association-post.api"
#define kCommentAssociationPost                     @"user/comment-association-post.api"
#define kGetAssociationByID                         @"user/get-association-by-id.api"
#define kVisitAssociation                           @"user/visit-association-post.api"
#define kKickMemberFromAsso                         @"user/kick-out-association.api"
#define kGetAssociationCommentById                  @"user/get-association-comment-by-post-id.api"
#define kDeleteAssociationComment                   @"user/delete-association-comment.api"

//Server Field

/**

 Method
 0 -> login by guest
 1 -> login by Facebook
 2 -> login by email / password
 
**/
#define kMethod                 @"method"           //INT, Y
#define kAccount                @"account"          //String, Y
#define kPassword               @"password"         //String, N

/**
 
 loginType
 0 -> unKnown
 1 -> mother
 2 -> father
 3 -> guest
 4 -> other
 
 **/

#define kLoginType              @"loginType"
#define kPHPSessionID           @"psid"
#define kLanguage               @"lang"
/**
 
 kDeviceType
 0 -> Unknow
 1 -> iPhone
 2 -> iPad
 3 -> iPod
 4 -> Android device
 **/
#define kDeviceType             @"deviceType"       //INT, Y
#define kModel                  @"model"            //String, Y

#define kNickname               @"nickname"
#define kGestation              @"gestation"
#define kExpectedDate           @"expectedDate"
#define kMobile                 @"mobile"
#define kEmail                 @"email"
#define kBirthday                 @"birthday"
#define kHeight                 @"height"
#define kWeight                 @"weight"
#define kPhoto                  @"photo"
#define kDeviceToken            @"deviceToken"

/**
type:
1 -> mother’s body
2 -> ￼baby’s heart
3 -> ￼baby’s ultrasonic photo
**/
#define kType                   @"type"
#define kFile                   @"file"
#define kTime                   @"time"
#define kMeta                   @"meta"
#define kFilter                 @"filter"
#define kKeyWord                @"keyword"
#define kRecordID               @"id"

#define kIsPrenatalExamination  @"isPrenatalExamination"
#define kDate                   @"date"
#define kStart                  @"start"
#define kEnd                    @"end"
#define kSubject                @"subject"
#define kEnablePush             @"enablePush"
#define kWeight                 @"weight"
#define kNote                   @"notes"
#define kEnventID               @"eventId"


#define kPostMatchID                @"matchId"
#define kPostRecommandID            @"matchId"

#define kToDo                   @"todo"
#define kToDoID                 @"todoId"
#define kString                 @"str"

#define kMood                   @"mood"
#define kImage                  @"image"
#define kBody                   @"body"
#define kPoint                  @"point"


#define kEnableMoodChange       @"enableMoodChange"
#define kMon                    @"mon"
#define kTues                    @"tues"
#define kWed                    @"wed"
#define kThur                    @"thur"
#define kFri                    @"fri"
#define kSat                    @"sat"
#define kSun                    @"sun"


#define kEvnetID                @"eventId"

/*****  Association      ****/
#define kAssoASID                   @"asid"
#define kAssoName                   @"name"
#define kAssoSignStar               @"signStar"
#define kAssoSignChina              @"signChina"
#define kAssoCity                   @"city"
#define kAssoClass                  @"associationClass"
#define kAssoPurpost                @"associationPurpose"
#define kAssoImage                  @"image"
#define kAssoIsPrivate              @"isPrivate"
#define kAssoListClass              @"class"
#define kAssoKeyword                @"keyword"
#define kAssoID                     @"associationId"
#define kAssoUID                    @"uid"
#define kAssoIsManager              @"isManager"
#define kAssoSubject                @"subject"
#define kAssoContent                @"content"
#define kAssoPostID                 @"postId"
#define kAssoComment                @"comment"
#define kAssoMatchId                @"matchId"
#define kAssoCommentID              @"commentId"
//Message

#define kNotConnectToInternetMSG        @"無網路連線！！"
#endif
