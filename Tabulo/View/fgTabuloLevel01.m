//
//  fgTabuloEasy.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-27.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloLevel01.h"
#import "fgDialogState.h"
#import "../../../Framework/Framework/Control/f3DragViewFromNode.h"
#import "fgDragViewOverEdge.h"
#import "../Control/fgLevelState.h"

@implementation fgTabuloLevel01

- (void)build:(f3ViewBuilder *)_builder state:(f3GameState *)_state level:(NSUInteger)_level {
    
    switch (_level)
    {
        case 7:
            [self loadLevelOne:_builder state:_state];
            break;
            
        case 8:
            [self loadLevelTwo:_builder state:_state];
            break;
            
        case 9:
            [self loadLevelThree:_builder state:_state];
            break;
            
        case 10:
            [self loadLevelFour:_builder state:_state];
            break;
            
        case 11:
            [self loadLevelFive:_builder state:_state];
            break;
            
        case 12:
            [self loadLevelSix:_builder state:_state];
            break;

        case 13:
            [self loadLevelSeven:_builder state:_state];
            break;

        case 14:
            [self loadLevelEight:_builder state:_state];
            break;
            
        case 15:
            [self loadLevelNine:_builder state:_state];
            break;

        case 16:
            [self loadLevelTen:_builder state:_state];
            break;
            
        case 17:
            [self loadLevelEleven:_builder state:_state];
            break;
            
        case 18:
            [self loadLevelTwelve:_builder state:_state];
            break;
    }

    [super build:_builder state:_state level:_level]; // compute solution
}

- (void)loadLevelOne:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:2.5f Angle:90.f];
    [self addPointFrom:1 Radius:2.5f Angle:90.f]; // 2
    [self addPointFrom:2 Radius:1.75f Angle:180.f];
    [self addPointFrom:2 Radius:2.5f Angle:135.f]; // 4
    [self addPointFrom:3 Radius:1.75f Angle:180.f];
    [self addPointFrom:4 Radius:2.5f Angle:135.f]; // 6
    [self addPointFrom:5 Radius:1.75f Angle:90.f];
    [self computePoints];
    
    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node6 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:6] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    [self clearPoints];

    [self buildHouse:node0 type:TABULO_PawnFour state:_state];
    [self buildPillar:node2];
    [self buildPillar:node5];
    [self buildHouse:node6 type:TABULO_PawnOne state:_state];
    [self buildBackground];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawnOne = [self buildPawn:node0 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];

    f3ViewAdaptee *pawnTwo = [self buildPawn:node6 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node6 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];

    f3ViewAdaptee *plankOne = [self buildSmallPlank:node7 angle:90.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node7 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];

    f3ViewAdaptee *plankTwo = [self buildMediumPlank:node1 angle:270.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node1 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node4 Origin:node2 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node4 Origin:node6 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node2 Target:node5];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node5 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node5 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node6 Target:node5];

    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node1 Target:node4];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node4 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node3 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node7 Target:node3];
}

- (void)loadLevelTwo:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:1.75f Angle:90.f];
    [self addPointFrom:1 Radius:1.75f Angle:90.f]; // 2
    [self addPointFrom:2 Radius:1.75f Angle:180.f];
    [self addPointFrom:3 Radius:1.75f Angle:180.f]; // 4
    [self addPointFrom:4 Radius:1.75f Angle:270.f];
    [self addPointFrom:5 Radius:1.75f Angle:270.f]; // 6
    [self addPointFrom:6 Radius:1.75f Angle:0.f];
    [self computePoints];
    
    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node4 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:4] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    [self clearPoints];
    
    [self buildHouse:node0 type:TABULO_PawnFour state:_state];
    [self buildPillar:node2];
    [self buildHouse:node4 type:TABULO_PawnOne state:_state];
    [self buildPillar:node6];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawnOne = [self buildPawn:node4 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node4 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];
    
    f3ViewAdaptee *pawnTwo = [self buildPawn:node0 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];

    f3ViewAdaptee *plankOne = [self buildSmallPlank:node3 angle:180.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node3 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
    
    f3ViewAdaptee *plankTwo = [self buildSmallPlank:node5 angle:270.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node5 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node0 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node6 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node2 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node4 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node4 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node6 Target:node4];

    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node0 Origin:node1 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node0 Origin:node7 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node1 Target:node3];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node3 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node4 Origin:node3 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node4 Origin:node5 Target:node3];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node5 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node7 Target:node5];
}

- (void)loadLevelThree:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:1.75f Angle:180.f];
    [self addPointFrom:0 Radius:2.5f Angle:135.f]; // 2
    [self addPointFrom:1 Radius:1.75f Angle:180.f];
    [self addPointFrom:2 Radius:2.5f Angle:135.f]; // 4
    [self addPointFrom:3 Radius:1.75f Angle:90.f];
    [self addPointFrom:4 Radius:2.5f Angle:90.f]; // 6
    [self addPointFrom:4 Radius:1.75f Angle:135.f];
    [self addPointFrom:6 Radius:2.5f Angle:90.f]; // 8
    [self addPointFrom:7 Radius:1.75f Angle:135.f];
    [self addPointFrom:8 Radius:2.5f Angle:0.f]; // 10
    [self addPointFrom:9 Radius:1.75f Angle:45.f];
    [self addPointFrom:10 Radius:2.5f Angle:0.f]; // 12
    [self computePoints];
    
    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node4 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:4] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_state buildNode:[self getPointAt:8] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_state buildNode:[self getPointAt:9] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node10 = [_state buildNode:[self getPointAt:10] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node11 = [_state buildNode:[self getPointAt:11] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node12 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:12] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    [self clearPoints];
    
    [self buildHouse:node0 type:TABULO_PawnOne state:_state];
    [self buildPillar:node3];
    [self buildHouse:node4 type:TABULO_PawnTwo state:_state];
    [self buildPillar:node8];
    [self buildPillar:node9];
    [self buildHouse:node12 type:TABULO_PawnFour state:_state];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background
    
    f3ViewAdaptee *pawnOne = [self buildPawn:node0 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];
    
    f3ViewAdaptee *pawnTwo = [self buildPawn:node4 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node4 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];
    
    f3ViewAdaptee *pawnThree = [self buildPawn:node12 type:TABULO_PawnTwo];
    f3DragViewFromNode *controlPawnThree = [[f3DragViewFromNode alloc] initWithNode:node12 forView:pawnThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnThree]];
    
    f3ViewAdaptee *plankOne = [self buildSmallPlank:node5 angle:90.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node5 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
    
    f3ViewAdaptee *plankTwo = [self buildSmallPlank:node7 angle:135.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node7 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
    
    f3ViewAdaptee *plankThree = [self buildMediumPlank:node6 angle:90.f hole:0];
    f3DragViewFromNode *controlPlankThree = [[f3DragViewFromNode alloc] initWithNode:node6 forView:plankThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankThree]];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements
    
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node0 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node3 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node3 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node4 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node4 Target:node9];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node9 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node11 Origin:node8 Target:node9];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node11 Origin:node9 Target:node8];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node2 Origin:node0 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node2 Origin:node4 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node6 Origin:node4 Target:node8];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node6 Origin:node8 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node10 Origin:node8 Target:node12];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node10 Origin:node12 Target:node8];
    
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node3 Origin:node1 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node3 Origin:node5 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node4 Origin:node5 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node4 Origin:node7 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node9 Origin:node7 Target:node11];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node9 Origin:node11 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node2 Target:node6];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node6 Target:node2];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node8 Origin:node6 Target:node10];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node8 Origin:node10 Target:node6];
}

- (void)loadLevelFour:(f3ViewBuilder *)_builder state:(f3GameState *)_state {
    
    [self addPointFrom:0 Radius:1.75f Angle:180.f];
    [self addPointFrom:1 Radius:1.75f Angle:180.f]; // 2
    [self addPointFrom:2 Radius:2.5f Angle:135.f];
    [self addPointFrom:2 Radius:1.75f Angle:180.f]; // 4
    [self addPointFrom:3 Radius:2.5f Angle:135.f];
    [self addPointFrom:4 Radius:1.75f Angle:180.f]; // 6
    [self addPointFrom:5 Radius:2.5f Angle:90.f];
    [self addPointFrom:6 Radius:1.75f Angle:90.f]; // 8
    [self addPointFrom:7 Radius:2.5f Angle:90.f];
    [self addPointFrom:9 Radius:2.5f Angle:0.f]; // 10
    [self addPointFrom:10 Radius:2.5f Angle:0.f];
    [self addPointFrom:11 Radius:1.75f Angle:0.f]; // 12
    [self addPointFrom:11 Radius:2.5f Angle:315.f];
    [self addPointFrom:12 Radius:1.75f Angle:0.f]; // 14
    [self addPointFrom:13 Radius:2.5f Angle:315.f];
    [self addPointFrom:14 Radius:1.75f Angle:270.f]; // 16
    [self computePoints];
    
    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node5 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:5] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_state buildNode:[self getPointAt:8] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_state buildNode:[self getPointAt:9] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node10 = [_state buildNode:[self getPointAt:10] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node11 = [_state buildNode:[self getPointAt:11] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node12 = [_state buildNode:[self getPointAt:12] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node13 = [_state buildNode:[self getPointAt:13] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node14 = [_state buildNode:[self getPointAt:14] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node15 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:15] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node16 = [_state buildNode:[self getPointAt:16] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    [self clearPoints];
    
    [self buildHouse:node0 type:TABULO_PawnTwo state:_state];
    [self buildPillar:node2];
    [self buildPillar:node6];
    [self buildHouse:node5 type:TABULO_PawnFour state:_state];
    [self buildPillar:node9];
    [self buildPillar:node11];
    [self buildPillar:node14];
    [self buildHouse:node15 type:TABULO_PawnOne state:_state];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background
    
    f3ViewAdaptee *pawnOne = [self buildPawn:node0 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];
    
    f3ViewAdaptee *pawnTwo = [self buildPawn:node5 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node5 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];
    
    f3ViewAdaptee *pawnThree = [self buildPawn:node15 type:TABULO_PawnTwo];
    f3DragViewFromNode *controlPawnThree = [[f3DragViewFromNode alloc] initWithNode:node15 forView:pawnThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnThree]];
    
    f3ViewAdaptee *plankOne = [self buildSmallPlank:node4 angle:0.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node4 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
    
    f3ViewAdaptee *plankTwo = [self buildSmallPlank:node8 angle:90.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node8 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
    
    f3ViewAdaptee *plankThree = [self buildMediumPlank:node7 angle:90.f hole:0];
    f3DragViewFromNode *controlPlankThree = [[f3DragViewFromNode alloc] initWithNode:node7 forView:plankThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankThree]];
    
    f3ViewAdaptee *plankFour = [self buildSmallPlank:node12 angle:0.f hole:0];
    f3DragViewFromNode *controlPlankFour = [[f3DragViewFromNode alloc] initWithNode:node12 forView:plankFour nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankFour]];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements
    
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node4 Origin:node2 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node4 Origin:node6 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node8 Origin:node6 Target:node5];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node8 Origin:node5 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node12 Origin:node11 Target:node14];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node12 Origin:node14 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node16 Origin:node14 Target:node15];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node16 Origin:node15 Target:node14];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node2 Target:node5];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node5 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node7 Origin:node5 Target:node9];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node7 Origin:node9 Target:node5];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node10 Origin:node9 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node10 Origin:node11 Target:node9];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node13 Origin:node11 Target:node15];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node13 Origin:node15 Target:node11];
    
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node1 Target:node4];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node4 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node4 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node8 Target:node4];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node14 Origin:node12 Target:node16];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node14 Origin:node16 Target:node12];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node5 Origin:node3 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node5 Origin:node7 Target:node3];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node9 Origin:node7 Target:node10];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node9 Origin:node10 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node11 Origin:node10 Target:node13];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node11 Origin:node13 Target:node10];
}

- (void)loadLevelFive:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:1.75f Angle:0.f];
    [self addPointFrom:1 Radius:1.75f Angle:0.f]; // 2
    [self addPointFrom:2 Radius:1.75f Angle:45.f];
    [self addPointFrom:2 Radius:2.5f Angle:90.f]; // 4
    [self addPointFrom:3 Radius:1.75f Angle:45.f];
    [self addPointFrom:4 Radius:2.5f Angle:90.f]; // 6
    [self addPointFrom:5 Radius:1.75f Angle:135.f];
    [self addPointFrom:6 Radius:2.5f Angle:90.f]; // 8
    [self addPointFrom:6 Radius:1.75f Angle:135.f];
    [self addPointFrom:8 Radius:2.5f Angle:90.f]; // 10
    [self addPointFrom:9 Radius:1.75f Angle:135.f];
    [self addPointFrom:11 Radius:1.75f Angle:45.f]; // 12
    [self computePoints];
    
    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_state buildNode:[self getPointAt:8] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_state buildNode:[self getPointAt:9] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node10 = [_state buildNode:[self getPointAt:10] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node11 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:11] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node12 = [_state buildNode:[self getPointAt:12] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    [self clearPoints];
    
    [self buildHouse:node0 type:TABULO_PawnFour state:_state];
    [self buildPillar:node2];
    [self buildPillar:node5];
    [self buildPillar:node6];
    [self buildPillar:node10];
    [self buildHouse:node11 type:TABULO_PawnOne state:_state];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawnOne = [self buildPawn:node11 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node11 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];
    
    f3ViewAdaptee *pawnTwo = [self buildPawn:node0 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];
    
    f3ViewAdaptee *plankOne = [self buildSmallPlank:node1 angle:0.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node1 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
    
    f3ViewAdaptee *plankTwo = [self buildSmallPlank:node7 angle:135.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node7 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
    
    f3ViewAdaptee *plankThree = [self buildMediumPlank:node8 angle:90.f hole:0];
    f3DragViewFromNode *controlPlankThree = [[f3DragViewFromNode alloc] initWithNode:node8 forView:plankThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankThree]];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements
    
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node2 Target:node5];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node5 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node5 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node6 Target:node5];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node6 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node11 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node12 Origin:node10 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node12 Origin:node11 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node4 Origin:node2 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node4 Origin:node6 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node8 Origin:node6 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node8 Origin:node10 Target:node6];
    
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node1 Target:node3];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node3 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node3 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node7 Target:node3];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node7 Target:node9];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node9 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node11 Origin:node9 Target:node12];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node11 Origin:node12 Target:node9];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node6 Origin:node4 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node6 Origin:node8 Target:node4];
}

- (void)loadLevelSix:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:2.5f Angle:70.f];
    [self addPointFrom:1 Radius:2.5f Angle:70.f]; // 2
    [self addPointFrom:2 Radius:1.75f Angle:90.f];
    [self addPointFrom:2 Radius:2.5f Angle:135.f]; // 4
    [self addPointFrom:3 Radius:1.75f Angle:90.f];
    [self addPointFrom:4 Radius:2.5f Angle:135.f]; // 6
    [self addPointFrom:5 Radius:1.75f Angle:180.f];
    [self addPointFrom:6 Radius:1.75f Angle:120.f]; // 8
    [self addPointFrom:6 Radius:1.75f Angle:240.f];
    [self addPointFrom:8 Radius:1.75f Angle:120.f]; // 10
    [self addPointFrom:9 Radius:1.75f Angle:240.f];
    [self addPointFrom:11 Radius:1.75f Angle:180.f]; // 12
    [self addPointFrom:12 Radius:1.75f Angle:180.f];
    [self computePoints];

    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node5 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:5] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_state buildNode:[self getPointAt:8] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_state buildNode:[self getPointAt:9] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node10 = [_state buildNode:[self getPointAt:10] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node11 = [_state buildNode:[self getPointAt:11] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node12 = [_state buildNode:[self getPointAt:12] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node13 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:13] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    [self clearPoints];

    [self buildHouse:node0 type:TABULO_PawnOne state:_state];
    [self buildPillar:node2];
    [self buildHouse:node5 type:TABULO_PawnTwo state:_state];
    [self buildPillar:node6];
    [self buildPillar:node10];
    [self buildPillar:node11];
    [self buildHouse:node13 type:TABULO_PawnFour state:_state];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawnOne = [self buildPawn:node0 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];
    
    f3ViewAdaptee *pawnTwo = [self buildPawn:node5 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node5 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];
    
    f3ViewAdaptee *pawnThree = [self buildPawn:node13 type:TABULO_PawnTwo];
    f3DragViewFromNode *controlPawnThree = [[f3DragViewFromNode alloc] initWithNode:node13 forView:pawnThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnThree]];
    
    f3ViewAdaptee *plankOne = [self buildSmallPlank:node12 angle:0.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node12 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];

    f3ViewAdaptee *plankTwo = [self buildSmallPlank:node8 angle:120.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node8 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
 
    f3ViewAdaptee *plankThree = [self buildMediumPlank:node4 angle:135.f hole:0];
    f3DragViewFromNode *controlPlankThree = [[f3DragViewFromNode alloc] initWithNode:node4 forView:plankThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankThree]];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node2 Target:node5];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node5 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node5 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node6 Target:node5];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node8 Origin:node6 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node8 Origin:node10 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node6 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node11 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node12 Origin:node11 Target:node13];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node12 Origin:node13 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node4 Origin:node6 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node4 Origin:node2 Target:node6];

    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node3 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node7 Target:node3];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node7 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node8 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node7 Target:node9];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node9 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node8 Target:node9];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node9 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node11 Origin:node9 Target:node12];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node11 Origin:node12 Target:node9];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node1 Target:node4];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node4 Target:node1];
}

- (void)loadLevelSeven:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:2.5f Angle:90.f];
    [self addPointFrom:1 Radius:2.5f Angle:90.f]; // 2
    [self addPointFrom:2 Radius:2.5f Angle:45.f];
    [self addPointFrom:2 Radius:1.75f Angle:90.f]; // 4
    [self addPointFrom:2 Radius:2.5f Angle:180.f];
    [self addPointFrom:3 Radius:2.5f Angle:45.f]; // 6
    [self addPointFrom:4 Radius:1.75f Angle:90.f];
    [self addPointFrom:5 Radius:2.5f Angle:180.f]; // 8
    [self addPointFrom:6 Radius:1.75f Angle:180.f];
    [self computePoints];
    
    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node7 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:7] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_state buildNode:[self getPointAt:8] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_state buildNode:[self getPointAt:9] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    [self clearPoints];
    
    [self buildHouse:node0 type:TABULO_PawnOne state:_state];
    [self buildPillar:node2];
    [self buildPillar:node6];
    [self buildHouse:node7 type:TABULO_PawnTwo state:_state];
    [self buildPillar:node8];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background
    
    f3ViewAdaptee *pawnOne = [self buildPawn:node8 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node8 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];
    
    f3ViewAdaptee *pawnTwo = [self buildPawn:node0 type:TABULO_PawnTwo];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];
    
    f3ViewAdaptee *plankOne = [self buildSmallPlank:node9 angle:180.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node9 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
    
    f3ViewAdaptee *plankTwo = [self buildSmallPlank:node4 angle:90.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node4 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];

    f3ViewAdaptee *plankThree = [self buildMediumPlank:node5 angle:180.f hole:0];
    f3DragViewFromNode *controlPlankThree = [[f3DragViewFromNode alloc] initWithNode:node5 forView:plankThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankThree]];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node4 Origin:node7 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node4 Origin:node2 Target:node7];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node7 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node6 Target:node7];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node6 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node2 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node5 Origin:node8 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node5 Origin:node2 Target:node8];

    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node7 Origin:node4 Target:node9];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node7 Origin:node9 Target:node4];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node1 Target:node3];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node3 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node3 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node5 Target:node3];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node1 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node5 Target:node1];
}

- (void)loadLevelEight:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:1.75f Angle:90.f];
    [self addPointFrom:1 Radius:1.75f Angle:90.f]; // 2
    [self addPointFrom:2 Radius:2.5f Angle:135.f];
    [self addPointFrom:2 Radius:1.75f Angle:180.f]; // 4
    [self addPointFrom:3 Radius:2.5f Angle:135.f];
    [self addPointFrom:4 Radius:1.75f Angle:180.f]; // 6
    [self addPointFrom:5 Radius:1.75f Angle:180.f];
    [self addPointFrom:5 Radius:1.75f Angle:270.f]; // 8
    [self addPointFrom:6 Radius:2.5f Angle:135.f];
    [self addPointFrom:7 Radius:1.75f Angle:180.f]; // 10
    [self addPointFrom:10 Radius:2.5f Angle:90.f];
    [self addPointFrom:11 Radius:2.5f Angle:90.f]; // 12
    [self computePoints];

    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_state buildNode:[self getPointAt:8] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_state buildNode:[self getPointAt:9] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node10 = [_state buildNode:[self getPointAt:10] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node11 = [_state buildNode:[self getPointAt:11] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node12 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:12] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    [self clearPoints];

    [self buildHouse:node0 type:TABULO_PawnTwo state:_state];
    [self buildPillar:node2];
    [self buildPillar:node5];
    [self buildPillar:node6];
    [self buildPillar:node10];
    [self buildHouse:node12 type:TABULO_PawnOne state:_state];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawnOne = [self buildPawn:node0 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];

    f3ViewAdaptee *pawnTwo = [self buildPawn:node12 type:TABULO_PawnTwo];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node12 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];
    
    f3ViewAdaptee *plankOne = [self buildMediumPlank:node11 angle:90.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node11 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];

    f3ViewAdaptee *plankTwo = [self buildSmallPlank:node7 angle:180.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node7 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];

    f3ViewAdaptee *plankThree = [self buildMediumPlank:node3 angle:135.f hole:0];
    f3DragViewFromNode *controlPlankThree = [[f3DragViewFromNode alloc] initWithNode:node3 forView:plankThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankThree]];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node4 Origin:node6 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node4 Origin:node2 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node5 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node10 Target:node5];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node8 Origin:node5 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node8 Origin:node6 Target:node5];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node2 Target:node5];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node5 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node9 Origin:node6 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node9 Origin:node10 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node11 Origin:node10 Target:node12];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node11 Origin:node12 Target:node10];

    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node4 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node1 Target:node4];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node4 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node6 Origin:node8 Target:node4];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node7 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node8 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node10 Origin:node9 Target:node11];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node10 Origin:node11 Target:node9];
}

- (void)loadLevelNine:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:2.5f Angle:180.f];
    [self addPointFrom:0 Radius:2.5f Angle:240.f]; // 2
    [self addPointFrom:1 Radius:2.5f Angle:180.f];
    [self addPointFrom:2 Radius:2.5f Angle:240.f]; // 4
    [self addPointFrom:3 Radius:2.5f Angle:300.f];
    [self addPointFrom:4 Radius:1.75f Angle:225.f]; // 6
    [self addPointFrom:4 Radius:2.5f Angle:270.f];
    [self addPointFrom:4 Radius:1.75f Angle:315.f]; // 8
    [self addPointFrom:6 Radius:1.75f Angle:225.f];
    [self addPointFrom:7 Radius:2.5f Angle:270.f]; // 10
    [self addPointFrom:8 Radius:1.75f Angle:315.f];
    [self addPointFrom:9 Radius:1.75f Angle:315.f]; // 12
    [self addPointFrom:10 Radius:1.75f Angle:45.f];
    [self computePoints];

    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node3 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:3] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_state buildNode:[self getPointAt:8] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_state buildNode:[self getPointAt:9] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node10 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:10] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node11 = [_state buildNode:[self getPointAt:11] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node12 = [_state buildNode:[self getPointAt:12] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node13 = [_state buildNode:[self getPointAt:13] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    [self clearPoints];

    [self buildHouse:node0 type:TABULO_PawnOne state:_state];
    [self buildHouse:node3 type:TABULO_PawnTwo state:_state];
    [self buildPillar:node4];
    [self buildPillar:node9];
    [self buildHouse:node10 type:TABULO_PawnFour state:_state];
    [self buildPillar:node11];
    [self buildBackground];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background
    
    f3ViewAdaptee *pawnOne = [self buildPawn:node0 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];

    f3ViewAdaptee *pawnTwo = [self buildPawn:node3 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node3 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];

    f3ViewAdaptee *pawnThree = [self buildPawn:node10 type:TABULO_PawnTwo];
    f3DragViewFromNode *controlPawnThree = [[f3DragViewFromNode alloc] initWithNode:node10 forView:pawnThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnThree]];

    f3ViewAdaptee *plankOne = [self buildMediumPlank:node1 angle:0.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node1 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];

    f3ViewAdaptee *plankTwo = [self buildSmallPlank:node6 angle:45.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node6 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];

    f3ViewAdaptee *plankThree = [self buildSmallPlank:node8 angle:135.f hole:0];
    f3DragViewFromNode *controlPlankThree = [[f3DragViewFromNode alloc] initWithNode:node8 forView:plankThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankThree]];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node3 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node2 Origin:node0 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node2 Origin:node4 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node5 Origin:node3 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node5 Origin:node4 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node7 Origin:node4 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node7 Origin:node10 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node6 Origin:node4 Target:node9];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node6 Origin:node9 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node8 Origin:node4 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node8 Origin:node11 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node12 Origin:node9 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node12 Origin:node10 Target:node9];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node13 Origin:node10 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node13 Origin:node11 Target:node10];

    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node4 Origin:node6 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node4 Origin:node8 Target:node6];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node9 Origin:node6 Target:node12];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node9 Origin:node12 Target:node6];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node10 Origin:node12 Target:node13];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node10 Origin:node13 Target:node12];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node11 Origin:node8 Target:node13];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node11 Origin:node13 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node2 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node5 Target:node2];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node5 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node7 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node2 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node7 Target:node2];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node0 Origin:node1 Target:node2];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node0 Origin:node2 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node3 Origin:node1 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node3 Origin:node5 Target:node1];
}

- (void)loadLevelTen:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:1.75f Angle:75.f];
    [self addPointFrom:0 Radius:1.75f Angle:165.f]; // 2
    [self addPointFrom:1 Radius:1.75f Angle:75.f];
    [self addPointFrom:2 Radius:1.75f Angle:165.f]; // 4
    [self addPointFrom:3 Radius:1.75f Angle:105.f];
    [self addPointFrom:3 Radius:2.5f Angle:150.f]; // 6
    [self addPointFrom:3 Radius:2.5f Angle:210.f];
    [self addPointFrom:4 Radius:2.5f Angle:90.f]; // 8
    [self addPointFrom:4 Radius:1.75f Angle:135.f];
    [self addPointFrom:5 Radius:1.75f Angle:105.f]; // 10
    [self addPointFrom:6 Radius:2.5f Angle:150.f];
    [self addPointFrom:9 Radius:1.75f Angle:135.f]; // 12
    [self addPointFrom:10 Radius:1.75f Angle:195.f];
    [self addPointFrom:11 Radius:1.75f Angle:225.f]; // 14
    [self computePoints];

    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node3 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:3] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_state buildNode:[self getPointAt:8] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_state buildNode:[self getPointAt:9] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node10 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:10] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node11 = [_state buildNode:[self getPointAt:11] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node12 = [_state buildNode:[self getPointAt:12] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node13 = [_state buildNode:[self getPointAt:13] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node14 = [_state buildNode:[self getPointAt:14] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    [self clearPoints];

    [self buildHouse:node0 type:TABULO_PawnOne state:_state];
    [self buildHouse:node3 type:TABULO_PawnTwo state:_state];
    [self buildPillar:node4];
    [self buildHouse:node10 type:TABULO_PawnFour state:_state];
    [self buildPillar:node11];
    [self buildPillar:node12];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawnOne = [self buildPawn:node4 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node4 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];

    f3ViewAdaptee *pawnTwo = [self buildPawn:node11 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node11 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];

    f3ViewAdaptee *pawnThree = [self buildPawn:node12 type:TABULO_PawnTwo];
    f3DragViewFromNode *controlPawnThree = [[f3DragViewFromNode alloc] initWithNode:node12 forView:pawnThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnThree]];
    
    f3ViewAdaptee *plankOne = [self buildMediumPlank:node8 angle:90.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node8 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
    
    f3ViewAdaptee *plankTwo = [self buildSmallPlank:node9 angle:135.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node9 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
    
    f3ViewAdaptee *plankThree = [self buildSmallPlank:node14 angle:45.f hole:0];
    f3DragViewFromNode *controlPlankThree = [[f3DragViewFromNode alloc] initWithNode:node14 forView:plankThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankThree]];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node0 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node3 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node2 Origin:node0 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node2 Origin:node4 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node3 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node10 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node13 Origin:node10 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node13 Origin:node11 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node4 Target:node12];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node12 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node14 Origin:node11 Target:node12];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node14 Origin:node12 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node6 Origin:node3 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node6 Origin:node11 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node7 Origin:node3 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node7 Origin:node4 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node8 Origin:node4 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node8 Origin:node11 Target:node4];

    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node0 Origin:node1 Target:node2];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node0 Origin:node2 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node3 Origin:node5 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node3 Origin:node1 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node4 Origin:node2 Target:node9];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node4 Origin:node9 Target:node2];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node10 Origin:node5 Target:node13];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node10 Origin:node13 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node11 Origin:node14 Target:node13];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node11 Origin:node13 Target:node14];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node12 Origin:node9 Target:node14];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node12 Origin:node14 Target:node9];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node3 Origin:node6 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node3 Origin:node7 Target:node6];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node7 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node8 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node11 Origin:node6 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node11 Origin:node8 Target:node6];
}

- (void)loadLevelEleven:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:2.5f Angle:150.f];
    [self addPointFrom:0 Radius:2.5f Angle:210.f]; // 2
    [self addPointFrom:1 Radius:2.5f Angle:150.f];
    [self addPointFrom:2 Radius:2.5f Angle:210.f]; // 4
    [self addPointFrom:3 Radius:1.75f Angle:135.f];
    [self addPointFrom:3 Radius:1.75f Angle:225.f]; // 6
    [self addPointFrom:3 Radius:2.5f Angle:270.f];
    [self addPointFrom:4 Radius:1.75f Angle:135.f]; // 8
    [self addPointFrom:4 Radius:1.75f Angle:225.f];
    [self addPointFrom:5 Radius:1.75f Angle:135.f]; // 10
    [self addPointFrom:6 Radius:1.75f Angle:225.f];
    [self addPointFrom:9 Radius:1.75f Angle:225.f]; // 12
    [self addPointFrom:10 Radius:2.5f Angle:270.f];
    [self addPointFrom:11 Radius:2.5f Angle:270.f]; // 14
    [self computePoints];

    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_state buildNode:[self getPointAt:8] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_state buildNode:[self getPointAt:9] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node10 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:10] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node11 = [_state buildNode:[self getPointAt:11] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node12 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:12] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node13 = [_state buildNode:[self getPointAt:13] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node14 = [_state buildNode:[self getPointAt:14] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    [self clearPoints];

    [self buildHouse:node0 type:TABULO_PawnOne state:_state];
    [self buildPillar:node3];
    [self buildPillar:node4];
    [self buildHouse:node10 type:TABULO_PawnFour state:_state];
    [self buildPillar:node11];
    [self buildHouse:node12 type:TABULO_PawnTwo state:_state];
    [self buildBackground];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawnOne = [self buildPawn:node0 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];

    f3ViewAdaptee *pawnTwo = [self buildPawn:node12 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node12 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];
    
    f3ViewAdaptee *pawnThree = [self buildPawn:node10 type:TABULO_PawnTwo];
    f3DragViewFromNode *controlPawnThree = [[f3DragViewFromNode alloc] initWithNode:node10 forView:pawnThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnThree]];

    f3ViewAdaptee *plankOne = [self buildMediumPlank:node7 angle:90.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node7 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];

    f3ViewAdaptee *plankTwo = [self buildSmallPlank:node8 angle:135.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node8 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
    
    f3ViewAdaptee *plankThree = [self buildMediumPlank:node14 angle:90.f hole:0];
    f3DragViewFromNode *controlPlankThree = [[f3DragViewFromNode alloc] initWithNode:node14 forView:plankThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankThree]];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node3 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node10 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node6 Origin:node3 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node6 Origin:node11 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node8 Origin:node4 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node8 Origin:node11 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node4 Target:node12];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node12 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node3 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node2 Origin:node0 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node2 Origin:node4 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node7 Origin:node3 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node7 Origin:node4 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node13 Origin:node10 Target:node11];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node13 Origin:node11 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node14 Origin:node11 Target:node12];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node14 Origin:node12 Target:node11];

    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node4 Origin:node8 Target:node9];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node4 Origin:node9 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node11 Origin:node8 Target:node6];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node11 Origin:node6 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node3 Origin:node5 Target:node6];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node3 Origin:node6 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node0 Origin:node1 Target:node2];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node0 Origin:node2 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node3 Origin:node1 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node3 Origin:node7 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node7 Target:node2];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node2 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node11 Origin:node13 Target:node14];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node11 Origin:node14 Target:node13];
}

- (void)loadLevelTwelve:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:1.75f Angle:75.f];
    [self addPointFrom:0 Radius:1.75f Angle:165.f]; // 2
    [self addPointFrom:1 Radius:1.75f Angle:75.f];
    [self addPointFrom:2 Radius:1.75f Angle:165.f]; // 4
    [self addPointFrom:3 Radius:2.5f Angle:90.f];
    [self addPointFrom:3 Radius:2.5f Angle:150.f]; // 6
    [self addPointFrom:3 Radius:2.5f Angle:210.f];
    [self addPointFrom:4 Radius:2.5f Angle:90.f]; // 8
    [self addPointFrom:5 Radius:2.5f Angle:90.f];
    [self addPointFrom:6 Radius:2.5f Angle:150.f]; // 10
    [self addPointFrom:9 Radius:1.75f Angle:165.f];
    [self addPointFrom:9 Radius:2.5f Angle:210.f]; // 12
    [self addPointFrom:10 Radius:1.75f Angle:75.f];
    [self addPointFrom:11 Radius:1.75f Angle:165.f]; // 14
    [self computePoints];

    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node8 = [_state buildNode:[self getPointAt:8] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node9 = [_state buildNode:[self getPointAt:9] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node10 = [_state buildNode:[self getPointAt:10] withExtend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node11 = [_state buildNode:[self getPointAt:11] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node12 = [_state buildNode:[self getPointAt:12] withRadius:1.5f writer:dataWriter symbols:dataSymbols];
    f3GraphNode *node13 = [_state buildNode:[self getPointAt:13] withRadius:0.8f writer:dataWriter symbols:dataSymbols];
    fgHouseNode *node14 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:14] extend:CGSizeMake(0.8f, 0.8f) writer:dataWriter symbols:dataSymbols];
    [self clearPoints];

    [self buildHouse:node0 type:TABULO_PawnFour state:_state];
    [self buildPillar:node3];
    [self buildPillar:node4];
    [self buildPillar:node9];
    [self buildPillar:node10];
    [self buildHouse:node14 type:TABULO_PawnOne state:_state];
    [self buildBackground];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawnOne = [self buildPawn:node0 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];

    f3ViewAdaptee *pawnTwo = [self buildPawn:node14 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node14 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];

    f3ViewAdaptee *plankOne = [self buildSmallPlank:node2 angle:165.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node2 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];

    f3ViewAdaptee *plankTwo = [self buildSmallPlank:node11 angle:165.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node11 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];

    f3ViewAdaptee *plankThree = [self buildMediumPlank:node6 angle:150.f hole:0];
    f3DragViewFromNode *controlPlankThree = [[f3DragViewFromNode alloc] initWithNode:node6 forView:plankThree nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankThree]];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node0 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node3 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node2 Origin:node0 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node2 Origin:node4 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node11 Origin:node9 Target:node14];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node11 Origin:node14 Target:node9];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node13 Origin:node10 Target:node14];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node13 Origin:node14 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node5 Origin:node3 Target:node9];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node5 Origin:node9 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node6 Origin:node3 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node6 Origin:node10 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node7 Origin:node3 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node7 Origin:node4 Target:node3];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node8 Origin:node4 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node8 Origin:node10 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node12 Origin:node9 Target:node10];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node12 Origin:node10 Target:node9];

    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node0 Origin:node1 Target:node2];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node0 Origin:node2 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node14 Origin:node11 Target:node13];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node14 Origin:node13 Target:node11];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node3 Origin:node5 Target:node6];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node3 Origin:node6 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node3 Origin:node6 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node3 Origin:node7 Target:node6];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node7 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node8 Target:node7];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node9 Origin:node5 Target:node12];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node9 Origin:node12 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node10 Origin:node6 Target:node12];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node10 Origin:node12 Target:node6];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node10 Origin:node6 Target:node8];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node10 Origin:node8 Target:node6];
}

@end
