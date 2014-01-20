//
//  fgTabuloEdge.h
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GraphEdge.h"

@interface fgTabuloEdge : f3GraphEdge {
    
    f3GraphNode *plankNode;
}

@property (readonly) f3GraphNode *Plank;

- (id)initFromNode:(f3GraphNode *)_origin toNode:(f3GraphNode *)_target plankNode:(f3GraphNode *)_plank;

@end
