//
//  fgTabuloEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloEdge.h"

@implementation fgTabuloEdge

- (id)initFromNode:(f3GraphNode *)_origin toNode:(f3GraphNode *)_target inputNode:(f3GraphNode *)_input {
    
    self = [super initFromNode:_origin toNode:_target];
    
    if (self != nil)
    {
        inputNode = _input;
    }

    return self;
}

- (f3GraphNode *)Input {
    
    return inputNode;
}

+ (NSArray *)edgesFromNode:(f3GraphNode *)_node withInput:(f3GraphNode *)_input {
    
    NSArray *edgesFrom = [self edgesFromNode:_node];
    
    NSMutableArray *edges = [NSMutableArray array];

    for (NSUInteger i =0; i <[edgesFrom count]; ++i)
    {
        fgTabuloEdge *edge = (fgTabuloEdge *)[edgesFrom objectAtIndex:i];
        
        if (edge.Input == _input)
        {
            [edges addObject:edge];
        }
    }

    return edges;
}

@end
