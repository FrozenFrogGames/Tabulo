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
#import "../../../Framework/Framework/IDataAdapter.h"
#import "fgTabuloEvent.h"

@class fgHouseNode;

@interface fgGameState : f3GameState {

    f3ViewScene *currentScene;
    NSUInteger gameLevel, goldPathLength;
    NSMutableArray *solutions;
    bool hintEnable;
    f3ViewComposite *hintLayer;
    f3ControlCommand *hintCommand;
    f3GraphEdge *hintEdge;
}

@property (readonly) int Level;

- (id)init:(f3ViewScene *)_scene level:(NSUInteger)_level;

- (void)bindSolution:(f3GraphConfig *)_config;
- (void)buildMenu:(f3ViewBuilder *)_builder;

- (f3GraphNode *)buildHouseNode:(NSObject<IDataAdapter> *)_data;
- (fgHouseNode *)buildHouseNode:(CGPoint)_position extend:(CGSize)_extend;

@end
