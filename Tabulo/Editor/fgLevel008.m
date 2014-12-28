//
//  fgLevel008.m
//  Tabulo
//
//  Created by Serge Menard on 2014-06-27.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevel008.h"

@implementation fgLevel008

- (void)loadScene:(fgTabuloDirector *)_director state:(fgLevelState *)_state {

    [scene addPointFrom:0 Radius:2.5f Angle:90.f];
    [scene addPointFrom:1 Radius:2.5f Angle:90.f]; // 2
    [scene addPointFrom:2 Radius:1.75f Angle:180.f];
    [scene addPointFrom:2 Radius:2.5f Angle:135.f]; // 4
    [scene addPointFrom:3 Radius:1.75f Angle:180.f];
    [scene addPointFrom:4 Radius:2.5f Angle:135.f]; // 6
    [scene addPointFrom:5 Radius:1.75f Angle:90.f];
    [scene computePoints];
    
    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[scene getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[scene getPointAt:1] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[scene getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_state buildNode:[scene getPointAt:3] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_state buildNode:[scene getPointAt:4] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_state buildNode:[scene getPointAt:5] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node6 = [(fgLevelState *)_state buildHouseNode:[scene getPointAt:6] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[scene getPointAt:7] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    [_state buildGraphState];
    
    [scene clearPoints];
    
    [scene buildHouse:_director node:node0 type:TABULO_PawnFour state:_state writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildPillar:_director node:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node6 type:TABULO_PawnOne state:_state writer:dataWriter symbols:dataSymbols];
    [scene buildBackground:_director writer:dataWriter symbols:dataSymbols];
    
    [scene buildComposite:_director writer:dataWriter symbols:dataSymbols]; // gameplay background
    
    f3ViewAdaptee *pawnOne = [scene buildPawn:_director state:_state node:node0 type:TABULO_PawnOne writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director state:_state node:node0 view:pawnOne writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *pawnTwo = [scene buildPawn:_director state:_state node:node6 type:TABULO_PawnFour writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director state:_state node:node6 view:pawnTwo writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plankOne = [scene buildSmallPlank:_director state:_state node:node7 angle:90.f hole:TABULO_HOLE_MAX writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director state:_state node:node7 view:plankOne writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plankTwo = [scene buildMediumPlank:_director state:_state node:node1 angle:270.f hole:TABULO_HOLE_MAX writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director state:_state node:node1 view:plankTwo writer:dataWriter symbols:dataSymbols];
    
    [scene buildComposite:_director writer:dataWriter symbols:dataSymbols]; // gameplay elements
    
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node0 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node2 target:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node4 origin:node2 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node4 origin:node6 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node3 origin:node2 target:node5 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node3 origin:node5 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node7 origin:node5 target:node6 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveSmallPlank node:node7 origin:node6 target:node5 writer:dataWriter symbols:dataSymbols];
    
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node2 origin:node1 target:node4 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveMediumPlank node:node2 origin:node4 target:node1 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node5 origin:node3 target:node7 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPlank:_director type:TABULO_HaveSmallPlank node:node5 origin:node7 target:node3 writer:dataWriter symbols:dataSymbols];
    
    [super loadScene:_director state:_state];
}

@end
