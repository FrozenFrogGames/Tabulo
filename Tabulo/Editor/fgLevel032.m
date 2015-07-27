//
//  fgLevel034.m
//  Tabulo
//
//  Created by Serge Menard on 2014-10-09.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevel032.h"

@implementation fgLevel032

- (void)buildSceneForLevel:(fgTabuloDirector *)_director withStrategy:(fgLevelStrategy *)_strategy {

    [scene addPointFrom:0 Radius:2.5f Angle:95.f];
    [scene addPointFrom:0 Radius:2.5f Angle:135.f]; // 2
    [scene addPointFrom:0 Radius:1.75f Angle:180.f];
    [scene addPointFrom:1 Radius:2.5f Angle:95.f]; // 4
    [scene addPointFrom:2 Radius:2.5f Angle:135.f];
    [scene addPointFrom:3 Radius:1.75f Angle:180.f]; // 6
    [scene addPointFrom:4 Radius:1.75f Angle:205.f];
    [scene addPointFrom:5 Radius:2.5f Angle:171.f]; // 8
    [scene addPointFrom:5 Radius:1.75f Angle:270.f];
    [scene addPointFrom:6 Radius:2.5f Angle:189.f]; // 10
    [scene addPointFrom:8 Radius:2.5f Angle:171.f];
    [scene addPointFrom:10 Radius:2.5f Angle:189.f]; // 12
    [scene addPointFrom:11 Radius:2.5f Angle:270.f];
    [scene computePoints];

    fgHouseNode *node0 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_strategy buildNode:[scene getPointAt:1] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_strategy buildNode:[scene getPointAt:2] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_strategy buildNode:[scene getPointAt:3] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_strategy buildNode:[scene getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_strategy buildNode:[scene getPointAt:5] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node6 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:6] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_strategy buildNode:[scene getPointAt:7] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_strategy buildNode:[scene getPointAt:8] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_strategy buildNode:[scene getPointAt:9] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node10 = [_strategy buildNode:[scene getPointAt:10] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node11 = [_strategy buildNode:[scene getPointAt:11] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node12 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:12] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node13 = [_strategy buildNode:[scene getPointAt:13] withRadius:1.5f writer:dataWriter symbols:dataSymbols];

    [_strategy initGraphStrategy:dataWriter symbols:dataSymbols];

    [scene buildHouse:_director node:node0 type:TABULO_PawnOne state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node6 type:TABULO_PawnFour state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node12 type:TABULO_PawnTwo state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildBackground:_director writer:dataWriter symbols:dataSymbols]; // gameplay background

    f3ViewAdaptee *pawnOne = [scene buildPawn:_director state:_strategy node:node0 type:TABULO_PawnTwo writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node0 view:pawnOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *pawnTwo = [scene buildPawn:_director state:_strategy node:node6 type:TABULO_PawnOne writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node6 view:pawnTwo writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *pawnThree = [scene buildPawn:_director state:_strategy node:node12 type:TABULO_PawnFour writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node12 view:pawnThree writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankOne = [scene buildMediumPlank:_director state:_strategy node:node1 angle:95.f hole:TABULO_OneHole_Four writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node1 view:plankOne writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plankTwo = [scene buildSmallPlank:_director state:_strategy node:node7 angle:205.f hole:TABULO_OneHole_One writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node7 view:plankTwo writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankThree = [scene buildMediumPlank:_director state:_strategy node:node10 angle:189.f hole:TABULO_OneHole_Two writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node10 view:plankThree writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plankFour = [scene buildMediumPlank:_director state:_strategy node:node13 angle:90.f hole:TABULO_HOLE_MAX writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node13 view:plankFour writer:dataWriter symbols:dataSymbols];
    
    [scene buildLayer:_director atIndex:GameplayLayer writer:dataWriter symbols:dataSymbols]; // gameplay elements

    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node0 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node4 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node2 origin:node0 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node2 origin:node5 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node3 origin:node0 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node3 origin:node6 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node7 origin:node5 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node7 origin:node4 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node8 origin:node5 target:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node8 origin:node11 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node9 origin:node5 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node9 origin:node6 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node10 origin:node6 target:node12 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node10 origin:node12 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node13 origin:node11 target:node12 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node13 origin:node12 target:node11 writer:dataWriter symbols:dataSymbols];

    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node0 origin:node1 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node0 origin:node2 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node5 origin:node8 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node5 origin:node2 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node5 origin:node7 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node5 origin:node9 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node6 origin:node3 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node6 origin:node9 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node11 origin:node8 target:node13 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node11 origin:node13 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node12 origin:node10 target:node13 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node12 origin:node13 target:node10 writer:dataWriter symbols:dataSymbols];

    [super buildSceneForLevel:_director withStrategy:_strategy];
}

@end
