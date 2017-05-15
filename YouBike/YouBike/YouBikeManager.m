//
//  YouBikeManager.m
//  YouBike
//
//  Created by 陳冠華 on 2017/5/15.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "YouBikeManager.h"

@implementation YouBikeManager





-(void) signInWithFacebookaccessToken: (NSString *) accessToken {
    
    
    NSString *string1 = [Constants server];
    NSString *string2 = [Constants login];
    NSString *str = [NSString stringWithFormat: @"%@%@", string1, string2];
    
    NSString * const urlString = str;
    NSURL * const url = [[NSURL alloc] initWithString: urlString];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL: url];
    NSDictionary * const parameter = [[NSDictionary alloc] init];
    [parameter setValue: accessToken forKey: @"accessToken"];
    
    NSData * const rawJson = [NSJSONSerialization dataWithJSONObject: parameter options: NSJSONWritingPrettyPrinted error: nil];
    
    [request setHTTPMethod: [Constants post]];
    [request setHTTPBody: rawJson];
    [request addValue: @"application/jsopn" forHTTPHeaderField: @"Content-Type"];
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * const session = [NSURLSession sessionWithConfiguration: defaultConfiguration delegate: self delegateQueue: dispatch_get_main_queue()];
    
    NSURLSessionTask * const task = [session downloadTaskWithRequest: request];
    [task resume];
    
    
}


-(void) getStations {
    
    NSString *string1 = [Constants server];
    NSString *string2 = [Constants station];
    NSString *str = [NSString stringWithFormat: @"%@%@", string1, string2];
    
    NSString * const urlString = str;
    NSURL * const url = [[NSURL alloc] initWithString: [Constants server] ];
    
    _userDefault = [NSUserDefaults standardUserDefaults];
    
    NSDictionary * const authorizeData = [_userDefault objectForKey: [Constants SignInReturn]];
    
    id token = [authorizeData valueForKey: @"token"];
    id tokenType = [authorizeData valueForKey: @"tokenType"];
    
    NSString * authString = [NSString stringWithFormat: @"%@ %@", token, tokenType];
    NSDictionary * headers = [[NSDictionary alloc] init];
    [headers setValue: authString forKey: @"Authorization"];
    
    NSDictionary * param = [[NSDictionary alloc] init];
    [param setValue: _stationParameter forKey: @"paging"];
    
    
    
    
}

@end
