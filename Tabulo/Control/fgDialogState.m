//
//  fgDialogState.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GraphNode.h"
#import "../../../Framework/Framework/View/f3GameDirector.h"
#import "../../../Framework/Framework/View/f3GameScene.h"
#import "fgGameState.h"
#import "fgDialogState.h"
#import "fgTabuloDirector.h"
#import "fgEventOnClick.h"
#import "fgTabuloTutorial.h"
#import "fgTabuloLevel01.h"

@implementation fgDialogState

enum TabuloDialogItem {

    DIALOGITEM_Reset,
    DIALOGITEM_Play,
    DIALOGITEM_Next,
    DIALOGITEM_Menu
};

- (id)init:(f3GameState *)_previousState {

    self = [super init];

    if (self != nil)
    {
        previousState = _previousState;
    }

    return self;
}

- (void)build:(f3ViewBuilder *)_builder event:(enum f3GameEvent)_event level:(NSUInteger)_level {

    if (_event != GAME_Over)
    {
        f3GraphNode *itemNode;
        f3GameEvent *itemEvent;
        fgEventOnClick *itemState;

        switch (_event) {
                
            case GAME_Next:
                
                [self buildDialogItem:_builder atPosition:CGPointMake(-2.f, -2.f) option:DIALOGITEM_Reset];
                itemNode = [self buildNode:CGPointMake(-2.f, -2.f) withExtend:CGSizeMake(1.f, 1.f)];
                itemEvent = [[fgTabuloEvent alloc] init:GAME_Play level:_level];
                itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
                [controls appendComponent:[[f3Controller alloc] initState:itemState]];
                
                [self buildDialogItem:_builder atPosition:CGPointMake(0.f, -2.f) option:DIALOGITEM_Next];
                itemNode = [self buildNode:CGPointMake(0.f, -2.f) withExtend:CGSizeMake(1.f, 1.f)];
                itemEvent = [[fgTabuloEvent alloc] init:GAME_Next level:_level];
                itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
                [controls appendComponent:[[f3Controller alloc] initState:itemState]];
                
                [self buildDialogItem:_builder atPosition:CGPointMake(2.f, -2.f) option:DIALOGITEM_Menu];
                itemNode = [self buildNode:CGPointMake(2.f, -2.f) withExtend:CGSizeMake(1.f, 1.f)];
                itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:[[f3GameEvent alloc] init]];
                [controls appendComponent:[[f3Controller alloc] initState:itemState]];
                
                break;

            case GAME_Play:
                
                [self buildDialogItem:_builder atPosition:CGPointMake(0.f, -2.f) option:DIALOGITEM_Play];
                itemNode = [self buildNode:CGPointMake(0.f, -2.f) withExtend:CGSizeMake(1.f, 1.f)];
                itemEvent = [[fgTabuloEvent alloc] init:GAME_Play level:_level];
                itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
                [controls appendComponent:[[f3Controller alloc] initState:itemState]];
                
                [self buildDialogItem:_builder atPosition:CGPointMake(2.f, -2.f) option:DIALOGITEM_Menu];
                itemNode = [self buildNode:CGPointMake(2.f, -2.f) withExtend:CGSizeMake(1.f, 1.f)];
                itemEvent = [[fgTabuloEvent alloc] init:GAME_Pause level:0];
                itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
                [controls appendComponent:[[f3Controller alloc] initState:itemState]];

                break;
                
            case GAME_Pause:
                
                [self buildDialogItem:_builder atPosition:CGPointMake(-2.f, -2.f) option:DIALOGITEM_Reset];
                itemNode = [self buildNode:CGPointMake(0.f, -2.f) withExtend:CGSizeMake(1.f, 1.f)];
                itemEvent = [[fgTabuloEvent alloc] init:GAME_Play level:_level];
                itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
                [controls appendComponent:[[f3Controller alloc] initState:itemState]];
                
                [self buildDialogItem:_builder atPosition:CGPointMake(0.f, -2.f) option:DIALOGITEM_Play];
                itemNode = [self buildNode:CGPointMake(0.f, -2.f) withExtend:CGSizeMake(1.f, 1.f)];
                itemEvent = [[fgTabuloEvent alloc] init:GAME_Pause level:0];
                itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
                [controls appendComponent:[[f3Controller alloc] initState:itemState]];
                
                [self buildDialogItem:_builder atPosition:CGPointMake(2.f, -2.f) option:DIALOGITEM_Menu];
                itemNode = [self buildNode:CGPointMake(2.f, -2.f) withExtend:CGSizeMake(1.f, 1.f)];
                itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:[[f3GameEvent alloc] init]];
                [controls appendComponent:[[f3Controller alloc] initState:itemState]];

                break;
                
            case GAME_Over: // nothing
                break;
        }

        [self buildDialogBox:_builder];
        [_builder buildComposite:0];

        dialogLayer = (f3ViewComposite *)[_builder pop];
    }
    else
    {
        dialogLayer = nil;
    }
}

- (void)buildDialogItem:(f3ViewBuilder *)_builder atPosition:(CGPoint)_position option:(enum TabuloDialogItem)_option {
    
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
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f)
                                          atPoint:coordonatePoint
                                       withExtend:buttonSize]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_Interface]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:radius height:radius]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];
}

- (void)buildDialogBox:(f3ViewBuilder *)_builder {
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForValues:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForValues:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1536.f)
                                          atPoint:CGPointMake(0.f, 320.f)
                                       withExtend:CGSizeMake(768.f, 896.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_Interface]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:6.f height:7.f]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForX:0.f y:0.f]];
    [_builder buildDecorator:1];
}

- (void)begin:(f3ControllerState *)_previousState owner:(f3Controller *)_owner {

    if (dialogLayer != nil)
    {
        [[f3GameDirector Director].Scene appendComposite:dialogLayer];
    }
}

- (void)end:(f3ControllerState *)_nextState owner:(f3Controller *)_owner {

    [[f3GameDirector Director].Scene removeComposite:dialogLayer];
    
    dialogLayer = nil;
}

- (void)notifyEvent:(f3GameEvent *)_event {
    
    f3GameAdaptee *producer = [f3GameAdaptee Producer];
    f3GameDirector *director = [f3GameDirector Director];
    
    if (_event.Event != GAME_Over && [_event isKindOfClass:[fgTabuloEvent class]])
    {
        fgTabuloEvent *event = (fgTabuloEvent *)_event;
        fgTabuloLevel *nextScene = nil;
        fgGameState *nextState = nil;
        
        NSUInteger nextLevel = event.Level;
        switch (event.Event) {

            case GAME_Next:
                ++nextLevel;

            case GAME_Play:

                if (nextLevel < 7)
                {
                    nextScene = [[fgTabuloTutorial alloc] init];
                }
                else if (nextLevel < 13)
                {
                    nextScene = [[fgTabuloLevel01 alloc] init];
                }

                nextState = [[fgGameState alloc] init:nextScene level:nextLevel];
                [nextScene build:director.Builder state:nextState level:nextLevel];
                [producer switchState:nextState];
                break;

            case GAME_Pause:

                [producer switchState:previousState];
                break;
        }
    }
    else
    {
        fgGameState *nextState = [[fgGameState alloc] init];
        [nextState buildMenu:director.Builder];
        [producer switchState:nextState];
    }
}

@end
