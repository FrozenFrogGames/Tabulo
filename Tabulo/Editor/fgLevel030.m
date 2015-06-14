//
//  fgLevel030.m
//  Tabulo
//
//  Created by Serge Menard on 2014-09-21.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevel030.h"

@implementation fgLevel030

- (void)buildSceneForLevel:(fgTabuloDirector *)_director withStrategy:(fgLevelStrategy *)_strategy {
    
    [scene addPointFrom:0 Radius:1.75f Angle:25.f];
    [scene addPointFrom:0 Radius:2.5f Angle:95.f]; // 2
    [scene addPointFrom:1 Radius:1.75f Angle:25.f];
    [scene addPointFrom:2 Radius:2.5f Angle:95.f]; // 4
    [scene addPointFrom:3 Radius:1.75f Angle:30.f];
    [scene addPointFrom:3 Radius:2.5f Angle:135.f]; // 6
    [scene addPointFrom:4 Radius:2.5f Angle:45.f];
    [scene addPointFrom:4 Radius:2.5f Angle:85.f]; // 8
    [scene addPointFrom:5 Radius:1.75f Angle:30.f];
    [scene addPointFrom:7 Radius:2.5f Angle:45.f]; // 10
    [scene addPointFrom:8 Radius:2.5f Angle:85.f];
    [scene addPointFrom:9 Radius:1.75f Angle:90.f]; // 12
    [scene addPointFrom:10 Radius:1.75f Angle:155.f];
    [scene addPointFrom:12 Radius:1.75f Angle:90.f]; // 14
    [scene addPointFrom:14 Radius:1.75f Angle:150.f];
    [scene computePoints];

    f3GraphNode *node0 = [_strategy buildNode:[scene getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_strategy buildNode:[scene getPointAt:1] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_strategy buildNode:[scene getPointAt:2] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_strategy buildNode:[scene getPointAt:3] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node4 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:4] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_strategy buildNode:[scene getPointAt:5] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_strategy buildNode:[scene getPointAt:6] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_strategy buildNode:[scene getPointAt:7] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_strategy buildNode:[scene getPointAt:8] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node9 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:9] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node10 = [_strategy buildNode:[scene getPointAt:10] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node11 = [_strategy buildNode:[scene getPointAt:11] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node12 = [_strategy buildNode:[scene getPointAt:12] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node13 = [_strategy buildNode:[scene getPointAt:13] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node14 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:14] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node15 = [_strategy buildNode:[scene getPointAt:15] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    [_strategy buildGraphState];

    [scene clearPoints];

    [scene buildPillar:_director node:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node4 type:TABULO_PawnFour state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node9 type:TABULO_PawnTwo state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node14 type:TABULO_PawnOne state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildBackground:_director writer:dataWriter symbols:dataSymbols];

    [scene buildComposite:_director atLayer:BackgroundLayer writer:dataWriter symbols:dataSymbols]; // gameplay background

    f3ViewAdaptee *pawnOne = [scene buildPawn:_director state:_strategy node:node4 type:TABULO_PawnOne writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node4 view:pawnOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *pawnTwo = [scene buildPawn:_director state:_strategy node:node9 type:TABULO_PawnFour writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node9 view:pawnTwo writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *pawnThree = [scene buildPawn:_director state:_strategy node:node14 type:TABULO_PawnTwo writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node14 view:pawnThree writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankOne = [scene buildMediumPlank:_director state:_strategy node:node2 angle:95.f hole:TABULO_OneHole_Four writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node2 view:plankOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankTwo = [scene buildSmallPlank:_director state:_strategy node:node12 angle:90.f hole:TABULO_OneHole_Two writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node12 view:plankTwo writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankThree = [scene buildMediumPlank:_director state:_strategy node:node7 angle:45.f hole:TABULO_OneHole_One writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node7 view:plankThree writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankFour = [scene buildSmallPlank:_director state:_strategy node:node13 angle:150.f hole:TABULO_HOLE_MAX writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node13 view:plankFour writer:dataWriter symbols:dataSymbols];

    [scene buildComposite:_director atLayer:GameplayLayer writer:dataWriter symbols:dataSymbols]; // gameplay elements

    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node1 origin:node0 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node1 origin:node3 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node2 origin:node0 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node2 origin:node4 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node5 origin:node9 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node5 origin:node3 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node6 origin:node4 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node6 origin:node3 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node7 origin:node4 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node7 origin:node10 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node8 origin:node4 target:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node8 origin:node11 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node12 origin:node9 target:node14 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node12 origin:node14 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node13 origin:node10 target:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node13 origin:node11 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node15 origin:node10 target:node14 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node15 origin:node14 target:node10 writer:dataWriter symbols:dataSymbols];

    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node3 origin:node1 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node3 origin:node5 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node9 origin:node12 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node9 origin:node5 target:node12 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node10 origin:node13 target:node15 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node10 origin:node15 target:node13 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node14 origin:node12 target:node15 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node14 origin:node15 target:node12 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node2 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node6 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node2 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node7 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node2 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node8 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node7 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node6 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node8 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node6 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node7 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node8 target:node7 writer:dataWriter symbols:dataSymbols];

    [super buildSceneForLevel:_director withStrategy:_strategy];
}

@end
