//
//  CorePagesBarBtn.m
//  CorePagesView
//
//  Created by muxi on 15/3/20.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CorePagesBarBtn.h"

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define HexColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation CorePagesBarBtn


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        //个性化
        [self corePagesBarBtnPrePare];
    }
    
    return self;
}



-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    
    if(self){
        
        //个性化
        [self corePagesBarBtnPrePare];
    }
    
    return self;
}

/**
 *  个性化
 */
-(void)corePagesBarBtnPrePare{
    
    [self setTitleColor:rgba(0, 0, 0, 1) forState:UIControlStateNormal];
    [self setTitleColor:rgba(90, 90, 90, 1) forState:UIControlStateHighlighted];
    [self setTitleColor:HexColor(0x51B9C7) forState:UIControlStateSelected];
}


@end
