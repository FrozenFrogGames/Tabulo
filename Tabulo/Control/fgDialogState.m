//
//  fgDialogState.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgDialogState.h"
#import "fgTabuloStrategy.h"
#import "fgMenuState.h"
#import "../fgTabuloDirector.h"
#import "../fgDataAdapter.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GraphNode.h"
#import "../../../Framework/Framework/Control/f3EventButtonState.h"
#import "../../../Framework/Framework/View/f3GameDirector.h"
#import "../../../Framework/Framework/View/f3DrawScene.h"
#import "../../../Framework/Framework/View/f3ViewAdaptee.h"

@implementation fgDialogState

enum TabuloDialogItem {
    
    DIALOGITEM_Reset,
    DIALOGITEM_Play,
    DIALOGITEM_Next,
    DIALOGITEM_Menu
};

- (id)initWithEvent:(f3GameFlowEvent *)_event {
    
    self = [super init];
    
    if (self != nil)
    {
        dialogEvent = _event;
    }
    
    return self;
}

- (void)buildSceneLayer:(f3ViewBuilder *)_builder screen:(CGSize)_screen unit:(CGSize)_unit scale:(float)_scale {
    
    f3GraphNode *itemNode;
    f3GameFlowEvent *itemEvent;
    f3EventButtonState *itemState;

    if (dialogEvent.Event < GAME_EVENT_MAX)
    {
        dialogScale = _screen.height /_unit.height /_scale;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            dialogScale /= 9.f;
        }
        else
        {
            dialogScale /= 12.f;
        }

        switch (dialogEvent.Event)
        {
            case GAME_Over:
                
                [self buildDialogItem:_builder atPosition:CGPointMake(-1.8f, -2.f) option:DIALOGITEM_Reset];
                itemNode = [[f3GraphNode alloc] init:CGPointMake(-1.8f *dialogScale, -2.f *dialogScale) extend:CGSizeMake(dialogScale * 0.75f, dialogScale * 0.75f)];
                [gameStrategy appendTouchListener:itemNode];
                itemEvent = [[f3GameFlowEvent alloc] init:GAME_Play level:dialogEvent.Level];
                itemState = [[f3EventButtonState alloc] initWithNode:itemNode event:itemEvent];
                [gameStrategy appendGameController:[[f3Controller alloc] initWithState:itemState]];

                [self buildDialogItem:_builder atPosition:CGPointMake(1.8f, -2.f) option:DIALOGITEM_Menu];
                itemNode = [[f3GraphNode alloc] init:CGPointMake(1.8f *dialogScale, -2.f *dialogScale) extend:CGSizeMake(dialogScale * 0.75f, dialogScale * 0.75f)];
                [gameStrategy appendTouchListener:itemNode];
                itemEvent = [[f3GameFlowEvent alloc] init:GAME_Over level:dialogEvent.Level];
                itemState = [[f3EventButtonState alloc] initWithNode:itemNode event:itemEvent];
                [gameStrategy appendGameController:[[f3Controller alloc] initWithState:itemState]];
                
                break;
                
            case GAME_Next:
                
                [self buildDialogItem:_builder atPosition:CGPointMake(-1.8f, -2.f) option:DIALOGITEM_Reset];
                itemNode = [[f3GraphNode alloc] init:CGPointMake(-1.8f *dialogScale, -2.f *dialogScale) extend:CGSizeMake(dialogScale * 0.75f, dialogScale * 0.75f)];
                [gameStrategy appendTouchListener:itemNode];
                itemEvent = [[f3GameFlowEvent alloc] init:GAME_Play level:dialogEvent.Level];
                itemState = [[f3EventButtonState alloc] initWithNode:itemNode event:itemEvent];
                [gameStrategy appendGameController:[[f3Controller alloc] initWithState:itemState]];
                
                [self buildDialogItem:_builder atPosition:CGPointMake(0.f, -2.f) option:DIALOGITEM_Next];
                itemNode = [[f3GraphNode alloc] init:CGPointMake(0.f, -2.f *dialogScale) extend:CGSizeMake(dialogScale, dialogScale)];
                [gameStrategy appendTouchListener:itemNode];
                itemEvent = [[f3GameFlowEvent alloc] init:GAME_Next level:dialogEvent.Level];
                itemState = [[f3EventButtonState alloc] initWithNode:itemNode event:itemEvent];
                [gameStrategy appendGameController:[[f3Controller alloc] initWithState:itemState]];
                
                [self buildDialogItem:_builder atPosition:CGPointMake(1.8f, -2.f) option:DIALOGITEM_Menu];
                itemNode = [[f3GraphNode alloc] init:CGPointMake(1.8f *dialogScale, -2.f *dialogScale) extend:CGSizeMake(dialogScale * 0.75f, dialogScale * 0.75f)];
                [gameStrategy appendTouchListener:itemNode];
                itemEvent = [[f3GameFlowEvent alloc] init:GAME_Over level:dialogEvent.Level];
                itemState = [[f3EventButtonState alloc] initWithNode:itemNode event:itemEvent];
                [gameStrategy appendGameController:[[f3Controller alloc] initWithState:itemState]];
                
                break;
                
            case GAME_Play:
                
                [self buildDialogItem:_builder atPosition:CGPointMake(0.f, -2.f) option:DIALOGITEM_Play];
                itemNode = [[f3GraphNode alloc] init:CGPointMake(0.f, -2.f *dialogScale) extend:CGSizeMake(dialogScale, dialogScale)];
                [gameStrategy appendTouchListener:itemNode];
                itemEvent = [[f3GameFlowEvent alloc] init:GAME_Play level:dialogEvent.Level];
                itemState = [[f3EventButtonState alloc] initWithNode:itemNode event:itemEvent];
                [gameStrategy appendGameController:[[f3Controller alloc] initWithState:itemState]];
                
                [self buildDialogItem:_builder atPosition:CGPointMake(1.8f, -2.f) option:DIALOGITEM_Menu];
                itemNode = [[f3GraphNode alloc] init:CGPointMake(1.8f *dialogScale, -2.f *dialogScale) extend:CGSizeMake(dialogScale * 0.75f, dialogScale * 0.75f)];
                [gameStrategy appendTouchListener:itemNode];
                itemEvent = [[f3GameFlowEvent alloc] init:GAME_Pause level:0];
                itemState = [[f3EventButtonState alloc] initWithNode:itemNode event:itemEvent];
                [gameStrategy appendGameController:[[f3Controller alloc] initWithState:itemState]];
                
                break;

            case GAME_Pause:

                if (TRUE) // TODO hide reset option if no action has been performed
                {
                    [self buildDialogItem:_builder atPosition:CGPointMake(-1.8f, -2.f) option:DIALOGITEM_Reset];
                    itemNode = [[f3GraphNode alloc] init:CGPointMake(-1.8f *dialogScale, -2.f *dialogScale) extend:CGSizeMake(dialogScale * 0.75f, dialogScale * 0.75f)];
                    [gameStrategy appendTouchListener:itemNode];
                    itemEvent = [[f3GameFlowEvent alloc] init:GAME_Play level:dialogEvent.Level];
                    itemState = [[f3EventButtonState alloc] initWithNode:itemNode event:itemEvent];
                    [gameStrategy appendGameController:[[f3Controller alloc] initWithState:itemState]];
                }

                [self buildDialogItem:_builder atPosition:CGPointMake(0.f, -2.f) option:DIALOGITEM_Play];
                itemNode = [[f3GraphNode alloc] init:CGPointMake(0.f, -2.f *dialogScale) extend:CGSizeMake(dialogScale, dialogScale)];
                [gameStrategy appendTouchListener:itemNode];
                itemEvent = [[f3GameFlowEvent alloc] init:GAME_Pause level:0];
                itemState = [[f3EventButtonState alloc] initWithNode:itemNode event:itemEvent];
                [gameStrategy appendGameController:[[f3Controller alloc] initWithState:itemState]];
                
                [self buildDialogItem:_builder atPosition:CGPointMake(1.8f, -2.f) option:DIALOGITEM_Menu];
                itemNode = [[f3GraphNode alloc] init:CGPointMake(1.8f *dialogScale, -2.f *dialogScale) extend:CGSizeMake(dialogScale * 0.75f, dialogScale * 0.75f)];
                [gameStrategy appendTouchListener:itemNode];
                itemEvent = [[f3GameFlowEvent alloc] init:GAME_Over level:dialogEvent.Level];
                itemState = [[f3EventButtonState alloc] initWithNode:itemNode event:itemEvent];
                [gameStrategy appendGameController:[[f3Controller alloc] initWithState:itemState]];
                
                break;
                
            case GAME_EVENT_MAX:
                // TODO throw f3Exception
                return;
        }
        
        f3GameDirector *director = [f3GameDirector Director];

        enum fgTabuloGrade grade = [(fgTabuloDirector *)director getGradeForLevel:dialogEvent.Level];
        
        [self buildTitle:_builder level:dialogEvent.Level];
        [self buildDialogGrade:_builder grade:grade];
        [self buildDialogBox:_builder];
        
        [_builder push:[f3IntegerArray buildHandleForUInt8:1, UCHAR_BOX(InterfaceLayer), nil]];
        [_builder buildComposite:1];

        [super buildSceneLayer:_builder screen:_screen unit:_unit scale:_scale];
    }
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
    
    [_builder push:[f3ViewAdaptee computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:coordonatePoint withExtend:buttonSize]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:(radius *dialogScale) height:(radius *dialogScale)]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:(_position.x *dialogScale) height:(_position.y *dialogScale)]];
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
    
    [_builder push:[f3ViewAdaptee computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:CGPointMake(768.f, 576.f) withExtend:CGSizeMake(768.f, 256.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:(4.5f *dialogScale) height:(1.5f *dialogScale)]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForX:0.f y:(2.4f *dialogScale)]];
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
    [_builder push:[f3ViewAdaptee computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:coordonatePoint withExtend:CGSizeMake(128.f, 256.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    [_builder push:[f3VectorHandle buildHandleForWidth:(0.75f *dialogScale) height:(1.5f *dialogScale)]];
    [_builder buildDecorator:2];
    [_builder push:[f3VectorHandle buildHandleForWidth:(_position.x *dialogScale) height:(_position.y *dialogScale)]];
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
    
    [_builder push:[f3ViewAdaptee computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:coordonatePoint withExtend:CGSizeMake(128.f, 128.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:dialogScale height:dialogScale]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:(_position.x *dialogScale) height:(_position.y *dialogScale)]];
    [_builder buildDecorator:1];
}

- (void)buildDialogBox:(f3ViewBuilder *)_builder {
    
    f3IntegerArray *indicesHandle = [f3IntegerArray buildHandleForUInt16:6, USHORT_BOX(0), USHORT_BOX(1), USHORT_BOX(2), USHORT_BOX(2), USHORT_BOX(1), USHORT_BOX(3), nil];
    
    f3FloatArray *vertexHandle = [f3FloatArray buildHandleForFloat32:8, FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(0.5f),
                                  FLOAT_BOX(-0.5f), FLOAT_BOX(-0.5f), FLOAT_BOX(0.5f), FLOAT_BOX(-0.5f), nil];
    
    [_builder push:indicesHandle];
    [_builder push:vertexHandle];
    [_builder buildAdaptee:DRAW_TRIANGLES];
    
    [_builder push:[f3ViewAdaptee computeCoordonate:CGSizeMake(2048.f, 1472.f) atPoint:CGPointMake(0.f, 320.f) withExtend:CGSizeMake(768.f, 896.f)]];
    [_builder push:[(fgTabuloDirector *)[f3GameDirector Director] getResourceIndex:RESOURCE_SpritesheetMenu]];
    [_builder buildDecorator:4];
    
    [_builder push:[f3VectorHandle buildHandleForWidth:(6.f *dialogScale) height:(7.f *dialogScale)]];
    [_builder buildDecorator:2];
    
    [_builder push:[f3VectorHandle buildHandleForX:0.f y:0.f]];
    [_builder buildDecorator:1];
}

- (void)notifyEvent:(f3GameEvent *)_event {

    f3GameAdaptee *producer = [f3GameAdaptee Producer];

    if ([_event isKindOfClass:[f3GameFlowEvent class]])
    {
        f3GameFlowEvent *event = (f3GameFlowEvent *)_event;

        if (event.Event == GAME_Over)
        {
            [producer popMenu];
        }
        else if (event.Event == GAME_Pause)
        {
            [producer popState];
        }
        else
        {
            NSUInteger nextLevel = event.Level;

            if (event.Event == GAME_Next)
            {
                ++nextLevel; // increment to next level
            }

            NSString *filename = [@"LEVEL" stringByAppendingString:[NSString stringWithFormat:@"%03lu",(unsigned long)nextLevel]];

            NSObject<IDataAdapter> *dataWriter = [[fgDataAdapter alloc] init:filename bundle:true];

            if (dataWriter != nil)
            {
                fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
                fgTabuloStrategy *nextGameStrategy = [[fgTabuloStrategy alloc] init:nextLevel];

                unsigned short result = [director loadScene:dataWriter strategy:nextGameStrategy];
                
                if (result == 0)
                {
                    f3GameState *nextGameState = [[f3GameState alloc] initWithStrategy:nextGameStrategy];

                    [producer buildScene:director.Builder state:nextGameState];
                }
                else
                {
                    NSLog(@"Error %i loading filename: %@", result, filename); // TODO throw f3Exception
                    
                    [producer popMenu];
                }
            }
            else
            {
                NSLog(@"Failed load filename: %@", filename); // TODO throw f3Exception

                [producer popMenu];
            }
        }
    }
}

@end
