//
//  ViewController.m
//  Kevin_Burgon_Assignment5
//
//  Created by student on 2/26/15.
//  Copyright (c) 2015 Kevin Burgon. All rights reserved.
//

#import "ViewController.h"
#import "WeatherViewCell.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

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


@property (nonatomic, strong) NSMutableArray *forecastDicArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.forecastDicArray = [NSMutableArray new];
	
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
    NSDictionary *city = [json objectForKey:@"city"];
    NSString *name = [city objectForKey:@"name"];
    NSArray *list = [json objectForKey:@"list"];
//    NSMutableArray *forecastDic;
    
    NSDictionary *neededInfo;
    
    for (NSDictionary *dailyForecast in list)
    {
        neededInfo = @{
                       @"date" : [dailyForecast objectForKey:@"dt"],
                       @"highTemp" : [[dailyForecast objectForKey:@"temp"] objectForKey:@"max"],
                       @"lowTemp" : [[dailyForecast objectForKey:@"temp"] objectForKey:@"min"],
//                                     @"weatherIcon" : [[dailyForecast objectForKey:@"weather"] objectForKey:@"icon"]
                       };
        
        NSLog(@"%@", [neededInfo objectForKey:@"highTemp"]);
        
        [self.forecastDicArray addObject:neededInfo];
        
    }
    
    self.locationText = name;
    
//
}

-(void)getWeatherWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude
{
    self.latLabel.text = [NSString stringWithFormat:@"Latitude: %f", latitude];
    self.longLabel.text = [NSString stringWithFormat:@"Longitude: %f", longitude];
    
    
//    NSLog(@"Raw Latitude: %f", latitude);
    NSString *latString = [NSString stringWithFormat:@"%f", latitude];
//    NSLog(@"Latitude: %@", latString);
    
//    NSLog(@"Raw Longitude: %f", longitude);
    NSString *longString = [NSString stringWithFormat:@"%f", longitude];
//    NSLog(@"Longitude: %@", longString);
    
    self.weatherSiteName = @"http://api.openweathermap.org/data/2.5/forecast/daily?lat=";
    self.weatherSiteName = [self.weatherSiteName stringByAppendingString:latString];
    self.weatherSiteName = [self.weatherSiteName stringByAppendingString:@"&lon="];
    self.weatherSiteName = [self.weatherSiteName stringByAppendingString:longString];
    self.weatherSiteName = [self.weatherSiteName stringByAppendingString:@"&cnt=7&units=imperial&APPID=3c045718f8871c3007d06f0e24cb09e2"];
    NSLog(@"URL: %@", self.weatherSiteName);
    
//    NSLog(@"Today's temperature: %@", _tempPerDay);
    
//    self.todayTemperature.text = _tempPerDay[0];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *locationNow = [locations lastObject];
	
//	NSLog(@"Starting to get location...");
	
    [self getWeatherWithLatitude:locationNow.coordinate.latitude andLongitude:locationNow.coordinate.longitude];

    NSURLSession *getForecast = [NSURLSession sharedSession];
    NSURLSessionDataTask *getWeatherData = [getForecast dataTaskWithURL:[NSURL URLWithString:self.weatherSiteName] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [self parseJSON:json];
        NSString *testTemp = [self.forecastDicArray[0] objectForKey:@"highTemp"];
        NSLog(@"Converted Temp: %@", testTemp);
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.todayTemperature.text = [self.forecastDicArray[0] objectForKey:@"highTemp"];
            self.locationLabel.text = self.locationText;
            [self.view reloadInputViews];
        });
    }];
    
    [getWeatherData resume];
    
    
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Error!");
	NSLog(@"%@", [error localizedDescription]);
}

// number of items in the collectionview
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

// the size for each item in the collection
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

// return the cell for indexpath
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    return cell;
}

@end
