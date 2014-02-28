//
//  fgTabuloEvent.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloEvent.h"

@implementation fgTabuloEvent

- (id)init {

    self = [super init];

    if (self != nil)
    {
        levelIndex = 0;
    }

    return self;
}

- (id)init:(NSUInteger)_event level:(NSUInteger)_index {

    self = [super init:_event];

    if (self != nil)
    {
        levelIndex = _index;
    }

    return self;
}

- (NSUInteger)Level {
    
    return levelIndex;
}

@end
