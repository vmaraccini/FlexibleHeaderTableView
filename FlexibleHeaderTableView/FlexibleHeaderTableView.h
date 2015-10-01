//
//  FlexibleHeaderTableView.h
//  FlexibleHeaderTableView
//
//  Created by Victor Maraccini on 9/30/15.
//  Copyright © 2015 Victor Gabriel Maraccini. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultMinimumHeaderHeight 20
#define kDefaultMaximumHeaderHeight 100

@interface FlexibleHeaderTableView : UITableView <UITableViewDelegate>

///Gets or sets the minimum height the header view will take.
@property (nonatomic, readwrite) CGFloat minimumHeaderHeight;
///Gets or sets the maximum height the header view will take.
@property (nonatomic, readwrite) CGFloat maximumHeaderHeight;

/**Adds an animation block that will be called whenever the scrolling progress changes. Can be used to syncrhonize the scrolling with other animations you may have.
 @discussion This block will be called whenever a scroll event is registered, or when the UITableView lays out its subviews. Try to avoid long running blocks.
 */
- (void) addAnimationBlock:(void (^)(CGFloat progress)) animationBlock;
///Removes a previously added animation block.
- (void) removeAnimationBlock:(void (^)(CGFloat progress)) animationBlock;

@end
