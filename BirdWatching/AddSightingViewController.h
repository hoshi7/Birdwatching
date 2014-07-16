//
//  AddSightingViewControllerTableViewController.h
//  BirdWatching
//
//  Created by yusuke.hoshi on 2014/07/09.
//  Copyright (c) 2014年 nanapi.co.jp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BirdSighting;
@interface AddSightingViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *birdNameInput;
@property (weak, nonatomic) IBOutlet UITextField *locationInput;
@property (strong, nonatomic) BirdSighting *birdSighting;
@end
