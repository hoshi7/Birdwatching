//
//  BirdSighitingCoreData.m
//  BirdWatching
//
//  Created by yusuke.hoshi on 2014/07/17.
//  Copyright (c) 2014年 nanapi.co.jp. All rights reserved.
//

#import "BirdSighitingCoreData.h"

@implementation BirdSighitingCoreData

@synthesize cacheName = cacheName_;
@synthesize xcdatamodelName = xcdatamodelName_;
@synthesize sqliteName = sqliteName_;
@synthesize fetchDelegate = fetchDelegate_;

static NSPersistentStoreCoordinator *persistentStoreCoordinator_ = nil;
static NSManagedObjectModel *managedObjectModel_ = nil;
static NSManagedObjectContext *managedObjectContext_ = nil;
static NSMutableDictionary *fetchedResultsController_ = nil;

- (id)init {
    if ( self = [super init] ) {
        fetchBatchSize_ = 20;
        cacheName_ = @"Root";
        self.fetchDelegate = self;
        fetchedResultsController_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (NSFetchedResultsController *)fetchedResultsController:(NSString *)entityName {
    NSFetchedResultsController *fetchedResultsController =
    [fetchedResultsController_ objectForKey:entityName];
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    // Create the request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entityName
                                   inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:fetchBatchSize_];
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor =
    [[NSSortDescriptor alloc]
     initWithKey:@"date"
     ascending:NO];
    NSArray *sortDescriptors =
    [[NSArray alloc]
     initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    // Edit the section name key and cache name if appropriate.
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc]
     initWithFetchRequest:fetchRequest
     managedObjectContext:[self managedObjectContext]
     sectionNameKeyPath:nil
     cacheName:self.cacheName
     ];
    aFetchedResultsController.delegate = self.fetchDelegate;
    
    fetchedResultsController = aFetchedResultsController;
    [fetchedResultsController_ setValue:fetchedResultsController forKey:entityName];
    NSError *error = nil;
    if ( ![fetchedResultsController performFetch:&error] ) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return fetchedResultsController;
}


- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] &&
            ![managedObjectContext save:&error])
        {
            abort();
        }
    }
}				


- (NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ =
        [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    /*
    NSString *modelPath = [[NSBundle mainBundle]
                           pathForResource:self.xcdatamodelName
                           ofType:@"momd"];*/
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.xcdatamodelName withExtension:@"momd"];
//    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc]
                           initWithContentsOfURL:modelURL];
    return managedObjectModel_;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    NSURL *storeURL =
    [[self applicationDocumentsDirectory]
     URLByAppendingPathComponent:self.sqliteName];
    NSError *error = nil;
    persistentStoreCoordinator_ =
    [[NSPersistentStoreCoordinator alloc]
     initWithManagedObjectModel:[self managedObjectModel]];
    if ( ![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType
                                                    configuration:nil
                                                              URL:storeURL
                                                          options:nil error:&error] )
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return persistentStoreCoordinator_;
}


- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory
             inDomains:NSUserDomainMask] lastObject];
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    //NSLog(@"SimpleCoreData");
}



#pragma mark -
#pragma mark API


- (NSManagedObject *)fetchObject:(NSString *)entityName
                         WithRow:(NSInteger)row AndSection:(NSInteger)section
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
    return [self fetchObject:entityName WithIndexPath:path];
}


- (NSManagedObject *)fetchObject:(NSString *)entityName
                   WithIndexPath:(NSIndexPath *)indexPath
{
    NSFetchedResultsController *fetchedResultsController = [self fetchedResultsController:entityName];
    return [fetchedResultsController objectAtIndexPath:indexPath];
}


- (NSInteger)countObjects:(NSString *)entityName {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext]];
    [request setIncludesSubentities:NO];
    
    NSError* error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    if (count == NSNotFound) {
        count = 0;
    }
    
    return count;
}
/*
- See more at: http://www.hnyssh.net/?p=227#sthash.1fPBtSYZ.dpuf
    NSFetchedResultsController *fetchedResultsController = [self fetchedResultsController:entityName];
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
    return [sectionInfo numberOfObjects];
}*/


- (NSInteger)countSections:(NSString *)entityName {
    return [[[self fetchedResultsController:entityName] sections] count];
}


- (void)deleteObject:(NSString *)entityName WithRow:(NSInteger)row AndSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self deleteObject:entityName WithIndexPath:indexPath];
}


- (void)deleteObject:(NSString *)entityName WithIndexPath:(NSIndexPath *)indexPath {
    NSFetchedResultsController *fetchedResultsController = [self fetchedResultsController:entityName];
    @try {
        NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
        if (managedObject) {
            [self deleteObject:entityName WithObject:managedObject];
        }
    }
    @catch (NSException * e) {
        NSLog(@"%@", e);
    }
}


- (void)deleteObject:(NSString *)entityName WithObject:(NSManagedObject *)managedObject {
    NSFetchedResultsController *fetchedResultsController = [self fetchedResultsController:entityName];	
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    [context deleteObject:managedObject];
    [self saveContext];
}


- (NSManagedObject *)newManagedObject:(NSString *)entryName {
    NSFetchedResultsController *fetchedResultsController = [self fetchedResultsController:entryName];
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    NSManagedObject *newManagedObject =
    [NSEntityDescription
     insertNewObjectForEntityForName:entryName
     inManagedObjectContext:context];
    return newManagedObject;
}


@end
