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

- (id)initFrom:(NSNumber *)_originKey targetKey:(NSNumber *)_targetKey {

    self = [super initFrom:_originKey targetKey:_targetKey];

    if (self != nil)
    {
        inputKey = nil;
    }

    return self;
}

+ (void)removeEdgesForKeys:(NSArray *)_keys {

    [f3GraphEdge removeEdgesForKeys:_keys];
}

- (NSNumber *)InputKey {

    return inputKey;
}

+ (NSArray *)edgesFromNode:(f3GraphNode *)_node withInput:(f3GraphNode *)_input {
    
    NSArray *edgesFrom = [self edgesFromNode:_node.Key];
    
    NSMutableArray *edges = [NSMutableArray array];

    for (NSUInteger i =0; i <[edgesFrom count]; ++i)
    {
        fgTabuloEdge *edge = (fgTabuloEdge *)[edgesFrom objectAtIndex:i];
        f3GraphNode *inputNode = [f3GraphNode nodeForKey:edge.InputKey];
        
        if (inputNode == _input)
        {
            [edges addObject:edge];
        }
    }

    return edges;
}

@end
