//
//  fgMenuState.m
//  Tabulo
//
//  Created by Serge Menard on 2014-03-30.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgMenuState.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3TranslationCommand.h"
#import "../../../Framework/Framework/Control/f3SetOffsetCommand.h"
#import "../../../Framework/Framework/Control/f3SetScaleCommand.h"
#import "../../../Framework/Framework/Control/f3ZoomCommand.h"
#import "../../../Framework/Framework/View/f3GameScene.h"
#import "../Control/fgEventOnClick.h"
#import "fgTabuloDirector.h"
#import "fgTabuloEvent.h"
#import "fgDialogState.h"
#import "fgHouseNode.h"

@implementation fgMenuState

const NSUInteger LEVEL_MAXIMUM = 18;
const NSUInteger LEVEL_LOCKED = 19;

- (id)init {
    
    self = [super init];
    
    if (self != nil)
    {
        currentScene = nil;
        offsetDecorator = nil;
        verticalOffset = 0.25f;
    }
    
    return self;
}

- (void)buildMenu:(f3ViewBuilder *)_builder {
    
    if (currentScene == nil)
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
        [_builder push:[f3VectorHandle buildHandleForX:0.f y:verticalOffset]];
        [_builder buildDecorator:1];
        offsetDecorator = (f3OffsetDecorator *)[_builder top];
        
        [self buildHeader:_builder];
        [self buildBackground:_builder];

        [_builder buildComposite:0];
        [currentScene appendComposite:(f3ViewComposite *)[_builder popComponent]]; // header
    }
    else
    {
        // throw f3Exception
    }
}

- (void)buildBackground:(f3ViewBuilder *)_builder {
    
    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    
    f3IntegerArray *background = [director getResourceIndex:RESOURCE_BackgroundMenu];
    
    if (background != nil)
    {
        f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
        
        f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                      FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
        [_builder push:indicesHandle];
        [_builder push:vertexHandle];
        [_builder buildAdaptee:DRAW_TRIANGLES];
        
        [_builder push:[f3FloatArray buildHandleForFloat32:8,
                       FLOAT_BOX(0.f), FLOAT_BOX(0.f), FLOAT_BOX(1.f), FLOAT_BOX(0.f),
                       FLOAT_BOX(0.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), FLOAT_BOX(1.f), nil]];
        [_builder push:background];
        [_builder buildDecorator:4];
/*
        [_builder push:[f3VectorHandle buildHandleForWidth:16.f height:12.f]];
        [_builder buildDecorator:2];
 */
        [_builder push:[f3VectorHandle buildHandleForWidth:16.f height:9.5f]];
        [_builder buildDecorator:2];
        [_builder push:[f3VectorHandle buildHandleForX:0.f y:-1.25f]];
        [_builder buildDecorator:1];
    }
}

- (void)buildHeader:(f3ViewBuilder *)_builder {

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f) atPoint:CGPointMake(0.f, 1216.f) withExtend:CGSizeMake(2048.f, 320.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    [_builder push:[f3VectorHandle buildHandleForWidth:16.f height:2.5f]];
    [_builder buildDecorator:2];
    [_builder push:[f3VectorHandle buildHandleForX:0.f y:4.75f]];
    [_builder buildDecorator:1];
}

- (void)buildLevelIcon:(f3ViewBuilder *)_builder state:(f3GameState *)_state atPosition:(CGPoint)_position level:(NSUInteger)_level {
/*
    enum TabuloLevelState state = (_level < LEVEL_LOCKED) ? LEVELSTATE_unlocked : LEVELSTATE_locked;
    
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
 */
    CGPoint coordonatePoint = (_level < LEVEL_LOCKED) ? CGPointMake(768.f, 640.f) : CGPointMake(1088.f, 640.f);
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f) atPoint:coordonatePoint withExtend:CGSizeMake(320.f, 320.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
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
        [_state appendComponent:[[f3Controller alloc] initState:controlView]];
    }
}

- (void)begin:(f3ControllerState *)_previousState owner:(f3Controller *)_owner {
    
    if (currentScene != nil)
    {
        [[f3GameDirector Director] loadScene:currentScene];
    }
}

- (void)notifyInput:(CGPoint)_relativePoint type:(enum f3InputType)_type {
    
    _relativePoint.y -= verticalOffset;
    
    [super notifyInput:_relativePoint type:_type];
}

- (void)notifyEvent:(f3GameEvent *)_event {
    
    if (_event.Event < GAME_EVENT_MAX && [_event isKindOfClass:[fgTabuloEvent class]])
    {
        f3GameDirector *director = [f3GameDirector Director];
        f3GameAdaptee *producer = [f3GameAdaptee Producer];

        fgDialogState *dialogState = [[fgDialogState alloc] init:self];
        [dialogState build:director.Builder event:_event.Event level:((fgTabuloEvent *)_event).Level grade:GRADE_none];
        [producer switchState:dialogState];
    }
    else
    {
        [super notifyEvent:_event];
    }
}

@end
