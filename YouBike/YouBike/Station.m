//
//  Station.m
//  YouBike
//
//  Created by 陳冠華 on 2017/5/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "Station.h"

@implementation Station



- (id)initName: (NSString *)name address: (NSString *)address numberOfRemainingBikes: (NSNumber *)numberOfRemainingBikes lati: (NSNumber *)lati longi:(NSNumber *) longi stationID: (NSString *)stationID {
    
    self = [super init];
    if (self) {
        
        self.name = name;
        self.address = address;
        self.numberOfRemainingBikes = numberOfRemainingBikes;
        self.lati = lati;
        self.longi = longi;
        self.stationID = stationID;
        
    }
    
    return self;
}



@end
