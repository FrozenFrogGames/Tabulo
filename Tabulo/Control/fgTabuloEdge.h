//
//  fgTabuloEdge.h
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GraphEdge.h"

@interface fgTabuloEdge : f3GraphEdge {
    
    f3GraphNode *inputNode;
}

+ (NSArray *)edgesFromNode:(f3GraphNode *)_node withInput:(f3GraphNode *)_input;

@property (readonly) f3GraphNode *Input;

- (id)initFromNode:(f3GraphNode *)_origin toNode:(f3GraphNode *)_target inputNode:(f3GraphNode *)_input;

@end
