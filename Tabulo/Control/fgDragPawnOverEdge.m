//
//  fgDragViewOverEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgDragPawnOverEdge.h"
#import "fgDragPawnFromNode.h"
#import "fgTabuloEdge.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"

@implementation fgDragPawnOverEdge

- (void)notifyInput:(enum f3InputType)_type fromNode:(f3GraphNode *)_node {
    
    if (actionCount == 0 && edgeSelect == nil && _type == INPUT_MOVED)
    {
        for (fgTabuloEdge *edge in edges)
        {
            if (edge.Target == _node || edge.Plank == _node)
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
    
    for (fgTabuloEdge *edge in edges)
    {
        if (![edge.Target appendListener:self])
        {
            // TODO throw f3Eception
        }
        
        if (![edge.Plank appendListener:self])
        {
            // TODO throw f3Eception
        }
    }
}

- (void)lostFocus {
    
    for (fgTabuloEdge *edge in edges)
    {
        if (![edge.Target removeListener:self])
        {
            // TODO throw f3Eception
        }
        
        if (![edge.Plank removeListener:self])
        {
            // TODO throw f3Eception
        }
    }
}

- (void)actionCompleted:(f3ControlComponent *)_action owner:(f3Controller *)_owner {
    
    if (_action == nil)
    {
        [_owner switchState:[[fgDragPawnFromNode alloc] initForView:view onNode:node withFlag:flagIndex]];
    }
    else if (--actionCount == 0)
    {
        f3GameAdaptee *producer = [f3GameAdaptee Producer];
        
        if ([producer haveFocus:_owner])
        {
            [producer requestFocus:nil];
        }
        
        [_owner switchState:[[fgDragPawnFromNode alloc] initForView:view onNode:edgeSelect.Target withFlag:flagIndex]];
        
        edgeSelect = nil;
    }
}

@end
