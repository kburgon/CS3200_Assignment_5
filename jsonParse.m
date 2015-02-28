NSDictionary *city = [json objectForKey:@"city"];
	NSString *name = [city objectForKey:@"name"];
NSArray *list = [json objectForKey:@"list"];
NSMutableArray *forecastDic;
for (NSDictionary *dailyForecast in list)
{
	NSDictionary *neededInfo = @{
		@"date", [dailyForecast objectForKey:@"dt"];
		@"highTemp", [[dailyForecast objectForKey:@"temp"] objectForKey:@"max"];
		@"lowTemp", [[dailyForecast objectForKey:@"temp"] objectForKey:@"min"];
		@"weatherIcon", [[dailyForecast objectForKey:@"weather"] objectForKey:@"icon"];
	}
}