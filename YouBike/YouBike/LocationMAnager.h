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



+ (instancetype)sharedInstance;
- (void)requestUserLocationAlways;
- (void)requestUserLocationWhenInUse;
- (void)start;
- (void)stop;
- (void)getPolylineFrom:(CLLocationCoordinate2D)sourceCoordinate
                     to:(CLLocationCoordinate2D)destinationCoordinate
      withTransportType:(MKDirectionsTransportType)transportType
  withCompletionHandler:(void (^_Nullable)(MKPolyline *_Nullable polyline, NSError *_Nullable error))completionHandler;



@end
