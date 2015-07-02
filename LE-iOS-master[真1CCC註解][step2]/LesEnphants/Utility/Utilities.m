//
//  Utilities.m
//  JamPush
//
//  Created by Xavier on 2012/01/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "Reachability.h"
#import <AdSupport/AdSupport.h>

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kDE2RA			0.01745329252
#define kERAD			6378.137
#define kFLATTENING		1.0/298.257223563



static char base64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation Utilities


#pragma mark - Class methods

+ ( NSString * )getDevicePlatform
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}


+ (BOOL)isPad
{
	BOOL isPad = NO;
	
	NSString* modelName = [[UIDevice currentDevice] model];
	NSRange range = [modelName rangeOfString:@"iPad"];
	if (range.location != NSNotFound)
	{
		isPad = YES;
	}
	
	return isPad;
}

/*CCC do
+ (NSString*)getMacAddress:(NSString*)interface withDelimiter:(NSString*)delimiter
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;              
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
	const char* szInterface = [interface UTF8String];
    if ((mgmtInfoBase[5] = if_nametoindex(szInterface)) == 0) 
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) 
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return nil;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X%@%02X%@%02X%@%02X%@%02X%@%02X", 
                                  macAddress[0], delimiter, macAddress[1], delimiter, macAddress[2], delimiter, 
                                  macAddress[3], delimiter, macAddress[4], delimiter, macAddress[5]];
	//    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}
*/
+ ( NSString * )deviceModel
{
    NSString *pstrDeviceModel = [[UIDevice currentDevice] systemName];
    NSLog(@"Device Model = %@", pstrDeviceModel);
    return pstrDeviceModel;
}

+ ( NSString * )iosVersion
{
    NSString *pstrOSVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"OS Version = %@", pstrOSVersion);
    return pstrOSVersion;
}
/*CCC do
+ (NSString*)uniqueIdentifier
{
    CGFloat fVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if ( fVersion < 7.0 )
    {
        return [Utilities getMacAddress:@"en0" withDelimiter:@":"];
    }
    else
    {
        //return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
}
*/
+ ( NSString * )appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; //上架的Version
}

+ ( NSString * )appBuildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; //Build
}

+ ( NSString * )appID
{
    return [[NSBundle mainBundle] bundleIdentifier];
}


+ (UIImage*)resizeImage:(UIImage*)image withSize:(CGSize)size
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    //CGSize size = CGSizeMake(width, height);
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    else
        UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Draw the original image to the context
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, size.width, size.height), image.CGImage);
    
    // Retrieve the UIImage from the current context
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageOut;
}


+ (UIImage*)navigationBarImage:(BOOL)withTitle
{
	return [Utilities resizeImage:[UIImage imageNamed:(withTitle ? @"bar" : @"bar01")] withSize:CGSizeMake(320, 44)];
}

+ ( NSString * )getDocumentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ ( NSString * )getTempPath
{
    return NSTemporaryDirectory();
}

+ ( CGSize )screenSize
{
    BOOL bIsIpad = [Utilities isPad];
    CGSize returnSize = CGSizeMake(320, 480);
    if ( bIsIpad )
    {
        returnSize = CGSizeMake(768, 1024);
    }
    
    return returnSize;
}

+ ( NSString * )sha1:( NSString * )input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
    
}

+ ( NSString * )MD5:( NSString * )input
{
    // Create pointer to the string as UTF8
    const char *ptr = [input UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

+ ( NSString * )timeStampToLocalTime:( NSString * )pstrTimeStamp
{
    NSLog(@"timeStampToLocalTime = %@", pstrTimeStamp);
    NSString *pstrLocalTimeString = @"";
    
    
    return pstrLocalTimeString;
}

+ ( NSDate * )getDateFromTimestamp:( NSString * )pstrTimestamp
{
    NSTimeInterval time = [pstrTimestamp doubleValue];
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"getDsateFromTimestamp:( %@ ) -> ( %@ )", pstrTimestamp, [myDate description]);
    return myDate;
}

//CCC:Reachability可用來簡單測試網路是否連接,回傳YES表示裝置連接網路
+ ( BOOL )isConnectedToInternet
{
    Reachability *pInternet = [Reachability reachabilityForInternetConnection];
	NetworkStatus status = [pInternet currentReachabilityStatus];
	if ( status == NotReachable ) 
	{
		NSLog(@"No Internet");
		return NO;
	}
	else if( status == ReachableViaWiFi )
	{
		//NSLog(@"ReachableViaWiFi");
		return YES;
	}
	else 
	{
		//NSLog(@"ReachableViaWWAN");
		return YES;
	}
    
	return NO;
}

+ ( void )printDictionaryContent:( NSDictionary * )pDic
{
    for ( id key in pDic )
    {
        NSLog(@"key = %@, value = %@", key, [pDic valueForKey:key]);
    }
}

+ ( NSString * )getDateTimeString:( NSDate * )pDate
{
	NSString *pstrReturn = @"";
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	[formatter setDateFormat:( @"yyyyMMddHHMMSS" )];
	pstrReturn = [formatter stringFromDate:pDate];
	[formatter release];
	
	return pstrReturn;
}

+ ( NSDate * )getDateFromDateTimeString:( NSString * )pstrDateTimeString
{
    //先轉回date
	NSDateFormatter *pDateFormatter = [[NSDateFormatter alloc] init];
	[pDateFormatter setDateFormat:@"yyyyMMddHHMMSS"];
	NSDate *pDate = [pDateFormatter dateFromString:pstrDateTimeString];
	[pDateFormatter release];
	
	return pDate;
}
+ ( NSDate * )getDateFromDateTimeString2:( NSString * )pstrDateTimeString
{
    //先轉回date
	NSDateFormatter *pDateFormatter = [[NSDateFormatter alloc] init];
	[pDateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *pDate = [pDateFormatter dateFromString:pstrDateTimeString];
	[pDateFormatter release];
	
	return pDate;
}


+ ( BOOL )saveLoginData:( NSString * )pstrSavePath ID:( NSString * )pstrID PW:( NSString * )pstrPW
{
    BOOL bResult = YES;
    
    NSData *pPlainDataID = [pstrID dataUsingEncoding:NSUTF8StringEncoding];
   
    
    NSData *pCipherDataID = [pPlainDataID AES256EncryptWithKey:@"Utilities"];
    
    
    //若密碼有設定，且不為空值
    if ( pstrPW != nil && ![pstrPW isEqualToString:@""] ) 
    {
        NSData *pPlainDataPW = [pstrPW dataUsingEncoding:NSUTF8StringEncoding];
        NSData *pCipherDataPW = [pPlainDataPW AES256EncryptWithKey:@"Utilities"];
        
        NSDictionary *pDic = [NSDictionary dictionaryWithObjectsAndKeys:pCipherDataID, @"ID", pCipherDataPW, @"PW", nil];
        [pDic writeToFile:pstrSavePath atomically:YES];
        return bResult;
    }
    
    
    NSDictionary *pDic = [NSDictionary dictionaryWithObjectsAndKeys:pCipherDataID, @"ID", nil];
    [pDic writeToFile:pstrSavePath atomically:YES];
    
    return bResult;
}

+( NSDictionary * )getLoginData:( NSString * )pstrSavePath
{
    NSDictionary *pReturnedDic = nil;
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:pstrSavePath] )
    {
        NSDictionary *pLoadDic = [NSDictionary dictionaryWithContentsOfFile:pstrSavePath];
        
        NSData *pCipherDataID = [pLoadDic objectForKey:@"ID"];  //Encoded ID Data
        NSData *pCipherDataPW = [pLoadDic objectForKey:@"PW"];  //ENcoded PW Data
        
        NSData *pPlainDataID = nil;     //Decode後的Data
        NSData *pPlainDataPW = nil;     //Decode後的Data
        NSString *pstrPlainID = @"";    //ID 明文
        NSString *pstrPlainPW = @"";    //pw 明文
        
        
        //如果有取回資料，才需要解密
        if ( pCipherDataID )
        {
            pPlainDataID = [pCipherDataID AES256DecryptWithKey:@"Utilities"];
        }
        
        if ( pCipherDataPW) 
        {
            pPlainDataPW = [pCipherDataPW AES256DecryptWithKey:@"Utilities"];
        }
        
        //如果有解密後的Data，要轉成NSString
        if ( pPlainDataID )
        {
            pstrPlainID = [[[NSString alloc] initWithData:pPlainDataID encoding:NSUTF8StringEncoding] autorelease];
        }
        
        if ( pPlainDataPW )
        {
            pstrPlainPW = [[[NSString alloc] initWithData:pPlainDataPW encoding:NSUTF8StringEncoding] autorelease];
        }
        
        pReturnedDic = [NSDictionary dictionaryWithObjectsAndKeys:@"OK", @"Status", pstrPlainID, @"ID", pstrPlainPW, @"PW", nil];
        
    }
    else 
    {
        pReturnedDic = [NSDictionary dictionaryWithObjectsAndKeys:@"File is not existed!!!", @"Status", nil];
    }
    
    return pReturnedDic;
}

+ ( UIImage * )sepiaImageFromImage:( UIImage * )inPutImg
{
    CIImage *myCIImage = [CIImage imageWithCGImage:[inPutImg CGImage]];
    
    CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
    [sepiaFilter setValue:myCIImage forKey:kCIInputImageKey];
    [sepiaFilter setValue:[NSNumber numberWithFloat:0.9f] forKey:@"inputIntensity"];
    
    CIImage *sepiaImage = [sepiaFilter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:kCIContextUseSoftwareRenderer]];
    CGImageRef sepiaCGImage = [context createCGImage:sepiaImage fromRect:[sepiaImage extent]];
    UIImage *sepiaUIImage = [UIImage imageWithCGImage:sepiaCGImage];
    CFRelease(sepiaCGImage);
    
    return sepiaUIImage;
}

+ ( double )approxDistance:( double )lat1
					  Lon1:( double )lon1
					  Lat2:( double )lat2
					  Lon2:( double )lon2
{
	double radLat1 = lat1 * 3.1415926535 / 180.0f;
	double radLat2 = lat2 * 3.1415926535 / 180.0f;
	double a = radLat1 - radLat2;
	double radLon1 = lon1 * 3.1415926535 / 180.0f;
	double radLon2 = lon2 * 3.1415926535 / 180.0f;
	double b = radLon1 - radLon2;
	double s = 2 * asin( sqrtf( powf( sinf(a/2), 2 ) + cosf(radLat1) * cosf(radLat2) * powf(sinf(b/2), 2) ) );
	s = s * kERAD;
	s = round( s * 10000 ) / 10000;
	//s = s / 4.128f;
	NSLog(@"s = %f", s);
	return s;
}

+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


+( void )setRoundCornor:( id )oneView
{
    //設定圓角
    //設定邊框粗細
    [[oneView layer] setBorderWidth:2.0];
    
    //邊框顏色
    [[oneView layer] setBorderColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor];
    
    //將超出邊框的部份做遮罩
    [[oneView layer] setMasksToBounds:YES];
    
    //設定被景顏色
    [[oneView layer] setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6].CGColor];
    
    //設定圓角程度
    [[oneView layer] setCornerRadius:60];// 10是圓倒角、30是圓形
}

+( void )setRoundCornor2:( id )oneView
{
    //設定圓角
    //設定邊框粗細
    [[oneView layer] setBorderWidth:2.0];
    
    //邊框顏色
    [[oneView layer] setBorderColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor];
    
    //將超出邊框的部份做遮罩
    [[oneView layer] setMasksToBounds:YES];
    
    //設定被景顏色
    [[oneView layer] setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6].CGColor];
    
    //設定圓角程度
    [[oneView layer] setCornerRadius:30];// 10是圓倒角、30是圓形
}

+( void )setRoundCornor3:( id )oneView
{
    //設定圓角
    //設定邊框粗細
    [[oneView layer] setBorderWidth:1.0];
    
    //邊框顏色
    [[oneView layer] setBorderColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor];
    
    //將超出邊框的部份做遮罩
    [[oneView layer] setMasksToBounds:YES];
    
    //設定被景顏色
    [[oneView layer] setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6].CGColor];
    
    //設定圓角程度
    [[oneView layer] setCornerRadius:20];// 10是圓倒角、30是圓形
}

+ (BOOL) telRegularExpression:(NSString *)tel
{
    NSString *_telRegExp = @"^09\\d{8}$";
    NSPredicate *_telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _telRegExp];
    return [_telTest evaluateWithObject:tel];
}

@end

@implementation NSData(Encription)
- ( NSData * )AES256EncryptWithKey:(NSString *)key   //加密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) 
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- ( NSData * )AES256DecryptWithKey:(NSString *)key   //解密
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) 
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}


- ( NSString * )newStringInBase64FromData            //追加64编码
{
    NSMutableString *dest = [[NSMutableString alloc] initWithString:@""];
    unsigned char * working = (unsigned char *)[self bytes];
    int srcLen = [self length];
    for (int i=0; i<srcLen; i += 3)
    {
        for (int nib=0; nib<4; nib++) 
        {
            int byt = (nib == 0)?0:nib-1;
            int ix = (nib+1)*2;
            if (i+byt >= srcLen) break;
            unsigned char curr = ((working[i+byt] << (8-ix)) & 0x3F);
            if (i+nib < srcLen) curr |= ((working[i+nib] >> ix) & 0x3F);
            [dest appendFormat:@"%c", base64[curr]];
        }
    }
    return dest;
}

+ (NSString*)base64encode:(NSString*)str
{
    if ([str length] == 0)
        return @"";
    const char *source = [str UTF8String];
    int strlength  = strlen(source);
    char *characters = malloc(((strlength + 2) / 3) * 4);
    if (characters == NULL)
    {
        return nil;
    }
    NSUInteger length = 0;
    NSUInteger i = 0;
    while (i < strlength) 
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < strlength)
        {
            buffer[bufferLength++] = source[i++];
        }
        
        characters[length++] = base64[(buffer[0] & 0xFC) >> 2];
        characters[length++] = base64[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
        {
            characters[length++] = base64[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        }
        else
        {
            characters[length++] = '=';
        }
        
        if (bufferLength > 2)
        {
            characters[length++] = base64[buffer[2] & 0x3F];
        }
        else
        {
            characters[length++] = '=';
        }
    }
    
    NSString *g = [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
    return g;
}

@end
