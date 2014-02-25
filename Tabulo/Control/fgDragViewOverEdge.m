//
//  fgDragViewOverEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgDragViewOverEdge.h"
#import "../../../Framework/Framework/Control/f3SetScaleCommand.h"
#import "../../../Framework/Framework/Control/f3AppendFeedbackCommand.h"
#import "../../../Framework/Framework/Control/f3RemoveFeedbackCommand.h"
#import "fgTabuloDirector.h"
#import "fgTabuloEdge.h"
#import "fgPawnFeedbackCommand.h"
#import "fgPlankFeedbackCommand.h"

@implementation fgDragViewOverEdge

- (void)begin:(f3ControllerState *)_previousState owner:(f3Controller *)_owner {

    f3ControlComponent *scaleCommand = nil, *feedbackCommand = nil;

    switch (flagIndex) {

        case TABULO_HaveSmallPlank:
        case TABULO_HaveMediumPlank:
            scaleCommand = [[f3SetScaleCommand alloc] initWithView:view Scale:[f3VectorHandle buildHandleForWidth:2.2f height:1.1f]];
            feedbackCommand = [[fgPlankFeedbackCommand alloc] initWithView:view Type:flagIndex Node:node];
            break;

        case TABULO_PawnOne:
        case TABULO_PawnTwo:
        case TABULO_PawnThree:
        case TABULO_PawnFour:
        case TABULO_PawnFive:
            scaleCommand = [[f3SetScaleCommand alloc] initWithView:view Scale:[f3VectorHandle buildHandleForWidth:1.2f height:1.2f]];
            feedbackCommand = [[fgPawnFeedbackCommand alloc] initWithView:view Type:flagIndex Node:node];
            break;
    }

    [super begin:_previousState owner:_owner];

    if (scaleCommand != nil)
    {
        [_owner appendComponent:scaleCommand];
    }
    
    if (feedbackCommand != nil)
    {
        [_owner appendComponent:feedbackCommand];
    }
}

- (void)end:(f3ControllerState *)_nextState owner:(f3Controller *)_owner {

    f3ControlComponent *scaleCommand = nil, *feedbackCommand = nil;
    
    switch (flagIndex) {
            
        case TABULO_HaveSmallPlank:
        case TABULO_HaveMediumPlank:
            feedbackCommand = [[f3RemoveFeedbackCommand alloc] initWithView:view];
            scaleCommand = [[f3SetScaleCommand alloc] initWithView:view Scale:[f3VectorHandle buildHandleForWidth:2.f height:1.f]];
            break;
            
        case TABULO_PawnOne:
        case TABULO_PawnTwo:
        case TABULO_PawnThree:
        case TABULO_PawnFour:
        case TABULO_PawnFive:
            feedbackCommand = [[f3RemoveFeedbackCommand alloc] initWithView:view];
            scaleCommand = [[f3SetScaleCommand alloc] initWithView:view Scale:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
            break;
    }

    [super end:_nextState owner:_owner];
    
    if (feedbackCommand != nil)
    {
        [_owner appendComponent:feedbackCommand];
    }

    if (scaleCommand != nil)
    {
        [_owner appendComponent:scaleCommand];
    }
}

- (void)attachListener {
    
    if (nodeListening == nil)
    {
        nodeListening = [NSMutableArray array];
        
        for (fgTabuloEdge *edge in edges)
        {
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
        if (_type == INPUT_MOVED || _type == INPUT_ENDED)
        {
            if (haveFocus && !releaseFocus && currentEdge == nil)
            {
                for (fgTabuloEdge *edge in edges)
                {
                    if (edge.Target == _node || edge.Input == _node)
                    {
                        if ([edge evaluateConditions])
                        {
                            currentEdge = edge;
//                          NSLog(@"State: %@, target: %@", self, edge.Target);
                            break;
                        }
                        else
                        {
                            // TODO notify player with visual feedback if relevant
                        }
                    }
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
