//
//  ViewController.m
//  BPTimer
//
//  Created by LiHaozhen on 14-10-8.
//  Copyright (c) 2014年 ihojin. All rights reserved.
//

#import "ViewController.h"
#import "BPSoundEffectPlayer.h"

@interface ViewController (){
    
    __weak IBOutlet UIButton *_btn;
    __weak IBOutlet UILabel *_label;
    BOOL _started;
    
    NSTimer *_timer;
    NSTimeInterval _leftTime;
    int _type;          //1:30s, 2:10sif
    
    NSDate *_toDate;
}


- (IBAction)startOrStop:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _started = NO;
    [self setupBtnForSelectedState:_started];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (IBAction)startOrStop:(UIButton *)sender {
    _started = !_started;
    [self setupBtnForSelectedState:_started];
}

- (void)setupBtnForSelectedState:(BOOL)selected
{
    UIImage *img = nil;
    NSString *title = nil;
    if (selected == NO) {
        img = [UIImage imageNamed:@"blue"];
        title = @"开始";
        [_timer invalidate];
        _timer = nil;
    }else{
        img = [UIImage imageNamed:@"yellow"];
        title = @"停止";
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        _type = 1;
        _toDate = [NSDate dateWithTimeIntervalSinceNow:30];
        [self timerFired:_timer];
        [BPSoundEffectPlayer playSoundEffectWithFileName:@"merge.wav"];
    }
    
    [_btn setBackgroundImage:img forState:UIControlStateNormal];
    [_btn setTitle:title forState:UIControlStateNormal];
}

- (void)timerFired:(NSTimer *)timer
{
    if (_type == 1) {
        if ([_toDate compare:[NSDate date]] == NSOrderedAscending) {
            _type = 2;
            _toDate = [NSDate dateWithTimeIntervalSinceNow:10];
            [BPSoundEffectPlayer playSoundEffectWithFileName:@"merge.wav"];
        }
    }else if(_type == 2){
        if ([_toDate compare:[NSDate date]] == NSOrderedAscending) {
            _type = 1;
            _toDate = [NSDate dateWithTimeIntervalSinceNow:30];
            [BPSoundEffectPlayer playSoundEffectWithFileName:@"merge.wav"];
        }
    }
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitNanosecond) fromDate:[NSDate date] toDate:_toDate options:kNilOptions];
    _label.text = [NSString stringWithFormat:@"%02d:%02d.%02d", (int)comp.minute, (int)comp.second, (int)(comp.nanosecond/10e6)];
}
@end
