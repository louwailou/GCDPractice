//
//  ViewController.m
//  GCDPractice
//
//  Created by sun on 15/3/24.
//  Copyright (c) 2015年 sun. All rights reserved.
//

#import "ViewController.h"
#import "Dispatch.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Dispatch * d = [[Dispatch alloc]init];
    [d createQueue];
   // [d testConcurrnet];
    [d group];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
