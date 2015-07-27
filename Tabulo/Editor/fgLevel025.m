//
//  fgLevel025.m
//  Tabulo
//
//  Created by Serge Menard on 2014-09-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevel025.h"

@implementation fgLevel025

- (void)buildSceneForLevel:(fgTabuloDirector *)_director withStrategy:(fgLevelStrategy *)_strategy {

    [scene addPointFrom:0 Radius:2.5f Angle:90.f];
    [scene addPointFrom:1 Radius:2.5f Angle:90.f]; // 2
    [scene addPointFrom:2 Radius:2.5f Angle:45.f];
    [scene addPointFrom:2 Radius:1.75f Angle:90.f]; // 4
    [scene addPointFrom:2 Radius:2.5f Angle:180.f];
    [scene addPointFrom:3 Radius:2.5f Angle:45.f]; // 6
    [scene addPointFrom:4 Radius:1.75f Angle:90.f];
    [scene addPointFrom:5 Radius:2.5f Angle:180.f]; // 8
    [scene addPointFrom:6 Radius:1.75f Angle:180.f];
    [scene addPointFrom:5 Radius:2.5f Angle:180.f]; // 10
    [scene computePoints];

    fgHouseNode *node0 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_strategy buildNode:[scene getPointAt:1] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_strategy buildNode:[scene getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_strategy buildNode:[scene getPointAt:3] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_strategy buildNode:[scene getPointAt:4] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_strategy buildNode:[scene getPointAt:5] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_strategy buildNode:[scene getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node7 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:7] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_strategy buildNode:[scene getPointAt:8] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_strategy buildNode:[scene getPointAt:9] withRadius:0.8f writer:dataWriter symbols:dataSymbols];

    [_strategy initGraphStrategy:dataWriter symbols:dataSymbols];
    
    [scene buildHouse:_director node:node0 type:TABULO_PawnOne state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node7 type:TABULO_PawnTwo state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildBackground:_director writer:dataWriter symbols:dataSymbols]; // gameplay background

    f3ViewAdaptee *pawnOne = [scene buildPawn:_director state:_strategy node:node0 type:TABULO_PawnTwo writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node0 view:pawnOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *pawnTwo = [scene buildPawn:_director state:_strategy node:node7 type:TABULO_PawnOne writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node7 view:pawnTwo writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plankOne = [scene buildMediumPlank:_director state:_strategy node:node1 angle:90.f hole:TABULO_OneHole_One writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node1 view:plankOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankTwo = [scene buildMediumPlank:_director state:_strategy node:node5 angle:180.f hole:TABULO_OneHole_Two writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node5 view:plankTwo writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankThree = [scene buildSmallPlank:_director state:_strategy node:node9 angle:180.f hole:TABULO_HOLE_MAX writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node9 view:plankThree writer:dataWriter symbols:dataSymbols];
    
    [scene buildLayer:_director atIndex:GameplayLayer writer:dataWriter symbols:dataSymbols]; // gameplay elements

    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node0 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node2 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node3 origin:node6 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node3 origin:node2 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node5 origin:node8 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node5 origin:node2 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node4 origin:node7 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node4 origin:node2 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node9 origin:node7 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node9 origin:node6 target:node7 writer:dataWriter symbols:dataSymbols];

    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node2 origin:node1 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node2 origin:node3 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node2 origin:node1 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node2 origin:node5 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node2 origin:node5 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node2 origin:node3 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node7 origin:node4 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node7 origin:node9 target:node4 writer:dataWriter symbols:dataSymbols];

    [super buildSceneForLevel:_director withStrategy:_strategy];
}

@end
