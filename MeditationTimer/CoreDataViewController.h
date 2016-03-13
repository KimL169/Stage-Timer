//
//  CoreDataViewController.h
//  Productive
//
//  Created by Kim on 01/09/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CoreDataViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (NSManagedObjectContext *)managedObjectContext;
- (void)saveManagedObjectContext;
- (NSArray *)performFetchWithEntityName:(NSString *)name predicate:(NSPredicate *)predicate sortDescriptor:(NSSortDescriptor *)sortDescriptor;

@end
