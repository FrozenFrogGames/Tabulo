//
//  fgTabuloEdge.h
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GraphEdge.h"
#import "../../../Framework/Framework/Control/f3GraphNode.h"

@interface fgTabuloEdge : f3GraphEdge {
    
    NSNumber *inputKey;
}

+ (NSArray *)edgesFromNode:(f3GraphNode *)_node withInput:(f3GraphNode *)_input;

@property (readonly) NSNumber *InputKey;

@end
