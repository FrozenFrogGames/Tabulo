//
//  fgLevel024.m
//  Tabulo
//
//  Created by Serge Menard on 2014-07-10.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevel024.h"

@implementation fgLevel024

- (void)buildScene:(fgTabuloDirector *)_director state:(fgLevelState *)_state {

    [scene addPointFrom:0 Radius:2.5f Angle:90.f];
    [scene addPointFrom:0 Radius:2.5f Angle:180.f]; // 2
    [scene addPointFrom:1 Radius:2.5f Angle:90.f];
    [scene addPointFrom:2 Radius:2.5f Angle:180.f]; // 4
    [scene addPointFrom:3 Radius:2.5f Angle:65.f];
    [scene addPointFrom:3 Radius:1.75f Angle:135.f]; // 6
    [scene addPointFrom:3 Radius:2.5f Angle:180.f];
    [scene addPointFrom:4 Radius:2.5f Angle:90.f]; // 8
    [scene addPointFrom:5 Radius:2.5f Angle:65.f];
    [scene addPointFrom:6 Radius:1.75f Angle:135.f]; // 10
    [scene addPointFrom:7 Radius:2.5f Angle:180.f];
    [scene addPointFrom:9 Radius:2.5f Angle:205.f]; // 12
    [scene addPointFrom:10 Radius:2.5f Angle:155.f];
    [scene addPointFrom:10 Radius:1.75f Angle:225.f]; // 14
    [scene addPointFrom:11 Radius:2.5f Angle:115.f];
    [scene addPointFrom:13 Radius:2.5f Angle:155.f]; // 16
    [scene computePoints];
    

    f3GraphNode *node0 = [_state buildNode:[scene getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[scene getPointAt:1] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[scene getPointAt:2] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node3 = [(fgLevelState *)_state buildHouseNode:[scene getPointAt:3] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_state buildNode:[scene getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_state buildNode:[scene getPointAt:5] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_state buildNode:[scene getPointAt:6] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[scene getPointAt:7] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_state buildNode:[scene getPointAt:8] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_state buildNode:[scene getPointAt:9] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node10 = [_state buildNode:[scene getPointAt:10] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node11 = [(fgLevelState *)_state buildHouseNode:[scene getPointAt:11] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node12 = [_state buildNode:[scene getPointAt:12] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node13 = [_state buildNode:[scene getPointAt:13] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node14 = [_state buildNode:[scene getPointAt:14] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node15 = [_state buildNode:[scene getPointAt:15] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node16 = [_state buildNode:[scene getPointAt:16] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    [_state buildConfig:dataWriter];
    
    [scene clearPoints];

    [scene buildPillar:_director node:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node3 type:TABULO_PawnFour state:_state writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node11 type:TABULO_PawnTwo state:_state writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node16 writer:dataWriter symbols:dataSymbols];
    [scene buildBackground:_director writer:dataWriter symbols:dataSymbols];
    
    [scene buildComposite:_director writer:dataWriter symbols:dataSymbols]; // gameplay background
    
    f3ViewAdaptee *pawnOne = [scene buildPawn:_director state:_state node:node3 type:TABULO_PawnTwo writer:dataWriter symbols:dataSymbols];
    [scene buildDragControl:_director state:_state node:node3 view:pawnOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *pawnTwo = [scene buildPawn:_director state:_state node:node11 type:TABULO_PawnFour writer:dataWriter symbols:dataSymbols];
    [scene buildDragControl:_director state:_state node:node11 view:pawnTwo writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plankOne = [scene buildMediumPlank:_director state:_state node:node8 angle:90.f hole:TABULO_OneHole_Two writer:dataWriter symbols:dataSymbols];
    [scene buildDragControl:_director state:_state node:node8 view:plankOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankTwo = [scene buildSmallPlank:_director state:_state node:node14 angle:45.f hole:TABULO_OneHole_Four writer:dataWriter symbols:dataSymbols];
    [scene buildDragControl:_director state:_state node:node14 view:plankTwo writer:dataWriter symbols:dataSymbols];

    [scene buildComposite:_director writer:dataWriter symbols:dataSymbols]; // gameplay elements

    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node0 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node3 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node2 origin:node0 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node2 origin:node4 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node5 origin:node3 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node5 origin:node9 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node6 origin:node3 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node6 origin:node10 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node7 origin:node3 target:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node7 origin:node11 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node8 origin:node4 target:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node8 origin:node11 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node12 origin:node9 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node12 origin:node10 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node13 origin:node10 target:node16 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node13 origin:node16 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node14 origin:node10 target:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node14 origin:node11 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node15 origin:node11 target:node16 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node15 origin:node16 target:node11 writer:dataWriter symbols:dataSymbols];

    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node0 origin:node1 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node0 origin:node2 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node3 origin:node1 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node3 origin:node7 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node3 origin:node1 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node3 origin:node5 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node3 origin:node5 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node3 origin:node7 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node2 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node8 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node9 origin:node5 target:node12 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node9 origin:node12 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node10 origin:node6 target:node14 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node10 origin:node14 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node10 origin:node12 target:node13 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node10 origin:node13 target:node12 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node11 origin:node7 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node11 origin:node8 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node11 origin:node7 target:node15 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node11 origin:node15 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node11 origin:node8 target:node15 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node11 origin:node15 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node16 origin:node13 target:node15 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node16 origin:node15 target:node13 writer:dataWriter symbols:dataSymbols];

    [super buildScene:_director state:_state];
}

@end
