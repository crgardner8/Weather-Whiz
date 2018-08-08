//
//  AddLocationViewController.h
//  WeatherWhiz
//
//  Created by Clifton Gardner on 8/5/18.
//  Copyright © 2018 Clifton Gardner. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WWLocation.h"

@import CoreLocation;

@protocol WWLocationDelegate <NSObject>
@required
-(void) updateViewForLocation:(WWLocation *)weatherLocation FromLocations:(NSArray *)locations;

@end

@interface AddCityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<WWLocationDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *locationsList;

@end
