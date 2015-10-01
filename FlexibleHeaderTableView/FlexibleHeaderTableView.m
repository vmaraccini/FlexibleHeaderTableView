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
    [super setDelegate:self];
    _minimumHeaderHeight = 20.0;
    _maximumHeaderHeight = 100.0;
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
- (void) setDelegate:(id<UITableViewDelegate>)delegate{
    _subDelegate = delegate;
}

- (id <UITableViewDelegate>) delegate {
    return _subDelegate;
}

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

#pragma mark Modified UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat progress = MIN(MAX((scrollView.contentOffset.y)/_maximumHeaderHeight, 0),1);
    [self updateWithProgress:progress];
    
    if ([_subDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_subDelegate scrollViewDidScroll:scrollView];
    }
    
}// any offset changes

#pragma mark Default UIScrollViewDelegate method chaining

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([_subDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [_subDelegate scrollViewDidZoom:scrollView];
    }
}// any zoom scale changes

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([_subDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [_subDelegate scrollViewWillBeginDragging:scrollView];
    }
}
// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([_subDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [_subDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([_subDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_subDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([_subDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [_subDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}// called on finger up as we are moving
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([_subDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [_subDelegate scrollViewDidEndDecelerating:scrollView];
    }
}// called when scroll view grinds to a halt

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([_subDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [_subDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if ([_subDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [_subDelegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}// return a view that will be scaled. if delegate returns nil, nothing happens
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    if ([_subDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [_subDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}// called before the scroll view begins zooming its content
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    if ([_subDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [_subDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}// scale between minimum and maximum. called after any 'bounce' animations

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if ([_subDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [_subDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return true;
}// return a yes if you want to scroll to the top. if not defined, assumes YES
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if ([_subDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [_subDelegate scrollViewDidScrollToTop:scrollView];
    }
}// called when scrolling animation finished. may be called immediately if already at top


#pragma mark Default UITableViewDelegate method chaining
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_subDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        return [_subDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([_subDelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        return [_subDelegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([_subDelegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
        return [_subDelegate tableView:tableView willDisplayFooterView:view forSection:section];
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([_subDelegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        return [_subDelegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([_subDelegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)]) {
        return [_subDelegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([_subDelegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]) {
        return [_subDelegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_subDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [_subDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([_subDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [_subDelegate tableView:tableView heightForHeaderInSection:section];
    }
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([_subDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [_subDelegate tableView:tableView heightForFooterInSection:section];
    }
    return UITableViewAutomaticDimension;
}

// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_subDelegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]) {
        return [_subDelegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    }
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if ([_subDelegate respondsToSelector:@selector(tableView:estimatedHeightForHeaderInSection:)]) {
        return [_subDelegate tableView:tableView estimatedHeightForHeaderInSection:section];
    }
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    if ([_subDelegate respondsToSelector:@selector(tableView:estimatedHeightForFooterInSection:)]) {
        return [_subDelegate tableView:tableView estimatedHeightForFooterInSection:section];
    }
    return UITableViewAutomaticDimension;
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([_subDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [_subDelegate tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}// custom view for header. will be adjusted to default or specified header height
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([_subDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [_subDelegate tableView:tableView viewForFooterInSection:section];
    }
    return nil;
}// custom view for footer. will be adjusted to default or specified footer height

// Accessories (disclosures).

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if ([_subDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
        [_subDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

// Selection

// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_subDelegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]) {
        return [_subDelegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }
    return true;
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_subDelegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)]) {
        [_subDelegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_subDelegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)]) {
        [_subDelegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
    }
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_subDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        return [_subDelegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    return nil;
}
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_subDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
        return [_subDelegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }
    return nil;
}
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_subDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_subDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_subDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
        [_subDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_subDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [_subDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_subDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [_subDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return nil;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_subDelegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)]) {
        return [_subDelegate tableView:tableView editActionsForRowAtIndexPath:indexPath];
    }
    return nil;
}// supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_subDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
        return [_subDelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }
    return false;
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_subDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]) {
        [_subDelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_subDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
        [_subDelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    if ([_subDelegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
        [_subDelegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }
    return proposedDestinationIndexPath;
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_subDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]) {
        return [_subDelegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
    return 0;
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_subDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)]) {
        return [_subDelegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }
    return false;
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    if ([_subDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)]) {
        return [_subDelegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    return false;
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    if ([_subDelegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)]) {
        [_subDelegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
}

@end
