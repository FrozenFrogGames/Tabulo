//
//  fgClickViewOnLevel.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgClickOnLevel.h"
#import "../View/fgTabuloDirector.h"

@implementation fgClickOnLevel

- (id)initWithNode:(f3GraphNode *)_node useLevel:(NSUInteger)_index {

    self = [super initWithNode:_node];
    
    if (self != nil)
    {
        levelIndex = _index;
    }

    return self;
}

- (void)onActionCompleted:(f3ControlComponent *)_action owner:(f3Controller *)_owner {

    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    
    [director showDialog:DIALOG_Play forScene:levelIndex]; // TODO move into GameState
    
    [super onActionCompleted:_action owner:_owner];
}

@end
