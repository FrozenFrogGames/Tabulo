//
//  fgTabuloMenu.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloMenu.h"
#import "fgDialogState.h"
#import "../../../Framework/Framework/View/f3ViewBuilder.h"
#import "../../../Framework/Framework/View/f3GameScene.h"
#import "../Control/fgEventOnClick.h"

@implementation fgTabuloMenu

const NSUInteger LEVEL_COUNT = 18;

- (void)build:(f3ViewBuilder *)_builder state:(f3GameState *)_state {

    NSUInteger index = 1;

//  [_producer.Grid sceneDidLoad:self]; // debug purpose
    
    while (index < LEVEL_COUNT)
    {
        [self buildLevelGroup:_builder state:_state index:index];

        index += 6;
    }

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // group

    [self buildHeader:_builder];

    [_builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_builder popComponent]]; // header
}

- (void)buildLevelGroup:(f3ViewBuilder *)_builder state:(f3GameState *)_state index:(NSUInteger)_index {

    float offset = 1.5f -(((_index -1) /6) *3.f);

    [self buildLevelIcon:_builder state:_state atPosition:CGPointMake(-6.25f, offset) level:_index++];
    [self buildLevelIcon:_builder state:_state atPosition:CGPointMake(-3.75f, offset) level:_index++];
    [self buildLevelIcon:_builder state:_state atPosition:CGPointMake(-1.25f, offset) level:_index++];
    [self buildLevelIcon:_builder state:_state atPosition:CGPointMake( 1.25f, offset) level:_index++];
    [self buildLevelIcon:_builder state:_state atPosition:CGPointMake( 3.75f, offset) level:_index++];
    [self buildLevelIcon:_builder state:_state atPosition:CGPointMake( 6.25f, offset) level:_index++];
/*
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f)
                                       atPoint:CGPointMake(0.f, 0.f)
                                    withExtend:CGSizeMake(1920.f, 320.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_Interface]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:15.f height:2.5f]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForX:0.f y:offset]];
    [_builder buildDecorator:1];
 */
}

- (void)buildLevelIcon:(f3ViewBuilder *)_builder state:(f3GameState *)_state atPosition:(CGPoint)_position level:(NSUInteger)_level {

    enum TabuloLevelState state = (_level < 7) ? LEVELSTATE_unlocked : LEVELSTATE_locked;

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

    if (_level < 7)
    {
        f3GraphNode *node = [_state buildNode:_position withExtend:CGSizeMake(1.1f, 1.1f)];
        fgTabuloEvent * event = [[fgTabuloEvent alloc] init:EVENT_StartGame level:_level option:DIALOGOPTION_Play];
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
    
    if (orientationIsPortrait)
    {
        [_builder push:[f3VectorHandle buildHandleForX:0.f y:6.5f]];
    }
    else
    {
        [_builder push:[f3VectorHandle buildHandleForX:0.f y:4.5f]];
    }
    
    [_builder buildDecorator:1];
}

@end
