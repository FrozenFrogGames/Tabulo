//
//  fgTabuloEditor.h
//  Tabulo
//
//  Created by Serge Menard on 2014-06-23.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloDirector.h"
#import "fgDataAdapter.h"
#import "fgHouseNode.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GraphNodeStrategy.h"
#import "../../../Framework/Framework/View/f3GameScene.h"

@interface fgTabuloScene : f3GameScene

- (void)buildComposite:(fgTabuloDirector *)_director writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols;

- (void)buildBackground:(fgTabuloDirector *)_director writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols;

- (void)buildPillar:(fgTabuloDirector *)_director node:(f3GraphNode *)_node writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols;

- (void)buildHouse:(fgTabuloDirector *)_director node:(fgHouseNode *)_node type:(enum f3TabuloPawnType)_type state:(f3GraphNodeStrategy *)_state writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols;

- (void)buildDragPawnControl:(fgTabuloDirector *)_director state:(f3GraphNodeStrategy *)_state node:(f3GraphNode *)_node view:(f3ViewAdaptee *)_view writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols;

- (void)buildDragPlankControl:(fgTabuloDirector *)_director state:(f3GraphNodeStrategy *)_state node:(f3GraphNode *)_node view:(f3ViewAdaptee *)_view writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols;

- (f3ViewAdaptee *)buildPawn:(fgTabuloDirector *)_director state:(f3GraphNodeStrategy *)_state node:(f3GraphNode *)_node type:(enum f3TabuloPawnType)_type writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols;

- (f3ViewAdaptee *)buildSmallPlank:(fgTabuloDirector *)_director state:(f3GraphNodeStrategy *)_state node:(f3GraphNode *)_node angle:(float)_angle hole:(enum f3TabuloHoleType)_hole writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols;

- (f3ViewAdaptee *)buildMediumPlank:(fgTabuloDirector *)_director state:(f3GraphNodeStrategy *)_state node:(f3GraphNode *)_node angle:(float)_angle hole:(enum f3TabuloHoleType)_hole writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols;

- (void)buildEdgesForPawn:(fgTabuloDirector *)_director type:(enum f3TabuloPlankType)_type node:(f3GraphNode *)_node origin:(f3GraphNode *)_origin target:(f3GraphNode *)_target writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols;

- (void)buildEdgesForPlank:(fgTabuloDirector *)_director type:(enum f3TabuloPlankType)_type node:(f3GraphNode *)_node origin:(f3GraphNode *)_origin target:(f3GraphNode *)_target writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols;

@end
