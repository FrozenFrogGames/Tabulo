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
#import "fgLevelState.h"
#import "fgMenuState.h"
#import "fgDialogState.h"
#import "fgTabuloDirector.h"
#import "fgEventOnClick.h"
#import "fgTabuloLevel.h"

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

- (void)build:(f3ViewBuilder *)_builder event:(enum f3GameEvent)_event level:(NSUInteger)_level grade:(enum fgTabuloGrade)_grade {

    f3GraphNode *itemNode;
    f3GameEvent *itemEvent;
    fgEventOnClick *itemState;
    
    if (_event >= GAME_EVENT_MAX)
    {
        // TODO throw f3Exception
        
        _event = GAME_EVENT_MAX;
    }

    switch (_event) {
            
        case GAME_Over:
            
            [self buildDialogItem:_builder atPosition:CGPointMake(-1.8f, -2.f) option:DIALOGITEM_Reset];
            itemNode = [self buildNode:CGPointMake(-1.8f, -2.f) withExtend:CGSizeMake(1.f, 1.f) writer:nil symbols:nil];
            itemEvent = [[fgTabuloEvent alloc] init:GAME_Play level:_level];
            itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
            [controls appendComponent:[[f3Controller alloc] initState:itemState]];
            
            [self buildDialogItem:_builder atPosition:CGPointMake(1.8f, -2.f) option:DIALOGITEM_Menu];
            itemNode = [self buildNode:CGPointMake(1.8f, -2.25f) withExtend:CGSizeMake(1.f, 1.f) writer:nil symbols:nil];
            itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:[[f3GameEvent alloc] init]];
            [controls appendComponent:[[f3Controller alloc] initState:itemState]];
            
            break;
            
        case GAME_Next:

            [self buildDialogItem:_builder atPosition:CGPointMake(-1.8f, -2.f) option:DIALOGITEM_Reset];
            itemNode = [self buildNode:CGPointMake(-1.8f, -2.f) withExtend:CGSizeMake(1.f, 1.f) writer:nil symbols:nil];
            itemEvent = [[fgTabuloEvent alloc] init:GAME_Play level:_level];
            itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
            [controls appendComponent:[[f3Controller alloc] initState:itemState]];
            
            [self buildDialogItem:_builder atPosition:CGPointMake(0.f, -2.f) option:DIALOGITEM_Next];
            itemNode = [self buildNode:CGPointMake(0.f, -2.f) withExtend:CGSizeMake(1.f, 1.f) writer:nil symbols:nil];
            itemEvent = [[fgTabuloEvent alloc] init:GAME_Next level:_level];
            itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
            [controls appendComponent:[[f3Controller alloc] initState:itemState]];

            [self buildDialogItem:_builder atPosition:CGPointMake(1.8f, -2.f) option:DIALOGITEM_Menu];
            itemNode = [self buildNode:CGPointMake(1.8f, -2.f) withExtend:CGSizeMake(1.f, 1.f) writer:nil symbols:nil];
            itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:[[f3GameEvent alloc] init]];
            [controls appendComponent:[[f3Controller alloc] initState:itemState]];
            
            break;

        case GAME_Play:

            [self buildDialogItem:_builder atPosition:CGPointMake(0.f, -2.f) option:DIALOGITEM_Play];
            itemNode = [self buildNode:CGPointMake(0.f, -2.f) withExtend:CGSizeMake(1.f, 1.f) writer:nil symbols:nil];
            itemEvent = [[fgTabuloEvent alloc] init:GAME_Play level:_level];
            itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
            [controls appendComponent:[[f3Controller alloc] initState:itemState]];
            
            [self buildDialogItem:_builder atPosition:CGPointMake(1.8f, -2.f) option:DIALOGITEM_Menu];
            itemNode = [self buildNode:CGPointMake(1.8f, -2.f) withExtend:CGSizeMake(1.f, 1.f) writer:nil symbols:nil];
            itemEvent = [[fgTabuloEvent alloc] init:GAME_Pause level:0];
            itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
            [controls appendComponent:[[f3Controller alloc] initState:itemState]];

            break;
            
        case GAME_Pause:

            if ([previousState HaveConfig])
            {
                [self buildDialogItem:_builder atPosition:CGPointMake(-1.8f, -2.f) option:DIALOGITEM_Reset];
                itemNode = [self buildNode:CGPointMake(-1.8f, -2.f) withExtend:CGSizeMake(1.f, 1.f) writer:nil symbols:nil];
                itemEvent = [[fgTabuloEvent alloc] init:GAME_Play level:_level];
                itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
                [controls appendComponent:[[f3Controller alloc] initState:itemState]];
            }
            
            [self buildDialogItem:_builder atPosition:CGPointMake(0.f, -2.f) option:DIALOGITEM_Play];
            itemNode = [self buildNode:CGPointMake(0.f, -2.f) withExtend:CGSizeMake(1.f, 1.f) writer:nil symbols:nil];
            itemEvent = [[fgTabuloEvent alloc] init:GAME_Pause level:0];
            itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:itemEvent];
            [controls appendComponent:[[f3Controller alloc] initState:itemState]];

            [self buildDialogItem:_builder atPosition:CGPointMake(1.8f, -2.f) option:DIALOGITEM_Menu];
            itemNode = [self buildNode:CGPointMake(1.8f, -2.f) withExtend:CGSizeMake(1.f, 1.f) writer:nil symbols:nil];
            itemState = [[fgEventOnClick alloc] initWithNode:itemNode event:[[f3GameEvent alloc] init]];
            [controls appendComponent:[[f3Controller alloc] initState:itemState]];

            break;
            
        case GAME_EVENT_MAX:
            dialogLayer = nil;
            return;
    }

    [self buildTitle:_builder level:_level];
    [self buildDialogGrade:_builder grade:_grade];
    [self buildDialogBox:_builder];
    [_builder buildComposite:0];

    dialogLayer = (f3ViewComposite *)[_builder pop];
}

- (void)buildDialogItem:(f3ViewBuilder *)_builder atPosition:(CGPoint)_position option:(enum TabuloDialogItem)_option {
    
    CGPoint coordonatePoint;
    CGSize buttonSize;
    float radius;
    
    switch (_option) {
            
        case DIALOGITEM_Reset:
            coordonatePoint = CGPointMake(1664.f, 1088.f);
            buttonSize = CGSizeMake(192.f, 192.f);
            radius = 1.5f;
            break;
            
        case DIALOGITEM_Play:
            coordonatePoint = CGPointMake(1536.f, 576.f);
            buttonSize = CGSizeMake(256.f, 256.f);
            radius = 2.f;
            break;
            
        case DIALOGITEM_Next:
            coordonatePoint = CGPointMake(1536.f, 832.f);
            buttonSize = CGSizeMake(256.f, 256.f);
            radius = 2.f;
            break;
            
        case DIALOGITEM_Menu:
            coordonatePoint = CGPointMake(1664.f, 1280.f);
            buttonSize = CGSizeMake(192.f, 192.f);
            radius = 1.5f;
            break;
    }
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:coordonatePoint withExtend:buttonSize]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:radius height:radius]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];
}

- (void)buildTitle:(f3ViewBuilder *)_builder level:(NSUInteger)_level {

    if (_level < 10)
    {
        [self buildDigitIcon:_builder position:CGPointMake(0.f, 1.f) digit:_level];
    }
    else if (_level < 20)
    {
        [self buildDigitIcon:_builder position:(_level == 11 ? CGPointMake(-0.375f, 1.f) : CGPointMake(-0.375f, 1.f)) digit:(_level / 10)];

        [self buildDigitIcon:_builder position:CGPointMake(0.375f, 1.f) digit:(_level % 10)];
    }
    else if (_level < 100)
    {
        [self buildDigitIcon:_builder position:CGPointMake(-0.5f, 1.f) digit:(_level / 10)];

        [self buildDigitIcon:_builder position:CGPointMake(0.5f, 1.f) digit:(_level % 10)];
    }

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:CGPointMake(768.f, 576.f) withExtend:CGSizeMake(768.f, 256.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];

    [_builder push:[f3VectorHandle buildHandleForWidth:4.5f height:1.5f]];
    [_builder buildDecorator:2];

    [_builder push:[f3VectorHandle buildHandleForX:0.f y:2.4f]];
    [_builder buildDecorator:1];
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
    [_builder push:[f3VectorHandle buildHandleForWidth:0.75f height:1.5f]];
    [_builder buildDecorator:2];
    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];
}

- (void)buildDialogGrade:(f3ViewBuilder *)_builder grade:(enum fgTabuloGrade)_grade {

    switch (_grade) {

        case GRADE_none:
            [self buildDialogStar:_builder atPosition:CGPointMake(-1.5f, -0.25f) option:GRADE_none];
            [self buildDialogStar:_builder atPosition:CGPointMake(0.f, -0.25f) option:GRADE_none];
            [self buildDialogStar:_builder atPosition:CGPointMake(1.5f, -0.25f) option:GRADE_none];
            break;
            
        case GRADE_bronze:
            [self buildDialogStar:_builder atPosition:CGPointMake(-1.5f, -0.25f) option:GRADE_bronze];
            [self buildDialogStar:_builder atPosition:CGPointMake(0.f, -0.25f) option:GRADE_none];
            [self buildDialogStar:_builder atPosition:CGPointMake(1.5f, -0.25f) option:GRADE_none];
            break;
            
        case GRADE_silver:
            [self buildDialogStar:_builder atPosition:CGPointMake(-1.5f, -0.25f) option:GRADE_silver];
            [self buildDialogStar:_builder atPosition:CGPointMake(0.f, -0.25f) option:GRADE_silver];
            [self buildDialogStar:_builder atPosition:CGPointMake(1.5f, -0.25f) option:GRADE_none];
            break;
            
        case GRADE_gold:
            [self buildDialogStar:_builder atPosition:CGPointMake(-1.5f, -0.25f) option:GRADE_gold];
            [self buildDialogStar:_builder atPosition:CGPointMake(0.f, -0.25f) option:GRADE_gold];
            [self buildDialogStar:_builder atPosition:CGPointMake(1.5f, -0.25f) option:GRADE_gold];
            break;
    }
}

- (void)buildDialogStar:(f3ViewBuilder *)_builder atPosition:(CGPoint)_position option:(enum fgTabuloGrade)_grade {
    
    CGPoint coordonatePoint;
    
    switch (_grade) {
            
        case GRADE_none:
            coordonatePoint = CGPointMake(1536.f, 1088.f);
            break;

        case GRADE_bronze:
        case GRADE_silver:
        case GRADE_gold:
            coordonatePoint = CGPointMake(1408.f, 1088.f);
            break;
    }
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];

    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:coordonatePoint withExtend:CGSizeMake(128.f, 128.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:1.f height:1.f]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:_position.x height:_position.y]];
    [_builder buildDecorator:1];
}

- (void)buildDialogBox:(f3ViewBuilder *)_builder {

    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];

    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];

    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    [_builder push:[f3GameScene computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:CGPointMake(0.f, 320.f) withExtend:CGSizeMake(768.f, 896.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
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

    if (_event.Event < GAME_EVENT_MAX)
    {
        f3GameAdaptee *producer = [f3GameAdaptee Producer];
        f3GameDirector *director = [f3GameDirector Director];
        
        if ([_event isKindOfClass:[fgTabuloEvent class]])
        {
            fgTabuloEvent *event = (fgTabuloEvent *)_event;
            
            if (event.Event == GAME_Over)
            {
                fgMenuState *nextState = [[fgMenuState alloc] init];
                [nextState buildMenu:director.Builder];
                [producer switchState:nextState];
            }
            else
            {
                if (event.Event == GAME_Pause)
                {
                    [producer switchState:previousState];
                }
                else
                {
                    fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
                    fgLevelState *nextState = nil;

                    NSUInteger nextLevel = event.Level;
                    if (event.Event == GAME_Next)
                    {
                        ++nextLevel; // increment level before to trigger play
                    }

                    NSString *filename = [@"DATA" stringByAppendingString:[NSString stringWithFormat:@"%04lu",(unsigned long)nextLevel]];
                    fgDataAdapter *dataWriter = [[fgDataAdapter alloc] initWithName:filename fromBundle:true];

                    if (dataWriter == nil)
                    {
                        fgTabuloScene *nextScene = [[fgTabuloLevel alloc] init];

                        nextState = [[fgLevelState alloc] init:nextScene level:nextLevel];
                        
                        [nextScene build:director.Builder state:nextState level:nextLevel];
                    }
                    else
                    {
                        nextState = [[fgLevelState alloc] init:nil level:nextLevel];
                        
                        [director buildScene:dataWriter state:(fgLevelState *)nextState level:nextLevel];
                    }

                    if (nextState != nil)
                    {
                        [producer switchState:nextState];
                        [nextState buildPauseButtton:director.Builder atPosition:CGPointMake(-7.f, -5.f) level:nextLevel];
                        [director buildComposite];
                    }
                }
            }
        }
        else
        {
            fgMenuState *nextState = [[fgMenuState alloc] init];
            [nextState buildMenu:director.Builder];
            [producer switchState:nextState];
        }
    }
    else
    {
        [super notifyEvent:_event];
    }
}

@end
