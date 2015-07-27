//
//  fgLevel029.m
//  Tabulo
//
//  Created by Serge Menard on 2014-09-21.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevel029.h"

@implementation fgLevel029

- (void)buildSceneForLevel:(fgTabuloDirector *)_director withStrategy:(fgLevelStrategy *)_strategy {

    [scene addPointFrom:0 Radius:2.5f Angle:140.f];
    [scene addPointFrom:0 Radius:2.5f Angle:180.f]; // 2
    [scene addPointFrom:0 Radius:2.5f Angle:220.f];
    [scene addPointFrom:1 Radius:2.5f Angle:140.f]; // 4
    [scene addPointFrom:2 Radius:2.5f Angle:180.f];
    [scene addPointFrom:3 Radius:2.5f Angle:220.f]; // 6
    [scene addPointFrom:4 Radius:1.75f Angle:160.f];
    [scene addPointFrom:4 Radius:1.75f Angle:250.f]; // 8
    [scene addPointFrom:5 Radius:2.5f Angle:115.f];
    [scene addPointFrom:5 Radius:2.5f Angle:245.f]; // 10
    [scene addPointFrom:5 Radius:1.75f Angle:290.f];
    [scene addPointFrom:6 Radius:1.75f Angle:200.f]; // 12
    [scene addPointFrom:7 Radius:1.75f Angle:160.f];
    [scene addPointFrom:12 Radius:1.75f Angle:200.f]; // 14
    [scene computePoints];

    fgHouseNode *node0 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_strategy buildNode:[scene getPointAt:1] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_strategy buildNode:[scene getPointAt:2] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_strategy buildNode:[scene getPointAt:3] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_strategy buildNode:[scene getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node5 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:5] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_strategy buildNode:[scene getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_strategy buildNode:[scene getPointAt:7] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_strategy buildNode:[scene getPointAt:8] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_strategy buildNode:[scene getPointAt:9] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node10 = [_strategy buildNode:[scene getPointAt:10] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node11 = [_strategy buildNode:[scene getPointAt:11] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node12 = [_strategy buildNode:[scene getPointAt:12] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node13 = [_strategy buildNode:[scene getPointAt:13] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node14 = [_strategy buildNode:[scene getPointAt:14] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];

    [_strategy initGraphStrategy:dataWriter symbols:dataSymbols];

    [scene buildHouse:_director node:node0 type:TABULO_PawnOne state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node5 type:TABULO_PawnTwo state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node13 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node14 writer:dataWriter symbols:dataSymbols];
    [scene buildBackground:_director writer:dataWriter symbols:dataSymbols]; // gameplay background

    f3ViewAdaptee *pawnOne = [scene buildPawn:_director state:_strategy node:node0 type:TABULO_PawnTwo writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node0 view:pawnOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *pawnTwo = [scene buildPawn:_director state:_strategy node:node5 type:TABULO_PawnOne writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node5 view:pawnTwo writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankOne = [scene buildMediumPlank:_director state:_strategy node:node9 angle:115.f hole:TABULO_OneHole_Two writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node9 view:plankOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankTwo = [scene buildSmallPlank:_director state:_strategy node:node12 angle:200.f hole:TABULO_OneHole_One writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node12 view:plankTwo writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankFour = [scene buildMediumPlank:_director state:_strategy node:node10 angle:245.f hole:TABULO_OneHole_One writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node10 view:plankFour writer:dataWriter symbols:dataSymbols];

    [scene buildLayer:_director atIndex:GameplayLayer writer:dataWriter symbols:dataSymbols]; // gameplay elements

    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node0 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node4 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node2 origin:node0 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node2 origin:node5 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node3 origin:node0 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node3 origin:node6 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node9 origin:node5 target:node13 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node9 origin:node13 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node10 origin:node5 target:node14 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node10 origin:node14 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node7 origin:node4 target:node13 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node7 origin:node13 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node8 origin:node4 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node8 origin:node5 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node11 origin:node6 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node11 origin:node5 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node12 origin:node6 target:node14 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node12 origin:node14 target:node6 writer:dataWriter symbols:dataSymbols];

    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node0 origin:node1 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node0 origin:node2 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node0 origin:node1 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node0 origin:node3 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node0 origin:node3 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node0 origin:node2 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node5 origin:node2 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node5 origin:node9 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node5 origin:node2 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node5 origin:node10 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node5 origin:node10 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node5 origin:node9 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node4 origin:node7 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node4 origin:node8 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node5 origin:node8 target:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node5 origin:node11 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node6 origin:node11 target:node12 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node6 origin:node12 target:node11 writer:dataWriter symbols:dataSymbols];

    [super buildSceneForLevel:_director withStrategy:_strategy];
}

@end
