//
//  fgDragPlankAroundNode.m
//  Tabulo
//
//  Created by Serge Menard on 2014-09-14.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgDragAroundGraphNodeState.h"
#import "fgTabuloStrategy.h"
#import "fgPlankEdge.h"
#import "../fgTabuloDirector.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GameState.h"
#import "../../../Framework/Framework/Control/f3GraphSchemaStrategy.h"
#import "../../../Framework/Framework/Control/f3GraphSchema.h"
#import "../../../Framework/Framework/Control/f3SetScaleCommand.h"

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
        if ([gameState.Strategy isKindOfClass:[f3GraphSchemaStrategy class]])
        {
            f3GraphSchemaStrategy *gameStrategy = (f3GraphSchemaStrategy *)[gameState Strategy];

            if ([gameStrategy.Schema getNodeFlag:nodeKey flag:TABULO_PLANK_Small])
            {
                rotationRadius = 1.75f; // small plank is 3.5 (3.42) units
            }
            else if ([gameStrategy.Schema getNodeFlag:nodeKey flag:TABULO_PLANK_Medium])
            {
                rotationRadius = 2.5f; // medium plank is 5 (4.95) units
            }
            else if ([gameStrategy.Schema getNodeFlag:nodeKey flag:TABULO_PLANK_Long])
            {
                rotationRadius = 3.5f; // long plank is 7 (7.07) units length
            }
        }
    }
}

- (void)begin:(f3ControllerState *)_previousState owner:(f3Controller *)_owner {
    
    [super begin:_previousState owner:_owner];

    feedbackEdges = [NSMutableArray array];
    
    f3GameAdaptee *producer = [f3GameAdaptee Producer];
    if ([producer.State isKindOfClass:[f3GameState class]])
    {
        f3GameState *gameState = (f3GameState *)producer.State;
        if ([gameState.Strategy isKindOfClass:[fgTabuloStrategy class]])
        {
            fgTabuloStrategy *gameStrategy = (fgTabuloStrategy *)gameState.Strategy;
            
            for (f3GraphEdge *edge in edges)
            {
                if ([gameStrategy.Schema evaluate:edge.Conditions])
                {
                    [feedbackEdges addObject:edge];
                }
            }
            
            if ([feedbackEdges count] > 0)
            {
                f3GameDirector *director = [f3GameDirector Director];
                f3ViewBuilder *viewBuilder = director.Builder;
                [gameStrategy buildFeedbackLayer:viewBuilder edges:feedbackEdges];
                
                id feedbackLayer = [viewBuilder popComponent];
                if ([feedbackLayer isKindOfClass:[f3ViewLayer class]])
                {
                    [director.Scene appendLayer:(f3ViewLayer *)feedbackLayer];
                }
            }
        }
    }
}

- (void)end:(f3ControllerState *)_nextState owner:(f3Controller *)_owner {
    
    [super end:_nextState owner:_owner];
    
    if ([feedbackEdges count] > 0)
    {
        f3GameDirector *director = [f3GameDirector Director];
        [director.Scene removeLayerAtIndex:HelperOverlay];
    }
    
    feedbackEdges = nil;
}

@end
