//
//  BirdsMasterViewController.m
//  BirdWatching
//
//  Created by yusuke.hoshi on 2014/07/04.
//  Copyright (c) 2014年 nanapi.co.jp. All rights reserved.
//

#import "BirdsMasterViewController.h"
#import "BirdsDetailViewController.h"
#import "BirdSightingDataController.h"
#import "BirdSighting.h"
#import "AddSightingViewController.h"

/*
@interface BirdsMasterViewController () {
    NSMutableArray *_objects;
}
@end
*/

@interface BirdsMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation BirdsMasterViewController
@synthesize simpleCoreData = simpleCoreData_;

- (void)awakeFromNib
{
    [super awakeFromNib];

//    self.simpleCoreData = simpleCoreData_;
//    self.dataController = [[BirdSightingDataController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.simpleCoreData = [[BirdSighitingCoreData alloc] init];
	self.simpleCoreData.xcdatamodelName = @"BirdSightingModel";
	self.simpleCoreData.sqliteName = @"BirdSightingModel";
    
	[self.simpleCoreData fetchedResultsController:@"BirdSighting"].delegate = self;
    
    self.navigationItem.rightBarButtonItem.accessibilityHint = @"Adds a newbird-sighting event";
    
   
	// Do any additional setup after loading the view, typically from a nib.
/*
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
 */
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	[self.simpleCoreData fetchedResultsController:@"BirdSighting"].delegate = self;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	NSManagedObject *managedObject = [self.simpleCoreData fetchObject:@"BirdSighting" WithIndexPath:indexPath];
	cell.textLabel.text = [[managedObject valueForKey:@"date"] description];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
*/


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [self.simpleCoreData countSections:@"BirdSighting"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.simpleCoreData countObjects:@"BirdSighting"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObject *managedObject = [self.simpleCoreData fetchObject:@"BirdSighting" WithIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"BirdSightingCell";
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    BirdSighting *sightingAtIndex = [BirdSighting alloc];
    sightingAtIndex.name = [[managedObject valueForKey:@"name"] description];
    sightingAtIndex.location = [[managedObject valueForKey:@"location"] description];
    sightingAtIndex.date = [formatter dateFromString:[[managedObject valueForKey:@"date"] description]];
//    BirdSighting *sightingAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    [[cell textLabel] setText:sightingAtIndex.name];
    [[cell detailTextLabel] setText:[formatter stringFromDate:(NSDate*)sightingAtIndex.date]];
    
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowSightingDetails"]) {
        BirdsDetailViewController *detailViewController = [segue
                                                           destinationViewController];
        
        NSManagedObject *managedObject = [self.simpleCoreData fetchObject:@"BirdSighting" WithIndexPath:[self.tableView indexPathForSelectedRow]];
        
//        static NSString *CellIdentifier = @"BirdSightingCell";
        static NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
        }
        BirdSighting *sightingAtIndex = [BirdSighting alloc];
        sightingAtIndex.name = [[managedObject valueForKey:@"name"] description];
        sightingAtIndex.location = [[managedObject valueForKey:@"location"] description];
        sightingAtIndex.date = [managedObject valueForKey:@"date"];
        detailViewController.sighting = sightingAtIndex;

//        detailViewController.sighting = [self.dataController
 //                                        objectInListAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
    
}
- (IBAction)done:(UIStoryboardSegue *)segue
{
    if([[segue identifier] isEqualToString:@"ReturnInput"]){
        AddSightingViewController *addController = [segue sourceViewController];
        
        if(addController.birdSighting){
//            [self.dataController addBirdSightingWithSighting:addController.birdSighting];
            NSManagedObject *newManagedObject = [self.simpleCoreData newManagedObject:@"BirdSighting"];
            [newManagedObject setValue:addController.birdSighting.date forKey:@"date"];
            [newManagedObject setValue:addController.birdSighting.name forKey:@"name"];
            [newManagedObject setValue:addController.birdSighting.location forKey:@"location"];
            [self.simpleCoreData saveContext];

            [[self tableView] reloadData];
        }
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if([[segue identifier] isEqualToString:@"CancelInput"]){
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	
    UITableView *tableView = self.tableView;
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
					atIndexPath:indexPath];
            break;
			
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

@end

