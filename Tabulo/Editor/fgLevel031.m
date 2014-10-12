//
//  fgLevel031.m
//  Tabulo
//
//  Created by Serge Menard on 2014-09-23.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevel031.h"

@implementation fgLevel031

- (void)buildScene:(fgTabuloDirector *)_director state:(fgLevelState *)_state {

    [scene addPointFrom:0 Radius:1.75f Angle:270.f];
    [scene addPointFrom:0 Radius:1.75f Angle:180.f]; // 2
    [scene addPointFrom:1 Radius:1.75f Angle:270.f];
    [scene addPointFrom:2 Radius:1.75f Angle:180.f]; // 4
    [scene addPointFrom:3 Radius:2.5f Angle:135.f];
    [scene addPointFrom:4 Radius:2.5f Angle:70.f]; // 6
    [scene addPointFrom:4 Radius:2.5f Angle:110.f];
    [scene addPointFrom:6 Radius:2.5f Angle:70.f]; // 8
    [scene addPointFrom:7 Radius:2.5f Angle:110.f];
    [scene addPointFrom:8 Radius:1.75f Angle:30.f]; // 10
    [scene addPointFrom:8 Radius:1.75f Angle:90.f];
    [scene addPointFrom:8 Radius:1.75f Angle:180.f]; // 12
    [scene addPointFrom:9 Radius:2.5f Angle:45.f];
    [scene addPointFrom:10 Radius:1.75f Angle:30.f]; // 14
    [scene addPointFrom:11 Radius:1.75f Angle:90.f];
    [scene addPointFrom:14 Radius:1.75f Angle:150.f]; // 16
    [scene addPointFrom:8 Radius:2.5f Angle:290.f];
    [scene computePoints];

    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[scene getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[scene getPointAt:1] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[scene getPointAt:2] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_state buildNode:[scene getPointAt:3] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node4 = [(fgLevelState *)_state buildHouseNode:[scene getPointAt:4] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_state buildNode:[scene getPointAt:5] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_state buildNode:[scene getPointAt:6] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[scene getPointAt:7] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_state buildNode:[scene getPointAt:8] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_state buildNode:[scene getPointAt:9] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node10 = [_state buildNode:[scene getPointAt:10] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node11 = [_state buildNode:[scene getPointAt:11] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node12 = [_state buildNode:[scene getPointAt:12] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node13 = [_state buildNode:[scene getPointAt:13] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node14 = [_state buildNode:[scene getPointAt:14] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node15 = [_state buildNode:[scene getPointAt:15] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node16 = [_state buildNode:[scene getPointAt:16] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node17 = [_state buildNode:[scene getPointAt:17] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    [_state buildConfig:dataWriter];

    [scene clearPoints];

    [scene buildHouse:_director node:node0 type:TABULO_PawnTwo state:_state writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node4 type:TABULO_PawnFour state:_state writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node14 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node15 writer:dataWriter symbols:dataSymbols];
    [scene buildBackground:_director writer:dataWriter symbols:dataSymbols];

    [scene buildComposite:_director writer:dataWriter symbols:dataSymbols]; // gameplay background

    f3ViewAdaptee *pawnOne = [scene buildPawn:_director state:_state node:node14 type:TABULO_PawnTwo writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director state:_state node:node14 view:pawnOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *pawnTwo = [scene buildPawn:_director state:_state node:node15 type:TABULO_PawnFour writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director state:_state node:node15 view:pawnTwo writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankOne = [scene buildMediumPlank:_director state:_state node:node17 angle:110.f hole:TABULO_OneHole_Two writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director state:_state node:node17 view:plankOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankTwo = [scene buildSmallPlank:_director state:_state node:node12 angle:180.f hole:TABULO_OneHole_Two writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director state:_state node:node12 view:plankTwo writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankThree = [scene buildSmallPlank:_director state:_state node:node11 angle:90.f hole:TABULO_OneHole_Four writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director state:_state node:node11 view:plankThree writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankFour = [scene buildMediumPlank:_director state:_state node:node5 angle:135.f hole:TABULO_OneHole_Four writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director state:_state node:node5 view:plankFour writer:dataWriter symbols:dataSymbols];

    [scene buildComposite:_director writer:dataWriter symbols:dataSymbols]; // gameplay elements

    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node1 origin:node0 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node1 origin:node3 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node2 origin:node0 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node2 origin:node4 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node5 origin:node4 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node5 origin:node3 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node6 origin:node4 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node6 origin:node8 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node7 origin:node4 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node7 origin:node9 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node10 origin:node8 target:node14 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node10 origin:node14 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node11 origin:node8 target:node15 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node11 origin:node15 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node12 origin:node8 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node12 origin:node9 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node13 origin:node9 target:node15 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node13 origin:node15 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node16 origin:node14 target:node15 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node16 origin:node15 target:node14 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node17 origin:node0 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node17 origin:node8 target:node0 writer:dataWriter symbols:dataSymbols];

    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node0 origin:node1 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node0 origin:node2 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node8 origin:node10 target:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node8 origin:node11 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node8 origin:node10 target:node12 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node8 origin:node12 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node8 origin:node12 target:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node8 origin:node11 target:node12 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node8 origin:node17 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node8 origin:node6 target:node17 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node14 origin:node10 target:node16 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node14 origin:node16 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node15 origin:node11 target:node16 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node15 origin:node16 target:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node5 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node6 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node5 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node7 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node7 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node6 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node9 origin:node7 target:node13 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node9 origin:node13 target:node7 writer:dataWriter symbols:dataSymbols];

    [super buildScene:_director state:_state];
}

@end
