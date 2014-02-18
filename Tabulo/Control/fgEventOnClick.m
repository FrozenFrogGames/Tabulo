//
//  fgClickViewOnLevel.m
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgEventOnClick.h"
#import "fgTabuloEvent.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"

@implementation fgEventOnClick

- (id)initWithNode:(f3GraphNode *)_node event:(fgTabuloEvent *)_event {

    self = [super initWithNode:_node];
    
    if (self != nil)
    {
        eventToTrigger = _event;
    }

    return self;
}

- (void)onActionCompleted:(f3ControlComponent *)_action owner:(f3Controller *)_owner {

    [[f3GameAdaptee Producer] notifyEvent:eventToTrigger];

    [super onActionCompleted:_action owner:_owner];
}

@end
