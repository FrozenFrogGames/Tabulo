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
#import "../Control/fgGameState.h"

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
    }
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
    
    fgHouseNode *node0 = [(fgGameState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:0.8f];
    fgHouseNode *node6 = [(fgGameState *)_state buildHouseNode:[self getPointAt:6] extend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:0.8f];
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
    
    fgHouseNode *node0 = [(fgGameState *)_state buildHouseNode:[self getPointAt:0] extend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f];
    fgHouseNode *node4 = [(fgGameState *)_state buildHouseNode:[self getPointAt:4] extend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:0.8f];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:0.8f];
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

}

- (void)loadLevelFour:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

}

- (void)loadLevelFive:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

}

- (void)loadLevelSix:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

}

@end

/*
 - (void)loadSceneTwo:(f3GameAdaptee *)_producer {
 
 [self addPointFrom:0 Radius:2.5f Angle:90.f];
 [self addPointFrom:1 Radius:2.5f Angle:90.f];
 [self addPointFrom:2 Radius:1.75f Angle:180.f];
 [self addPointFrom:2 Radius:2.5f Angle:135.f];
 [self addPointFrom:3 Radius:1.75f Angle:180.f];
 [self addPointFrom:4 Radius:2.5f Angle:135.f];
 [self addPointFrom:5 Radius:1.75f Angle:90.f];
 [self computePoints];
 
 [self buildHouse:TABULO_PawnThree atPosition:[self getPointAt:0]];
 [self builPillarAtPosition:[self getPointAt:2]];
 [self builPillarAtPosition:[self getPointAt:5]];
 [self buildHouse:TABULO_PawnTwo atPosition:[self getPointAt:6]];
 [self buildBackground];
 
 [builder buildComposite:0];
 
 [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay background
 
 f3ViewAdaptee *pawnTwo = [self buildPawn:TABULO_PawnTwo atPosition:[self getPointAt:0]];
 f3ViewAdaptee *pawnThree = [self buildPawn:TABULO_PawnThree atPosition:[self getPointAt:6]];
 
 f3ViewAdaptee *plankOne = [self buildMediumPlank:270.f atPosition:[self getPointAt:1] withHole:0];
 f3ViewAdaptee *plankTwo = [self buildSmallPlank:90.f atPosition:[self getPointAt:7] withHole:0];
 
 [builder buildComposite:0];
 [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay elements
 
 //  [_producer.Grid sceneDidLoad:scene]; // debug purpose
 
 f3GraphNode *node0 = [self buildNode:_producer atPosition:[self getPointAt:0] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node1 = [self buildNode:_producer atPosition:[self getPointAt:1] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node2 = [self buildNode:_producer atPosition:[self getPointAt:2] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node3 = [self buildNode:_producer atPosition:[self getPointAt:3] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node4 = [self buildNode:_producer atPosition:[self getPointAt:4] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node5 = [self buildNode:_producer atPosition:[self getPointAt:5] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node6 = [self buildNode:_producer atPosition:[self getPointAt:7] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node7 = [self buildNode:_producer atPosition:[self getPointAt:6] withExtend:CGSizeMake(0.75f, 0.75f)];
 
 [self clearPoints];
 
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node2 Target:node0];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node4 Origin:node2 Target:node7];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node4 Origin:node7 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node2 Target:node5];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node5 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node6 Origin:node5 Target:node7];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node6 Origin:node7 Target:node5];
 
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node1 Target:node4];
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node4 Target:node1];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node3 Target:node6];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node6 Target:node3];
 
 fgDragViewFromNode *controlPlankOne = [[fgDragViewFromNode alloc] initForView:plankTwo onNode:node6 withFlag:TABULO_HaveSmallPlank];
 fgDragViewFromNode *controlPlankTwo = [[fgDragViewFromNode alloc] initForView:plankOne onNode:node1 withFlag:TABULO_HaveMediumPlank];
 
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
 
 fgDragViewFromNode *controlPawnTwo = [[fgDragViewFromNode alloc] initForView:pawnTwo onNode:node0 withFlag:TABULO_PawnTwo];
 fgDragViewFromNode *controlPawnThree = [[fgDragViewFromNode alloc] initForView:pawnThree onNode:node7 withFlag:TABULO_PawnThree];
 
 [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnTwo Home:node7]];
 [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnThree Home:node0]];
 }
 
 - (void)loadSceneThree:(f3GameAdaptee *)_producer {
 
 [self addPointFrom:0 Radius:2.5f Angle:90.f];
 [self addPointFrom:1 Radius:2.5f Angle:90.f]; // 2
 [self addPointFrom:2 Radius:1.75f Angle:90.f];
 [self addPointFrom:2 Radius:2.5f Angle:180.f]; // 4
 [self addPointFrom:3 Radius:1.75f Angle:90.f];
 [self addPointFrom:4 Radius:2.5f Angle:180.f]; // 6
 [self addPointFrom:5 Radius:1.75f Angle:0.f];
 [self addPointFrom:7 Radius:1.75f Angle:0.f]; // 8
 [self addPointFrom:2 Radius:2.5f Angle:45.f];
 [self computePoints];
 
 [self buildHouse:TABULO_PawnFive atPosition:[self getPointAt:0]];
 [self builPillarAtPosition:[self getPointAt:2]];
 [self buildHouse:TABULO_PawnFour atPosition:[self getPointAt:5]];
 [self builPillarAtPosition:[self getPointAt:6]];
 [self builPillarAtPosition:[self getPointAt:8]];
 [self buildBackground];
 
 [builder buildComposite:0];
 
 [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay background
 
 f3ViewAdaptee *pawnFour = [self buildPawn:TABULO_PawnFour atPosition:[self getPointAt:0]];
 f3ViewAdaptee *pawnFive = [self buildPawn:TABULO_PawnFive atPosition:[self getPointAt:5]];
 
 f3ViewAdaptee *plankOne = [self buildSmallPlank:0.f atPosition:[self getPointAt:7] withHole:0];
 f3ViewAdaptee *plankTwo = [self buildMediumPlank:90.f atPosition:[self getPointAt:1] withHole:0];
 f3ViewAdaptee *plankThree = [self buildMediumPlank:180.f atPosition:[self getPointAt:4] withHole:0];
 
 [builder buildComposite:0];
 [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay elements
 
 //  [_producer.Grid sceneDidLoad:scene]; // debug purpose
 
 f3GraphNode *node0 = [self buildNode:_producer atPosition:[self getPointAt:0] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node1 = [self buildNode:_producer atPosition:[self getPointAt:1] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node2 = [self buildNode:_producer atPosition:[self getPointAt:2] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node3 = [self buildNode:_producer atPosition:[self getPointAt:3] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node4 = [self buildNode:_producer atPosition:[self getPointAt:4] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node5 = [self buildNode:_producer atPosition:[self getPointAt:5] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node6 = [self buildNode:_producer atPosition:[self getPointAt:6] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node7 = [self buildNode:_producer atPosition:[self getPointAt:7] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node8 = [self buildNode:_producer atPosition:[self getPointAt:8] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node9 = [self buildNode:_producer atPosition:[self getPointAt:9] withExtend:CGSizeMake(0.75f, 0.75f)];
 
 [self clearPoints];
 
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node2 Target:node0];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node4 Origin:node2 Target:node6];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node4 Origin:node6 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node9 Origin:node2 Target:node8];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node9 Origin:node8 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node2 Target:node5];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node5 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node5 Target:node8];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node8 Target:node5];
 
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node1 Target:node9];
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node9 Target:node1];
 
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node1 Target:node4];
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node4 Target:node1];
 
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node3 Target:node7];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node7 Target:node3];
 
 fgDragViewFromNode *controlPlankOne = [[fgDragViewFromNode alloc] initForView:plankOne onNode:node7 withFlag:TABULO_HaveSmallPlank];
 fgDragViewFromNode *controlPlankTwo = [[fgDragViewFromNode alloc] initForView:plankTwo onNode:node1 withFlag:TABULO_HaveMediumPlank];
 fgDragViewFromNode *controlPlankThree = [[fgDragViewFromNode alloc] initForView:plankThree onNode:node4 withFlag:TABULO_HaveMediumPlank];
 
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankThree]];
 
 fgDragViewFromNode *controlPawnFour = [[fgDragViewFromNode alloc] initForView:pawnFour onNode:node0 withFlag:TABULO_PawnFour];
 fgDragViewFromNode *controlPawnFive = [[fgDragViewFromNode alloc] initForView:pawnFive onNode:node5 withFlag:TABULO_PawnFive];
 
 [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnFour Home:node5]];
 [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnFive Home:node0]];
 }
 
 - (void)loadSceneFour:(f3GameAdaptee *)_producer {
 
 [self addPointFrom:0 Radius:1.75f Angle:180.f];
 [self addPointFrom:1 Radius:1.75f Angle:180.f];
 [self addPointFrom:0 Radius:2.5f Angle:135.f];
 [self addPointFrom:2 Radius:1.75f Angle:90.f];
 [self addPointFrom:4 Radius:1.75f Angle:90.f];
 [self addPointFrom:5 Radius:1.75f Angle:135.f];
 [self addPointFrom:5 Radius:2.5f Angle:90.f];
 [self addPointFrom:6 Radius:1.75f Angle:135.f];
 [self addPointFrom:8 Radius:1.75f Angle:45.f];
 [self addPointFrom:7 Radius:2.5f Angle:90.f];
 [self addPointFrom:10 Radius:2.5f Angle:0.f];
 [self addPointFrom:11 Radius:2.5f Angle:0.f];
 [self computePoints];
 
 [self buildHouse:TABULO_PawnFive atPosition:[self getPointAt:0]];
 [self builPillarAtPosition:[self getPointAt:2]];
 [self buildHouse:TABULO_PawnOne atPosition:[self getPointAt:5]];
 [self builPillarAtPosition:[self getPointAt:8]];
 [self builPillarAtPosition:[self getPointAt:10]];
 [self buildHouse:TABULO_PawnFour atPosition:[self getPointAt:12]];
 [self buildBackground];
 
 [builder buildComposite:0];
 
 [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay background
 
 f3ViewAdaptee *pawnFour = [self buildPawn:TABULO_PawnFour atPosition:[self getPointAt:0]];
 f3ViewAdaptee *pawnFive = [self buildPawn:TABULO_PawnFive atPosition:[self getPointAt:5]];
 f3ViewAdaptee *pawnOne = [self buildPawn:TABULO_PawnOne atPosition:[self getPointAt:12]];
 
 f3ViewAdaptee *plankOne = [self buildSmallPlank:90.f atPosition:[self getPointAt:4] withHole:0];
 f3ViewAdaptee *plankTwo = [self buildSmallPlank:45.f atPosition:[self getPointAt:9] withHole:0];
 f3ViewAdaptee *plankThree = [self buildMediumPlank:0.f atPosition:[self getPointAt:11] withHole:0];
 
 [builder buildComposite:0];
 [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay elements
 
 //  [_producer.Grid sceneDidLoad:scene]; // debug purpose
 
 f3GraphNode *node0 = [self buildNode:_producer atPosition:[self getPointAt:0] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node1 = [self buildNode:_producer atPosition:[self getPointAt:1] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node2 = [self buildNode:_producer atPosition:[self getPointAt:2] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node3 = [self buildNode:_producer atPosition:[self getPointAt:3] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node4 = [self buildNode:_producer atPosition:[self getPointAt:4] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node5 = [self buildNode:_producer atPosition:[self getPointAt:5] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node6 = [self buildNode:_producer atPosition:[self getPointAt:6] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node7 = [self buildNode:_producer atPosition:[self getPointAt:7] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node8 = [self buildNode:_producer atPosition:[self getPointAt:8] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node9 = [self buildNode:_producer atPosition:[self getPointAt:9] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node10 = [self buildNode:_producer atPosition:[self getPointAt:12] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node11 = [self buildNode:_producer atPosition:[self getPointAt:11] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node12 = [self buildNode:_producer atPosition:[self getPointAt:10] withExtend:CGSizeMake(0.75f, 0.75f)];
 
 [self clearPoints];
 
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node0 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node2 Target:node0];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node0 Target:node5];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node5 Target:node0];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node4 Origin:node2 Target:node5];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node4 Origin:node5 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node6 Origin:node5 Target:node8];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node6 Origin:node8 Target:node5];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node7 Origin:node5 Target:node12];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node7 Origin:node12 Target:node5];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node8 Target:node12];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node12 Target:node8];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node11 Origin:node10 Target:node12];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node11 Origin:node12 Target:node10];
 
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node5 Origin:node3 Target:node7];
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node5 Origin:node7 Target:node3];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node6 Target:node4];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node4 Target:node6];
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node12 Origin:node7 Target:node11];
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node12 Origin:node11 Target:node7];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node1 Target:node4];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node4 Target:node1];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node8 Origin:node6 Target:node9];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node8 Origin:node9 Target:node6];
 
 fgDragViewFromNode *controlPlankOne = [[fgDragViewFromNode alloc] initForView:plankOne onNode:node4 withFlag:TABULO_HaveSmallPlank];
 fgDragViewFromNode *controlPlankTwo = [[fgDragViewFromNode alloc] initForView:plankTwo onNode:node9 withFlag:TABULO_HaveSmallPlank];
 fgDragViewFromNode *controlPlankThree = [[fgDragViewFromNode alloc] initForView:plankThree onNode:node11 withFlag:TABULO_HaveMediumPlank];
 
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankThree]];
 
 fgDragViewFromNode *controlPawnFour = [[fgDragViewFromNode alloc] initForView:pawnFour onNode:node0 withFlag:TABULO_PawnFour];
 fgDragViewFromNode *controlPawnFive = [[fgDragViewFromNode alloc] initForView:pawnFive onNode:node5 withFlag:TABULO_PawnFive];
 fgDragViewFromNode *controlPawnOne = [[fgDragViewFromNode alloc] initForView:pawnOne onNode:node10 withFlag:TABULO_PawnOne];
 
 [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnFour Home:node10]];
 [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnFive Home:node0]];
 [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnOne Home:node5]];
 }
 
 - (void)loadSceneFive:(f3GameAdaptee *)_producer {
 
 [self addPointFrom:0 Radius:1.75f Angle:90.f];
 [self addPointFrom:0 Radius:2.5f Angle:135.f]; // 2
 [self addPointFrom:0 Radius:2.5f Angle:225.f];
 [self addPointFrom:1 Radius:1.75f Angle:90.f]; // 4
 [self addPointFrom:2 Radius:2.5f Angle:135.f];
 [self addPointFrom:3 Radius:2.5f Angle:225.f]; // 6
 [self addPointFrom:4 Radius:1.75f Angle:180.f];
 [self addPointFrom:5 Radius:1.75f Angle:90.f]; // 8
 [self addPointFrom:5 Radius:1.75f Angle:225.f];
 [self addPointFrom:8 Radius:1.75f Angle:90.f]; // 10
 [self addPointFrom:9 Radius:1.75f Angle:225.f];
 [self addPointFrom:11 Radius:1.75f Angle:180.f]; // 12
 [self addPointFrom:12 Radius:1.75f Angle:180.f];
 [self computePoints];
 
 [self buildHouse:TABULO_PawnOne atPosition:[self getPointAt:4]];
 [self buildHouse:TABULO_PawnTwo atPosition:[self getPointAt:6]];
 [self buildHouse:TABULO_PawnThree atPosition:[self getPointAt:13]];
 [self builPillarAtPosition:[self getPointAt:0]];
 [self builPillarAtPosition:[self getPointAt:5]];
 [self builPillarAtPosition:[self getPointAt:10]];
 [self builPillarAtPosition:[self getPointAt:11]];
 [self buildBackground];
 
 [builder buildComposite:0];
 
 [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay background
 
 f3ViewAdaptee *pawnOne = [self buildPawn:TABULO_PawnOne atPosition:[self getPointAt:6]];
 f3ViewAdaptee *pawnTwo = [self buildPawn:TABULO_PawnTwo atPosition:[self getPointAt:13]];
 f3ViewAdaptee *pawnThree = [self buildPawn:TABULO_PawnThree atPosition:[self getPointAt:4]];
 
 f3ViewAdaptee *plankOne = [self buildSmallPlank:180.f atPosition:[self getPointAt:12] withHole:0];
 f3ViewAdaptee *plankTwo = [self buildSmallPlank:90.f atPosition:[self getPointAt:8] withHole:0];
 f3ViewAdaptee *plankThree = [self buildMediumPlank:135.f atPosition:[self getPointAt:2] withHole:0];
 
 [builder buildComposite:0];
 [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay elements
 
 //  [_producer.Grid sceneDidLoad:scene]; // debug purpose
 
 f3GraphNode *node0  = [self buildNode:_producer atPosition:[self getPointAt:0] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node1  = [self buildNode:_producer atPosition:[self getPointAt:1] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node2  = [self buildNode:_producer atPosition:[self getPointAt:2] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node3  = [self buildNode:_producer atPosition:[self getPointAt:3] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node4  = [self buildNode:_producer atPosition:[self getPointAt:4] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node5  = [self buildNode:_producer atPosition:[self getPointAt:5] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node6  = [self buildNode:_producer atPosition:[self getPointAt:6] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node7  = [self buildNode:_producer atPosition:[self getPointAt:7] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node8  = [self buildNode:_producer atPosition:[self getPointAt:8] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node9  = [self buildNode:_producer atPosition:[self getPointAt:9] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node10 = [self buildNode:_producer atPosition:[self getPointAt:10] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node11 = [self buildNode:_producer atPosition:[self getPointAt:11] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node12 = [self buildNode:_producer atPosition:[self getPointAt:12] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node13 = [self buildNode:_producer atPosition:[self getPointAt:13] withExtend:CGSizeMake(0.75f, 0.75f)];
 
 [self clearPoints];
 
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node0 Target:node4];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node4 Target:node0];
 
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node2 Origin:node0 Target:node5];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node2 Origin:node5 Target:node0];
 
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node0 Target:node6];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node3 Origin:node6 Target:node0];
 
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node4 Target:node5];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node5 Target:node4];
 
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node8 Origin:node5 Target:node10];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node8 Origin:node10 Target:node5];
 
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node5 Target:node11];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node9 Origin:node11 Target:node5];
 
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node12 Origin:node11 Target:node13];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node12 Origin:node13 Target:node11];
 
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node0 Origin:node2 Target:node3];
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node0 Origin:node3 Target:node2];
 
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node4 Origin:node1 Target:node7];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node4 Origin:node7 Target:node1];
 
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node7 Target:node8];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node8 Target:node7];
 
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node8 Target:node9];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node9 Target:node8];
 
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node11 Origin:node9 Target:node12];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node11 Origin:node12 Target:node9];
 
 fgDragViewFromNode *controlPlankOne = [[fgDragViewFromNode alloc] initForView:plankOne onNode:node12 withFlag:TABULO_HaveSmallPlank];
 fgDragViewFromNode *controlPlankTwo = [[fgDragViewFromNode alloc] initForView:plankTwo onNode:node8 withFlag:TABULO_HaveSmallPlank];
 fgDragViewFromNode *controlPlankThree = [[fgDragViewFromNode alloc] initForView:plankThree onNode:node2 withFlag:TABULO_HaveMediumPlank];
 
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankThree]];
 
 fgDragViewFromNode *controlPawnOne = [[fgDragViewFromNode alloc] initForView:pawnOne onNode:node6 withFlag:TABULO_PawnOne];
 fgDragViewFromNode *controlPawnTwo = [[fgDragViewFromNode alloc] initForView:pawnTwo onNode:node13 withFlag:TABULO_PawnTwo];
 fgDragViewFromNode *controlPawnThree = [[fgDragViewFromNode alloc] initForView:pawnThree onNode:node4 withFlag:TABULO_PawnThree];
 
 [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnOne Home:node4]];
 [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnTwo Home:node6]];
 [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnThree Home:node13]];
 }
 
 - (void)loadSceneSix:(f3GameAdaptee *)_producer {
 
 [self addPointFrom:0 Radius:2.5f Angle:90.f];
 [self addPointFrom:1 Radius:2.5f Angle:90.f]; // 2
 [self addPointFrom:2 Radius:1.75f Angle:90.f];
 [self addPointFrom:2 Radius:2.5f Angle:180.f]; // 4
 [self addPointFrom:3 Radius:1.75f Angle:90.f];
 [self addPointFrom:4 Radius:2.5f Angle:180.f]; // 6
 [self addPointFrom:5 Radius:1.75f Angle:0.f];
 [self addPointFrom:7 Radius:1.75f Angle:0.f]; // 8
 [self addPointFrom:2 Radius:2.5f Angle:45.f];
 [self computePoints];
 
 [self buildHouse:TABULO_PawnFive atPosition:[self getPointAt:0]];
 [self builPillarAtPosition:[self getPointAt:2]];
 [self buildHouse:TABULO_PawnFour atPosition:[self getPointAt:5]];
 [self builPillarAtPosition:[self getPointAt:6]];
 [self builPillarAtPosition:[self getPointAt:8]];
 [self buildBackground];
 
 [builder buildComposite:0];
 
 [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay background
 
 f3ViewAdaptee *pawnFour = [self buildPawn:TABULO_PawnFour atPosition:[self getPointAt:0]];
 f3ViewAdaptee *pawnFive = [self buildPawn:TABULO_PawnFive atPosition:[self getPointAt:5]];
 
 f3ViewAdaptee *plankOne = [self buildSmallPlank:0.f atPosition:[self getPointAt:7] withHole:0];
 f3ViewAdaptee *plankTwo = [self buildMediumPlank:90.f atPosition:[self getPointAt:1] withHole:4];
 f3ViewAdaptee *plankThree = [self buildMediumPlank:180.f atPosition:[self getPointAt:4] withHole:5];
 
 [builder buildComposite:0];
 [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay elements
 
 //  [_producer.Grid sceneDidLoad:scene]; // debug purpose
 
 f3GraphNode *node0 = [self buildNode:_producer atPosition:[self getPointAt:0] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node1 = [self buildNode:_producer atPosition:[self getPointAt:1] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node2 = [self buildNode:_producer atPosition:[self getPointAt:2] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node3 = [self buildNode:_producer atPosition:[self getPointAt:3] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node4 = [self buildNode:_producer atPosition:[self getPointAt:4] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node5 = [self buildNode:_producer atPosition:[self getPointAt:5] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node6 = [self buildNode:_producer atPosition:[self getPointAt:6] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node7 = [self buildNode:_producer atPosition:[self getPointAt:7] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node8 = [self buildNode:_producer atPosition:[self getPointAt:8] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node9 = [self buildNode:_producer atPosition:[self getPointAt:9] withExtend:CGSizeMake(0.75f, 0.75f)];
 
 [self clearPoints];
 
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node2 Target:node0];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node4 Origin:node2 Target:node6];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node4 Origin:node6 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node9 Origin:node2 Target:node8];
 [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node9 Origin:node8 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node2 Target:node5];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node5 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node5 Target:node8];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node7 Origin:node8 Target:node5];
 
 
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node1 Target:node9];
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node9 Target:node1];
 
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node1 Target:node4];
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node2 Origin:node4 Target:node1];
 
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node3 Target:node7];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node7 Target:node3];
 
 fgDragViewFromNode *controlPlankOne = [[fgDragViewFromNode alloc] initForView:plankOne onNode:node7 withFlag:TABULO_HaveSmallPlank];
 fgDragViewFromNode *controlPlankTwo = [[fgDragViewFromNode alloc] initForView:plankTwo onNode:node1 withFlag:TABULO_HaveMediumPlank];
 fgDragViewFromNode *controlPlankThree = [[fgDragViewFromNode alloc] initForView:plankThree onNode:node4 withFlag:TABULO_HaveMediumPlank];
 
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankThree]];
 
 fgDragViewFromNode *controlPawnFour = [[fgDragViewFromNode alloc] initForView:pawnFour onNode:node0 withFlag:TABULO_PawnFour];
 fgDragViewFromNode *controlPawnFive = [[fgDragViewFromNode alloc] initForView:pawnFive onNode:node5 withFlag:TABULO_PawnFive];
 
 [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnFour Home:node5]];
 [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnFive Home:node0]];
 }
 
 - (void)loadSceneSeven:(f3GameAdaptee *)_producer {
 
 [self addPointFrom:0 Radius:1.75f Angle:90.f];
 [self computePoints];
 
 [self buildHouse:TABULO_PawnOne atPosition:[self getPointAt:0]];
 [self builPillarAtPosition:[self getPointAt:2]];
 [self buildBackground];
 
 [builder buildComposite:0];
 
 [scene appendComposite:(f3ViewComposite *)[builder popComponent]]; // gameplay background
 
 f3ViewAdaptee *pawnOne = [self buildPawn:TABULO_PawnOne atPosition:[self getPointAt:12]];
 
 f3ViewAdaptee *plankOne = [self buildSmallPlank:90.f atPosition:[self getPointAt:1] withHole:0];
 f3ViewAdaptee *plankTwo = [self buildMediumPlank:180.f atPosition:[self getPointAt:3] withHole:0];
 
 [builder buildComposite:0];
 
 f3GraphNode *node0 = [self buildNode:_producer atPosition:[self getPointAt:0] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node1 = [self buildNode:_producer atPosition:[self getPointAt:1] withExtend:CGSizeMake(0.75f, 0.75f)];
 f3GraphNode *node2 = [self buildNode:_producer atPosition:[self getPointAt:2] withExtend:CGSizeMake(0.75f, 0.75f)];
 
 [self clearPoints];
 
 if ([scene appendComposite:(f3ViewComposite *)[builder popComponent]]) // gameplay elements
 {
 //      [_producer.Grid sceneDidLoad:scene]; // debug purpose
 
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node0 Target:node2];
 [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node2 Target:node0];
 
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node6 Target:node4];
 [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node5 Origin:node4 Target:node6];
 
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node12 Origin:node7 Target:node11];
 [self buildEdgesForPlank:TABULO_HaveMediumPlank Node:node12 Origin:node11 Target:node7];
 
 g3DragViewFromNode *controlPlankOne = [[g3DragViewFromNode alloc] initForView:plankOne onNode:node4 withFlag:TABULO_HaveSmallPlank];
 g3DragViewFromNode *controlPlankTwo = [[g3DragViewFromNode alloc] initForView:plankTwo onNode:node9 withFlag:TABULO_HaveSmallPlank];
 
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
 [_producer appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
 
 fgDragPawnFromNode *controlPawnOne = [[fgDragPawnFromNode alloc] initForView:pawnOne onNode:node10 withFlag:TABULO_PawnOne];
 
 [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnOne Home:node5]];
 }
}
 */