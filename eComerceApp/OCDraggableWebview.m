//
//  OCDraggableWebview.m
//  eComerceApp
//
//  Created by Tarek Issa on 03/12/2015.
//  Copyright © 2015 Tvinci. All rights reserved.
//

#import "OCDraggableWebview.h"

@interface OCDraggableWebview ()

@property (assign, nonatomic) CGPoint lastPosition;
@property (assign, nonatomic) BOOL savedPositionUp;

@end


@implementation OCDraggableWebview

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0) {
        return;
    }
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height ) {
        return;
    }
    
    _savedPositionUp = [self isPositionUp];
    if (scrollView.isDragging) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ocWebviewDragging" object:[NSNumber numberWithBool:_savedPositionUp]];
    }
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDragging");
    _savedPositionUp = [self isPositionUp];
    _lastPosition = scrollView.contentOffset;
    
    if (_savedPositionUp) {
        //  ****** show bar
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ocWebviewWillBeginDragging" object:[NSNumber numberWithBool:_savedPositionUp]];
        
    }
    
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // Fixing WKWebView rendering issue!
    if ([[[self class] superclass] instancesRespondToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    if (_savedPositionUp) {
        //  ****** show bar
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ocWebviewEndDragging" object:[NSNumber numberWithBool:_savedPositionUp]];
    }
}

// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (!_savedPositionUp) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ocShowBar" object:nil];
    }
}

- (BOOL)isPositionUp {
    return (self.scrollView.contentOffset.y > _lastPosition.y);
}

@end
