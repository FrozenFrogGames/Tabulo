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
        offsetDecorator = nil;
    }
    
    return self;
}

- (void)buildScene:(f3ViewBuilder *)_builder screen:(CGSize)_screen unit:(CGSize)_unit {

    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];

    NSUInteger index = 1;

    float paddingHeight = _screen.height /4 /_unit.height;
    float yOffset = (paddingHeight *2.f) - (paddingHeight /2.f);
    float paddingWidth = _screen.width /6 /_unit.width;
    while (index < [director getLevelCount])
    {
        float xOffset = (paddingWidth /2.f) - (paddingWidth *3.f);
        [self buildLevelIcon:_builder state:self position:CGPointMake(xOffset, yOffset) scale:(paddingWidth *0.95f) level:index++];
        xOffset += paddingWidth;
        [self buildLevelIcon:_builder state:self position:CGPointMake(xOffset, yOffset) scale:(paddingWidth *0.95f) level:index++];
        xOffset += paddingWidth;
        [self buildLevelIcon:_builder state:self position:CGPointMake(xOffset, yOffset) scale:(paddingWidth *0.95f) level:index++];
        xOffset += paddingWidth;
        [self buildLevelIcon:_builder state:self position:CGPointMake(xOffset, yOffset) scale:(paddingWidth *0.95f) level:index++];
        xOffset += paddingWidth;
        [self buildLevelIcon:_builder state:self position:CGPointMake(xOffset, yOffset) scale:(paddingWidth *0.95f) level:index++];
        xOffset += paddingWidth;
        [self buildLevelIcon:_builder state:self position:CGPointMake(xOffset, yOffset) scale:(paddingWidth *0.95f) level:index++];
        yOffset -= paddingHeight;
    }

    [_builder buildComposite:0];

    verticalOffset = -paddingHeight;
    [_builder push:[f3VectorHandle buildHandleForX:0.f y:verticalOffset]];
    [_builder buildDecorator:1];
    offsetDecorator = (f3OffsetDecorator *)[_builder pop];

    [self buildHeader:_builder height:paddingHeight width:paddingWidth];
    [_builder push:offsetDecorator];
    [self buildBackground:_builder height:paddingHeight width:paddingWidth];
    [_builder buildComposite:0];

    f3ViewScene *currentScene = [[f3ViewScene alloc] init];
    [currentScene appendComposite:(f3ViewComposite *)[_builder popComponent]];
    [director loadScene:currentScene];
}

- (void)buildBackground:(f3ViewBuilder *)_builder height:(float)_height width:(float)_width {

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

        [_builder push:[f3VectorHandle buildHandleForWidth:(_width *6) height:(_height *3)]];
        [_builder buildDecorator:2];

        [_builder push:[f3VectorHandle buildHandleForX:0.f y:(_height /-2.f)]];
        [_builder buildDecorator:1];
    }
}

- (void)buildHeader:(f3ViewBuilder *)_builder height:(float)_height width:(float)_width {

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];

    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:CGPointMake(0.f, 0.f) withExtend:CGSizeMake(2048.f, 320.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];

    [_builder push:[f3VectorHandle buildHandleForWidth:(_width *6) height:_height]];
    [_builder buildDecorator:2];

    [_builder push:[f3VectorHandle buildHandleForX:0.f y:(_height /2.f +_height)]];
    [_builder buildDecorator:1];
}

- (void)buildLevelIcon:(f3ViewBuilder *)_builder state:(f3GameState *)_state position:(CGPoint)_position scale:(float)_scale level:(NSUInteger)_level {

    bool isLevelLocked = [(fgTabuloDirector *)[f3GameDirector Director] isLevelLocked:_level];
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
            [self buildDigitIcon:_builder position:_position scale:(_scale *0.4f) digit:_level];
        }
        else if (_level < 20)
        {
            leftPosition.x = _position.x - (_scale *(_level == 11 ? 0.15f : 0.25f));
            leftPosition.y = _position.y;
            [self buildDigitIcon:_builder position:leftPosition scale:(_scale *0.4f) digit:(_level /10)];
            
            rightPosition.x = _position.x + (_scale *0.15f);
            rightPosition.y = _position.y;
            [self buildDigitIcon:_builder position:rightPosition scale:(_scale *0.4f) digit:(_level % 10)];
        }
        else if (_level < 100)
        {
            leftPosition.x = _position.x - (_scale /5.f);
            leftPosition.y = _position.y;
            [self buildDigitIcon:_builder position:leftPosition scale:(_scale *0.4f) digit:(_level / 10)];

            rightPosition.x = _position.x + (_scale /5.f);
            rightPosition.y = _position.y;
            [self buildDigitIcon:_builder position:rightPosition scale:(_scale *0.4f) digit:(_level % 10)];
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

    [_builder push:[f3VectorHandle buildHandleForWidth:_scale height:_scale]];
    [_builder buildDecorator:2];

    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];

    if (!isLevelLocked)
    {
        f3GraphNode *node = [_state buildNode:_position withExtend:CGSizeMake(_scale *.45, _scale *.45) writer:nil symbols:nil];
        fgTabuloEvent * event = [[fgTabuloEvent alloc] init:GAME_Play level:_level];
        fgEventOnClick *controlView = [[fgEventOnClick alloc] initWithNode:node event:event];
        [_state appendComponent:[[f3Controller alloc] initState:controlView]];
    }
}

- (void)buildDigitIcon:(f3ViewBuilder *)_builder position:(CGPoint)_position scale:(float)_scale digit:(NSUInteger)_digit {

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];

    CGPoint coordonatePoint = CGPointMake((_digit *128.f) +768.f, 320.f);
    
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:coordonatePoint withExtend:CGSizeMake(128.f, 256.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];

    [_builder push:[f3VectorHandle buildHandleForWidth:_scale height:(_scale *2.f)]];
    [_builder buildDecorator:2];

    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];
}
/*
- (void)update:(NSTimeInterval)_elapsed owner:(f3Controller *)_owner {

    [super update:_elapsed owner:_owner];

    if (fabsf(lastInputPoint.y - lastOffsetPoint.y) > 5.f)
    {
        lastOffsetPoint =  lastInputPoint;
    }
}
 */
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
