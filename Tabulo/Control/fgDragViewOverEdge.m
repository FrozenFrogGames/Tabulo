//
//  fgDragViewOverEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgDragViewOverEdge.h"
#import "fgTabuloEdge.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"

@implementation fgDragViewOverEdge

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
