//
//  XFAppContext.m
//  SaiKu
//
//  Created by Jiangxing on 15/3/2.
//  Copyright (c) 2015年 com.saiku. All rights reserved.
//

#import "XFAppContext.h"

//#import <UICKeyChainStore.h>

static NSString *const GAAPPDataGuideRun = @"guideRun";
static NSString *const XFAppContextUid = @"uid";
static NSString *const XFAppContextNick = @"nickname";
static NSString *const XFAppContextSex = @"sex";
static NSString *const XFAppContextBirthday = @"birth";
static NSString *const XFAppContextAvatar = @"portrait";
static NSString *const XFAppContextCdate = @"cdate";
static NSString *const XFAppContextUdate = @"udate";
static NSString *const XFAppContextInterests = @"interests";
static NSString *const XFAppContextBackGroundUrl = @"backgroundUrl";
static NSString *const XFAppContextMobile = @"mobile";
static NSString *const XFAppContextToken = @"token";
static NSString *const XFAppContextRCToken = @"rctoken";


@implementation XFAppContext

- (id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        self.uid = [prefs stringForKey:XFAppContextUid];
        self.nickname = [prefs stringForKey:XFAppContextNick];
        self.token = [prefs stringForKey:XFAppContextToken];
        self.rctoken = [prefs stringForKey:XFAppContextRCToken];
        self.sex = [prefs stringForKey:XFAppContextSex];
        self.birth = [prefs stringForKey:XFAppContextBirthday];
        self.portrait = [prefs stringForKey:XFAppContextAvatar];
        self.cdate = [prefs stringForKey:XFAppContextCdate];
        self.udate = [prefs stringForKey:XFAppContextUdate];
        self.interests = [prefs stringForKey:XFAppContextInterests];
        self.backgroundUrl = [prefs stringForKey:XFAppContextBackGroundUrl];
        self.mobile = [prefs stringForKey:XFAppContextMobile];
        self.guideRun = [prefs stringForKey:GAAPPDataGuideRun];
    }
    return self;
}

+ (instancetype)sharedContext
{
    static XFAppContext *_sharedContext = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedContext = [[XFAppContext alloc] init];
    });
    return _sharedContext;
}

- (void)save
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (self.uid != nil) {
        [prefs setObject:self.uid forKey:XFAppContextUid];
    }
    if (!ISEMPTY(self.nickname)) {
        [prefs setObject:self.nickname forKey:XFAppContextNick];
    }
    if (!ISEMPTY(self.sex)) {
      [prefs setObject:self.sex forKey:XFAppContextSex];
    }
    if (!ISEMPTY(self.birth)) {
      [prefs setObject:self.birth forKey:XFAppContextBirthday];
    }
    if (!ISEMPTY(self.portrait)) {
        [prefs setObject:self.portrait forKey:XFAppContextAvatar];
    }
    if (!ISEMPTY(self.cdate)) {
        [prefs setObject:self.cdate forKey:XFAppContextCdate];
    }
    if (!ISEMPTY(self.udate)) {
        [prefs setObject:self.udate forKey:XFAppContextUdate];
    }
    if (!ISEMPTY(self.interests)) {
      [prefs setObject:self.interests forKey:XFAppContextInterests];
    }
    if (!ISEMPTY(self.token)) {
        [prefs setObject:self.token forKey:XFAppContextToken];
    }
    if (!ISEMPTY(self.rctoken)) {
        [prefs setObject:self.rctoken forKey:XFAppContextRCToken];
    }
    if (!ISEMPTY(self.guideRun)) {
        [prefs setObject:self.guideRun forKey:GAAPPDataGuideRun];
    }
    if (!ISEMPTY(self.backgroundUrl)) {
        [prefs setObject:self.backgroundUrl forKey:XFAppContextBackGroundUrl];
    }
    if (!ISEMPTY(self.mobile)) {
        [prefs setObject:self.mobile forKey:XFAppContextMobile];
    }
    [prefs synchronize];
}

- (void)clear
{
    // 删除用户UID记录
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:XFAppContextUid];
    self.uid = nil;
    [prefs removeObjectForKey:XFAppContextToken];
    self.token = nil;
    [prefs removeObjectForKey:XFAppContextRCToken];
    self.rctoken = nil;
    [prefs removeObjectForKey:XFAppContextNick];
    self.nickname = nil;
    [prefs removeObjectForKey:XFAppContextSex];
    self.sex = nil;
    [prefs removeObjectForKey:XFAppContextBirthday];
    self.birth = nil;
    [prefs removeObjectForKey:XFAppContextAvatar];
    self.portrait = nil;
    [prefs removeObjectForKey:XFAppContextCdate];
    self.cdate = nil;
    [prefs removeObjectForKey:XFAppContextUdate];
    self.udate = nil;
    [prefs removeObjectForKey:XFAppContextBackGroundUrl];
    self.backgroundUrl = nil;
    [prefs removeObjectForKey:XFAppContextMobile];
    self.mobile = nil;

}


@end
