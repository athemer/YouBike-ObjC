//
//  YouBikeManager.h
//  YouBike
//
//  Created by 陳冠華 on 2017/5/15.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <AFNetworking.h>



@interface YouBikeManager : NSObject <NSURLSessionDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>



@property (class) YouBikeManager *shared;
@property NSUserDefaults *userDefault;
@property NSString *stationParameter;
@property NSString *commentParameter;


@end
