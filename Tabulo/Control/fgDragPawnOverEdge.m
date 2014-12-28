//
//  fgDragViewOverEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgDragPawnOverEdge.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GameState.h"
#import "../../../Framework/Framework/Control/f3SetScaleCommand.h"
#import "../../../Framework/Framework/Control/f3GraphEdgeWithInput.h"
#import "fgHouseNode.h"
#import "../View/fgTabuloDirector.h"
#import "fgPawnFeedbackCommand.h"
#import "fgPlankFeedbackCommand.h"
#import "fgRemoveFeedbackCommand.h"

@implementation fgDragPawnOverEdge

- (void)begin:(f3ControllerState *)_previousState owner:(f3Controller *)_owner {

    f3ControlBuilder *builder = [f3GameAdaptee Producer].Builder;
    
    [super begin:_previousState owner:_owner];
    
    f3ControlComponent *feedbackCommand = [[fgPawnFeedbackCommand alloc] initWithView:view Node:node];
    f3ControlComponent *scaleCommand = [[f3SetScaleCommand alloc] initWithView:view scale:[f3VectorHandle buildHandleForWidth:1.2f height:1.2f]];

    [builder push:feedbackCommand];
    [builder push:scaleCommand];
    
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

    f3ControlComponent *scaleCommand = [[f3SetScaleCommand alloc] initWithView:view scale:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
        
    [builder push:scaleCommand];

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
        f3ControlComponent *feedbackCommand = [[fgRemoveFeedbackCommand alloc] initWithView:view];
        
        for (f3GraphEdgeWithInput *edge in edges)
        {
            f3GraphNode *houseNode = [f3GraphNode nodeForKey:edge.TargetKey];
            if ([houseNode isKindOfClass:[fgHouseNode class]])
            {
                if (currentEdge == nil || currentEdge.TargetKey != edge.TargetKey)
                {
                    [(fgRemoveFeedbackCommand *)feedbackCommand appendHouseNode:(fgHouseNode *)houseNode];
                }
            }
        }
        
        [_owner appendComponent:feedbackCommand];

        feedbackDisplayed = false;
    }
}

- (void)attachListener {
    
    if (nodeListening == nil)
    {
        nodeListening = [NSMutableArray array];
        
        for (f3GraphEdgeWithInput *edge in edges)
        {
            f3GraphNode *targetNode = [f3GraphNode nodeForKey:edge.TargetKey];
            if ([nodeListening containsObject:targetNode])
            {
                // TODO throw f3Exception
            }
            else
            {
                [nodeListening addObject:targetNode];
            }
            
            f3GraphNode *inputNode = [f3GraphNode nodeForKey:edge.InputKey];
            if ([nodeListening containsObject:inputNode])
            {
                // TODO throw f3Exception
            }
            else
            {
                [nodeListening addObject:inputNode];
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

- (void)notifyInput:(enum f3InputType)_type forKey:(f3GraphNode *)_node {

    if ([nodeListening containsObject:_node])
    {
        shouldKeepFocus = false;

        if (_type == INPUT_MOVED || _type == INPUT_ENDED)
        {
            if (haveFocus && !releaseFocus)
            {
                if (currentEdge == nil)
                {
                    f3GameAdaptee *producer = [f3GameAdaptee Producer];
                    
                    if ([producer.State isKindOfClass:[f3GameState class]])
                    {
                        f3GameState *gameState =(f3GameState *)producer.State;

                        for (f3GraphEdgeWithInput *edge in edges)
                        {
                            if (edge.TargetKey == _node.Key || edge.InputKey == _node.Key)
                            {
                                if ([gameState evaluateEdge:edge])
                                {
                                    feedbackToRemove = feedbackDisplayed;
                                    currentEdge = edge;
//                                  NSLog(@"State: %@, target: %@", self, edge.Target);
                                    break;
                                }
                            }
                        }
                    }
                }
                else if (_type == INPUT_MOVED && currentEdge.TargetKey == _node.Key)
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
