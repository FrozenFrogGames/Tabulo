//
//  fgTabuloEvent.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GameEvent.h"


enum fgEventType {
    
    EVENT_Menu,
    EVENT_StartGame,
    EVENT_ResumeGame,
    EVENT_GameOver
};

@interface fgTabuloEvent : f3GameEvent {

    NSUInteger levelIndex, dialogOption;
}

@property (readonly) NSUInteger Level;
@property (readonly) NSUInteger Option;

- (id)init:(NSUInteger)_type level:(NSUInteger)_index option:(NSUInteger)_option;

@end
