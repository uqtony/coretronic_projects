//
//  ViewController.m
//  tonyhud01
//
//  Created by tony.shih on 2015/12/15.
//  Copyright © 2015年 tony.shih. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) CGFloat originBrightness;
@property (strong) CLGeocoder *gecoder;
@property (nonatomic, strong) CLPlacemark *placemark;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initLocationManager];
    _gecoder = [[CLGeocoder alloc] init];
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _originBrightness = [UIScreen mainScreen].brightness;
    [[UIScreen mainScreen] setBrightness:1.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIScreen mainScreen] setBrightness:_originBrightness];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    switch (touch.view.tag) {
        case 1:
            // タグが1のビュー
            NSLog(@"ImageViewに触った");
            break;
        default:
            // それ以外
            NSLog(@"Viewに触った");
            break;
    }
    [[UIScreen mainScreen] setBrightness:1.0];
}

-(void)initLocationManager {
    _locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone; //whenever we move
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // Start monitor location
        [_locationManager startUpdatingLocation];
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
    }
    else {
        NSLog(@"Location service is not available!");
    }
    _speedLabel.text = [NSString stringWithFormat:@"0"];
    _mainView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
}

-(void)getAddressInfoFrom:(CLLocation*)location
{
    [_gecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error == nil && [placemarks count] > 0) {
            _placemark = [placemarks lastObject];
        }
        else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}

// 位置情報更新時
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    double speed = [newLocation speed];
    if (speed < 0)
        speed = 0.0;
    NSString *currentSpeed = [NSString stringWithFormat:@"%.2f", speed * 3.600];
    _speedLabel.text = currentSpeed;
    //緯度・経度を出力
    NSLog(@"didUpdateToLocation latitude=%f, longitude=%f, speed=%f",
          [newLocation coordinate].latitude,
          [newLocation coordinate].longitude,
          [newLocation speed]);
}

// 測位失敗時や、5位置情報の利用をユーザーが「不許可」とした場合などに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
    
}

@end
