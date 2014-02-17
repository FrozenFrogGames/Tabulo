//
//  fgTabuloScene.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloState.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "fgTabuloDirector.h"
#import "fgTabuloEvent.h"
#import "fgTabuloMenu.h"
#import "fgTabuloTutorial.h"
#import "fgTabuloEasy.h"

@implementation fgTabuloState

const NSUInteger LEVEL_COUNT = 18;

- (void)notifyEvent:(f3GameEvent *)_event {

    if ([_event isKindOfClass:[fgTabuloEvent class]])
    {
        fgTabuloEvent *event = (fgTabuloEvent *)_event;
        
        fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
        [director.Scene removeAllComposites];
        
        f3GameAdaptee *producer = [f3GameAdaptee Producer];
        [producer removeAllComponents];
        
        if (event.EventType == EVENT_StartGame)
        {
            fgTabuloTutorial *tutorial = [[fgTabuloTutorial alloc] init];
        
            [tutorial buildLevel:event.Level director:director producer:producer];
    
            [director loadScene:tutorial];
        }
        else if (event.EventType == EVENT_Initialize || event.EventType == EVENT_GameOver)
        {
            fgTabuloMenu *menu = [[fgTabuloMenu alloc] init];

            [menu buildMenu:LEVEL_COUNT director:director producer:producer];

            [director loadScene:menu];
        }
        else
        {
            [super notifyEvent:_event];
        }
    }
    else
    {
        [super notifyEvent:_event];
    }
}

@end
