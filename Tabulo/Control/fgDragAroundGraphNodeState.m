//
//  fgDragPlankAroundNode.m
//  Tabulo
//
//  Created by Serge Menard on 2014-09-14.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgDragAroundGraphNodeState.h"
#import "../View/fgTabuloDirector.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GameState.h"
#import "../../../Framework/Framework/Control/f3GraphNodeStrategy.h"

@implementation fgDragAroundGraphNodeState

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
        f3GraphNodeStrategy *gameStrategy = (f3GraphNodeStrategy *)[gameState Strategy];

        if ([gameStrategy getNodeFlag:nodeKey flag:TABULO_HaveSmallPlank])
        {
            rotationRadius = 1.75f; // small plank is 3.5 (3.42) units
        }
        else if ([gameStrategy getNodeFlag:nodeKey flag:TABULO_HaveMediumPlank])
        {
            rotationRadius = 2.5f; // medium plank is 5 (4.95) units
        }
        else if ([gameStrategy getNodeFlag:nodeKey flag:TABULO_HaveLongPlank])
        {
            rotationRadius = 3.5f; // long plank is 7 (7.07) units length
        }
    }
}

- (bool)acceptTargetNode:(f3GraphNode *)_node {
    
    f3ControllerState *state = [f3GameAdaptee Producer].State;
    
    if ([super acceptTargetNode:_node])
    {
        NSNumber *nodeKey = [_node Key];
        
        if ([state isKindOfClass:[f3GameState class]])
        {
            f3GameState *gameState = (f3GameState *)state;
            f3GraphNodeStrategy *gameStrategy = (f3GraphNodeStrategy *)[gameState Strategy];

            return (![gameStrategy getNodeFlag:nodeKey flag:TABULO_HaveSmallPlank]  &&
                    ![gameStrategy getNodeFlag:nodeKey flag:TABULO_HaveMediumPlank] &&
                    ![gameStrategy getNodeFlag:nodeKey flag:TABULO_HaveLongPlank]   );
        }
    }
    
    return false;
}

- (bool)acceptRotationNode:(f3GraphNode *)_node {

    f3ControllerState *state = [f3GameAdaptee Producer].State;

    if ([super acceptRotationNode:_node])
    {
        NSNumber *nodeKey = [_node Key];
        
        if ([state isKindOfClass:[f3GameState class]])
        {
            f3GameState *gameState = (f3GameState *)state;
            f3GraphNodeStrategy *gameStrategy = (f3GraphNodeStrategy *)[gameState Strategy];

            return ([gameStrategy getNodeFlag:nodeKey flag:TABULO_PawnOne]   ||
                    [gameStrategy getNodeFlag:nodeKey flag:TABULO_PawnTwo]   ||
                    [gameStrategy getNodeFlag:nodeKey flag:TABULO_PawnThree] ||
                    [gameStrategy getNodeFlag:nodeKey flag:TABULO_PawnFour]  ||
                    [gameStrategy getNodeFlag:nodeKey flag:TABULO_PawnFive]  );
        }
    }

    return false;
}

@end
