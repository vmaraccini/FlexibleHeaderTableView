//
//  FlexibleHeaderTableView.m
//  FlexibleHeaderTableView
//
//  Created by Victor Maraccini on 9/30/15.
//  Copyright © 2015 Victor Gabriel Maraccini. All rights reserved.
//

#import "FlexibleHeaderTableView.h"

@interface FlexibleHeaderTableView ()

@property (nonatomic, weak) id<UITableViewDelegate> subDelegate;
@property (nonatomic, retain) NSMutableArray* animationBlocks;

@end

@implementation FlexibleHeaderTableView

#pragma mark Initialization methods
- (instancetype) init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setUp];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void) setUp {
    _minimumHeaderHeight = kDefaultMinimumHeaderHeight;
    _maximumHeaderHeight = kDefaultMaximumHeaderHeight;
}

#pragma mark Internal methods
- (void) addAnimationBlock:(void (^)(CGFloat progress)) animationBlock {
    if (_animationBlocks == nil)
        _animationBlocks = [[NSMutableArray alloc] init];
    [_animationBlocks addObject:animationBlock];
}

- (void) removeAnimationBlock:(void (^)(CGFloat))animationBlock {
    if (_animationBlocks == nil)
        return;
    [_animationBlocks removeObject:animationBlock];
}

#pragma mark Delegate chaining

- (void) layoutSubviews {
    [super layoutSubviews];
    CGFloat progress = MIN(MAX((self.contentOffset.y)/_maximumHeaderHeight, 0),1);
    [self updateWithProgress:progress];
}

- (void) setTableHeaderView:(UIView *)tableHeaderView {
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, _maximumHeaderHeight)];
    [container addSubview:tableHeaderView];
    [tableHeaderView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [super setTableHeaderView:container];
}

- (void) updateWithProgress: (CGFloat) progress {
    if (self.tableHeaderView == nil || [[self.tableHeaderView subviews] count] == 0) {
        return;
    }
    
    UIView* internalView = [[self.tableHeaderView subviews] objectAtIndex:0];
    CGPoint origin = internalView.frame.origin;
    CGSize size = internalView.frame.size;
    internalView.frame = CGRectMake(origin.x,
                                    origin.y,
                                    self.frame.size.width,
                                    _minimumHeaderHeight + (1 - progress)*(_maximumHeaderHeight - _minimumHeaderHeight));
    
    internalView.transform = CGAffineTransformMakeTranslation(0, (self.contentOffset.y));
    
    for (void (^anim)(CGFloat) in _animationBlocks) {
        anim(progress);
    }
}

@end
