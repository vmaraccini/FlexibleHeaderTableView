//
//  FlexibleHeaderTableView.h
//  FlexibleHeaderTableView
//
//  Created by Victor Maraccini on 9/30/15.
//  Copyright © 2015 Victor Gabriel Maraccini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlexibleHeaderTableView : UITableView <UITableViewDelegate>

@property (nonatomic, readwrite) CGFloat minimumHeaderHeight;
@property (nonatomic, readwrite) CGFloat maximumHeaderHeight;

- (void) addAnimationBlock:(void (^)(CGFloat progress)) animationBlock;
- (void) removeAnimationBlock:(void (^)(CGFloat progress)) animationBlock;

@end
