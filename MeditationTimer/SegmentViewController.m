//
//  SegmentViewController.m
//  MeditationTimer
//
//  Created by Kim on 22/01/16.
//  Copyright © 2016 Kim. All rights reserved.
//

#import "SegmentViewController.h"
#import "NSDate+Utilities.h"
#import "NSNumber+time.h"
#import "Segment.h"
#import "SegmentCell.h"
#import <UIKit/UIKit.h>

@interface SegmentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tableViewCellNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tableViewCellTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tableViewCellOrderNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *addSegmentButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) NSManagedObjectContext *context;
@end

@implementation SegmentViewController

- (void)viewDidLoad {
    id delegate = [[UIApplication sharedApplication] delegate];
    self.context = [delegate managedObjectContext];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self performFetch];
}
- (IBAction)addSegmentButton:(UIButton *)sender {
    Segment *segment = [NSEntityDescription insertNewObjectForEntityForName:@"Segment" inManagedObjectContext:_context];
    segment.name = @"tap to set name";
    [self saveManagedObjectContext];
    [self.tableView reloadData];
}

- (IBAction)returnButton:(UIBarButtonItem *)sender {
    
    //save the segments and close
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(SegmentCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    SegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SegmentCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Segment *segment = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (segment.name) {
        cell.titleTextField.text = segment.name;
    } else {
        cell.titleTextField.text = @"tap to set title";
    }
    
    if ([segment.time intValue] != 0) {
        NSString *timeString = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",[segment.time hours],[segment.time minutesMinusHours],[segment.time secondsMinusMinutesMinutesHours]];
        cell.timeTextField.text = timeString;
    } else {
        cell.timeTextField.text = @"tap to set time";
    }
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Segment *segment = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [_context deleteObject:segment];
        [self saveManagedObjectContext];
        [self.tableView reloadData];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
    // Return the number of rows in the section.
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //return the number of sections in both the bodystat and diet plan fetchedresultscontroller.
    return [[self.fetchedResultsController sections]count];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    _context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Segment" inManagedObjectContext:_context];
    
    //set the fetch request to the Patient entity
    [fetchRequest setEntity:entity];
    
    //sort on patients last name, ascending;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"orderNumber" ascending:YES];
    
    
    //make an array of the descriptor because the fetchrequest argument takes an array.
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    //now assign the sort descriptors to the fetchrequest.
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:_context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

//if changes to a section occured.
- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            NSLog(@"A table item was moved");
            break;
        case NSFetchedResultsChangeUpdate:
            NSLog(@"A table item was updated");
            break;
    }
}

//if changes to an object occured.
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    // responses for type (insert, delete, update, move).
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

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

- (void)performFetch {
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error fetching: %@", error);
        abort();
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    return  [(AppDelegate *)[[UIApplication sharedApplication]delegate]managedObjectContext];
}
@end
