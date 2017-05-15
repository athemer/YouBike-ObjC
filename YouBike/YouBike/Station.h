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
@property NSNumber *numberOfRemainingBikes;
@property NSNumber *lati;
@property NSNumber *longi;
@property NSString *stationID;

- (id)initName: (NSString *)name address: (NSString *)address numberOfRemainingBikes: (NSNumber *)numberOfRemainingBikes lati: (NSNumber *)lati longi:(NSNumber *) longi stationID: (NSString *)stationID;

@end
