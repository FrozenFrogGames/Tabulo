//
//  fgTabuloTutorial.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-27.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloTutorial.h"
#import "fgDialogState.h"
#import "../../../Framework/Framework/Control/f3DragViewFromNode.h"
#import "fgDragViewOverEdge.h"
#import "../Control/fgTabuloController.h"
#import "../Control/fgPawnController.h"

@implementation fgTabuloTutorial

- (void)build:(f3ViewBuilder *)_builder state:(f3GameState *)_state level:(NSUInteger)_level {

    fgTabuloController *gameController = nil;

    switch (_level)
    {
        case 1:
            gameController = [self loadTutorialOne:_builder state:_state];
            break;

        case 2:
            gameController = [self loadTutorialTwo:_builder state:_state];
            break;

        case 3:
            gameController = [self loadTutorialThree:_builder state:_state];
            break;
            
        case 4:
            gameController = [self loadTutorialFour:_builder state:_state];
            break;

        case 5:
            gameController = [self loadTutorialFive:_builder state:_state];
            break;
            
        case 6:
            gameController = [self loadTutorialSix:_builder state:_state];
            break;
    }
    
    [_state appendComponent:gameController];
}

- (fgTabuloController *)loadTutorialOne:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:2.5f Angle:90.f];
    [self addPointFrom:1 Radius:2.5f Angle:90.f];
    [self computePoints];
    
    [self buildPillar:0];
    [self buildHouse:2 Type:TABULO_PawnFour];
    [self buildBackground];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background
    
    f3ViewAdaptee *pawn = [self buildPawn:0 Type:TABULO_PawnFour];
    f3ViewAdaptee *plank = [self buildMediumPlank:1 Angle:270.f Hole:0];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

//  [_state.Grid sceneDidLoad:self]; // debug purpose
    
    f3GraphNode *node0 = [_state buildNode:[self getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f)];
    
    [self clearPoints];
    
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node2 Target:node0];

    fgTabuloController* gameController = [[fgTabuloController alloc] init:[[fgTabuloEvent alloc] init:EVENT_GameOver level:1 option:DIALOGOPTION_Next]];

    f3DragViewFromNode *controlPlank = [[f3DragViewFromNode alloc] initWithNode:node1 forView:plank useFlag:TABULO_HaveMediumPlank nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlank]];

    f3DragViewFromNode *controlPawn = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawn useFlag:TABULO_PawnFour nextState:[fgDragViewOverEdge class]];
    [gameController appendComponent:[[fgPawnController alloc] initState:controlPawn Home:node2]];

    return gameController;
}

- (fgTabuloController *)loadTutorialTwo:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    fgTabuloController* gameController = [[fgTabuloController alloc] init:[[fgTabuloEvent alloc] init:EVENT_GameOver level:2 option:DIALOGOPTION_Next]];

    [self addPointFrom:0 Radius:1.75f Angle:90.f];
    [self addPointFrom:1 Radius:1.75f Angle:90.f];
    [self addPointFrom:2 Radius:1.75f Angle:0.f];
    [self addPointFrom:3 Radius:1.75f Angle:0.f];
    [self computePoints];

    [self buildPillar:0];
    [self buildPillar:2];
    [self buildHouse:4 Type:TABULO_PawnFour];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background
    
    f3ViewAdaptee *pawn = [self buildPawn:0 Type:TABULO_PawnFour];
    f3ViewAdaptee *plank = [self buildSmallPlank:1 Angle:270.f Hole:0];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

//  [_state.Grid sceneDidLoad:self]; // debug purpose

    f3GraphNode *node0 = [_state buildNode:[self getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f)];

    [self clearPoints];
    
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node2 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node4 Target:node2];
    
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node1 Target:node3];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node3 Target:node1];

    f3DragViewFromNode *controlPlank = [[f3DragViewFromNode alloc] initWithNode:node1 forView:plank useFlag:TABULO_HaveSmallPlank nextState:[fgDragViewOverEdge class]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlank]];

    f3DragViewFromNode *controlPawn = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawn useFlag:TABULO_PawnFour nextState:[fgDragViewOverEdge class]];
    [gameController appendComponent:[[fgPawnController alloc] initState:controlPawn Home:node4]];
    
    return gameController;
}

- (fgTabuloController *)loadTutorialThree:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:2.5f Angle:90.f];
    [self addPointFrom:1 Radius:2.5f Angle:90.f]; // 2
    [self addPointFrom:2 Radius:1.75f Angle:45.f];
    [self addPointFrom:3 Radius:1.75f Angle:45.f]; // 4
    [self addPointFrom:2 Radius:1.75f Angle:135.f];
    [self addPointFrom:5 Radius:1.75f Angle:135.f]; // 6
    [self computePoints];
    
    [self buildPillar:0];
    [self buildPillar:2];
    [self buildPillar:4];
    [self buildHouse:6 Type:TABULO_PawnFour];
    [self buildBackground];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background
    
    f3ViewAdaptee *pawn = [self buildPawn:0 Type:TABULO_PawnFour];
    f3ViewAdaptee *plankOne = [self buildMediumPlank:1 Angle:90.f Hole:0];
    f3ViewAdaptee *plankTwo = [self buildSmallPlank:3 Angle:45.f Hole:0];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

//  [_state.Grid sceneDidLoad:self]; // debug purpose

    f3GraphNode *node0 = [_state buildNode:[self getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:1.5f];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:0.8f];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f)];

    [self clearPoints];
    
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node0 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveMediumPlank Node:node1 Origin:node2 Target:node0];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node2 Target:node4];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node3 Origin:node4 Target:node2];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node2 Target:node6];
    [self buildEdgesForPawn:TABULO_HaveSmallPlank Node:node5 Origin:node6 Target:node2];

    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node3 Target:node5];
    [self buildEdgesForPlank:TABULO_HaveSmallPlank Node:node2 Origin:node5 Target:node3];

    fgTabuloController* gameController = [[fgTabuloController alloc] init:[[fgTabuloEvent alloc] init:EVENT_GameOver level:3 option:DIALOGOPTION_Next]];
    
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node1 forView:plankOne useFlag:TABULO_HaveMediumPlank nextState:[fgDragViewOverEdge class]];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node3 forView:plankTwo useFlag:TABULO_HaveSmallPlank nextState:[fgDragViewOverEdge class]];
    
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];

    f3DragViewFromNode *controlPawn = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawn useFlag:TABULO_PawnFour nextState:[fgDragViewOverEdge class]];
    
    [gameController appendComponent:[[fgPawnController alloc] initState:controlPawn Home:node6]];
    
    return gameController;
}

- (fgTabuloController *)loadTutorialFour:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:2.5f Angle:90.f];
    [self addPointFrom:1 Radius:2.5f Angle:90.f]; // 2
    [self addPointFrom:2 Radius:2.5f Angle:210.f];
    [self addPointFrom:3 Radius:2.5f Angle:210.f]; // 4
    [self addPointFrom:4 Radius:2.5f Angle:330.f];
    [self computePoints];
    
    [self buildHouse:0 Type:TABULO_PawnOne];
    [self buildHouse:2 Type:TABULO_PawnFour];
    [self buildPillar:4];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawnOne = [self buildPawn:2 Type:TABULO_PawnOne];
    f3ViewAdaptee *pawnTwo = [self buildPawn:0 Type:TABULO_PawnFour];

    f3ViewAdaptee *plankOne = [self buildMediumPlank:1 Angle:90.f Hole:0];
    f3ViewAdaptee *plankTwo = [self buildMediumPlank:5 Angle:150.f Hole:0];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

//  [_state.Grid sceneDidLoad:self]; // debug purpose
    
    f3GraphNode *node0 = [_state buildNode:[self getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:1.5f];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:1.5f];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:1.5f];

    [self clearPoints];

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

    fgTabuloController* gameController = [[fgTabuloController alloc] init:[[fgTabuloEvent alloc] init:EVENT_GameOver level:4 option:DIALOGOPTION_Next]];
    
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node1 forView:plankOne useFlag:TABULO_HaveMediumPlank nextState:[fgDragViewOverEdge class]];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node5 forView:plankTwo useFlag:TABULO_HaveMediumPlank nextState:[fgDragViewOverEdge class]];

    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
    
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node2 forView:pawnOne useFlag:TABULO_PawnOne nextState:[fgDragViewOverEdge class]];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnTwo useFlag:TABULO_PawnFour nextState:[fgDragViewOverEdge class]];

    [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnOne Home:node0]];
    [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnTwo Home:node2]];
    
    return gameController;
}

- (fgTabuloController *)loadTutorialFive:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:1.75f Angle:180.f];
    [self addPointFrom:1 Radius:1.75f Angle:180.f]; // 2
    [self addPointFrom:2 Radius:1.75f Angle:225.f];
    [self addPointFrom:3 Radius:1.75f Angle:225.f]; // 4
    [self addPointFrom:2 Radius:1.75f Angle:135.f];
    [self addPointFrom:5 Radius:1.75f Angle:135.f]; // 6
    [self computePoints];
    
    [self buildPillar:0];
    [self buildPillar:2];
    [self buildHouse:4 Type:TABULO_PawnOne];
    [self buildHouse:6 Type:TABULO_PawnFour];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background

    f3ViewAdaptee *pawnOne = [self buildPawn:6 Type:TABULO_PawnOne];
    f3ViewAdaptee *pawnTwo = [self buildPawn:4 Type:TABULO_PawnFour];
    
    f3ViewAdaptee *plankOne = [self buildSmallPlank:1 Angle:0.f Hole:0];
    f3ViewAdaptee *plankTwo = [self buildSmallPlank:5 Angle:135.f Hole:0];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements

//  [_state.Grid sceneDidLoad:self]; // debug purpose
    
    f3GraphNode *node0 = [_state buildNode:[self getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:0.8f];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f)];
    
    [self clearPoints];
    
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
    
    fgTabuloController* gameController = [[fgTabuloController alloc] init:[[fgTabuloEvent alloc] init:EVENT_GameOver level:5 option:DIALOGOPTION_Next]];
    
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node1 forView:plankOne useFlag:TABULO_HaveSmallPlank nextState:[fgDragViewOverEdge class]];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node5 forView:plankTwo useFlag:TABULO_HaveSmallPlank nextState:[fgDragViewOverEdge class]];
    
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
    
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node6 forView:pawnOne useFlag:TABULO_PawnOne nextState:[fgDragViewOverEdge class]];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node4 forView:pawnTwo useFlag:TABULO_PawnFour nextState:[fgDragViewOverEdge class]];
    
    [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnOne Home:node4]];
    [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnTwo Home:node6]];
    
    return gameController;
}

- (fgTabuloController *)loadTutorialSix:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    [self addPointFrom:0 Radius:1.75f Angle:90.f];
    [self addPointFrom:1 Radius:1.75f Angle:90.f]; // 2
    [self addPointFrom:2 Radius:1.75f Angle:180.f];
    [self addPointFrom:3 Radius:1.75f Angle:180.f]; // 4
    [self addPointFrom:4 Radius:1.75f Angle:270.f];
    [self addPointFrom:5 Radius:1.75f Angle:270.f]; // 6
    [self addPointFrom:6 Radius:1.75f Angle:0.f];
    [self computePoints];

    [self buildHouse:0 Type:TABULO_PawnFour];
    [self buildPillar:2];
    [self buildHouse:4 Type:TABULO_PawnOne];
    [self buildPillar:6];
    [self buildBackground];
    
    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay background
    
    f3ViewAdaptee *pawnOne = [self buildPawn:4 Type:TABULO_PawnFour];
    f3ViewAdaptee *pawnTwo = [self buildPawn:0 Type:TABULO_PawnOne];
    
    f3ViewAdaptee *plankOne = [self buildSmallPlank:3 Angle:180.f Hole:0];
    f3ViewAdaptee *plankTwo = [self buildSmallPlank:5 Angle:270.f Hole:0];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // gameplay elements
    
//  [_state.Grid sceneDidLoad:self]; // debug purpose
    
    f3GraphNode *node0 = [_state buildNode:[self getPointAt:0] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node1 = [_state buildNode:[self getPointAt:1] withRadius:0.8f];
    f3GraphNode *node2 = [_state buildNode:[self getPointAt:2] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node3 = [_state buildNode:[self getPointAt:3] withRadius:0.8f];
    f3GraphNode *node4 = [_state buildNode:[self getPointAt:4] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node5 = [_state buildNode:[self getPointAt:5] withRadius:0.8f];
    f3GraphNode *node6 = [_state buildNode:[self getPointAt:6] withExtend:CGSizeMake(0.8f, 0.8f)];
    f3GraphNode *node7 = [_state buildNode:[self getPointAt:7] withRadius:0.8f];

    [self clearPoints];

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

    fgTabuloController* gameController = [[fgTabuloController alloc] init:[[fgTabuloEvent alloc] init:EVENT_GameOver level:6 option:DIALOGOPTION_Next]];
    
    f3DragViewFromNode *controlPlankOne = [[f3DragViewFromNode alloc] initWithNode:node3 forView:plankOne useFlag:TABULO_HaveSmallPlank nextState:[fgDragViewOverEdge class]];
    f3DragViewFromNode *controlPlankTwo = [[f3DragViewFromNode alloc] initWithNode:node5 forView:plankTwo useFlag:TABULO_HaveSmallPlank nextState:[fgDragViewOverEdge class]];
    
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankOne]];
    [_state appendComponent:[[f3Controller alloc] initState:controlPlankTwo]];
    
    f3DragViewFromNode *controlPawnOne = [[f3DragViewFromNode alloc] initWithNode:node4 forView:pawnOne useFlag:TABULO_PawnOne nextState:[fgDragViewOverEdge class]];
    f3DragViewFromNode *controlPawnTwo = [[f3DragViewFromNode alloc] initWithNode:node0 forView:pawnTwo useFlag:TABULO_PawnOne nextState:[fgDragViewOverEdge class]];
    
    [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnOne Home:node0]];
    [gameController appendComponent:[[fgPawnController alloc] initState:controlPawnTwo Home:node4]];
    
    return gameController;
}

@end
