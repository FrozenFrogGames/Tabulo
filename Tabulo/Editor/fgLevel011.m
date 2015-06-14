//
//  fgLevel011.m
//  Tabulo
//
//  Created by Serge Menard on 2014-06-27.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevel011.h"

@implementation fgLevel011

- (void)buildSceneForLevel:(fgTabuloDirector *)_director withStrategy:(fgLevelStrategy *)_strategy {
    
    [scene addPointFrom:0 Radius:1.75f Angle:180.f];
    [scene addPointFrom:1 Radius:1.75f Angle:180.f]; // 2
    [scene addPointFrom:2 Radius:1.75f Angle:225.f];
    [scene addPointFrom:2 Radius:2.5f Angle:270.f]; // 4
    [scene addPointFrom:3 Radius:1.75f Angle:225.f];
    [scene addPointFrom:4 Radius:2.5f Angle:270.f]; // 6
    [scene addPointFrom:5 Radius:1.75f Angle:315.f];
    [scene addPointFrom:6 Radius:2.5f Angle:270.f]; // 8
    [scene addPointFrom:6 Radius:1.75f Angle:315.f];
    [scene addPointFrom:8 Radius:2.5f Angle:270.f]; // 10
    [scene addPointFrom:9 Radius:1.75f Angle:315.f];
    [scene addPointFrom:11 Radius:1.75f Angle:225.f]; // 12
    [scene computePoints];
    
    fgHouseNode *node0 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_strategy buildNode:[scene getPointAt:1] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_strategy buildNode:[scene getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_strategy buildNode:[scene getPointAt:3] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_strategy buildNode:[scene getPointAt:4] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_strategy buildNode:[scene getPointAt:5] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_strategy buildNode:[scene getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_strategy buildNode:[scene getPointAt:7] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_strategy buildNode:[scene getPointAt:8] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_strategy buildNode:[scene getPointAt:9] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node10 = [_strategy buildNode:[scene getPointAt:10] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node11 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:11] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node12 = [_strategy buildNode:[scene getPointAt:12] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    [_strategy buildGraphState];
    
    [scene clearPoints];
    
    [scene buildHouse:_director node:node0 type:TABULO_PawnFour state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node11 type:TABULO_PawnOne state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildBackground:_director writer:dataWriter symbols:dataSymbols];
    
    [scene buildComposite:_director atLayer:BackgroundLayer writer:dataWriter symbols:dataSymbols]; // gameplay background
    
    f3ViewAdaptee *pawnOne = [scene buildPawn:_director state:_strategy node:node11 type:TABULO_PawnFour writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node11 view:pawnOne writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *pawnTwo = [scene buildPawn:_director state:_strategy node:node0 type:TABULO_PawnOne writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node0 view:pawnTwo writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plankOne = [scene buildSmallPlank:_director state:_strategy node:node1 angle:0.f hole:TABULO_HOLE_MAX writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node1 view:plankOne writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plankTwo = [scene buildSmallPlank:_director state:_strategy node:node7 angle:135.f hole:TABULO_HOLE_MAX writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node7 view:plankTwo writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plankThree = [scene buildMediumPlank:_director state:_strategy node:node8 angle:90.f hole:TABULO_HOLE_MAX writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node8 view:plankThree writer:dataWriter symbols:dataSymbols];
    
    [scene buildComposite:_director atLayer:GameplayLayer writer:dataWriter symbols:dataSymbols]; // gameplay elements
    
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node1 origin:node0 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node1 origin:node2 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node3 origin:node2 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node3 origin:node5 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node7 origin:node5 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node7 origin:node6 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node9 origin:node6 target:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node9 origin:node11 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node12 origin:node10 target:node11 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node12 origin:node11 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node4 origin:node2 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node4 origin:node6 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node8 origin:node6 target:node10 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node8 origin:node10 target:node6 writer:dataWriter symbols:dataSymbols];
    
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node2 origin:node1 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node2 origin:node3 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node5 origin:node3 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node5 origin:node7 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node6 origin:node7 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node6 origin:node9 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node11 origin:node9 target:node12 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node11 origin:node12 target:node9 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node6 origin:node4 target:node8 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node6 origin:node8 target:node4 writer:dataWriter symbols:dataSymbols];
    
    [super buildSceneForLevel:_director withStrategy:_strategy];
}

@end
