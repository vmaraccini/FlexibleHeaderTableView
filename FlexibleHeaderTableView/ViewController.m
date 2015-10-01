//
//  ViewController.m
//  FlexibleHeaderTableView
//
//  Created by Victor Maraccini on 9/30/15.
//  Copyright © 2015 Victor Gabriel Maraccini. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    view.backgroundColor = [UIColor blackColor];
    [_tableView setTableHeaderView:view];
    
    [_tableView addAnimationBlock:^(CGFloat progress) {
        view.backgroundColor = [UIColor colorWithWhite:progress/2 alpha:1];
    }];
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
