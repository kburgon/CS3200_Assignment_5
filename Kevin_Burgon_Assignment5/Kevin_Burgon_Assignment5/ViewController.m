//
//  ViewController.m
//  Kevin_Burgon_Assignment5
//
//  Created by student on 2/26/15.
//  Copyright (c) 2015 Kevin Burgon. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) NSString *locationText;
@property (nonatomic, strong) NSString *curTemp;
@property (weak, nonatomic) IBOutlet UILabel *todayTemperature;
@property (strong, nonatomic) IBOutlet UILabel *latLabel;
@property (strong, nonatomic) IBOutlet UILabel *longLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (nonatomic, strong) NSString *weatherSiteName;

@property (nonatomic, assign) CGFloat posLatitude;
@property (nonatomic, assign) CGFloat posLongitude;

@property (nonatomic, strong) CLLocationManager *curLocation;

@property (nonatomic, strong) NSMutableArray* tempPerDay;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.locationText = @"Logan";
    
//    self.todayTemperature.text = @"56";
	
//	NSLog(@"Initializing location manager...");
	
//	self.tempPerDay = [[NSMutableArray alloc] init];
	
    self.curLocation = [CLLocationManager new];
    self.curLocation.delegate = self;
    self.curLocation.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self.curLocation requestWhenInUseAuthorization];
    }
    
    [self.curLocation startUpdatingLocation];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)parseJSON:(NSDictionary*)json
{
//	[self.tempPerDay removeAllObjects];
    NSDictionary *city = [json objectForKey:@"city"];
    self.locationText = [city objectForKey:@"name"];
	NSArray *list = [json objectForKey:@"list"];

	NSMutableArray *temperatures = [NSMutableArray new];
//    NSLog(@"list size: %lu", (unsigned long)[list count]);
	for (NSDictionary *dayWeather in list)
    {
        NSDictionary *temp = [dayWeather objectForKey:@"temp"];
        NSString *dayTemp = [temp objectForKey:@"day"];
//        NSLog(@"today's temperature: %@", dayTemp);
        [temperatures addObject:dayTemp];
		NSLog(@"this temp: %@", [temperatures lastObject]);
    }
	self.curTemp = [temperatures firstObject];

//	NSLog(@"current temp: %@", [self.tempPerDay firstObject]);
//        self.tempPerDay = temperatures;
    
    dispatch_async(dispatch_get_main_queue(), ^{
		NSLog(@"String curTemp = %@", self.curTemp);
		self.locationLabel.text = self.locationText;
        [self.view reloadInputViews];
    });
}

-(void)getWeatherWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude
{
    self.latLabel.text = [NSString stringWithFormat:@"Latitude: %f", latitude];
    self.longLabel.text = [NSString stringWithFormat:@"Longitude: %f", longitude];
    NSURLSession *getForecast = [NSURLSession sharedSession];
    
//    NSLog(@"Raw Latitude: %f", latitude);
    NSString *latString = [NSString stringWithFormat:@"%f", latitude];
//    NSLog(@"Latitude: %@", latString);
    
//    NSLog(@"Raw Longitude: %f", longitude);
    NSString *longString = [NSString stringWithFormat:@"%f", longitude];
//    NSLog(@"Longitude: %@", longString);
    
    self.weatherSiteName = @"http://api.openweathermap.org/data/2.5/forecast/daily?lat=";
    weatherSiteName = [weatherSiteName stringByAppendingString:latString];
    weatherSiteName = [weatherSiteName stringByAppendingString:@"&lon="];
    weatherSiteName = [weatherSiteName stringByAppendingString:longString];
    weatherSiteName = [weatherSiteName stringByAppendingString:@"&cnt=7&units=imperial&APPID=3c045718f8871c3007d06f0e24cb09e2"];
    NSLog(@"URL: %@", weatherSiteName);
    
//    NSLog(@"Today's temperature: %@", _tempPerDay);
    
//    self.todayTemperature.text = _tempPerDay[0];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *locationNow = [locations lastObject];
	
//	NSLog(@"Starting to get location...");
	
    [self getWeatherWithLatitude:locationNow.coordinate.latitude andLongitude:locationNow.coordinate.longitude];

     NSURLSessionDataTask *getWeatherData = [getForecast dataTaskWithURL:[NSURL URLWithString:self.weatherSiteName] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [self parseJSON:json];
    }];
    
    [getWeatherData resume];
    
//    [self updateLatitude:locationNow.coordinate.latitude];
//    [self updateLongitude:locationNow.coordinate.longitude];
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Error!");
	NSLog(@"%@", [error localizedDescription]);
}

@end
