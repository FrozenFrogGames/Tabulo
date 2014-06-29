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
#import "../../../Framework/Framework/View/f3ViewScene.h"
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
        lastOffset = -99.f;
        motionElapsedTime = -1.f;
        inputElapsedTime = 0.f;
        levelContainer = nil;
        levelHasMoved = false;
    }

    return self;
}

- (void)buildScene:(f3ViewBuilder *)_builder screen:(CGSize)_screen unit:(CGSize)_unit {
    
    offsetPadding = _screen.height /4 /_unit.height;

    float paddingWidth = _screen.width /6 /_unit.width;
    float iconScale, yOffset = (offsetPadding *2.f) - (offsetPadding /2.f);
    
    if (paddingWidth > offsetPadding)
    {
        iconScale = offsetPadding *0.95f;
    }
    else
    {
        iconScale = paddingWidth *0.95f;
    }

    NSUInteger index = 1;
    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
    while (index < [director getLevelCount])
    {
        float xOffset = (paddingWidth /2.f) - (paddingWidth *3.f);
        [self buildLevelIcon:_builder state:self position:CGPointMake(xOffset, yOffset) scale:iconScale level:index++];
        xOffset += paddingWidth;
        [self buildLevelIcon:_builder state:self position:CGPointMake(xOffset, yOffset) scale:iconScale level:index++];
        xOffset += paddingWidth;
        [self buildLevelIcon:_builder state:self position:CGPointMake(xOffset, yOffset) scale:iconScale level:index++];
        xOffset += paddingWidth;
        [self buildLevelIcon:_builder state:self position:CGPointMake(xOffset, yOffset) scale:iconScale level:index++];
        xOffset += paddingWidth;
        [self buildLevelIcon:_builder state:self position:CGPointMake(xOffset, yOffset) scale:iconScale level:index++];
        xOffset += paddingWidth;
        [self buildLevelIcon:_builder state:self position:CGPointMake(xOffset, yOffset) scale:iconScale level:index++];
        yOffset -= offsetPadding;
    }
    
    [_builder buildComposite:0];
    
    levelContainer = (f3ViewComposite *)[_builder top];

    currentOffset = 0.f; //-offsetPadding;
    pendingOffset = currentOffset;

    [_builder push:[f3VectorHandle buildHandleForX:0.f y:currentOffset]];
    [_builder buildDecorator:1];
    offsetDecorator = (f3OffsetDecorator *)[_builder pop];
    
    [self buildHeader:_builder height:offsetPadding width:paddingWidth];
    [_builder push:offsetDecorator];
    [self buildBackground:_builder height:offsetPadding width:paddingWidth];
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
    
    [_builder push:[f3ViewScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:CGPointMake(0.f, 0.f) withExtend:CGSizeMake(2048.f, 320.f)]];
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
    
    [_builder push:[f3ViewScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:coordonatePoint withExtend:CGSizeMake(320.f, 320.f)]];
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
    
    [_builder push:[f3ViewScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:coordonatePoint withExtend:CGSizeMake(128.f, 256.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:_scale height:(_scale *2.f)]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];
}

- (float)computeScale:(CGSize)_screen unit:(CGSize)_unit {
    
    return 1.f;
}

- (void)update:(NSTimeInterval)_elapsed owner:(f3Controller *)_owner {

    [super update:_elapsed owner:_owner];

    if (offsetDecorator != nil)
    {
        if (motionElapsedTime > -1)
        {
            motionElapsedTime += _elapsed;

            if (motionElapsedTime >= 0.3)
            {
                f3ModelHandle *model = [f3VectorHandle buildHandleForX:0.f y:pendingOffset];
                f3OffsetDecorator *decorator = [[f3OffsetDecorator alloc] initWithComponent:levelContainer Offset:model];

                if ([[f3GameDirector Director].Scene replaceComponent:offsetDecorator byComponent:decorator])
                {
                    offsetDecorator = decorator;
                }

                motionElapsedTime = -1;
            }
            else
            {
                offsetDecorator.Ratio = motionElapsedTime /0.3;
            }
        }
        
        if (inputPending)
        {
            inputElapsedTime += _elapsed;

            if (lastOffset < -99.f || motionElapsedTime > -1)
            {
                lastOffset = lastInputPoint.y;

                inputElapsedTime = 0;
            }
            else if (inputElapsedTime > 0.1f)
            {
                float delta = lastInputPoint.y -lastOffset;

                if (fabsf(delta) > 1.f)
                {
                    NSLog(@"Scroll delta: %f, elapsed: %f", delta, inputElapsedTime);

                    float translation = (delta > 0.f ? offsetPadding : -offsetPadding);

                    if (fabsf(delta) > 4.f)
                    {
                        translation *= 3.f;
                    }
                    else if (fabsf(delta) > 2.f)
                    {
                        translation *= 2.f;
                    }

                    float minPadding = -offsetPadding, maxPadding = (offsetPadding *2.f);

                    float targetOffset = pendingOffset +translation;

                    if (targetOffset < minPadding)
                    {
                        targetOffset = minPadding;
                    }
                    else if (targetOffset > maxPadding)
                    {
                        targetOffset = maxPadding;
                    }

                    if (targetOffset != pendingOffset)
                    {
                        motionElapsedTime = 0;

                        [offsetDecorator applyTranslation:[f3VectorHandle buildHandleForX:0.f y:(targetOffset -pendingOffset)]];

                        pendingOffset = targetOffset;
                    }
                }
                else if ((delta > 0.f && lastDelta < delta) || (delta < 0.f && lastDelta > delta))
                {
                    inputElapsedTime = 0.f;
                }

                lastDelta = delta;
            }
        }
    }
}

- (void)notifyInput:(CGPoint)_relativePoint type:(enum f3InputType)_type {

    if (currentOffset != pendingOffset && _type == INPUT_ENDED)
    {
        currentOffset = pendingOffset;
    }
    else if (_relativePoint.y < offsetPadding)
    {
        _relativePoint.y -= currentOffset;

        [super notifyInput:_relativePoint type:_type];
    }
    
    if (_type != INPUT_MOVED)
    {
        lastOffset = -100.f;
    }
}

- (void)notifyEvent:(f3GameEvent *)_event {
    
    if ([_event isKindOfClass:[fgTabuloEvent class]])
    {
        fgDialogState *dialogState = [[fgDialogState alloc] init:self event:(fgTabuloEvent *)_event];
        
        [[f3GameAdaptee Producer] buildDialog:[f3GameDirector Director].Builder state:dialogState];
    }
}

@end
