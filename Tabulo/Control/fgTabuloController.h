//
//  fgTabuloController.h
//  Tabulo
//
//  Created by Serge Menard on 14-01-10.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3ControlComposite.h"
#import "fgTabuloEvent.h"

@interface fgTabuloController : f3ControlComposite {
    
    fgTabuloEvent *eventToTrigger;
}

- (id)init:(fgTabuloEvent *)_event;

@end
