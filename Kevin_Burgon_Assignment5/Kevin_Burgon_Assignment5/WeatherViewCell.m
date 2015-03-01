//
//  WeatherViewCell.m
//  Kevin_Burgon_Assignment5
//
//  Created by student on 2/28/15.
//  Copyright (c) 2015 Kevin Burgon. All rights reserved.
//

#import "WeatherViewCell.h"

@interface WeatherViewCell ()

@property (nonatomic, strong) NSDictionary *cellInfo;


@end

@implementation WeatherViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:(CGRect)frame];
    if(self)
    {
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}


@end
