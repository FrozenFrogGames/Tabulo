//
//  fgPlankFeedbackCommand.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-24.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgPlankFeedbackCommand.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GraphEdge.h"
#import "../../../Framework/Framework/Control/f3GameState.h"
#import "../../../Framework/Framework/Control/f3GraphNodeStrategy.h"
#import "../../../Framework/Framework/View/f3ViewAdaptee.h"
#import "fgPlankEdge.h"

@implementation fgPlankFeedbackCommand

- (id)initWithView:(f3ViewComponent *)_view Node:(f3GraphNode *)_node {

    self = [super initWithView:_view];
    
    if (self != nil)
    {
        plankNode = _node;
    }
    
    return self;
}

- (f3ViewComposite *)buildFeedbackCompositeFor:(f3ViewComponent *)_component { // TODO fix me
    
    f3ViewComposite *result = [[f3ViewComposite alloc] init];
/*
    NSArray *edges = [f3GraphEdge edgesFromNode:plankNode.Key];
    f3ViewBuilder *builder = [f3GameDirector Director].Builder;
    f3GameState *gameState = (f3GameState *)[f3GameAdaptee Producer].State;
    f3GraphNodeStrategy *gameStrategy = (f3GraphNodeStrategy *)[gameState Strategy];

    for (f3GraphEdge *edge in edges)
    {
        if ([gameStrategy evaluateEdge:edge])
        {
            if ([edge isKindOfClass:[fgPlankEdge class]])
            {
                f3GraphNode *targetNode = [f3GraphNode nodeForKey:edge.TargetKey];
                float targetAngle = [(fgPlankEdge *)edge Angle];
                
                if ([gameStrategy getNodeFlag:plankNode.Key flag:TABULO_HaveSmallPlank])
                {
                    [fgPlankFeedbackCommand buildSmallPlank:builder Position:targetNode.Position Angle:targetAngle];
                }
                else if ([gameStrategy getNodeFlag:plankNode.Key flag:TABULO_HaveMediumPlank])
                {
                    [fgPlankFeedbackCommand buildMediumPlank:builder Position:targetNode.Position Angle:targetAngle];
                }
                else if ([gameStrategy getNodeFlag:plankNode.Key flag:TABULO_HaveLongPlank])
                {
                    // TODO support long plank
                }
                
                if ([builder top] != nil)
                {
                    [result appendComponent:[builder popComponent]];
                }
            }
        }
    }
    
    [result appendComponent:_component];
 */
    return result;
}

@end
