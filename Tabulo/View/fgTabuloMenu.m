//
//  fgTabuloMenu.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloMenu.h"
#import "../../../Framework/Framework/View/f3ViewBuilder.h"
#import "../Control/fgClickViewOnLevel.h"

@implementation fgTabuloMenu

enum TabuloLevelState {

    LEVELSTATE_unlocked,
    LEVELSTATE_locked,
    LEVELSTATE_bronze,
    LEVELSTATE_silver,
    LEVELSTATE_gold
};

+ (void)buildDialog:(enum f3TabuloDialogOptions)_options director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer {

}

+ (void)buildMenu:(NSUInteger)_count director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer {

    NSUInteger index = 1;

//  [_producer.Grid sceneDidLoad:_director.Scene]; // debug purpose
    
    while (index < _count)
    {
        [self buildLevelGroup:index director:_director producer:_producer];

        index += 6;
    }

    [_director.Builder buildComposite:0];
    [_director.Scene appendComposite:(f3ViewComposite *)[_director.Builder popComponent]]; // group

    [self buildHeader:_director];

    [_director.Builder buildComposite:0];
    [_director.Scene appendComposite:(f3ViewComposite *)[_director.Builder popComponent]]; // header
}

+ (void)buildLevelGroup:(NSUInteger)_index director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer {

    f3ViewBuilder *builder = [_director Builder];
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    if ([_director OrientationIsPortrait])
    {
        float offset = 1.875f -(((_index -1) /6) *5.6875f);

        [self buildLevelIcon:_index++ atPosition:CGPointMake(-2.375f, 1.1875f +offset) director:_director producer:_producer];
        [self buildLevelIcon:_index++ atPosition:CGPointMake(0.f, 1.1875f +offset) director:_director producer:_producer];
        [self buildLevelIcon:_index++ atPosition:CGPointMake(2.375f, 1.1875f +offset) director:_director producer:_producer];
        [self buildLevelIcon:_index++ atPosition:CGPointMake(-2.375f, -1.1875f +offset) director:_director producer:_producer];
        [self buildLevelIcon:_index++ atPosition:CGPointMake(0.f, -1.1875f +offset) director:_director producer:_producer];
        [self buildLevelIcon:_index++ atPosition:CGPointMake(2.375f, -1.1875f +offset) director:_director producer:_producer];
        
        [builder push:indicesHandle];
        [builder push:vertexHandle];
        [builder buildAdaptee:DRAW_TRIANGLES];
        
        [builder push:[f3GameLevel computeCoordonate:CGSizeMake(2048.f, 2048.f)
                                           atPoint:CGPointMake(0.f, 768.f)
                                        withExtend:CGSizeMake(1024.f, 704.f)]];
        [builder push:[_director getResourceIndex:RESOURCE_UserInterface]];
        [builder buildDecorator:4];
        
        [builder push:[f3VectorHandle buildHandleForWidth:8.f height:5.5f]];
        [builder buildDecorator:2];
        
        [builder push:[f3VectorHandle buildHandleForX:0.f y:offset]];
        [builder buildDecorator:1];
    }
    else
    {
        float offset = 1.125f -(((_index -1) /6) *3.1875f);

        [self buildLevelIcon:_index++ atPosition:CGPointMake(-5.9375f, offset) director:_director producer:_producer];
        [self buildLevelIcon:_index++ atPosition:CGPointMake(-3.5625f, offset) director:_director producer:_producer];
        [self buildLevelIcon:_index++ atPosition:CGPointMake(-1.1875f, offset) director:_director producer:_producer];
        [self buildLevelIcon:_index++ atPosition:CGPointMake( 1.1875f, offset) director:_director producer:_producer];
        [self buildLevelIcon:_index++ atPosition:CGPointMake( 3.5625f, offset) director:_director producer:_producer];
        [self buildLevelIcon:_index++ atPosition:CGPointMake( 5.9375f, offset) director:_director producer:_producer];

        [builder push:indicesHandle];
        [builder push:vertexHandle];
        [builder buildAdaptee:DRAW_TRIANGLES];
        
        [builder push:[f3GameLevel computeCoordonate:CGSizeMake(2048.f, 2048.f)
                                           atPoint:CGPointMake(0.f, 384.f)
                                        withExtend:CGSizeMake(1920.f, 384.f)]];
        [builder push:[_director getResourceIndex:RESOURCE_UserInterface]];
        [builder buildDecorator:4];
        
        [builder push:[f3VectorHandle buildHandleForWidth:15.f height:3.f]];
        [builder buildDecorator:2];
        
        [builder push:[f3VectorHandle buildHandleForX:0.f y:offset]];
        [builder buildDecorator:1];
    }
}

+ (void)buildLevelIcon:(NSUInteger)_index atPosition:(CGPoint)_position director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer {

    enum TabuloLevelState state = (_index < 7) ? LEVELSTATE_unlocked : LEVELSTATE_locked;

    f3ViewBuilder *builder = [_director Builder];

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];

    f3ViewAdaptee *view = (f3ViewAdaptee *)[builder top];

    CGPoint coordonatePoint;

    switch (state) {

        case LEVELSTATE_unlocked:
            coordonatePoint = CGPointMake(0.f, 1472.f);
            break;
            
        case LEVELSTATE_locked:
            coordonatePoint = CGPointMake(256.f, 1472.f);
            break;

        case LEVELSTATE_bronze:
            coordonatePoint = CGPointMake(0.f, 1728.f);
            break;
            
        case LEVELSTATE_silver:
            coordonatePoint = CGPointMake(256.f, 1728.f);
            break;
            
        case LEVELSTATE_gold:
            coordonatePoint = CGPointMake(512.f, 1728.f);
            break;
    }

    [builder push:[f3GameLevel computeCoordonate:CGSizeMake(2048.f, 2048.f)
                                       atPoint:coordonatePoint
                                    withExtend:CGSizeMake(256.f, 256.f)]];
    [builder push:[_director getResourceIndex:RESOURCE_UserInterface]];
    [builder buildDecorator:4];

    [builder push:[f3VectorHandle buildHandleForWidth:2.f height:2.f]];
    [builder buildDecorator:2];

    [builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [builder buildDecorator:1];
    
    f3GraphNode *node = [_producer buildNode:_position withExtend:CGSizeMake(1.1f, 1.1f)];

    fgClickViewOnLevel *controlView = [[fgClickViewOnLevel alloc] initForView:view onNode:node forLevel:_index];

    [_producer appendComponent:[[f3Controller alloc] initState:controlView]];
}

+ (void)buildHeader:(fgTabuloDirector *)_director {
    
    f3ViewBuilder *builder = [_director Builder];
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    [builder push:[f3GameLevel computeCoordonate:CGSizeMake(2048.f, 2048.f)
                                       atPoint:CGPointMake(0.f, 0.f)
                                    withExtend:CGSizeMake(2048.f, 384.f)]];
    [builder push:[_director getResourceIndex:RESOURCE_UserInterface]];
    [builder buildDecorator:4];
    
    [builder push:[f3VectorHandle buildHandleForWidth:16.f height:3.f]];
    [builder buildDecorator:2];
    
    if ([_director OrientationIsPortrait])
    {
        [builder push:[f3VectorHandle buildHandleForX:0.f y:6.5f]];
    }
    else
    {
        [builder push:[f3VectorHandle buildHandleForX:0.f y:4.5f]];
    }
    
    [builder buildDecorator:1];
}

@end
