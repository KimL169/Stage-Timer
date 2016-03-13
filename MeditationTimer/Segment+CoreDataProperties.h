//
//  Segment+CoreDataProperties.h
//  MeditationTimer
//
//  Created by Kim on 22/01/16.
//  Copyright © 2016 Kim. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Segment.h"

NS_ASSUME_NONNULL_BEGIN

@interface Segment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *time;
@property (nullable, nonatomic, retain) NSNumber *orderNumber;

@end

NS_ASSUME_NONNULL_END
