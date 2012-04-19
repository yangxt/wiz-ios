//
//  WizGlobalData.m
//  Wiz
//
//  Created by Wei Shijun on 3/9/11.
//  Copyright 2011 WizBrother. All rights reserved.
//

#import "WizGlobalData.h"
#import "WizSync.h"
#import "WizCreateAccount.h"
#import "WizVerifyAccount.h"
#import "WizDocumentsByLocation.h"
#import "WizDocumentsByTag.h"
#import "WizDocumentsByKey.h"
#import "WizIndex.h"
#import "WizMisc.h"
#import "WizGlobals.h"
#import "WizDownloadObject.h"
#import "LoginViewController.h"
#import "PickViewController.h"
#import "WizChangePassword.h"
#import "WizSettings.h"
#import "TTTAttributedLabel.h"
#import "WizNotification.h"
#import "WizSyncManager.h"
#import "WizAccountManager.h"
//
#define DataTypeOfSyncManager               @"DataTypeOfSyncManager"
#define DataTypeOfSync                      @"Sync"
#define DataTypeOfCreateAccount             @"CreateAccount"
#define DataTypeOfVerifyAccount             @"VerifyAccount"
#define DataTypeOfDocumentsByLocation       @"DocumentsByLocation"
#define DataTypeOfDocumentsByTag            @"DocumentsByTag"
#define DataTypeOfDownloadRecentDocuments   @"DownloadRecentDocuments"
#define DataTypeOfDocumentsByKey            @"DocumentsByKey"
#define DataTypeOfDownloadObject            @"DownloadObject"
#define DataTypeOfUploadObject              @"UploadObject"
#define DataTypeOfUploadDocument            @"UploadDocument"
#define DataTypeOfUploadAttachment          @"UploadAttachment"
#define DataTypeOfDownloadDocument          @"DownloadDocument"
#define DataTypeOfDownloadAttachment        @"DownloadAttachment"
#define DataTypeOfIndex                     @"Index"
#define DataMainOfWiz                       @"wizMain"
#define DataTypeOfChangePassword            @"changeUserPassword"
#define DataTypeOfSyncByTag                 @"SyncByTag"
#define DataTypeOfSyncByLocation            @"SyncByLocation"
#define DataTypeOfSyncByKey                 @"SyncByKey"
#define DataTypeOfGlobalDownloadPool        @"GlobalDownloadPool"
#define DataIconForDocumentWithoutData      @"IconDocumentWithoutData"
#define DataTypeOfAccountManager            @"DataTypeOfAccountManager"

//
#define DataOfAttributesForDocumentListName                 @"attributesForDocumentListName"
#define WizGlobalAccount                                    @"DataOfGlobalShareDataWiz"
#define DataOfAttributesForPadAbstractViewParagraph         @"DataOfAttributesForPadAbstractViewParagraph"
#define DataOfActiveAccountUserId                           @"DataOfActiveAccountUserId"
#define DataOfGlobalWizNotification                         @"DataOfGlobalWizNotification"
static WizGlobalData* g_data;

@interface WizGlobalData()
{
	NSMutableDictionary* dict;
}
@property (nonatomic, retain) NSMutableDictionary* dict;

@end

@implementation WizGlobalData

@synthesize dict;

-(id) init
{
	if (self  = [super init])
	{
		NSString* logFileName = [[WizGlobals documentsPath] stringByAppendingPathComponent:@"info.log"];
		SetLogFileName([logFileName UTF8String]);
		NSMutableDictionary* d = [[NSMutableDictionary alloc] init] ;
		self.dict = d;
		[d release];
	}
	//
	return self;
}
-(void) dealloc
{
	dict = nil;
	//
	[super dealloc];
}

- (id) dataOfAccount: (NSString*) userId dataType: (NSString *) dataType
{
	NSString* key = [WizGlobalData keyOfAccount:userId dataType: dataType];
	//
	id val = [dict valueForKey:key];
	//
	return val;
}
- (void) setDataOfAccount: (NSString*) userId dataType: (NSString *) dataType data: (id) data
{
	NSString* key = [WizGlobalData keyOfAccount:userId dataType: dataType];
	//
	[dict setValue:data forKey:key];
}

- (WizSync *) syncData:(NSString*) userId
{
	id data = [self dataOfAccount:userId dataType: DataTypeOfSync];
	if (data != nil)
		return data;
	//
	data = [[WizSync alloc] initWithAccount:userId password:@""];
	[self setDataOfAccount:userId dataType:DataTypeOfSync data:data];
	 [data release];  return data;
}

- (WizCreateAccount *) createAccountData:(NSString*) userId
{
	id data = [self dataOfAccount:userId dataType: DataTypeOfCreateAccount];
	if (data != nil)
		return data;
	//
	data = [[WizCreateAccount alloc] initWithAccount:userId password:@""];
	[self setDataOfAccount:userId dataType:DataTypeOfCreateAccount data:data];
	 [data release];  return data;
}
- (WizVerifyAccount *) verifyAccountData:(NSString*) userId
{
	id data = [self dataOfAccount:userId dataType: DataTypeOfVerifyAccount];
	if (data != nil)
		return data;
	//
	data = [[WizVerifyAccount alloc] initWithAccount:userId password:@""];
	[self setDataOfAccount:userId dataType:DataTypeOfVerifyAccount data:data];
	 [data release];  return data;
}

- (WizChangePassword*) dataOfChangePassword:(NSString *)userId
{
    id data = [self dataOfAccount:userId dataType: DataTypeOfChangePassword];
	if (data != nil)
		return data;
	//
	data = [[WizChangePassword alloc] initWithAccount:userId password:@""];
	[self setDataOfAccount:userId dataType:DataTypeOfChangePassword data:data];
    [data release]; 
    return data;
}



- (UIImage*) documentIconWithoutData
{
    id data = [self dataOfAccount:DataMainOfWiz   dataType:DataIconForDocumentWithoutData ];
	if (data != nil)
		return data;
	//
	data = [UIImage imageNamed:@"documentWithoutData"];
	[self setDataOfAccount:DataMainOfWiz dataType:DataIconForDocumentWithoutData data:data];
    return data;
}

-(WizDownloadObject *) downloadObjectData:(NSString*) userId
{
	id data = [self dataOfAccount:userId dataType: DataTypeOfDownloadObject];
	if (data != nil)
		return data;
	//
	data = [[WizDownloadObject alloc] initWithAccount:userId password:@""];
	[self setDataOfAccount:userId dataType:DataTypeOfDownloadObject data:data];
	 [data release];  return data;
}
- (void) stopSyncing
{
    for (int i = 0; i < [[WizSettings accounts] count]; i++) {
        NSString* userId = [WizSettings accountUserIdAtIndex:[WizSettings accounts] index:i];
        WizSync* sync = [self dataOfAccount:userId dataType:DataTypeOfSync];
        if (nil != sync) {
            [sync cancel];
        }
        WizSyncByKey* syncKey = [self dataOfAccount:userId dataType:DataTypeOfSyncByKey];
        if (nil != syncKey) {
            [syncKey cancel];
        }
        
        WizSyncByTag* syncTag = [self dataOfAccount:userId dataType:DataTypeOfSyncByTag];
        if (nil != syncTag) {
            [syncTag cancel];
        }
        WizSyncByLocation* syncLoc = [self dataOfAccount:userId dataType:DataTypeOfSyncByLocation];
        if (nil != syncLoc) {
            [syncLoc cancel];
        }
        
    }
}

-(NSDictionary*) attributesForDocumentListName
{
    id data = [self dataOfAccount:WizGlobalAccount dataType:DataOfAttributesForDocumentListName];
	if (data != nil)
		return data;
	//
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    UIFont* stringFont = [UIFont boldSystemFontOfSize:15];
    CTFontRef font = CTFontCreateWithName((CFStringRef)stringFont.fontName, stringFont.pointSize, NULL);
    [dic setObject:(id)font forKey:(NSString*)kCTFontAttributeName];
    
    CTLineBreakMode lineBreakMode = kCTLineBreakByCharWrapping;
    CTParagraphStyleSetting settings[]={lineBreakMode};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings));
    [dic setObject:(id)paragraphStyle forKey:(NSString*)kCTParagraphStyleAttributeName];
    [self setDataOfAccount:WizGlobalAccount dataType:DataOfAttributesForDocumentListName data:dic];
    return dic;
}
- (NSDictionary*) attributesForAbstractViewParagraphPad
{
    id data = [self dataOfAccount:WizGlobalAccount dataType:DataOfAttributesForPadAbstractViewParagraph];
	if (data != nil)
		return data;
    NSMutableDictionary* attributeDic = [NSMutableDictionary dictionary];
    [attributeDic setObject:(id)[UIColor lightGrayColor].CGColor forKey:(NSString*)kCTUnderlineColorAttributeName];
    [attributeDic setObject:(id)[[UIColor grayColor] CGColor]  forKey:(NSString *)kCTForegroundColorAttributeName];
    long characheterSpacing = 0.5f;
    char characheter = (char)characheterSpacing;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &characheter);
    [attributeDic setObject:(id)num forKey:(NSString *)kCTKernAttributeName];
    CFRelease(num);
    CGFloat lineSpace = 19;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierMinimumLineHeight;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value = &lineSpace;
    CTParagraphStyleSetting settings[] = {lineSpaceStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings));
    [attributeDic setObject:(id)style forKey:(id)kCTParagraphStyleAttributeName];
    UIFont* stringFont = [UIFont systemFontOfSize:13];
    CTFontRef font = CTFontCreateWithName((CFStringRef)stringFont.fontName, stringFont.pointSize, NULL);
    [attributeDic setObject:(id)font forKey:(NSString*)kCTFontAttributeName];
    [self setDataOfAccount:WizGlobalAccount dataType:DataOfAttributesForPadAbstractViewParagraph data:attributeDic];
    return attributeDic;
}




- (WizDocumentsByLocation *) documentsByLocationData:(NSString*) userId
{
	id data = [self dataOfAccount:userId dataType: DataTypeOfDocumentsByLocation];
	if (data != nil)
		return data;
	//
	data = [[WizDocumentsByLocation alloc] initWithAccount:userId password:@""];
	[self setDataOfAccount:userId dataType:DataTypeOfDocumentsByLocation data:data];
	 [data release]; 
    return data;
}

- (WizDocumentsByKey *) documentsByKeyData:(NSString*) userId
{
	id data = [self dataOfAccount:userId dataType: DataTypeOfDocumentsByKey];
	if (data != nil)
		return data;
	//
	data = [[WizDocumentsByKey alloc] initWithAccount:userId password:@""];
	[self setDataOfAccount:userId dataType:DataTypeOfDocumentsByKey data:data];
	[data release];
    return data;
}
- (NSNotificationCenter*) wizNotificationCenter
{
    id data = [self dataOfAccount:WizGlobalAccount dataType:DataOfGlobalWizNotification];
    if (data != nil) {
        return data;
    }
    data = [[NSNotificationCenter alloc] init];
    [self setDataOfAccount:WizGlobalAccount dataType:DataOfGlobalWizNotification data:data];
    [data release];
    return data;
}

- (WizDocumentsByTag *) documentsByTagData:(NSString*) userId
{
	id data = [self dataOfAccount:userId dataType: DataTypeOfDocumentsByTag];
	if (data != nil)
		return data;
	//
	data = [[WizDocumentsByTag alloc] initWithAccount:userId password:@""];
	[self setDataOfAccount:userId dataType:DataTypeOfDocumentsByTag data:data];
	[data release];
    return data;
}

- (WizIndex *) indexData:(NSString*) userId
{
	id data = [self dataOfAccount:userId dataType: DataTypeOfIndex];
	if (data != nil)
		return data;
	//
	data = [[WizIndex alloc] initWithAccount:userId];
	[self setDataOfAccount:userId dataType:DataTypeOfIndex data:data];
    [data release];
	return data;	
}

- (void) removeObserverFromDefaultNoticeCenter
{
    NSArray* arr = [dict allValues];
    for (id each in arr) {
        [[NSNotificationCenter defaultCenter] removeObserver:each];
        [WizNotificationCenter removeObserver:each];
    }
}

- (WizSyncManager*) syncManger
{
    id data = [self dataOfAccount:WizGlobalAccount dataType:DataTypeOfSyncManager];
    if (nil == data) {
        data = [[WizSyncManager alloc] init];
        [self setDataOfAccount:WizGlobalAccount dataType:DataTypeOfSyncManager data:data];
        [data release];
        return data;
    }
    return data;
}

- (WizAccountManager*) defaultAccountManager
{
    id data = [self dataOfAccount:WizGlobalAccount dataType:DataTypeOfAccountManager];
    if (nil == data) {
        data = [[WizAccountManager alloc] init];
        [self setDataOfAccount:WizGlobalAccount dataType:DataTypeOfAccountManager data:data];
        [data release];
        return data;
    }
    return data;
}
- (void) removeShareObjectData:(NSString*) dataType   userId:(NSString*) userId
{
    NSString* key = [WizGlobalData keyOfAccount:userId dataType: dataType];
    [dict removeObjectForKey:key];
}

- (void) removeAccountData:(NSString *)userId
{
    [self removeShareObjectData:DataTypeOfVerifyAccount userId:userId];
    [self removeShareObjectData:DataTypeOfUploadObject userId:userId];
    [self removeShareObjectData:DataTypeOfUploadDocument userId:userId];
    [self removeShareObjectData:DataTypeOfUploadAttachment userId:userId];
    [self removeShareObjectData:DataTypeOfCreateAccount userId:userId];
    [self removeShareObjectData:DataTypeOfSync userId:userId];
    [self removeShareObjectData:DataTypeOfSyncByKey userId:userId];
    [self removeShareObjectData:DataTypeOfSyncByLocation userId:userId];
    [self removeShareObjectData:DataTypeOfSyncByTag userId:userId];
    [self removeShareObjectData:DataTypeOfDocumentsByKey userId:userId];
    [self removeShareObjectData:DataTypeOfDocumentsByLocation userId:userId];
    [self removeShareObjectData:DataTypeOfDocumentsByTag userId:userId];
    [self removeShareObjectData:DataTypeOfDownloadAttachment userId:userId];
    [self removeShareObjectData:DataTypeOfDownloadDocument userId:userId];
    [self removeShareObjectData:DataTypeOfDownloadRecentDocuments userId:userId];
    [self removeShareObjectData:DataTypeOfGlobalDownloadPool userId:userId];
    [self removeObserverFromDefaultNoticeCenter];
    
}
- (BOOL) registerActiveAccountUserId:(NSString *)userId
{
    if (userId == nil || [userId isEqualToString:@""]) {
        userId = [WizSettings defaultAccountUserId];
        if (userId == nil || [userId isEqualToString:@""]) {
            if ([[WizSettings accounts] count] == 0) {
                return NO;
            }
            [WizSettings setDefalutAccount:[WizSettings accountUserIdAtIndex:[WizSettings accounts] index:0]];
            userId = [WizSettings defaultAccountUserId];
        }
    }
    [self setDataOfAccount:WizGlobalAccount dataType:DataOfActiveAccountUserId data:userId];
    return YES;
}
- (NSString*) activeAccountUserId
{
    id data = [self dataOfAccount:WizGlobalAccount dataType:DataOfActiveAccountUserId];
    if (data != nil && [data isKindOfClass:[NSString class]]) {
        return data;
    }
    if (![self registerActiveAccountUserId:@""]) {
        return @"";
    }
    data = [self dataOfAccount:WizGlobalAccount dataType:DataOfActiveAccountUserId];
    return data;
}
+ (NSString*) keyOfAccount:(NSString*) userId dataType: (NSString *) dataType
{
	NSString* key = [NSString stringWithFormat:@"%@_%@", userId, dataType];
	return key;
}
//singleton
+ (WizGlobalData*) sharedData
{
    @synchronized(g_data)
    {
        if (g_data == nil) {
            g_data = [[super allocWithZone:NULL] init];
        }
        return g_data;
    }
}
+ (id) allocWithZone:(NSZone *)zone
{
    return [[self sharedData] retain];
}
- (id) retain
{
    return self;
}
- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}
- (id) copyWithZone:(NSZone*)zone
{
    return self;
}
- (id) autorelease
{
    return self;
}
- (oneway void) release
{
    return;
}
+ (void) deleteShareData
{
	if (g_data != nil)
	{
		[g_data release];
		g_data = nil;
	}
}


@end
