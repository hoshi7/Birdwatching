//
//  BirdsDetailViewController.h
//  BirdWatching
//
//  Created by yusuke.hoshi on 2014/07/04.
//  Copyright (c) 2014年 nanapi.co.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BirdSighting;

@interface BirdsDetailViewController : UITableViewController

@property (strong, nonatomic) BirdSighting *sighting;
@property (weak, nonatomic) IBOutlet UILabel *birdNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
