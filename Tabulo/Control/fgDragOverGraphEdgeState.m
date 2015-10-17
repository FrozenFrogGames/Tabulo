//
//  fgDragViewOverEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgDragOverGraphEdgeState.h"
#import "fgTabuloStrategy.h"
#import "fgHouseNode.h"
#import "../fgTabuloDirector.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GameState.h"
#import "../../../Framework/Framework/Control/f3GraphSchema.h"
#import "../../../Framework/Framework/Control/f3GraphSchemaStrategy.h"
#import "../../../Framework/Framework/Control/f3GraphEdgeWithInputNode.h"

@implementation fgDragOverGraphEdgeState

- (void)begin:(f3ControllerState *)_previousState owner:(f3Controller *)_owner {

    [super begin:_previousState owner:_owner];

    feedbackEdges = [NSMutableArray array];
    
    f3GameAdaptee *producer = [f3GameAdaptee Producer];
    if ([producer.State isKindOfClass:[f3GameState class]])
    {
        f3GameState *gameState = (f3GameState *)producer.State;
        if ([gameState.Strategy isKindOfClass:[fgTabuloStrategy class]])
        {
            fgTabuloStrategy *gameStrategy = (fgTabuloStrategy *)gameState.Strategy;

            for (f3GraphEdge *edge in edges)
            {
                if ([gameStrategy.Schema evaluate:edge.Conditions])
                {
                    f3GraphNode *targetNode = [f3GraphNode nodeForKey:edge.TargetKey];

                    if ([targetNode isKindOfClass:[fgHouseNode class]])
                    {
                        [(fgHouseNode *)targetNode buildHouseFeedback:gameStrategy.Schema edge:(fgPawnEdge *)edge];
                    }

                    [feedbackEdges addObject:edge];
                }
            }

            if ([feedbackEdges count] > 0)
            {
                f3GameDirector *director = [f3GameDirector Director];
                f3ViewBuilder *viewBuilder = director.Builder;
                [gameStrategy buildFeedbackLayer:viewBuilder edges:feedbackEdges];

                id feedbackLayer = [viewBuilder popComponent];
                if ([feedbackLayer isKindOfClass:[f3ViewLayer class]])
                {
                    [director.Scene appendLayer:(f3ViewLayer *)feedbackLayer];
                }
            }
        }
    }
}

- (void)update:(NSTimeInterval)_elapsed owner:(f3Controller *)_owner {

    [super update:_elapsed owner:_owner];
    
    if ([feedbackEdges count] > 0 && [pendingActions count] > 0)
    {
        f3GameDirector *director = [f3GameDirector Director];
        [director.Scene removeLayerAtIndex:HelperOverlay];

        f3GameAdaptee *producer = [f3GameAdaptee Producer];
        if ([producer.State isKindOfClass:[f3GameState class]])
        {
            f3GameState *gameState = (f3GameState *)producer.State;
            if ([gameState.Strategy isKindOfClass:[f3GraphSchemaStrategy class]])
            {
                f3GraphSchemaStrategy *gameStrategy = (f3GraphSchemaStrategy *)gameState.Strategy;

                for (f3GraphEdge *edge in feedbackEdges)
                {
                    f3GraphNode *targetNode = [f3GraphNode nodeForKey:edge.TargetKey];
                    if ([targetNode isKindOfClass:[fgHouseNode class]])
                    {
                        if (edge != currentEdge) // clear feedback except for the edge in action
                        {
                            [(fgHouseNode *)targetNode clearHouseFeedback:gameStrategy.Schema];
                        }
                    }
                }
            }

            if ([node isKindOfClass:[fgHouseNode class]])
            {
                [(fgHouseNode *)node clearHouseFeedback:nil]; // force feedback to false on the current node
            }

            [feedbackEdges removeAllObjects];
        }
    }
}

- (void)end:(f3ControllerState *)_nextState owner:(f3Controller *)_owner {

    [super end:_nextState owner:_owner];

    f3GameDirector *director = [f3GameDirector Director];
    [director.Scene removeLayerAtIndex:HelperOverlay];
    
    if ([feedbackEdges count] > 0)
    {
        f3GameAdaptee *producer = [f3GameAdaptee Producer];
        if ([producer.State isKindOfClass:[f3GameState class]])
        {
            f3GameState *gameState = (f3GameState *)producer.State;
            if ([gameState.Strategy isKindOfClass:[f3GraphSchemaStrategy class]])
            {
                f3GraphSchemaStrategy *gameStrategy = (f3GraphSchemaStrategy *)gameState.Strategy;

                for (f3GraphEdge *edge in feedbackEdges)
                {
                    f3GraphNode *targetNode = [f3GraphNode nodeForKey:edge.TargetKey];
                    if ([targetNode isKindOfClass:[fgHouseNode class]])
                    {
                        [(fgHouseNode *)targetNode clearHouseFeedback:gameStrategy.Schema];
                    }
                }
            }
            
            [feedbackEdges removeAllObjects];
        }
    }
    
    feedbackEdges = nil;
}

- (void)attachListener {
    
    if (nodeListening == nil)
    {
        nodeListening = [NSMutableArray array];
        
        for (f3GraphEdgeWithInputNode *edge in edges)
        {
            f3GraphNode *targetNode = [f3GraphNode nodeForKey:edge.TargetKey];
            if ([nodeListening containsObject:targetNode])
            {
                // TODO throw f3Exception
            }
            else
            {
                [nodeListening addObject:targetNode];
            }
            
            f3GraphNode *inputNode = [f3GraphNode nodeForKey:edge.InputKey];
            if ([nodeListening containsObject:inputNode])
            {
                // TODO throw f3Exception
            }
            else
            {
                [nodeListening addObject:inputNode];
            }
        }
        
        for (f3GraphNode *nodeItem in nodeListening)
        {
            if (![nodeItem appendListener:self])
            {
                NSLog(@"Error! Already listenning node: %@", nodeItem);
            }
        }
    }
}

- (void)notifyEvent:(f3GameEvent *)_event {
    
    if ([_event isKindOfClass:[f3GraphNodeEvent class]])
    {
        f3GraphNodeEvent *graphNodeEvent = (f3GraphNodeEvent *)_event;
        
        if ([nodeListening containsObject:graphNodeEvent.Node])
        {
            shouldKeepFocus = false;
            
            if (graphNodeEvent.Event == GRAPH_InputMoved || graphNodeEvent.Event == GRAPH_InputEnded)
            {
                if (haveFocus && !releaseFocus)
                {
                    NSNumber *nodeKey = graphNodeEvent.Node.Key;
                    
                    if (currentEdge == nil)
                    {
                        f3GameAdaptee *producer = [f3GameAdaptee Producer];
                        
                        if ([producer.State isKindOfClass:[f3GameState class]])
                        {
                            f3GameState *gameState =(f3GameState *)producer.State;
                            f3GraphSchemaStrategy *gameStrategy =(f3GraphSchemaStrategy *)[gameState Strategy];
                            
                            for (f3GraphEdgeWithInputNode *edge in edges)
                            {
                                if (edge.TargetKey == nodeKey || edge.InputKey == nodeKey)
                                {
                                    if ([gameStrategy.Schema evaluate:edge.Conditions])
                                    {
                                        currentEdge = edge;
//                                      NSLog(@"State: %@, target: %@", self, edge.Target);
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    else if (graphNodeEvent.Event == GRAPH_InputMoved && currentEdge.TargetKey == nodeKey)
                    {
                        shouldKeepFocus = true;
                    }
                }
            }
        }
        else
        {
            NSLog(@"Error! Listenning unrelated input: %@", graphNodeEvent.Node);
        }
    }
    else
    {
        [super notifyEvent:_event];
    }
}

@end
