//
//  fgTabuloMenu.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloMenu.h"
#import "../../../Framework/Framework/View/f3ViewBuilder.h"
#import "../../../Framework/Framework/View/f3GameScene.h"
#import "../Control/fgEventOnClick.h"

@implementation fgTabuloMenu

enum TabuloLevelState {

    LEVELSTATE_unlocked,
    LEVELSTATE_locked,
    LEVELSTATE_bronze,
    LEVELSTATE_silver,
    LEVELSTATE_gold
};

enum TabuloDialogItem {
    
    DIALOGITEM_Reset,
    DIALOGITEM_Play,
    DIALOGITEM_Next,
    DIALOGITEM_Menu
};

- (f3ViewComposite *)buildDialog:(fgTabuloEvent *)_event director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer {

    f3GraphNode *itemNode;
    fgTabuloEvent *itemEvent;
    fgEventOnClick *itemState;

    switch (_event.Option) {

        case DIALOGOPTION_Play:

            [self buildDialogItem:DIALOGITEM_Play atPosition:CGPointMake(0.f, -2.f) director:_director producer:_producer];

            itemNode = [_producer buildNode:CGPointMake(0.f, -2.f) withExtend:CGSizeMake(1.f, 1.f)];
            itemEvent = [[fgTabuloEvent alloc] init:EVENT_StartGame level:_event.Level dialog:DIALOGOPTION_Play];
            itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];

            [_producer appendComponent:[[f3Controller alloc] initState:itemState]];
            break;

        case DIALOGOPTION_Next:

            [self buildDialogItem:DIALOGITEM_Reset atPosition:CGPointMake(-2.f, -2.f) director:_director producer:_producer];

            itemNode = [_producer buildNode:CGPointMake(-2.f, -2.f) withExtend:CGSizeMake(1.f, 1.f)];
            itemEvent = [[fgTabuloEvent alloc] init:EVENT_StartGame level:_event.Level dialog:DIALOGOPTION_Play];
            itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];

            [_producer appendComponent:[[f3Controller alloc] initState:itemState]];

            [self buildDialogItem:DIALOGITEM_Next atPosition:CGPointMake(0.f, -2.f) director:_director producer:_producer];

            itemNode = [_producer buildNode:CGPointMake(0.f, -2.f) withExtend:CGSizeMake(1.f, 1.f)];
            itemEvent = [[fgTabuloEvent alloc] init:EVENT_StartGame level:(_event.Level +1) dialog:DIALOGOPTION_Play];
            itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
            
            [_producer appendComponent:[[f3Controller alloc] initState:itemState]];
            break;

        case DIALOGOPTION_Pause:
            [self buildDialogItem:DIALOGITEM_Reset atPosition:CGPointMake(-2.f, -2.f) director:_director producer:_producer];
            [self buildDialogItem:DIALOGITEM_Play atPosition:CGPointMake(0.f, -2.f) director:_director producer:_producer];
            break;
    }

    
    [self buildDialogItem:DIALOGITEM_Menu atPosition:CGPointMake(2.f, -2.f) director:_director producer:_producer];
    
    itemNode = [_producer buildNode:CGPointMake(2.f, -2.f) withExtend:CGSizeMake(1.f, 1.f)];
    itemEvent = [[fgTabuloEvent alloc] init:EVENT_Menu];
    itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
    
    [_producer appendComponent:[[f3Controller alloc] initState:itemState]];

    [self buildDialogBox:_director];

    [_director.Builder buildComposite:0];

    f3ViewComposite *dialog = [_director.Builder top];

    [self appendComposite:(f3ViewComposite *)[_director.Builder popComponent]]; // dialog box

    return dialog;
}

- (void)buildDialogItem:(enum TabuloDialogItem)_option atPosition:(CGPoint)_position director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer {

    CGPoint coordonatePoint;
    CGSize buttonSize;
    float radius;

    switch (_option) {

        case DIALOGITEM_Reset:
            coordonatePoint = CGPointMake(1728.f, 320.f);
            buttonSize = CGSizeMake(192.f, 192.f);
            radius = 1.5f;
            break;

        case DIALOGITEM_Play:
            coordonatePoint = CGPointMake(1408.f, 704.f);
            buttonSize = CGSizeMake(256.f, 256.f);
            radius = 2.f;
            break;

        case DIALOGITEM_Next:
            coordonatePoint = CGPointMake(1664.f, 704.f);
            buttonSize = CGSizeMake(256.f, 256.f);
            radius = 2.f;
            break;

        case DIALOGITEM_Menu:
            coordonatePoint = CGPointMake(1728.f, 512.f);
            buttonSize = CGSizeMake(192.f, 192.f);
            radius = 1.5f;
            break;
    }

    f3ViewBuilder *builder = [_director Builder];

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];

    [builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f)
                                         atPoint:coordonatePoint
                                      withExtend:buttonSize]];
    [builder push:[_director getResourceIndex:RESOURCE_Interface]];
    [builder buildDecorator:4];

    [builder push:[f3VectorHandle buildHandleForWidth:radius height:radius]];
    [builder buildDecorator:2];

    [builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [builder buildDecorator:1];
}

- (void)buildDialogBox:(fgTabuloDirector *)_director {
    
    f3ViewBuilder *builder = [_director Builder];
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    [builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f)
                                         atPoint:CGPointMake(0.f, 320.f)
                                      withExtend:CGSizeMake(768.f, 896.f)]];
    [builder push:[_director getResourceIndex:RESOURCE_Interface]];
    [builder buildDecorator:4];
    
    [builder push:[f3VectorHandle buildHandleForWidth:6.f height:7.f]];
    [builder buildDecorator:2];

    [builder push:[f3VectorHandle buildHandleForX:0.f y:0.f]];
    [builder buildDecorator:1];
}

- (void)buildMenu:(NSUInteger)_count director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer {

    NSUInteger index = 1;

//  [_producer.Grid sceneDidLoad:self]; // debug purpose
    
    while (index < _count)
    {
        [self buildLevelGroup:index director:_director producer:_producer];

        index += 6;
    }
    
//  [self buildBackground];

    [_director.Builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_director.Builder popComponent]]; // group

    [self buildHeader:_director];

    [_director.Builder buildComposite:0];
    [self appendComposite:(f3ViewComposite *)[_director.Builder popComponent]]; // header
}

- (void)buildLevelGroup:(NSUInteger)_index director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer {

    f3ViewBuilder *builder = [_director Builder];

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    float offset = 1.5f -(((_index -1) /6) *3.f);

    [self buildLevelIcon:_index++ atPosition:CGPointMake(-6.25f, offset) director:_director producer:_producer];
    [self buildLevelIcon:_index++ atPosition:CGPointMake(-3.75f, offset) director:_director producer:_producer];
    [self buildLevelIcon:_index++ atPosition:CGPointMake(-1.25f, offset) director:_director producer:_producer];
    [self buildLevelIcon:_index++ atPosition:CGPointMake( 1.25f, offset) director:_director producer:_producer];
    [self buildLevelIcon:_index++ atPosition:CGPointMake( 3.75f, offset) director:_director producer:_producer];
    [self buildLevelIcon:_index++ atPosition:CGPointMake( 6.25f, offset) director:_director producer:_producer];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    [builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f)
                                       atPoint:CGPointMake(0.f, 0.f)
                                    withExtend:CGSizeMake(1920.f, 320.f)]];
    [builder push:[_director getResourceIndex:RESOURCE_Interface]];
    [builder buildDecorator:4];
    
    [builder push:[f3VectorHandle buildHandleForWidth:15.f height:2.5f]];
    [builder buildDecorator:2];
    
    [builder push:[f3VectorHandle buildHandleForX:0.f y:offset]];
    [builder buildDecorator:1];
}

- (void)buildLevelIcon:(NSUInteger)_index atPosition:(CGPoint)_position director:(fgTabuloDirector *)_director producer:(f3GameAdaptee *)_producer {

    enum TabuloLevelState state = (_index < 7) ? LEVELSTATE_unlocked : LEVELSTATE_locked;

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

    f3ViewBuilder *builder = [_director Builder];
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    [builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f)
                                       atPoint:coordonatePoint
                                    withExtend:CGSizeMake(320.f, 320.f)]];
    [builder push:[_director getResourceIndex:RESOURCE_Interface]];
    [builder buildDecorator:4];

    [builder push:[f3VectorHandle buildHandleForWidth:2.5f height:2.5f]];
    [builder buildDecorator:2];

    [builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [builder buildDecorator:1];

    if (_index < 7)
    {
        f3GraphNode *node = [_producer buildNode:_position withExtend:CGSizeMake(1.1f, 1.1f)];

        fgEventOnClick *controlView = [[fgEventOnClick alloc] initWithNode:node event:[[fgTabuloEvent alloc] init:EVENT_StartGame level:_index dialog:DIALOGOPTION_Play]];

        [_producer appendComponent:[[f3Controller alloc] initState:controlView]];
    }
}

- (void)buildHeader:(fgTabuloDirector *)_director {
    
    f3ViewBuilder *builder = [_director Builder];
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [builder push:indicesHandle];
    [builder push:vertexHandle];
    [builder buildAdaptee:DRAW_TRIANGLES];
    
    [builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f)
                                       atPoint:CGPointMake(0.f, 1216.f)
                                    withExtend:CGSizeMake(2048.f, 320.f)]];
    [builder push:[_director getResourceIndex:RESOURCE_Interface]];
    [builder buildDecorator:4];
    
    [builder push:[f3VectorHandle buildHandleForWidth:16.f height:3.f]];
    [builder buildDecorator:2];
    
    if (orientationIsPortrait)
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
