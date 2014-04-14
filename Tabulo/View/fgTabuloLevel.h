//
//  fgTabuloLevel.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../View/fgTabuloDirector.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/View/f3GameScene.h"
#import "fgHouseNode.h"
#import "fgDataAdapter.h"

@interface fgTabuloLevel : f3GameScene {
    
    f3AngleDecorator *backgroundRotation;
    fgDataAdapter *dataWriter;
    NSMutableArray *dataSymbols;
}

- (void)build:(f3ViewBuilder *)_builder state:(f3GameState *)_state level:(NSUInteger)_level;

- (void)buildComposite;
- (void)buildBackground;
- (void)buildPillar:(f3GraphNode *)_node;
- (void)buildHouse:(fgHouseNode *)_node type:(enum f3TabuloPawnType)_type state:(f3GameState *)_state;
- (void)buildDragControl:(f3GameState *)_state node:(f3GraphNode *)_node view:(f3ViewAdaptee *)_view;

- (f3ViewAdaptee *)buildPawn:(f3GraphNode *)_node type:(enum f3TabuloPawnType)_type;
- (f3ViewAdaptee *)buildSmallPlank:(f3GraphNode *)_node angle:(float)_angle hole:(enum f3TabuloHoleType)_hole;
- (f3ViewAdaptee *)buildMediumPlank:(f3GraphNode *)_node angle:(float)_angle hole:(enum f3TabuloHoleType)_hole;

- (void)buildEdgesForPawn:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target;
- (void)buildEdgesForPlank:(enum f3TabuloPlankType)_type Node:(f3GraphNode *)_node Origin:(f3GraphNode *)_origin Target:(f3GraphNode *)_target;

@end
