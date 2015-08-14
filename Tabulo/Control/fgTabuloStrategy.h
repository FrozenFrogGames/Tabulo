//
//  fgTabuloScene.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GraphNodeStrategy.h"
#import "../../../Framework/Framework/Control/f3GraphEdgeCondition.h"
#import "../../../Framework/Framework/Control/f3ControlCommand.h"
#import "../../../Framework/Framework/View/f3ViewBuilder.h"
#import "../../../Framework/Framework/View/f3ViewScene.h"
#import "../../../Framework/Framework/View/f3OffsetDecorator.h"
#import "../../../Framework/Framework/IDataAdapter.h"
#import "../View/fgTabuloDirector.h"
#import "fgTabuloEvent.h"

@class fgHouseNode;
@class f3GraphSchema;
@class f3GraphEdgeWithRotationNode;

@interface fgTabuloStrategy : f3GraphNodeStrategy {

    NSUInteger levelIndex;
    enum fgTabuloGrade levelGrade;
    f3ControlCommand *hintCommand;
    bool hintEnable;
}

@property (readonly) int Level;

- (id)init:(NSUInteger)_level;

- (f3GraphNode *)buildHouseNode:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols;
- (fgHouseNode *)buildHouseNode:(CGPoint)_position extend:(CGSize)_extend writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols;

+ (f3ViewAdaptee *)buildPawn:(f3ViewBuilder *)_builder node:(f3GraphNode *)_node strategy:(f3GraphNodeStrategy *)_strategy opacity:(float)_opacity;
+ (f3ViewAdaptee *)buildPlank:(f3ViewBuilder *)_builder edge:(f3GraphEdgeWithRotationNode *)_edge strategy:(f3GraphNodeStrategy *)_strategy opacity:(float)_opacity;

@end
