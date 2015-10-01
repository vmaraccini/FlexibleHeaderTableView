# FlexibleHeaderTableView
An iOS UITableView subclass with flexible height. Does not need a Navigation bar/Toolbar to work.

##Description:
FlexibleHeaderTableView is an implementation of a flexible height header bar above the UITableView that does not use a Navigation Bar to funcion. Instead, all you need to do is supply a tableHeaderView to the FlexibleHeaderTableView and it will be scaled according to the specified ```minimumHeaderHeight``` and ```maximumHeaderHeight```.

![alt tag](https://raw.githubusercontent.com/vmaraccini/FlexibleHeaderTableView/master/SimpleUsage.gif)

##Usage:
This is a drop-in replacement to your original UITableView. Simply change your Interface Builder's object to FlexibleHeaderTableView and everything should work!

This class adds a few methods and properties:

```Objective-C
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
````

##Example:
In your existing UITableViewController.m:
```Objective-C
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
```
