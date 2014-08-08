//
//  BirdsAppDelegate.h
//  BirdWatching
//
//  Created by yusuke.hoshi on 2014/07/04.
//  Copyright (c) 2014年 nanapi.co.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BirdSighitingCoreData.h"

@interface BirdsAppDelegate : UIResponder <UIApplicationDelegate>{
    BirdSighitingCoreData *simpleCoreData_;
}

@property (strong, nonatomic) UIWindow *window;

@end
