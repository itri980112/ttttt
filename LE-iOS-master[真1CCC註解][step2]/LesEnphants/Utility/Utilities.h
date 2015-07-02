//
//  Utilities.h
//  JamPush
//
//  Created by Xavier on 2012/01/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    JP_ASYNC_CONTROL_GPS = 0
}JP_ASYNC_CONTROL_TYPE;


@interface Utilities : NSObject

// Class methods
//
+ ( NSString * )getDevicePlatform;
+ ( BOOL )isPad;
//+ ( NSString * )uniqueIdentifier;//CCC do
+ ( UIImage * )resizeImage:( UIImage * )image withSize:( CGSize )size;
+ ( UIImage * )navigationBarImage:( BOOL )withTitle;
+ ( NSString * )getDocumentPath;
+ ( NSString * )getTempPath;
+ ( NSString * )deviceModel;
+ ( NSString * )iosVersion;
+ ( CGSize )screenSize;
+ ( NSString * )sha1:( NSString * )input;
+ ( NSString * )MD5:( NSString * )input;
+ ( NSString * )appBuildVersion;
+ ( NSString * )appVersion;
+ ( NSString * )appID;
+ ( NSString * )timeStampToLocalTime:( NSString * )pstrTimeStamp;
+ ( NSDate * )getDateFromTimestamp:( NSString * )pstrTimestamp;
+ ( BOOL )isConnectedToInternet;
+ ( void )printDictionaryContent:( NSDictionary * )pDic;
+ ( NSString * )getDateTimeString:( NSDate * )pDate;
+ ( NSDate * )getDateFromDateTimeString:( NSString * )pstrDateTimeString;
+ ( NSDate * )getDateFromDateTimeString2:( NSString * )pstrDateTimeString;
+ ( BOOL )saveLoginData:( NSString * )pstrSavePath ID:( NSString * )pstrID PW:( NSString * )pstrPW;
+ ( NSDictionary * )getLoginData:( NSString * )pstrSavePath;
+ ( UIImage * )sepiaImageFromImage:( UIImage * )inPutImg;
+ ( double )approxDistance:( double )lat1
					  Lon1:( double )lon1
					  Lat2:( double )lat2
					  Lon2:( double )lon2;

+(BOOL) NSStringIsValidEmail:(NSString *)checkString;
+( void )setRoundCornor:( id )oneView;
+( void )setRoundCornor2:( id )oneView;
+( void )setRoundCornor3:( id )oneView;
+ (BOOL) telRegularExpression:(NSString *)tel;


@end

@interface NSData(Encription)
- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密
- (NSString *)newStringInBase64FromData;            //追加64编码
+ (NSString*)base64encode:(NSString*)str;           //同上64编码
@end

