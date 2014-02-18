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

- (id)init {
    
    self = [super init];
    
    if (self != nil)
    {
        dialogBox = nil;
    }
    
    return self;
}

- (void)notifyEvent:(f3GameEvent *)_event {

    if ([_event isKindOfClass:[fgTabuloEvent class]])
    {
        fgTabuloEvent *event = (fgTabuloEvent *)_event;
        f3GameAdaptee *producer = [f3GameAdaptee Producer];
        fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
        
        if (event.EventType == EVENT_Menu)
        {
            dialogBox = nil;
    
            [producer removeAllComponents];
            [director.Scene removeAllComposites];

            fgTabuloMenu *menu = [[fgTabuloMenu alloc] init];
            [menu buildMenu:LEVEL_COUNT director:director producer:producer];
            
            [director loadScene:menu];
        }
        else if (event.EventType == EVENT_StartGame)
        {
            if (dialogBox == nil)
            {
                fgTabuloMenu *menu = [[fgTabuloMenu alloc] init];
                
                dialogBox = [menu buildDialog:event director:director producer:producer];
                
                [director.Scene appendComposite:dialogBox];
            }
            else
            {
                dialogBox = nil;

                [producer removeAllComponents];
                [director.Scene removeAllComposites];

                fgTabuloTutorial *tutorial = [[fgTabuloTutorial alloc] init];
                [tutorial buildLevel:event.Level director:director producer:producer];

                [director loadScene:tutorial];
            }
        }
        else if (event.EventType == EVENT_GameOver)
        {
            if (dialogBox == nil)
            {
                fgTabuloMenu *menu = [[fgTabuloMenu alloc] init];
                
                dialogBox = [menu buildDialog:event director:director producer:producer];
                
                [director.Scene appendComposite:dialogBox];
            }
            else
            {
                dialogBox = nil;

                [producer removeAllComponents];
                [director.Scene removeAllComposites];

                fgTabuloTutorial *tutorial = [[fgTabuloTutorial alloc] init];
                [tutorial buildLevel:event.Level director:director producer:producer];

                [director loadScene:tutorial];
            }
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
