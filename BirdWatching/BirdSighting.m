//
//  BirdSighting.m
//  BirdWatching
//
//  Created by yusuke.hoshi on 2014/07/04.
//  Copyright (c) 2014年 nanapi.co.jp. All rights reserved.
//

#import "BirdSighting.h"

@implementation BirdSighting
-(id)initWithName:(NSString *)name location:(NSString *)location date:(NSDate *)date{
    self = [super init];
    if(self){
        _name = name;
        _location = location;
        _date = date;
        return self;
    }
    return nil;
}
@end
