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

- (void)appendHouseNode:(fgTabuloNode *)_node {
    
    [feedbackOnNodes addObject:_node];
}

- (void)update:(NSTimeInterval)_elapsed {
    
    for (fgTabuloNode *node in feedbackOnNodes)
    {
        [node clearHouseFeedback];
    }
    
    [super update:_elapsed];
    
    [feedbackOnNodes removeAllObjects];
    
    feedbackOnNodes = nil;
}

@end
