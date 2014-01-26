//
//  fgDragViewOverEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgDragViewOverEdge.h"
#import "fgDragViewFromNode.h"
#import "fgTabuloEdge.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"

@implementation fgDragViewOverEdge

- (void)notifyInput:(enum f3InputType)_type fromNode:(f3GraphNode *)_node {
    
    if (actionCount == 0 && edgeSelect == nil && _type == INPUT_MOVED && [nodeListening containsObject:_node])
    {
        for (fgTabuloEdge *edge in edges)
        {
            if (edge.Target == _node || edge.Input == _node)
            {
                if ([edge evaluateConditions])
                {
                    edgeSelect = edge;
                    
                    break;
                }
            }
        }
    }
}

- (void)gainFocus {

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
                // TODO throw f3Eception
            }
        }
    }
}

- (void)actionCompleted:(f3ControlComponent *)_action owner:(f3Controller *)_owner {
    
    if (_action == nil)
    {
        [_owner switchState:[[fgDragViewFromNode alloc] initForView:view onNode:node withFlag:flagIndex]];
    }
    else if (--actionCount == 0)
    {
        f3GameAdaptee *producer = [f3GameAdaptee Producer];
        
        if ([producer haveFocus:_owner])
        {
            [producer requestFocus:nil];
        }
        
        [_owner switchState:[[fgDragViewFromNode alloc] initForView:view onNode:edgeSelect.Target withFlag:flagIndex]];
        
        edgeSelect = nil;
    }
}

@end
