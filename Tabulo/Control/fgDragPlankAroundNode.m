//
//  fgDragPlankAroundNode.m
//  Tabulo
//
//  Created by Serge Menard on 2014-09-14.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgDragPlankAroundNode.h"
#import "../View/fgTabuloDirector.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GameState.h"

@implementation fgDragPlankAroundNode

- (id)initWithNode:(f3GraphNode *)_node forView:(f3ViewAdaptee *)_view  {
    
    self = [super initWithNode:_node forView:_view];
    
    if (self != nil)
    {
        [self computeRotationRadius];
    }
    
    return self;
}

- (id)initWithNode:(f3GraphNode *)_node forView:(f3ViewAdaptee *)_view nextState:(Class)_class {
    
    self = [super initWithNode:_node forView:_view nextState:_class];
    
    if (self != nil)
    {
        [self computeRotationRadius];
    }
    
    return self;
}

- (void)computeRotationRadius {

    NSNumber *nodeKey = node.Key;
    f3ControllerState *state = [f3GameAdaptee Producer].State;

    if ([state isKindOfClass:[f3GameState class]])
    {
        f3GameState *gameState = (f3GameState *)state;

        if ([gameState getNodeFlag:nodeKey flag:TABULO_HaveSmallPlank])
        {
            rotationRadius = 1.75f; // small plank is 3.5 (3.42) units
        }
        else if ([gameState getNodeFlag:nodeKey flag:TABULO_HaveMediumPlank])
        {
            rotationRadius = 2.5f; // medium plank is 5 (4.95) units
        }
        else if ([gameState getNodeFlag:nodeKey flag:TABULO_HaveLongPlank])
        {
            rotationRadius = 3.5f; // long plank is 7 (7.07) units length
        }
    }
}

- (void)attachListener {

    f3ControllerState *state = [f3GameAdaptee Producer].State;
    
    [super attachListener];

    if (rotationNodes != nil && [state isKindOfClass:[f3GameState class]])
    {
        f3GameState *gameState = (f3GameState *)state;
        
        for (NSUInteger i = [rotationNodes count]; i > 0; --i)
        {
            NSNumber *nodeKey = [(f3GraphNode *)[rotationNodes objectAtIndex:i -1] Key];

            if ( ![gameState getNodeFlag:nodeKey flag:TABULO_PawnOne]
              && ![gameState getNodeFlag:nodeKey flag:TABULO_PawnTwo]
              && ![gameState getNodeFlag:nodeKey flag:TABULO_PawnThree]
              && ![gameState getNodeFlag:nodeKey flag:TABULO_PawnFour]
              && ![gameState getNodeFlag:nodeKey flag:TABULO_PawnFive] )
            {
                [rotationNodes removeObjectAtIndex:i -1];
            }
        }
    }
}

@end
