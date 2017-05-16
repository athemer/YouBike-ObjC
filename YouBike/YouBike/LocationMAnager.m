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


- (id) init {
    
    _locationManager = [[CLLocationManager alloc] init];
    _isFirstLocationReceived = YES;
    return self;
}

- (void)requestWhenInUse {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.activityType = CLActivityTypeOther;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 10.0;
    
}


- (void)requestAlwaysInUse {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.activityType = CLActivityTypeOther;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 10.0;
    
}

- (void)start {
    
    self.locationManager.startUpdatingLocation;

}

-(void)stop {
    
    self.locationManager.stopUpdatingLocation;
    
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




- (void) getPlylineWithsourceCoordinate: (CLLocationCoordinate2D *) sourceCoordinate
                 destinationCooridenate: (CLLocationCoordinate2D *) destinationCooridenate
                          transportType: (MKDirectionsTransportType *) transportType
                                success: (void (^)(MKPolyline * ployilne)) successHandler
                                failure: (void (^)(NSError * error)) faulureHandler {
    
    
    MKPlacemark * const sourcePlaceMark  = [[MKPlacemark alloc] initWithCoordinate: *sourceCoordinate addressDictionary: NULL];
    MKMapItem * const sourceMapItem = [[MKMapItem alloc] initWithPlacemark: sourcePlaceMark];
                                    
    MKPlacemark *const destinationPlaceMark  = [[MKPlacemark alloc] initWithCoordinate: *destinationCooridenate addressDictionary: NULL];
    MKMapItem * const destinationMapItem = [[MKMapItem alloc] initWithPlacemark: destinationPlaceMark];
    
    MKDirectionsRequest * const directionsRequest = [[MKDirectionsRequest alloc]init ];
                                    
    directionsRequest.transportType = *(transportType);
    directionsRequest.source = sourceMapItem;
    directionsRequest.destination = destinationMapItem;
                                    
    MKDirections * const directions = [[MKDirections alloc] initWithRequest: directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
                                       
        if (error != nil) {
                                            
            faulureHandler(error);
            NSLog(@"error: %@", error);
            
            return;
        }
        
        MKPolyline * const polyline = response.routes.firstObject.polyline;
        
        successHandler(polyline);
        
    }];
}



@end
