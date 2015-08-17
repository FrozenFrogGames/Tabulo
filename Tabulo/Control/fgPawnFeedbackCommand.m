//
//  fgPawnFeedbackCommand.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-24.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgPawnFeedbackCommand.h"
#import "fgHouseNode.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GraphSchemaStrategy.h"
#import "../../../Framework/Framework/Control/f3GraphEdge.h"
#import "../../../Framework/Framework/View/f3ViewAdaptee.h"
#import "../../../Framework/Framework/View/f3GraphSceneBuilder.h"

@implementation fgPawnFeedbackCommand

- (id)initWithView:(f3ViewComponent *)_view Node:(f3GraphNode *)_node {

    self = [super initWithView:_view];
    
    if (self != nil)
    {
        pawnNode = _node;
    }
    
    return self;
}

- (f3ViewComposite *)buildFeedbackCompositeFor:(f3ViewComponent *)_component { // TODO fix me

    f3ViewComposite *result = [[f3ViewComposite alloc] init];
/*
    enum f3TabuloPawnType pawnType = TABULO_PAWN_MAX;
    NSArray *edges = [f3GraphEdge edgesFromNode:pawnNode.Key];
    f3ViewBuilder *builder = [f3GameDirector Director].Builder;
    f3GameState *gameState = (f3GameState *)[f3GameAdaptee Producer].State;
    f3GraphNodeStrategy *gameStrategy =(f3GraphNodeStrategy *)[gameState Strategy];

    if ([gameStrategy getNodeFlag:pawnNode.Key flag:TABULO_PawnOne])
    {
        pawnType = TABULO_PawnOne;
    }
    else if ([gameStrategy getNodeFlag:pawnNode.Key flag:TABULO_PawnTwo])
    {
        pawnType = TABULO_PawnTwo;
    }
    else if ([gameStrategy getNodeFlag:pawnNode.Key flag:TABULO_PawnThree])
    {
        pawnType = TABULO_PawnThree;
    }
    else if ([gameStrategy getNodeFlag:pawnNode.Key flag:TABULO_PawnFour])
    {
        pawnType = TABULO_PawnFour;
    }
    else if ([gameStrategy getNodeFlag:pawnNode.Key flag:TABULO_PawnFive])
    {
        pawnType = TABULO_PawnFive;
    }
    
    if (pawnType < TABULO_PAWN_MAX)
    {
        for (f3GraphEdge *edge in edges)
        {
            if ([gameStrategy evaluateEdge:edge])
            {
                f3GraphNode *node = [f3GraphNode nodeForKey:edge.TargetKey];

                if ([node isKindOfClass:[fgHouseNode class]]) // TODO give feedback on house sooner
                {
                    [(fgHouseNode *)node buildHouseFeedback:pawnType];
                }

                [fgPawnFeedbackCommand buildPawn:builder Position:node.Position Type:pawnType];

                [result appendComponent:[builder popComponent]];
            }
        }
    }

    [result appendComponent:_component];
 */
    return result;
}


@end
