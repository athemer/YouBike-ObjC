//
//  Station.h
//  YouBike
//
//  Created by 陳冠華 on 2017/5/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Station : NSObject

@property NSString *name;
@property NSString *address;
@property int numberOfRemainingBikes;
@property double lati;
@property double longi;
@property NSString *stationID;

- (id)initName: (NSString *)name address: (NSString *)address numberOfRemainingBikes: (int )numberOfRemainingBikes lati: (double) lati longi:(double) longi stationID: (NSString *)stationID;

@end
