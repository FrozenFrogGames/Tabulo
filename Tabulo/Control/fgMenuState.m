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
        fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];

        currentScene = [[f3ViewScene alloc] init];
        
        NSUInteger index = 1;
        
        while (index < [director getLevelCount])
        {
            float offset = 1.5f -(((index -1) /6) *3.f);
            
            [self buildLevelIcon:_builder state:self position:CGPointMake(-6.25f, offset) level:index++];
            [self buildLevelIcon:_builder state:self position:CGPointMake(-3.75f, offset) level:index++];
            [self buildLevelIcon:_builder state:self position:CGPointMake(-1.25f, offset) level:index++];
            [self buildLevelIcon:_builder state:self position:CGPointMake( 1.25f, offset) level:index++];
            [self buildLevelIcon:_builder state:self position:CGPointMake( 3.75f, offset) level:index++];
            [self buildLevelIcon:_builder state:self position:CGPointMake( 6.25f, offset) level:index++];
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
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:CGPointMake(0.f, 0.f) withExtend:CGSizeMake(2048.f, 320.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    [_builder push:[f3VectorHandle buildHandleForWidth:16.f height:2.5f]];
    [_builder buildDecorator:2];
    [_builder push:[f3VectorHandle buildHandleForX:0.f y:4.75f]];
    [_builder buildDecorator:1];
}

- (void)buildLevelIcon:(f3ViewBuilder *)_builder state:(f3GameState *)_state position:(CGPoint)_position level:(NSUInteger)_level {

    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    
    bool isLevelLocked = [director isLevelLocked:_level];

    CGPoint coordonatePoint;

    if (isLevelLocked)
    {
        coordonatePoint = CGPointMake(768.f, 1152.f);
    }
    else
    {
        CGPoint leftPosition, rightPosition;

        if (_level < 10)
        {
            [self buildDigitIcon:_builder position:_position digit:_level];
        }
        else if (_level < 20)
        {
            leftPosition.x = _position.x - (_level == 11 ? 0.375f : 0.575f);
            leftPosition.y = _position.y;
            [self buildDigitIcon:_builder position:leftPosition digit:(_level / 10)];
            
            rightPosition.x = _position.x + 0.375f;
            rightPosition.y = _position.y;
            [self buildDigitIcon:_builder position:rightPosition digit:(_level % 10)];
        }
        else if (_level < 100)
        {
            leftPosition.x = _position.x - 0.5f;
            leftPosition.y = _position.y;
            [self buildDigitIcon:_builder position:leftPosition digit:(_level / 10)];

            rightPosition.x = _position.x + 0.5;
            rightPosition.y = _position.y;
            [self buildDigitIcon:_builder position:rightPosition digit:(_level % 10)];
        }

        coordonatePoint = CGPointMake(768.f, 832.f);
    }

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:coordonatePoint withExtend:CGSizeMake(320.f, 320.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    [_builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [_builder buildDecorator:2];
    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];

    if (!isLevelLocked)
    {
        f3GraphNode *node = [_state buildNode:_position withExtend:CGSizeMake(1.1f, 1.1f) writer:nil symbols:nil];
        fgTabuloEvent * event = [[fgTabuloEvent alloc] init:GAME_Play level:_level];
        fgEventOnClick *controlView = [[fgEventOnClick alloc] initWithNode:node event:event];
        [_state appendComponent:[[f3Controller alloc] initState:controlView]];
    }
}

- (void)buildDigitIcon:(f3ViewBuilder *)_builder position:(CGPoint)_position digit:(NSUInteger)_digit {

    CGPoint coordonatePoint = CGPointMake((_digit *128.f) +768.f, 320.f);

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:coordonatePoint withExtend:CGSizeMake(128.f, 256.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    [_builder push:[f3VectorHandle buildHandleForWidth:1.f/*1.0625f*/ height:2.f]];
    [_builder buildDecorator:2];
    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];
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
        fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
        f3GameAdaptee *producer = [f3GameAdaptee Producer];
        fgTabuloEvent * event = (fgTabuloEvent *)_event;

        enum fgTabuloGrade grade = [director getGradeForLevel:event.Level];

        fgDialogState *dialogState = [[fgDialogState alloc] init:self];
        [dialogState build:director.Builder event:_event.Event level:event.Level grade:grade];
        [producer switchState:dialogState];
    }
    else
    {
        [super notifyEvent:_event];
    }
}

@end
