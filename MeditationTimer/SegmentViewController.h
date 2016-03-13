//
//  SegmentViewController.h
//  MeditationTimer
//
//  Created by Kim on 22/01/16.
//  Copyright © 2016 Kim. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataViewController.h"

@interface SegmentViewController : CoreDataViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate>

@end
