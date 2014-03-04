//
//  fgTabuloEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloEdge.h"
#import "../../../Framework/Framework/Control/f3GraphNode.h"

@implementation fgTabuloEdge

- (id)init:(unsigned char)_flag origin:(f3GraphNode *)_origin target:(f3GraphNode *)_target {

    self = [super init:_flag origin:_origin target:_target];

    if (self != nil)
    {
        inputKey = nil;
    }

    return self;
}

- (f3GraphNode *)Input {

    if (inputKey != nil)
    {
        return [f3GraphNode nodeForKey:inputKey];
    }

    return nil;
}

+ (NSArray *)edgesFromNode:(f3GraphNode *)_node withInput:(f3GraphNode *)_input {
    
    NSArray *edgesFrom = [self edgesFromNode:_node.Key];
    
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
