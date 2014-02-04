//
//  fgClickViewOnLevel.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgClickViewOnLevel.h"
#import "../View/fgTabuloDirector.h"

@implementation fgClickViewOnLevel

- (id)initForView:(f3ViewAdaptee *)_view onNode:(f3GraphNode *)_node forLevel:(NSUInteger)_levelIndex {

    self = [super initForView:_view onNode:_node];
    
    if (self != nil)
    {
        levelIndex = _levelIndex;
    }

    return self;
}

- (void)actionCompleted:(f3ControlComponent *)_action owner:(f3Controller *)_owner {

    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    
    [director showDialog:DIALOG_Play forScene:levelIndex];
}

@end
