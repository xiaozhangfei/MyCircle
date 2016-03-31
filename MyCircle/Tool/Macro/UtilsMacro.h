//
//  UtilsMacro.h
//  Here
//
//  Created by liumadu on 15-1-5.
//  Copyright (c) 2015年 lmd. All rights reserved.
//

#ifndef BaMaRemind_UtilsMacro_h
#define BaMaRemind_UtilsMacro_h

#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
// rgb颜色转换（16进制->10进制）
#define HexColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIFontOfSize(s) [UIFont systemFontOfSize:s]
#define NSStringFromInt(intValue) [NSString stringWithFormat:@"%d", intValue]
#define NSStringFromFloat(floatValue) [NSString stringWithFormat:@"%f", floatValue]
#define IsKindOfClass(_x, _class) ([_x isKindOfClass:[_class class]])
#define RespondsToSelector(_c, _m) ([_c respondsToSelector:_m])
#define ISNull(_x)   ([_x isKindOfClass:[NSNull class]] || _x == nil)
#define HAVECONTROLLER(value) if(value == nil || value.controller == nil){return;}
#define ARRAY_VALUE(value) (value != nil && [value count] > 0)



#endif
