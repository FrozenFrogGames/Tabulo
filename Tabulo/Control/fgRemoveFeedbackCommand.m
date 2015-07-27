//
//  fgRemoveFeedbackCommand.m
//  Tabulo
//
//  Created by Serge Menard on 2014-03-01.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgRemoveFeedbackCommand.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GraphState.h"
#import "../../../Framework/Framework/Control/f3GraphNodeStrategy.h"

@implementation fgRemoveFeedbackCommand

- (id)initWithView:(f3ViewComponent *)_view {
    
    self = [super initWithView:_view];
    
    if (self != nil)
    {
        feedbackOnNodes = [NSMutableArray array];
    }

    return self;
}

- (void)appendHouseNode:(fgHouseNode *)_node {

    [feedbackOnNodes addObject:_node];
}

- (bool)update:(NSTimeInterval)_elapsed {

    f3ControllerState *state = [f3GameAdaptee Producer].State;
    
    if ([state isKindOfClass:[f3GameState class]])
    {
        f3GraphNodeStrategy *gameStrategy = (f3GraphNodeStrategy *)[(f3GameState *)state Strategy];

        for (fgHouseNode *node in feedbackOnNodes)
        {
            NSNumber *nodeKey = [node Key];
            
            if ([gameStrategy getNodeFlag:nodeKey flag:TABULO_PawnOne])
            {
                [node buildHouseFeedback:TABULO_PawnOne];
            }
            else if ([gameStrategy getNodeFlag:nodeKey flag:TABULO_PawnTwo])
            {
                [node buildHouseFeedback:TABULO_PawnTwo];
            }
            else if ([gameStrategy getNodeFlag:nodeKey flag:TABULO_PawnThree])
            {
                [node buildHouseFeedback:TABULO_PawnThree];
            }
            else if ([gameStrategy getNodeFlag:nodeKey flag:TABULO_PawnFour])
            {
                [node buildHouseFeedback:TABULO_PawnFour];
            }
            else if ([gameStrategy getNodeFlag:nodeKey flag:TABULO_PawnFive])
            {
                [node buildHouseFeedback:TABULO_PawnFive];
            }
            else
            {
                [node buildHouseFeedback:TABULO_PAWN_MAX];
            }
        }
    }

    [feedbackOnNodes removeAllObjects];
    
    feedbackOnNodes = nil;
    
    return [super update:_elapsed];
}

@end
