//
//  fgRemoveFeedbackCommand.m
//  Tabulo
//
//  Created by Serge Menard on 2014-03-01.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgRemoveFeedbackCommand.h"

@implementation fgRemoveFeedbackCommand

- (id)initWithView:(f3ViewComponent *)_view {
    
    self = [super initWithView:_view];
    
    if (self != nil)
    {
        feedbackOnNodes = [NSMutableArray array];
    }

    return self;
}

- (void)appendHouseNode:(fgHouseNode *)_node {

    [feedbackOnNodes addObject:_node];
}

- (bool)update:(NSTimeInterval)_elapsed {
/*
    for (fgHouseNode *node in feedbackOnNodes)
    {
        [node clearHouseFeedback];
    }
 */
    [feedbackOnNodes removeAllObjects];
    
    feedbackOnNodes = nil;
    
    return [super update:_elapsed];
}

@end
