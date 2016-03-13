//
//  CoreDataViewController.m
//  Productive
//
//  Created by Kim on 01/09/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import "CoreDataViewController.h"

@interface CoreDataViewController ()

@end

@implementation CoreDataViewController

- (void)saveManagedObjectContext {
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges]){
        if (![self.managedObjectContext save: &error]) {//save failed
            NSLog(@"Save failed: %@", [error localizedDescription]);
        } else {
            NSLog(@"Save succesfull");
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    return  [(AppDelegate *)[[UIApplication sharedApplication]delegate]managedObjectContext];
}

- (NSArray *)performFetchWithEntityName:(NSString *)name predicate:(NSPredicate *)predicate sortDescriptor: (NSSortDescriptor *)sortDescriptor {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    // Specify how the fetched objects should be sorted
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"%@", error);
    }
    return fetchedObjects;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
