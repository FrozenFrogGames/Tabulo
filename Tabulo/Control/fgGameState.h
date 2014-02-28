//
//  fgTabuloScene.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GameState.h"
#import "../../../Framework/Framework/View/f3ViewBuilder.h"
#import "../../../Framework/Framework/View/f3ViewScene.h"
#import "fgTabuloNode.h"
#import "fgTabuloEvent.h"

@interface fgGameState : f3GameState {

    f3ViewScene *currentScene;
    NSMutableArray *tabuloNodes;
    NSUInteger gameLevel;
    double gameOverTimer;
}

@property (readonly) int Level;

- (id)init:(f3ViewScene *)_scene level:(NSUInteger)_level;

- (void)buildMenu:(f3ViewBuilder *)_builder;

- (fgTabuloNode *)buildNode:(CGPoint)_position extend:(CGSize)_extend view:(f3ViewAdaptee *)_view type:(enum f3TabuloPawnType)_type;

@end
