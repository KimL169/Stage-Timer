//
//  SegmentCell.h
//  MeditationTimer
//
//  Created by Kim on 22/01/16.
//  Copyright © 2016 Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;

@end
