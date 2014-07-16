//
//  BirdsMasterViewController.h
//  BirdWatching
//
//  Created by yusuke.hoshi on 2014/07/04.
//  Copyright (c) 2014年 nanapi.co.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BirdSightingDataController;
@interface BirdsMasterViewController : UITableViewController
@property (strong, nonatomic) BirdSightingDataController *dataController;
- (IBAction)done:(UIStoryboardSegue *) segue;
- (IBAction)cancel:(UIStoryboardSegue *) segue;
@end
