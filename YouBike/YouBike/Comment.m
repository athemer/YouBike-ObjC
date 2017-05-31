//
//  Comment.m
//  YouBike
//
//  Created by 陳冠華 on 2017/5/22.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

#import "Comment.h"

@implementation Comment



- (instancetype) initWithUsername: (NSString*) username userPictureUrl: (NSString *) userPictureUrl time: (NSString *) time text: (NSString *) text {

    _username = username;
    _userPictureUrl = userPictureUrl;
    _time = time;
    _text = text;
    
    return self;
}

@end
