//
//  fgLevel006.m
//  Tabulo
//
//  Created by Serge Menard on 2014-06-26.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevel006.h"

@implementation fgLevel006

- (void)buildSceneForLevel:(fgTabuloDirector *)_director withStrategy:(fgLevelStrategy *)_strategy {
    
    [scene addPointFrom:0 Radius:2.5f Angle:135.f];
    [scene addPointFrom:1 Radius:2.5f Angle:135.f]; // 2
    [scene addPointFrom:2 Radius:2.5f Angle:45.f];
    [scene addPointFrom:3 Radius:2.5f Angle:45.f]; // 4
    [scene addPointFrom:4 Radius:2.5f Angle:135.f];
    [scene addPointFrom:5 Radius:2.5f Angle:135.f]; // 6
    [scene computePoints];
    
    fgHouseNode *node0 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_strategy buildNode:[scene getPointAt:1] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_strategy buildNode:[scene getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_strategy buildNode:[scene getPointAt:3] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node4 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:4] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_strategy buildNode:[scene getPointAt:5] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_strategy buildNode:[scene getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];

    [_strategy initGraphStrategy:dataWriter symbols:dataSymbols];

    [scene buildHouse:_director node:node0 type:TABULO_PawnOne state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node4 type:TABULO_PawnFour state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildBackground:_director writer:dataWriter symbols:dataSymbols]; // gameplay background

    f3ViewAdaptee *pawnOne = [scene buildPawn:_director state:_strategy node:node2 type:TABULO_PawnOne writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node2 view:pawnOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *pawnTwo = [scene buildPawn:_director state:_strategy node:node6 type:TABULO_PawnFour writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node6 view:pawnTwo writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plankOne = [scene buildMediumPlank:_director state:_strategy node:node5 angle:135.f hole:TABULO_HOLE_MAX writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node5 view:plankOne writer:dataWriter symbols:dataSymbols];

    [scene buildLayer:_director atIndex:GameplayLayer writer:dataWriter symbols:dataSymbols]; // gameplay elements

    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node0 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node2 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node3 origin:node2 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node3 origin:node4 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node5 origin:node4 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node5 origin:node6 target:node4 writer:dataWriter symbols:dataSymbols];

    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node2 origin:node1 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node2 origin:node3 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node3 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node5 target:node3 writer:dataWriter symbols:dataSymbols];
    
    [super buildSceneForLevel:_director withStrategy:_strategy];
}

@end
