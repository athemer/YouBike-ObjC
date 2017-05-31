//
//  LocationMAnager.m
//  YouBike
//
//  Created by 陳冠華 on 2017/5/12.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "LocationMAnager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@implementation LocationMAnager


+ (instancetype)sharedInstance {
    
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        
    }
    
    return self;
}

- (void)requestWhenInUse {
    
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.activityType = CLActivityTypeOther;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 10.0;
    
}


- (void)requestAlwaysInUse {
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.activityType = CLActivityTypeOther;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 10.0;
    
}

- (void)start {
    
    [self.locationManager startUpdatingLocation];

}

-(void)stop {
    
    [self.locationManager stopUpdatingLocation];
    
}


- (NSString *) getCountry {
    
    if (_isFirstLocationReceived || _nowPlaceMark == nil) {
        
        return @"Unknown";
        
    }

    NSString *const country = _nowPlaceMark.country;
    
    return country;
}



- (void)getLocation:(void (^)(double lati, double longi)) result
{
    
    if (_isFirstLocationReceived) {
        
        result (0, 0);
        
    }

    double lati = _nowLocation.coordinate.latitude;
    double longi = _nowLocation.coordinate.longitude;

    result(lati, longi);
    
}



//
//- (void) getPlylineWithsourceCoordinate: (CLLocationCoordinate2D *) sourceCoordinate
//                 destinationCooridenate: (CLLocationCoordinate2D *) destinationCooridenate
//                          transportType: (MKDirectionsTransportType *) transportType
//                                success: (void (^)(MKPolyline * ployilne)) successHandler
//                                failure: (void (^)(NSError * error)) faulureHandler {
//    
//    
//    MKPlacemark * const sourcePlaceMark  = [[MKPlacemark alloc] initWithCoordinate: *sourceCoordinate addressDictionary: NULL];
//    MKMapItem * const sourceMapItem = [[MKMapItem alloc] initWithPlacemark: sourcePlaceMark];
//                                    
//    MKPlacemark *const destinationPlaceMark  = [[MKPlacemark alloc] initWithCoordinate: *destinationCooridenate addressDictionary: NULL];
//    MKMapItem * const destinationMapItem = [[MKMapItem alloc] initWithPlacemark: destinationPlaceMark];
//    
//    MKDirectionsRequest * const directionsRequest = [[MKDirectionsRequest alloc]init ];
//                                    
//    directionsRequest.transportType = *(transportType);
//    directionsRequest.source = sourceMapItem;
//    directionsRequest.destination = destinationMapItem;
//                                    
//    MKDirections * const directions = [[MKDirections alloc] initWithRequest: directionsRequest];
//    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
//                                       
//        if (error != nil) {
//                                            
//            faulureHandler(error);
//            NSLog(@"error: %@", error);
//            
//            return;
//        }
//        
//        MKPolyline * const polyline = response.routes.firstObject.polyline;
//        
//        successHandler(polyline);
//        
//    }];
//}


- (void)getPolylineFrom:(CLLocationCoordinate2D)sourceCoordinate
                     to:(CLLocationCoordinate2D)destinationCoordinate
      withTransportType:(MKDirectionsTransportType)transportType
  withCompletionHandler:(void (^)(MKPolyline *__nullable polyline, NSError *__nullable error))completionHandler {
    
    MKPlacemark *sourcePlacemark            = [[MKPlacemark alloc] initWithCoordinate:sourceCoordinate];
    MKMapItem *sourceMapItem                = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    
    MKPlacemark *destinationPlacemark       = [[MKPlacemark alloc] initWithCoordinate:destinationCoordinate];
    MKMapItem *destinationMapItem           = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    MKDirectionsRequest *directionRequest   = [[MKDirectionsRequest alloc] init];
    directionRequest.transportType          = transportType;
    directionRequest.source                 = sourceMapItem;
    directionRequest.destination            = destinationMapItem;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionRequest];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            completionHandler(nil, error);
        }
        
        MKPolyline *polyline = response.routes.firstObject.polyline;
        
        completionHandler(polyline, nil);
        
    }];
    
}

@end
