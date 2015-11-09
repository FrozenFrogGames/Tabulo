//
//  fgDialogState.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GameState.h"
#import "../../../Framework/Framework/View/f3ViewBuilder.h"
#import "../../../Framework/Framework/Control/f3GameFlowEvent.h"
#import "../fgTabuloDirector.h"

@interface fgDialogState : f3GameState {
    
    f3GameFlowEvent *dialogEvent;
    float dialogScale;
}

- (id)initWithEvent:(f3GameFlowEvent *)_event;

@end
