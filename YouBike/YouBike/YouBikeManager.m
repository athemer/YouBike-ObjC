//
//  YouBikeManager.m
//  YouBike
//
//  Created by 陳冠華 on 2017/5/15.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "YouBikeManager.h"
#import <AFNetworking.h>
#import "Station.h"
#import "ViewController.h"
#import "Comment.h"





@interface YouBikeManager()



@end



@implementation YouBikeManager


+ (instancetype)sharedInstance {
    
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YouBikeManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    
    self = [super init];
    
    self.stationArray = [[NSMutableArray alloc] init];
//    self.commentArray = [[NSMutableArray alloc] init];
    self.stationParameter = [[NSString alloc] init];
    self.commentParameter = [[NSString alloc] init];
    
    return self;
    
}

- (void)signInWithFacebookWithAccessToken:(NSString*)accessToken
                    withCompletionHandler:(void (^__nonnull)(NSString * __nullable token,
                                                             NSString * __nullable tokenType,
                                                             NSError * __nullable error))completionHandler {
    
    NSString *urlString = [NSString stringWithFormat: @"%@%@", @"http://52.198.40.72/youbike/v1", @"/sign-in/facebook"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    
    NSDictionary *parameter = @{@"accessToken": accessToken};
    
    NSData *rawJson = [NSJSONSerialization dataWithJSONObject: parameter options:NSJSONWritingPrettyPrinted error: nil];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = rawJson;
    [request addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration: configuration];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest: request completionHandler:^(NSURLResponse * _Nonnull response,
                                                                                          id  _Nullable responseObject,
                                                                                          NSError * _Nullable error) {
        if (error != nil) {
            
            NSLog(@"%@", error);
            completionHandler(nil, nil, error);
            return;
            
        }
        
        NSDictionary *jsonObject = (NSDictionary *)responseObject;
        
        if (jsonObject == nil) {
            return;
        }
        
        NSDictionary *data = [jsonObject objectForKey: @"data"];
        
        if (data == nil) {
            return;
        }
        
        NSString *token = [data objectForKey: @"token"];
        
        NSString *tokenType = [data objectForKey: @"tokenType"];
        
        [NSUserDefaults.standardUserDefaults setObject:token forKey: @"token"];
        
        [NSUserDefaults.standardUserDefaults setObject:tokenType forKey: @"tokenType"];
        
        completionHandler(token, tokenType, nil);
    }];
    
    [task resume];
    
}



- (void)getStations {
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", @"http://52.198.40.72/youbike/v1", @"/stations"];
    
    NSString *token = [NSUserDefaults.standardUserDefaults objectForKey: @"token"];
    
    NSString *tokenType = [NSUserDefaults.standardUserDefaults objectForKey: @"tokenType"];
    
    NSString *authString = [NSString stringWithFormat: @"%@ %@", tokenType, token];
    
    NSDictionary *param;
    
    if (self.stationParameter != nil) {
        param = @{ @"paging": self.stationParameter};
    }
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:authString forHTTPHeaderField: @"Authorization"];
    
    [manager GET:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        NSDictionary *jsonObject = (NSDictionary *)responseObject;
        
        if (jsonObject == nil) {
            return;
        }
        
        NSDictionary *data = [jsonObject objectForKey:@"data"];
        
        if (data == nil) {
            return;
        }
        
        NSDictionary *paging = [jsonObject objectForKey:@"paging"];

        NSString *nextPage = [paging objectForKey:@"next"];
        
        if (nextPage != nil) {
            self.stationParameter = nextPage;
        } else {
            self.stationParameter = nil;
        }
        
        NSLog(@" station parameter %@", self.stationParameter);
        
        for (NSDictionary *station in data) {
            //
            NSString *remainBikes = [station objectForKey: @"sbi"];
            NSString *stationNameCH = [station objectForKey: @"sna"];
            NSString *stationNameEN = [station objectForKey: @"snaen"];
            NSString *stationAddressCH = [station objectForKey: @"ar"];
            NSString *stationAddressEN = [station objectForKey: @"aren"];
            NSString *lati = [station objectForKey: @"lat"];
            NSString *longi = [station objectForKey: @"lng"];
            NSString *stationID = [station objectForKey: @"sno"];
            
            int remainBikeValue = [remainBikes intValue];
            double latiValue = [lati doubleValue];
            double longiValue = [longi doubleValue];
            
            
            Station *stationData = [[Station alloc] initName: stationNameCH address: stationAddressCH numberOfRemainingBikes: remainBikeValue lati: latiValue longi: longiValue stationID: stationID];
            
//            Station *oneStation = [[Station alloc] initWithName:stationNameCH nameEN:stationNameEN addressCH:stationAddressCH addressEN:stationAddressEN numberOfRemainingBikes:remainBikeValue lati:latiValue longi:longiValue stationID:stationID];
            
            [self.stationArray addObject: stationData];
            
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate manager:self didGet: self.stationArray];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate manager:self didFailWith:error];
        });
        
    }];
    
}


- (void)getCommentWithID:(NSString *)stationID withCompletionHandler:(void (^__nonnull)(NSMutableArray<Comment *> * __nullable comments,
                                                                                        NSError * __nullable error))completionHandler {
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@%@", @"http://52.198.40.72/youbike/v1", @"/stations", stationID, @"/comment"];
    
    NSString *token = [NSUserDefaults.standardUserDefaults objectForKey:@"token"];
    
    NSString *tokenType = [NSUserDefaults.standardUserDefaults objectForKey:@"tokenType"];
    
    NSString *authString = [NSString stringWithFormat:@"%@ %@", tokenType, token];
    
    NSDictionary *param;
    
    if (self.commentParameter != nil) {
        param = @{@"paging": self.commentParameter};
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:authString forHTTPHeaderField:@"Authorization"];
    
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *jsonObject = (NSDictionary *)responseObject;
        
        if (jsonObject == nil) {
            return;
        }
        
        NSDictionary *data = [jsonObject objectForKey:@"data"];
        
        if (data == nil) {
            return;
        }
        
        NSDictionary *paging = [jsonObject objectForKey:@"paging"];
        
        NSString *nextPage = [paging objectForKey:@"next"];
        
        if (nextPage != nil) {
            self.commentParameter = nextPage;
        } else {
            self.commentParameter = nil;
        }
        
        for (NSDictionary *comment in data) {
            
            NSDictionary *userData = [comment objectForKey:@"user"];
            
            NSString *text = [comment objectForKey:@"text"];
            
            NSString *time = [comment objectForKey:@"created"];
            
            if (userData == nil) {
                continue;
            }
            
            NSString *username = [userData objectForKey:@"name"];
            
            NSString *pictureUrl = [userData objectForKey:@"picture"];
            
            Comment *comments = [[Comment alloc] initWithUsername:username userPictureUrl:pictureUrl time:time text:text];
            
            [self.commentArray addObject:comments];
        }
        
        completionHandler(self.commentArray, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSLog(@"%@", error);
        completionHandler(nil, error);
    }];
    
    
}


@end
