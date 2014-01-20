//
//  fgTabuloEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloEdge.h"

@implementation fgTabuloEdge

- (id)initFromNode:(f3GraphNode *)_origin toNode:(f3GraphNode *)_target plankNode:(f3GraphNode *)_plank {
    
    self = [super initFromNode:_origin toNode:_target];
    
    if (self != nil)
    {
        plankNode = _plank;
    }

    return self;
}

- (f3GraphNode *)Plank {
    
    return plankNode;
}

@end
