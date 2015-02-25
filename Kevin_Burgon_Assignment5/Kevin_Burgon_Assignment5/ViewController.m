//
//  ViewController.m
//  Kevin_Burgon_Assignment5
//
//  Created by Student User on 2/24/15.
//  Copyright (c) 2015 student. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *temperature;
@property (nonatomic, strong) UIImageView *todayWeatherView;
@property (nonatomic, strong) UICollectionView *forCastView;

@end

@implementation ViewController

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.cityLabel.text = @"Logan";
        self.cityLabel.textColor = [UIColor blackColor];
        [self.view addSubview:self.cityLabel];
        
        self.temperature = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 100)];
        self.temperature.text = @"-5";
        self.temperature.textColor = [UIColor blackColor];
        [self.view addSubview:self.temperature];
        
//        self.todayWeatherView [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
//        UIImage *weatherImage = [UIImage imageNamed:@"testImage"];
//        self.todayWeatherView.contentMode = UIViewContentModeScaleAspectFill;
//        self.todayWeatherView.image = weatherImage;
//        
//        self.forCastView = [[UICollectionView alloc] init];
    }
    return self;
}

@end