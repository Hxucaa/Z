//
//  NSObject+Swift.h
//  XListing
//
//  Created by Lance Zhu on 2015-07-28.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swift)

- (id)swift_performSelector:(SEL)selector withObject:(id)object;
- (void)swift_performSelector:(SEL)selector withObject:(id)object afterDelay:(NSTimeInterval)delay;

@end
