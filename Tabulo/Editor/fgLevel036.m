//
//  fgLevel033.m
//  Tabulo
//
//  Created by Serge Menard on 2014-09-28.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevel036.h"

@implementation fgLevel036

- (void)buildSceneForLevel:(fgTabuloDirector *)_director withStrategy:(fgLevelStrategy *)_strategy {
    
    [scene addPointFrom:0 Radius:1.75f Angle:99.f];
    [scene addPointFrom:0 Radius:1.75f Angle:189.f]; // 2
    [scene addPointFrom:1 Radius:1.75f Angle:99.f];
    [scene addPointFrom:2 Radius:1.75f Angle:189.f]; // 4
    [scene addPointFrom:3 Radius:1.75f Angle:81.f];
    [scene addPointFrom:3 Radius:2.5f Angle:126.f]; // 6
    [scene addPointFrom:3 Radius:2.5f Angle:234.f];
    [scene addPointFrom:4 Radius:2.5f Angle:162.f]; // 8
    [scene addPointFrom:5 Radius:1.75f Angle:81.f];
    [scene addPointFrom:6 Radius:2.5f Angle:126.f]; // 10
    [scene addPointFrom:8 Radius:2.5f Angle:162.f];
    [scene addPointFrom:9 Radius:1.75f Angle:171.f]; // 12
    [scene addPointFrom:10 Radius:2.5f Angle:198.f];
    [scene addPointFrom:11 Radius:2.5f Angle:90.f]; // 14
    [scene addPointFrom:13 Radius:2.5f Angle:198.f];
    [scene computePoints];

    f3GraphNode *node0 = [_strategy buildNode:[scene getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_strategy buildNode:[scene getPointAt:1] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_strategy buildNode:[scene getPointAt:2] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node3 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:3] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_strategy buildNode:[scene getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_strategy buildNode:[scene getPointAt:5] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_strategy buildNode:[scene getPointAt:6] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_strategy buildNode:[scene getPointAt:7] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_strategy buildNode:[scene getPointAt:8] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_strategy buildNode:[scene getPointAt:9] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node10 = [_strategy buildNode:[scene getPointAt:10] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node11 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:11] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node12 = [_strategy buildNode:[scene getPointAt:12] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node13 = [_strategy buildNode:[scene getPointAt:13] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node14 = [_strategy buildNode:[scene getPointAt:14] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node15 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:15] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];

    [_strategy initGraphStrategy:dataWriter symbols:dataSymbols];

    [scene buildHouse:_director node:node11 type:TABULO_PawnOne state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node3 type:TABULO_PawnFour state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node15 type:TABULO_PawnTwo state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildBackground:_director writer:dataWriter symbols:dataSymbols]; // gameplay background

    f3ViewAdaptee *pawnOne = [scene buildPawn:_director state:_strategy node:node3 type:TABULO_PawnOne writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node3 view:pawnOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *pawnTwo = [scene buildPawn:_director state:_strategy node:node11 type:TABULO_PawnTwo writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node11 view:pawnTwo writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *pawnThree = [scene buildPawn:_director state:_strategy node:node15 type:TABULO_PawnFour writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node15 view:pawnThree writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plankTwo = [scene buildSmallPlank:_director state:_strategy node:node5 angle:81.f hole:TABULO_OneHole_Two writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node5 view:plankTwo writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankThree = [scene buildMediumPlank:_director state:_strategy node:node8 angle:162.f hole:TABULO_OneHole_One writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node8 view:plankThree writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankFour = [scene buildMediumPlank:_director state:_strategy node:node13 angle:198.f hole:TABULO_OneHole_Four writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node13 view:plankFour writer:dataWriter symbols:dataSymbols];

    [scene buildLayer:_director atIndex:GameplayLayer writer:dataWriter symbols:dataSymbols]; // gameplay elements

    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node1 origin:node0 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node1 origin:node3 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node2 origin:node0 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node2 origin:node4 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node5 origin:node9 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node5 origin:node3 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node12 origin:node9 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node12 origin:node10 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node6 origin:node10 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node6 origin:node3 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node7 origin:node4 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node7 origin:node3 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node8 origin:node11 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node8 origin:node4 target:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node13 origin:node10 target:node15 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node13 origin:node15 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node14 origin:node11 target:node15 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node14 origin:node15 target:node11 writer:dataWriter symbols:dataSymbols];

    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node0 origin:node1 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node0 origin:node2 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node3 origin:node1 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node3 origin:node5 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node9 origin:node12 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node9 origin:node5 target:node12 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node3 origin:node6 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node3 origin:node7 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node8 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node7 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node10 origin:node6 target:node13 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node10 origin:node13 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node11 origin:node8 target:node14 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node11 origin:node14 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node15 origin:node14 target:node13 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node15 origin:node13 target:node14 writer:dataWriter symbols:dataSymbols];

    [super buildSceneForLevel:_director withStrategy:_strategy];
}

@end
