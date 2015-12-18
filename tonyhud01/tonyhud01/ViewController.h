//
//  ViewController.h
//  tonyhud01
//
//  Created by tony.shih on 2015/12/15.
//  Copyright © 2015年 tony.shih. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel* speedLabel;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, weak) IBOutlet UIView *mainView;

@end

