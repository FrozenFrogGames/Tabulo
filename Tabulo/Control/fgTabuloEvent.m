//
//  fgTabuloEvent.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloEvent.h"

@implementation fgTabuloEvent

- (id)init:(NSUInteger)_type {
    
    self = [super init:_type];
    
    if (self != nil)
    {
        levelIndex = 0;
        dialogOption = 0;
    }

    return self;
}

- (id)init:(NSUInteger)_type level:(NSUInteger)_index dialog:(NSUInteger)_option {

    self = [super init:_type];

    if (self != nil)
    {
        levelIndex = _index;
        dialogOption = _option;
    }

    return self;
}

- (NSUInteger)Level {

    return levelIndex;
}

- (NSUInteger)Option {

    return dialogOption;
}

@end
