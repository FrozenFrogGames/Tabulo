//
//  fgTabuloScene.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GameState.h"
#import "../../../Framework/Framework/Control/f3GraphCondition.h"
#import "../../../Framework/Framework/Control/f3ControlCommand.h"
#import "../../../Framework/Framework/View/f3ViewBuilder.h"
#import "../../../Framework/Framework/View/f3ViewScene.h"
#import "../../../Framework/Framework/View/f3OffsetDecorator.h"
#import "../../../Framework/Framework/IDataAdapter.h"
#import "fgTabuloEvent.h"
#import "fgTabuloDirector.h"

@class fgHouseNode;

@interface fgLevelState : f3GameState {

    f3ViewScene *currentScene;
    NSUInteger levelIndex, minimumPathLength;
    enum fgTabuloGrade levelGrade;
    NSMutableArray *solutions;
    bool hintEnable;
    f3ViewComposite *hintLayer;
    f3ControlCommand *hintCommand;
    f3GraphEdge *hintEdge;
}

@property (readonly) int Level;

- (id)init:(f3ViewScene *)_scene level:(NSUInteger)_level;

- (void)bindSolution:(f3GraphConfig *)_config;
- (void)buildPauseButtton:(f3ViewBuilder *)_builder atPosition:(CGPoint)_position level:(NSUInteger)_level;

- (f3GraphNode *)buildHouseNode:(NSObject<IDataAdapter> *)_data symbols:(NSMutableArray *)_symbols;
- (fgHouseNode *)buildHouseNode:(CGPoint)_position extend:(CGSize)_extend writer:(NSObject<IDataAdapter> *)_writer symbols:(NSMutableArray *)_symbols;

@end
