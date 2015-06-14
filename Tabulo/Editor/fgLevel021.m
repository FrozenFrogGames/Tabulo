//
//  fgLevel020.m
//  Tabulo
//
//  Created by Serge Menard on 2014-07-05.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevel021.h"

@implementation fgLevel021

- (void)buildSceneForLevel:(fgTabuloDirector *)_director withStrategy:(fgLevelStrategy *)_strategy {

    [scene addPointFrom:0 Radius:2.5f Angle:45.f];
    [scene addPointFrom:0 Radius:2.5f Angle:135.f]; // 2
    [scene addPointFrom:1 Radius:2.5f Angle:45.f];
    [scene addPointFrom:2 Radius:2.5f Angle:135.f]; // 4
    [scene addPointFrom:3 Radius:2.5f Angle:135.f];
    [scene addPointFrom:4 Radius:2.5f Angle:45.f]; // 6
    [scene addPointFrom:5 Radius:2.5f Angle:135.f];
    [scene addPointFrom:7 Radius:2.5f Angle:90.f]; // 8
    [scene addPointFrom:8 Radius:2.5f Angle:90.f];
    [scene computePoints];

    fgHouseNode *node0 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_strategy buildNode:[scene getPointAt:1] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_strategy buildNode:[scene getPointAt:2] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_strategy buildNode:[scene getPointAt:3] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_strategy buildNode:[scene getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_strategy buildNode:[scene getPointAt:5] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_strategy buildNode:[scene getPointAt:6] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_strategy buildNode:[scene getPointAt:7] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_strategy buildNode:[scene getPointAt:8] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node9 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:9] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    [_strategy buildGraphState];
    
    [scene clearPoints];

    [scene buildHouse:_director node:node0 type:TABULO_PawnOne state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node9 type:TABULO_PawnFour state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildBackground:_director writer:dataWriter symbols:dataSymbols];

    [scene buildComposite:_director atLayer:BackgroundLayer writer:dataWriter symbols:dataSymbols]; // gameplay background
    
    f3ViewAdaptee *pawnOne = [scene buildPawn:_director state:_strategy node:node0 type:TABULO_PawnFour writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node0 view:pawnOne writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *pawnTwo = [scene buildPawn:_director state:_strategy node:node9 type:TABULO_PawnOne writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node9 view:pawnTwo writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankOne = [scene buildMediumPlank:_director state:_strategy node:node1 angle:45.f hole:TABULO_OneHole_One writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node1 view:plankOne writer:dataWriter symbols:dataSymbols];

    f3ViewAdaptee *plankTwo = [scene buildMediumPlank:_director state:_strategy node:node6 angle:45.f hole:TABULO_OneHole_Four writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node6 view:plankTwo writer:dataWriter symbols:dataSymbols];

    [scene buildComposite:_director atLayer:GameplayLayer writer:dataWriter symbols:dataSymbols]; // gameplay elements

    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node0 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node3 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node2 origin:node0 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node2 origin:node4 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node5 origin:node3 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node5 origin:node7 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node6 origin:node4 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node6 origin:node7 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node8 origin:node7 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node8 origin:node9 target:node7 writer:dataWriter symbols:dataSymbols];

    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node0 origin:node1 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node0 origin:node2 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node3 origin:node1 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node3 origin:node5 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node2 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node4 origin:node6 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node7 origin:node5 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node7 origin:node6 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node7 origin:node5 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node7 origin:node8 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node7 origin:node6 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node7 origin:node8 target:node6 writer:dataWriter symbols:dataSymbols];

    [super buildSceneForLevel:_director withStrategy:_strategy];
}

@end
