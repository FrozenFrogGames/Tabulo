//
//  fgTabuloScene.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GraphSchemaStrategy.h"
#import "../../../Framework/Framework/Control/f3GraphCondition.h"
#import "../../../Framework/Framework/Control/f3ControlSequence.h"
#import "../../../Framework/Framework/View/f3ViewBuilder.h"
#import "../../../Framework/Framework/View/f3ViewScene.h"
#import "../../../Framework/Framework/View/f3OffsetDecorator.h"
#import "../../../Framework/Framework/IDataAdapter.h"
#import "fgTabuloDirector.h"
#import "fgTabuloEvent.h"

@class fgHouseNode;
@class f3GraphSchema;
@class f3GraphEdgeWithRotationNode;

@interface fgTabuloStrategy : f3GraphSchemaStrategy {

    NSUInteger levelIndex;
    enum fgTabuloGrade levelGrade;
    f3ControlSequence *hintCommand;
}

@property (readonly) int Level;

- (id)init:(NSUInteger)_level;
- (void)buildFeedbackLayer:(f3ViewBuilder *)_builder edges:(NSArray *)_edges;

+ (f3ViewAdaptee *)buildHelperPawn:(f3ViewBuilder *)_builder edge:(f3GraphEdge *)_node schema:(f3GraphSchema *)_schema opacity:(float)_opacity;
+ (f3ViewAdaptee *)buildHelperPlank:(f3ViewBuilder *)_builder edge:(f3GraphEdgeWithRotationNode *)_edge schema:(f3GraphSchema *)_schema opacity:(float)_opacity;

@end
