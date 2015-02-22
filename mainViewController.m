// Kevin Burgon
// A01468470
// Assignment 5

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

		self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 100, 100)];
		self.cityLabel.text = @"Logan";
		[self.view addsubView:self.cityLabel];

		self.temperature = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 50, 100)];
		self.temperature = @"-5";
		[self.view addsubView:self.temperature];

		self.todayWeatherView [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
		UIImage *weatherImage = [UIImage imageNamed:@"testImage"];
		self.todayWeatherView.contentMode = UIViewContentModeScaleAspectFill;
		newImageViewer.image = weatherImage;

		self.forCastView = [[UICollectionView alloc] init];
	}
}

@end