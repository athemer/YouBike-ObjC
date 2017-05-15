//
//  LocationMAnager.h
//  YouBike
//
//  Created by 陳冠華 on 2017/5/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface LocationMAnager : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *nowLocation;
@property (strong, nonatomic) CLPlacemark *nowPlaceMark;
@property Boolean *isFirstLocationReceived;

@property (class) LocationMAnager * shared;


- (void) getPlylineWithsourceCoordinate: (CLLocationCoordinate2D *) sourceCoordinate
                 destinationCooridenate: (CLLocationCoordinate2D *) destinationCooridenate
                          transportType: (MKDirectionsTransportType *) transportType
                                success: (void (^)(MKPolyline * ployilne)) successHandler
                                failure: (void (^)(NSError * error)) faulureHandler;

@end
