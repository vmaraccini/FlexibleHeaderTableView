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
    
    //Create the header view
    UIView* view = [[UIView alloc] init];
    
    //Add some content to it:
    UILabel* lbl = [[UILabel alloc]init];
    lbl.text = @"FlexibleHeaderTableView";
    lbl.frame = view.frame;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:lbl];
    
    //Set it as the table's header view
    [_tableView setTableHeaderView:view];
    
    //Add an animation block to change color, size and opacity:
    [_tableView addAnimationBlock:^(CGFloat progress) {
        view.backgroundColor = [UIColor colorWithWhite:.5 - progress/4 alpha:1];
        lbl.font = [UIFont systemFontOfSize:20 - progress*5];
        lbl.alpha = 1 - progress;
    }];

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
