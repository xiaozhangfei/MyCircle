//
//  XFUrl.h
//  MyCircle
//
//  Created by and on 16/3/17.
//  Copyright © 2016年 and. All rights reserved.
//

#ifndef XFUrl_h
#define XFUrl_h

//-------------------------------------- Base ------------------------------------------------//
#define baseURL                 @"http://zxfserver.sinaapp.com/home/"
#define baseImageURL            @"http://7xo6u7.com1.z0.glb.clouddn.com/"
#define baseVideoURL            @"http://zxfserver.sinaapp.com/Public/video/"

//----------------------------------- video,image---------------------------------------------//
#define url_image(v)            [NSString stringWithFormat:@"%@%@",baseImageURL,a]
#define url_video(v)            [NSString stringWithFormat:@"%@%@",baseVideoURL,v]


//-------------------------------------- Ad --------------------------------------------------//
#define url_ad                  [NSString stringWithFormat:@"%@index/adcon",baseURL]

//----------------------------------- Account ------------------------------------------------//
#define url_user_register       [NSString stringWithFormat:@"%@account/register",baseURL]
#define url_login               [NSString stringWithFormat:@"%@account/login",baseURL]
#define url_loginWithAuthcode   [NSString stringWithFormat:@"%@account/logincode",baseURL]
#define url_checkPhoneNum       [NSString stringWithFormat:@"%@account/testMobile",baseURL]
#define url_checkNick(v)        [NSString stringWithFormat:@"%@account/testnick/nick/%@",baseURL,v]
#define url_uppwd               [NSString stringWithFormat:@"%@account/uppwd",baseURL]
#define url_getPersonInfo(v)    [NSString stringWithFormat:@"%@account/person/pid/%@",baseURL,v]
#define url_upmarkname          [NSString stringWithFormat:@"%@account/upmarkname",baseURL]
#define url_deleteFriend        [NSString stringWithFormat:@"%@account/deleteFriend",baseURL]
#define url_getrc               [NSString stringWithFormat:@"%@account/getrc",baseURL]
#define url_getFrinds           [NSString stringWithFormat:@"%@account/friends",baseURL]
#define url_sendAuthCode(phone) [NSString stringWithFormat:@"%@account/verify-code?mobile=%@",baseURL,phone]

//------------------------------------- File ------------------------------------------------//
#define url_upImageToken(type)  [NSString stringWithFormat:@"%@file/upimgtoken/type/%@",baseURL,type]
#define url_upImageToCircle     [NSString stringWithFormat:@"%@file/upimg",baseURL]

//------------------------------------ Circle -----------------------------------------------//
#define url_createCircle        [NSString stringWithFormat:@"%@index/create",baseURL]
#define url_hots(page,sort)     [NSString stringWithFormat:@"%@index/circlehot/page/%ld/sort/%@",baseURL,page,sort]
#define url_circleDetail(v)     [NSString stringWithFormat:@"%@index/detail/cid/%@",baseURL,v]

#define url_upjscode            [NSString stringWithFormat:@"%@index/upjscode",baseURL]


//-------------------------------------- base ------------------------------------------------//


//-------------------------------------- base ------------------------------------------------//


#endif /* XFUrl_h */
