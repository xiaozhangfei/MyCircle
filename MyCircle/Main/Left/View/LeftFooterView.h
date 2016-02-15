//
//  LeftFooterView.h
//  MyCircle
//
//  Created by and on 15/12/30.
//  Copyright © 2015年 and. All rights reserved.
//

#import <UIKit/UIKit.h>
//定位
#import <CoreLocation/CoreLocation.h>
#import "BtnExt.h"
@interface LeftFooterView : UIView <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;//定位
    CLGeocoder *_geocoder;//位置编码
}
@property (weak, nonatomic) BtnExt *setView;
@property (weak, nonatomic) BtnExt *nightView;
@property (weak, nonatomic) UIView *weatherView;
@property (strong, nonatomic) UILabel *degreeLabel;
@property (strong, nonatomic) UILabel *locationLabel;

//刷新位置，更新天气
- (void)locationAction;
//更新天气
- (void)refreshWeather;

@end
