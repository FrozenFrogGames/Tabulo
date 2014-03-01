//
//  fgTabuloScene.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgGameState.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/View/f3GameScene.h"
#import "../Control/fgEventOnClick.h"
#import "fgTabuloDirector.h"
#import "fgTabuloEvent.h"
#import "fgDialogState.h"

@implementation fgGameState

const NSUInteger LEVEL_MAXIMUM = 18;
const NSUInteger LEVEL_LOCKED = 7;

enum TabuloLevelState {
    
    LEVELSTATE_unlocked,
    LEVELSTATE_locked,
    LEVELSTATE_bronze,
    LEVELSTATE_silver,
    LEVELSTATE_gold
};

- (id)init {

    self = [super init];

    if (self != nil)
    {
        currentScene = nil;
        tabuloNodes = nil;
        gameLevel = 0;
        gameOverTimer = 0.0;
    }

    return self;
}

- (id)init:(f3ViewScene *)_scene level:(NSUInteger)_level {

    self = [super init];

    if (self != nil)
    {
        currentScene = _scene;
        tabuloNodes = [NSMutableArray array];
        gameLevel = _level;
        gameOverTimer = 2.0;
    }

    return self;
}

- (void)buildMenu:(f3ViewBuilder *)_builder {

    if (currentScene == nil && tabuloNodes == nil)
    {
        currentScene = [[f3ViewScene alloc] init];
        
        NSUInteger index = 1;
        
        while (index < LEVEL_MAXIMUM)
        {
            float offset = 1.5f -(((index -1) /6) *3.f);
            
            [self buildLevelIcon:_builder state:self atPosition:CGPointMake(-6.25f, offset) level:index++];
            [self buildLevelIcon:_builder state:self atPosition:CGPointMake(-3.75f, offset) level:index++];
            [self buildLevelIcon:_builder state:self atPosition:CGPointMake(-1.25f, offset) level:index++];
            [self buildLevelIcon:_builder state:self atPosition:CGPointMake( 1.25f, offset) level:index++];
            [self buildLevelIcon:_builder state:self atPosition:CGPointMake( 3.75f, offset) level:index++];
            [self buildLevelIcon:_builder state:self atPosition:CGPointMake( 6.25f, offset) level:index++];
        }

        [_builder buildComposite:0];
        [currentScene appendComposite:(f3ViewComposite *)[_builder popComponent]]; // levels
        
        [self buildHeader:_builder];
        
        [_builder buildComposite:0];
        [currentScene appendComposite:(f3ViewComposite *)[_builder popComponent]]; // header
    }
    else
    {
        // throw f3Exception
    }
}

- (void)buildLevelIcon:(f3ViewBuilder *)_builder state:(f3GameState *)_state atPosition:(CGPoint)_position level:(NSUInteger)_level {
    
    enum TabuloLevelState state = (_level < LEVEL_LOCKED) ? LEVELSTATE_unlocked : LEVELSTATE_locked;
    
    CGPoint coordonatePoint;
    
    switch (state) {
            
        case LEVELSTATE_unlocked:
            coordonatePoint = CGPointMake(768.f, 640.f);
            break;
            
        case LEVELSTATE_locked:
            coordonatePoint = CGPointMake(1088.f, 640.f);
            break;
            
        case LEVELSTATE_bronze:
            coordonatePoint = CGPointMake(768.f, 320.f);
            break;
            
        case LEVELSTATE_silver:
            coordonatePoint = CGPointMake(1088.f, 320.f);
            break;
            
        case LEVELSTATE_gold:
            coordonatePoint = CGPointMake(1408.f, 320.f);
            break;
    }
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f) atPoint:coordonatePoint withExtend:CGSizeMake(320.f, 320.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_Interface]];
    [_builder buildDecorator:4];
    [_builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [_builder buildDecorator:2];
    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];
    
    if (_level < LEVEL_LOCKED)
    {
        f3GraphNode *node = [_state buildNode:_position withExtend:CGSizeMake(1.1f, 1.1f)];
        fgTabuloEvent * event = [[fgTabuloEvent alloc] init:GAME_Play level:_level];
        fgEventOnClick *controlView = [[fgEventOnClick alloc] initWithNode:node event:event];
        [_state appendComponent:[[f3Controller alloc] initState:controlView]]; // TODO use level controller
    }
}

- (void)buildHeader:(f3ViewBuilder *)_builder {
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f) atPoint:CGPointMake(0.f, 1216.f) withExtend:CGSizeMake(2048.f, 320.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_Interface]];
    [_builder buildDecorator:4];
    [_builder push:[f3VectorHandle buildHandleForWidth:16.f height:3.f]];
    [_builder buildDecorator:2];
    [_builder push:[f3VectorHandle buildHandleForX:0.f y:4.5f]];
    [_builder buildDecorator:1];
}

- (void)begin:(f3ControllerState *)_previousState owner:(f3Controller *)_owner {
    
    if (currentScene != nil)
    {
        [[f3GameDirector Director] loadScene:currentScene];
    }
}

- (void)update:(NSTimeInterval)_elapsed owner:(f3Controller *)_owner {
    
    [super update:_elapsed owner:_owner];

    if (gameLevel > 0)
    {
        for (fgTabuloNode *node in tabuloNodes)
        {
            if (![node IsPawnHome])
            {
                gameOverTimer = 0.5;
                break;
            }
        }

        gameOverTimer -= _elapsed;
        
        if (gameOverTimer < 0.0)
        {
            f3GameDirector *director = [f3GameDirector Director];
            f3GameAdaptee *producer = [f3GameAdaptee Producer];
            
            if (gameLevel < (LEVEL_LOCKED -1))
            {
                fgDialogState *dialogState = [[fgDialogState alloc] init:self];
                [dialogState build:director.Builder event:GAME_Next level:gameLevel];
                [producer switchState:dialogState];
            }
            else
            {
                fgGameState *nextState = [[fgGameState alloc] init];
                [nextState buildMenu:director.Builder];
                [producer switchState:nextState];
            }
        }
    }
}

- (void)end:(f3ControllerState *)_nextState owner:(f3Controller *)_owner {

    currentScene = nil;
    tabuloNodes = nil;
}

- (fgTabuloNode *)buildNode:(CGPoint)_position extend:(CGSize)_extend view:(f3ViewAdaptee *)_view type:(enum f3TabuloPawnType)_type {

    fgTabuloNode *node = [[fgTabuloNode alloc] initPosition:_position extend:_extend view:_view type:_type];

    [grid appendNode:node];

    [tabuloNodes addObject:node];

    return node;
}

- (void)notifyEvent:(f3GameEvent *)_event {

    f3GameDirector *director = [f3GameDirector Director];
    f3GameAdaptee *producer = [f3GameAdaptee Producer];

    if (_event.Event != GAME_Over && [_event isKindOfClass:[fgTabuloEvent class]])
    {
        fgTabuloEvent * event = (fgTabuloEvent *)_event;

        fgDialogState *dialogState = [[fgDialogState alloc] init:self];
        [dialogState build:director.Builder event:event.Event level:event.Level];
        [producer switchState:dialogState];
    }
    else
    {
        fgGameState *nextState = [[fgGameState alloc] init];
        [nextState buildMenu:director.Builder];
        [producer switchState:nextState];
    }
}

@end
