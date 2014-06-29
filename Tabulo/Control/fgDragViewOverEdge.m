//
//  fgDragViewOverEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgDragViewOverEdge.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GameState.h"
#import "../../../Framework/Framework/Control/f3SetScaleCommand.h"
#import "fgTabuloEdge.h"
#import "fgHouseNode.h"
#import "../View/fgTabuloDirector.h"
#import "fgPawnFeedbackCommand.h"
#import "fgPlankFeedbackCommand.h"
#import "fgRemoveFeedbackCommand.h"

@implementation fgDragViewOverEdge

- (id)initWithNode:(f3GraphNode *)_node forView:(f3ViewAdaptee *)_view {
    
    self = [super initWithNode:_node forView:_view];
    
    if (self != nil)
    {
        f3GameState *gameState = (f3GameState *)[f3GameAdaptee Producer].State;

        isPawnView = ( [gameState getNodeFlag:_node.Key flag:TABULO_PawnOne]
                    || [gameState getNodeFlag:_node.Key flag:TABULO_PawnTwo]
                    || [gameState getNodeFlag:_node.Key flag:TABULO_PawnThree]
                    || [gameState getNodeFlag:_node.Key flag:TABULO_PawnFour]
                    || [gameState getNodeFlag:_node.Key flag:TABULO_PawnFive] );
        
        isPlankView = ( [gameState getNodeFlag:_node.Key flag:TABULO_HaveSmallPlank]
                     || [gameState getNodeFlag:_node.Key flag:TABULO_HaveMediumPlank]
                     || [gameState getNodeFlag:_node.Key flag:TABULO_HaveLongPlank] );
    }
    
    return self;
}

- (id)initWithNode:(f3GraphNode *)_node forView:(f3ViewAdaptee *)_view nextState:(Class)_class {
    
    self = [super initWithNode:_node forView:_view nextState:_class];
    
    if (self != nil)
    {
        f3GameState *gameState = (f3GameState *)[f3GameAdaptee Producer].State;

        isPawnView = ( [gameState getNodeFlag:_node.Key flag:TABULO_PawnOne]
                    || [gameState getNodeFlag:_node.Key flag:TABULO_PawnTwo]
                    || [gameState getNodeFlag:_node.Key flag:TABULO_PawnThree]
                    || [gameState getNodeFlag:_node.Key flag:TABULO_PawnFour]
                    || [gameState getNodeFlag:_node.Key flag:TABULO_PawnFive] );

        isPlankView = ( [gameState getNodeFlag:_node.Key flag:TABULO_HaveSmallPlank]
                     || [gameState getNodeFlag:_node.Key flag:TABULO_HaveMediumPlank]
                     || [gameState getNodeFlag:_node.Key flag:TABULO_HaveLongPlank] );
    }

    return self;
}

- (void)begin:(f3ControllerState *)_previousState owner:(f3Controller *)_owner {

    f3ControlBuilder *builder = [f3GameAdaptee Producer].Builder;
    
    [super begin:_previousState owner:_owner];
    
    if (isPlankView)
    {
        f3ControlComponent *feedbackCommand = [[fgPlankFeedbackCommand alloc] initWithView:view Node:node];
        f3ControlComponent *scaleCommand = [[f3SetScaleCommand alloc] initWithView:view scale:[f3VectorHandle buildHandleForWidth:2.2f height:1.1f]];

        [builder push:feedbackCommand];
        [builder push:scaleCommand];
    }
    else if (isPawnView)
    {
        f3ControlComponent *feedbackCommand = [[fgPawnFeedbackCommand alloc] initWithView:view Node:node];
        f3ControlComponent *scaleCommand = [[f3SetScaleCommand alloc] initWithView:view scale:[f3VectorHandle buildHandleForWidth:1.2f height:1.2f]];

        [builder push:feedbackCommand];
        [builder push:scaleCommand];
    }
    
    f3ControlComponent *command = [builder popComponent];
    
    while (command != nil)
    {
        [_owner appendComponent:command];
        
        if ([command isKindOfClass:[f3AppendFeedbackCommand class]])
        {
            feedbackDisplayed = true;
        }

        command = [builder popComponent];
    }
}

- (void)update:(NSTimeInterval)_elapsed owner:(f3Controller *)_owner {
    
    if (feedbackToRemove)
    {
        [self clearFeedback:_owner];

        feedbackToRemove = false;
    }
    
    [super update:_elapsed owner:_owner];
}

- (void)end:(f3ControllerState *)_nextState owner:(f3Controller *)_owner {

    f3ControlBuilder *builder = [f3GameAdaptee Producer].Builder;

    [super end:_nextState owner:_owner];

    if (isPlankView)
    {
        f3ControlComponent *scaleCommand = [[f3SetScaleCommand alloc] initWithView:view scale:[f3VectorHandle buildHandleForWidth:2.f height:1.f]];

        [builder push:scaleCommand];
    }
    else if (isPawnView)
    {
        f3ControlComponent *scaleCommand = [[f3SetScaleCommand alloc] initWithView:view scale:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
        
        [builder push:scaleCommand];
    }

    f3ControlComponent *command = [builder popComponent];
    
    while (command != nil)
    {
        [_owner appendComponent:command];
        
        command = [builder popComponent];
    }

    [self clearFeedback:_owner];
}

- (void)clearFeedback:(f3Controller *)_owner {

    if (feedbackDisplayed)
    {
        if (isPlankView)
        {
            f3ControlComponent *feedbackCommand = [[f3RemoveFeedbackCommand alloc] initWithView:view];

            [_owner appendComponent:feedbackCommand];
        }
        else if (isPawnView)
        {
            f3ControlComponent *feedbackCommand = [[fgRemoveFeedbackCommand alloc] initWithView:view];
            
            for (fgTabuloEdge *edge in edges)
            {
                if ([edge.Target isKindOfClass:[fgHouseNode class]])
                {
                    if (currentEdge == nil || currentEdge.Target != edge.Target)
                    {
                        [(fgRemoveFeedbackCommand *)feedbackCommand appendHouseNode:(fgHouseNode *)edge.Target];
                    }
                }
            }
            
            [_owner appendComponent:feedbackCommand];
        }

        feedbackDisplayed = false;
    }
}

- (void)attachListener {
    
    if (nodeListening == nil)
    {
        nodeListening = [NSMutableArray array];
        
        for (fgTabuloEdge *edge in edges)
        {
            if (edge.Target == nil || edge.Input == nil)
            {
                continue; // TODO throw f3Exception
            }

            if (![nodeListening containsObject:edge.Target])
            {
                [nodeListening addObject:edge.Target];
            }
            
            if (![nodeListening containsObject:edge.Input])
            {
                [nodeListening addObject:edge.Input];
            }
        }
        
        for (f3GraphNode *nodeItem in nodeListening)
        {
            if (![nodeItem appendListener:self])
            {
                NSLog(@"Error! Already listenning node: %@", nodeItem);
            }
        }
    }
}

- (void)notifyInput:(enum f3InputType)_type fromNode:(f3GraphNode *)_node {

    if ([nodeListening containsObject:_node])
    {
        shouldKeepFocus = false;

        if (_type == INPUT_MOVED || _type == INPUT_ENDED)
        {
            if (haveFocus && !releaseFocus)
            {
                if (currentEdge == nil)
                {
                    f3GameState *gameState = (f3GameState *)[f3GameAdaptee Producer].State;

                    for (fgTabuloEdge *edge in edges)
                    {
                        if (edge.Target == _node || edge.Input == _node)
                        {
                            if ([gameState evaluateEdge:edge])
                            {
                                feedbackToRemove = feedbackDisplayed;
                                currentEdge = edge;
//                              NSLog(@"State: %@, target: %@", self, edge.Target);
                                break;
                            }
                        }
                    }
                }
                else if (_type == INPUT_MOVED && currentEdge.Target == _node)
                {
                    shouldKeepFocus = true;
                }
            }
        }
    }
    else
    {
        NSLog(@"Error! Listenning unrelated node: %@", _node);
    }
}

@end
