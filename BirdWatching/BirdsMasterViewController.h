//
//  BirdsMasterViewController.h
//  BirdWatching
//
//  Created by yusuke.hoshi on 2014/07/04.
//  Copyright (c) 2014年 nanapi.co.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BirdSighitingCoreData.h"

@class BirdSightingDataController;
@interface BirdsMasterViewController : UITableViewController<NSFetchedResultsControllerDelegate>{
    BirdSighitingCoreData *simpleCoreData_;
}

@property (nonatomic, retain) BirdSighitingCoreData *simpleCoreData;

//@property (strong, nonatomic) BirdSightingDataController *dataController;
- (IBAction)done:(UIStoryboardSegue *) segue;
- (IBAction)cancel:(UIStoryboardSegue *) segue;
@end
