//
//  fgTabuloScene.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgLevelState.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "fgTabuloDirector.h"
#import "fgTabuloEvent.h"
#import "fgTabuloMenu.h"
#import "fgDialogState.h"

@implementation fgLevelState

- (void)notifyEvent:(f3GameEvent *)_event {

    if ([_event isKindOfClass:[fgTabuloEvent class]])
    {
        fgTabuloEvent *event = (fgTabuloEvent *)_event;
        f3GameAdaptee *producer = [f3GameAdaptee Producer];
        f3GameDirector *director = [f3GameDirector Director];

        if (event.EventType == EVENT_Menu)
        {
//          [producer removeAllComponents];
            [director.Scene removeAllComposites];

            fgLevelState *nextState = [[fgLevelState alloc] init];
            fgTabuloMenu *menu = [[fgTabuloMenu alloc] init];

            [menu build:director.Builder state:nextState];

            [producer switchState:nextState];
            [director loadScene:menu];
        }
        else
        {
            fgDialogState *dialogState = [[fgDialogState alloc] init:self];
            [dialogState build:director.Builder event:event];
            [producer switchState:dialogState];
        }
    }
    else
    {
        [super notifyEvent:_event];
    }
}

@end
