//
//  ZHFVLocationManager.m
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/1.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import "ZHFVLocationManager.h"
#import <CoreLocation/CoreLocation.h>


@interface ZHFVLocationManager()<CLLocationManagerDelegate>

@property (nonatomic,strong ) CLLocationManager *locationManager;//定位服务

@property (nonatomic,assign) double latitude;//经度
@property (nonatomic,assign) double longitude;//维度


@end

@implementation ZHFVLocationManager
+(instancetype)shareInstance
{
    static dispatch_once_t pred;
    __strong static ZHFVLocationManager *shareObject = nil;
    dispatch_once(&pred, ^{
        shareObject = [self new];
    });
    return shareObject;
}

- (void)startUpdataLocate{
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
}

#pragma mark - 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
}
#pragma mark - 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    //当前的经纬度
    self.latitude = currentLocation.coordinate.latitude;
    self.longitude = currentLocation.coordinate.longitude;
    NSLog(@"当前的经纬度 %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
}
@end
