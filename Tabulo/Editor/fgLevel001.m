//
//  fgDATA0001.m
//  Tabulo
//
//  Created by Serge Menard on 2014-06-23.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevel001.h"

@implementation fgLevel001

- (void)buildScene:(fgTabuloDirector *)_director state:(fgLevelState *)_state {
    
    [scene addPointFrom:0 Radius:2.5f Angle:90.f];
    [scene addPointFrom:1 Radius:2.5f Angle:90.f]; // 2
    [scene computePoints];
    
    f3GraphNode *node0 = [_state buildNode:[scene getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[scene getPointAt:1] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node2 = [_state buildHouseNode:[scene getPointAt:2] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    [_state buildConfig:dataWriter];

    [scene clearPoints];

    [scene buildPillar:_director node:node0 writer:dataWriter symbols:dataSymbols];
    [scene buildHouse:_director node:node2 type:TABULO_PawnFour state:_state writer:dataWriter symbols:dataSymbols];
    [scene buildBackground:_director writer:dataWriter symbols:dataSymbols];
    
    [scene buildComposite:_director writer:dataWriter symbols:dataSymbols]; // gameplay background
    
    f3ViewAdaptee *pawn = [scene buildPawn:_director state:_state node:node0 type:TABULO_PawnFour writer:dataWriter symbols:dataSymbols];
    [scene buildDragPawnControl:_director state:_state node:node0 view:pawn writer:dataWriter symbols:dataSymbols];
    
    f3ViewAdaptee *plank = [scene buildMediumPlank:_director state:_state node:node1 angle:270.f hole:TABULO_HOLE_MAX writer:dataWriter symbols:dataSymbols];
    [scene buildDragPlankControl:_director state:_state node:node1 view:plank writer:dataWriter symbols:dataSymbols];
    
    [scene buildComposite:_director writer:dataWriter symbols:dataSymbols]; // gameplay elements
    
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node0 target:node2 writer:dataWriter symbols:dataSymbols];
    [scene buildEdgesForPawn:_director type:TABULO_HaveMediumPlank node:node1 origin:node2 target:node0 writer:dataWriter symbols:dataSymbols];

    [super buildScene:_director state:_state];
}

@end
