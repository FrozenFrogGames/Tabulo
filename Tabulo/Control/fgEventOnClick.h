//
//  fgClickViewOnLevel.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3ClickOnNode.h"
#import "../../../Framework/Framework/Control/f3GameEvent.h"

@interface fgEventOnClick : f3ClickOnNode {

    f3GameEvent *eventToTrigger;
}

- (id)initWithNode:(f3GraphNode *)_node event:(f3GameEvent *)_event;

@end
