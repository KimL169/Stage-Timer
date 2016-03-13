//
//  ViewController.m
//  MeditationTimer
//
//  Created by Kim on 22/01/16.
//  Copyright © 2016 Kim. All rights reserved.
//

#import "ViewController.h"
#import "NSNumber+time.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *startPauzeButton;
@property (nonatomic) BOOL startButton;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) int counter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _startButton = YES;
    _counter = 10;
}

- (void)startTimer {
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
- (IBAction)startStopButtonPressed:(UIButton *)sender {
    if (_startButton) {
        //set the state to a stop button and change UI
        _startButton = NO;
        [_startPauzeButton setTitle:@"■" forState:UIControlStateNormal];
        [self startTimer];
    } else {
        //set the state to a stop button and change UI
        _startButton = YES;
        [_startPauzeButton setTitle:@"►" forState:UIControlStateNormal];
        [self stopTimer];
    }
}

- (void)stopTimer {
    
    //remove the timer
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)resetTimer {
    //put the counter to 0 and remove the timer
    _counter = 0;
    self.timerLabel.text = [NSString stringWithFormat:@"00:00:00"];
    [self stopTimer];
}

- (void)timerUpdate {
    if (_counter > 0) {
        self.counter--;
        NSNumber *time = [NSNumber numberWithInt:_counter];
        self.timerLabel.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",[time hours],[time minutesMinusHours],[time secondsMinusMinutesMinutesHours]];
    } else {
        // 1. make a bell sound
        // 2. check if there is a next stage, if so: start the next stage
        // 3. remove the timer.
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"gong-burmese" ofType:@"wav"];
        NSURL *alertURL = [NSURL fileURLWithPath:path];
        SystemSoundID alertSound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)alertURL, &alertSound);
        AudioServicesPlaySystemSound(alertSound);
        
        [self stopTimer];
        
    }
        
    
}
- (IBAction)resetButton:(UIButton *)sender {
    
    [self resetTimer];
    _startButton = YES;
    [_startPauzeButton setTitle:@"►" forState:UIControlStateNormal];
}
@end
