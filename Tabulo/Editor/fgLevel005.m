//
//  fgLevel005.m
//  Tabulo
//
//  Created by Serge Menard on 2014-06-26.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevel005.h"

@implementation fgLevel005

- (void)buildSceneForLevel:(fgTabuloDirector *)_director withStrategy:(fgLevelStrategy *)_strategy {

    [scene addPointFrom:0 Radius:1.75f Angle:180.f];
    [scene addPointFrom:1 Radius:1.75f Angle:180.f]; // 2
    [scene addPointFrom:2 Radius:1.75f Angle:225.f];
    [scene addPointFrom:3 Radius:1.75f Angle:225.f]; // 4
    [scene addPointFrom:2 Radius:1.75f Angle:135.f];
    [scene addPointFrom:5 Radius:1.75f Angle:135.f]; // 6
    [scene computePoints];
    
    f3GraphNode *node0 = [_strategy buildNode:[scene getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_strategy buildNode:[scene getPointAt:1] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_strategy buildNode:[scene getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_strategy buildNode:[scene getPointAt:3] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node4 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:4] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_strategy buildNode:[scene getPointAt:5] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node6 = [(fgLevelStrategy *)_strategy buildHouseNode:[scene getPointAt:6] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    [_strategy buildGraphState];

    [scene clearPoints];
    
    [scene buildPillar:_director node:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node4 type:TABULO_PawnOne state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node6 type:TABULO_PawnFour state:_strategy writer:dataWriter symbols:dataSymbols];
    [scene buildBackground:_director writer:dataWriter symbols:dataSymbols];
    
    [scene buildComposite:_director atLayer:BackgroundLayer writer:dataWriter symbols:dataSymbols]; // gameplay background
    
    f3ViewAdaptee *pawnOne = [scene buildPawn:_director state:_strategy node:node6 type:TABULO_PawnOne writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node6 view:pawnOne writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *pawnTwo = [scene buildPawn:_director state:_strategy node:node4 type:TABULO_PawnFour writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director strategy:_strategy node:node4 view:pawnTwo writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plankOne = [scene buildSmallPlank:_director state:_strategy node:node1 angle:0.f hole:TABULO_HOLE_MAX writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node1 view:plankOne writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plankTwo = [scene buildSmallPlank:_director state:_strategy node:node5 angle:135.f hole:TABULO_HOLE_MAX writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director strategy:_strategy node:node5 view:plankTwo writer:dataWriter symbols:dataSymbols];

    [scene buildComposite:_director atLayer:GameplayLayer writer:dataWriter symbols:dataSymbols]; // gameplay elements
    
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node1 origin:node0 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node1 origin:node2 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node3 origin:node2 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node3 origin:node4 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node5 origin:node2 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node5 origin:node6 target:node2 writer:dataWriter symbols:dataSymbols];

    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node2 origin:node1 target:node3 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node2 origin:node3 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node2 origin:node1 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node2 origin:node5 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node2 origin:node3 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node2 origin:node5 target:node3 writer:dataWriter symbols:dataSymbols];
    
    [super buildSceneForLevel:_director withStrategy:_strategy];
}

@end
