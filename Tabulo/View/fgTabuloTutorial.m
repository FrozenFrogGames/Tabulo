//
//  fgTabuloTutorial.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-27.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloTutorial.h"
#import "../../../Framework/Framework/Control/f3ControlComposite.h"
#import "../../../Framework/Framework/Control/f3DragViewFromNode.h"
#import "../Control/fgLevelState.h"
#import "fgDragViewOverEdge.h"
#import "fgDialogState.h"

@implementation fgTabuloTutorial

- (void)build:(f3ViewBuilder *)_builder state:(f3GameState *)_state level:(NSUInteger)_level {

    switch (_level)
    {
        case 1:
            [self loadTutorialOne:_builder state:_state];
            break;

        case 2:
            [self loadTutorialTwo:_builder state:_state];
            break;

        case 3:
            [self loadTutorialThree:_builder state:_state];
            break;
            
        case 4:
            [self loadTutorialFour:_builder state:_state];
            break;

        case 5:
            [self loadTutorialFive:_builder state:_state];
            break;
            
        case 6:
            [self loadTutorialSix:_builder state:_state];
            break;
    }

    [super build:_builder state:_state level:_level];
}

- (void)loadTutorialOne:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:2.5f Angle:90.f];
    [self addPointFrom:1 Radius:2.5f Angle:90.f]; // 2
    [self computePoints];

    f3GraphNode *node0 = [_state buildNode:[self getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f];
    fgHouseNode *node2 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:2] extend:CGSizeMake(0.8f, 0.8f)];
    [self clearPoints];
    
    [self buildPillar:node0];
    [self buildHouse:node2 type:TABULO_PawnFour state:_state];
    [self buildBackground];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background
    
    f3ViewAdaptee *pawn = [self buildPawn:node0 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawn = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawn nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawn]];

    f3ViewAdaptee *plank = [self buildMediumPlank:node1 angle:270.f hole:0];
    f3DragViewFromNode *controlPlank = [[f3DragViewFromNode alloc] initWithNode:node1 forView:plank nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlank]];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements
    
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node2 Target:node0];
}

- (void)loadTutorialTwo:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:1.75f Angle:90.f];
    [self addPointFrom:1 Radius:1.75f Angle:90.f]; // 2
    [self addPointFrom:2 Radius:1.75f Angle:0.f];
    [self addPointFrom:3 Radius:1.75f Angle:0.f]; // 4
    [self computePoints];

    f3GraphNode *node0 = [_state buildNode:[self getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f];
    fgHouseNode *node4 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:4] extend:CGSizeMake(0.8f, 0.8f)];
    [self clearPoints];

    [self buildPillar:node0];
    [self buildPillar:node2];
    [self buildHouse:node4 type:TABULO_PawnFour state:_state];
    [self buildBackground];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawn = [self buildPawn:node0 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawn = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawn nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawn]];

    f3ViewAdaptee *plank = [self buildSmallPlank:node1 angle:270.f hole:0];
    f3DragViewFromNode *controlPlank = [[f3DragViewFromNode alloc] initWithNode:node1 forView:plank nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlank]];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements
    
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node2 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node4 Target:node2];
    
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node1 Target:node3];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node3 Target:node1];
}

- (void)loadTutorialThree:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:2.5f Angle:90.f];
    [self addPointFrom:1 Radius:2.5f Angle:90.f]; // 2
    [self addPointFrom:2 Radius:1.75f Angle:45.f];
    [self addPointFrom:3 Radius:1.75f Angle:45.f]; // 4
    [self addPointFrom:2 Radius:1.75f Angle:135.f];
    [self addPointFrom:5 Radius:1.75f Angle:135.f]; // 6
    [self computePoints];

    f3GraphNode *node0 = [_state buildNode:[self getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:1.5f];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:0.8f];
    fgHouseNode *node6 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:6] extend:CGSizeMake(0.8f, 0.8f)];
    [self clearPoints];
    
    [self buildPillar:node0];
    [self buildPillar:node2];
    [self buildPillar:node4];
    [self buildHouse:node6 type:TABULO_PawnFour state:_state];
    [self buildBackground];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background
    
    f3ViewAdaptee *pawn = [self buildPawn:node0 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawn = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawn nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawn]];

    f3ViewAdaptee *plankOne = [self buildMediumPlank:node1 angle:90.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node1 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];

    f3ViewAdaptee *plankTwo = [self buildSmallPlank:node3 angle:45.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node3 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements
    
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node2 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node4 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node2 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node6 Target:node2];

    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node3 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node5 Target:node3];
}

- (void)loadTutorialFour:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:2.5f Angle:90.f];
    [self addPointFrom:1 Radius:2.5f Angle:90.f]; // 2
    [self addPointFrom:2 Radius:2.5f Angle:210.f];
    [self addPointFrom:3 Radius:2.5f Angle:210.f]; // 4
    [self addPointFrom:4 Radius:2.5f Angle:330.f];
    [self computePoints];

    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:1.5f];
    fgHouseNode *node2 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:2] extend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:1.5f];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:1.5f];
    [self clearPoints];

    [self buildHouse:node0 type:TABULO_PawnOne state:_state];
    [self buildHouse:node2 type:TABULO_PawnFour state:_state];
    [self buildPillar:node4];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawnOne = [self buildPawn:node2 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node2 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];

    f3ViewAdaptee *pawnTwo = [self buildPawn:node0 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];

    f3ViewAdaptee *plankOne = [self buildMediumPlank:node1 angle:90.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node1 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];

    f3ViewAdaptee *plankTwo = [self buildMediumPlank:node5 angle:150.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node5 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements
    
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node2 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node4 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node5 Origin:node4 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node5 Origin:node0 Target:node4];

    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node0 Origin:node1 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node0 Origin:node5 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node1 Target:node3];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node3 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node3 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node5 Target:node3];
}

- (void)loadTutorialFive:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:1.75f Angle:180.f];
    [self addPointFrom:1 Radius:1.75f Angle:180.f]; // 2
    [self addPointFrom:2 Radius:1.75f Angle:225.f];
    [self addPointFrom:3 Radius:1.75f Angle:225.f]; // 4
    [self addPointFrom:2 Radius:1.75f Angle:135.f];
    [self addPointFrom:5 Radius:1.75f Angle:135.f]; // 6
    [self computePoints];

    f3GraphNode *node0 = [_state buildNode:[self getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f];
    fgHouseNode *node4 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:4] extend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:0.8f];
    fgHouseNode *node6 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:6] extend:CGSizeMake(0.8f, 0.8f)];
    [self clearPoints];
    
    [self buildPillar:node0];
    [self buildPillar:node2];
    [self buildHouse:node4 type:TABULO_PawnOne state:_state];
    [self buildHouse:node6 type:TABULO_PawnFour state:_state];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawnOne = [self buildPawn:node6 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node6 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];

    f3ViewAdaptee *pawnTwo = [self buildPawn:node4 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node4 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];

    f3ViewAdaptee *plankOne = [self buildSmallPlank:node1 angle:0.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node1 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];

    f3ViewAdaptee *plankTwo = [self buildSmallPlank:node5 angle:135.f hole:0];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node5 forView:plankTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements
    
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node2 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node4 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node2 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node6 Target:node2];
    
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node1 Target:node3];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node3 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node1 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node5 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node3 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node5 Target:node3];
}

- (void)loadTutorialSix:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:2.5f Angle:45.f];
    [self addPointFrom:1 Radius:2.5f Angle:45.f]; // 2
    [self addPointFrom:2 Radius:2.5f Angle:135.f];
    [self addPointFrom:3 Radius:2.5f Angle:135.f]; // 4
    [self addPointFrom:4 Radius:2.5f Angle:45.f];
    [self addPointFrom:5 Radius:2.5f Angle:45.f]; // 6
    [self computePoints];
    
    fgHouseNode *node0 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f];
    fgHouseNode *node4 = [(fgLevelState *)_state buildHouseNode:[self getPointAt:4] extend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:0.8f];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f)];
    [self clearPoints];
    
    [self buildHouse:node0 type:TABULO_PawnOne state:_state];
    [self buildPillar:node2];
    [self buildHouse:node4 type:TABULO_PawnFour state:_state];
    [self buildPillar:node6];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background
    
    f3ViewAdaptee *pawnOne = [self buildPawn:node2 type:TABULO_PawnOne];
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node2 forView:pawnOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnOne]];
    
    f3ViewAdaptee *pawnTwo = [self buildPawn:node6 type:TABULO_PawnFour];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node6 forView:pawnTwo nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPawnTwo]];
    
    f3ViewAdaptee *plankOne = [self buildMediumPlank:node5 angle:45.f hole:0];
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node5 forView:plankOne nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements
    
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node2 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node4 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node5 Origin:node4 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node5 Origin:node6 Target:node4];
    
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node1 Target:node3];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node3 Target:node1];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node3 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node4 Origin:node5 Target:node3];
}

@end
