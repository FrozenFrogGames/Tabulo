//
//  fgDragViewFromNode.m
//  Tabulo
//
//  Created by Serge Menard on 2014-01-19.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgDragViewFromNode.h"
#import "fgDragViewOverEdge.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"

@implementation fgDragViewFromNode

- (void)actionCompleted:(f3ControlComponent *)_action owner:(f3Controller *)_owner {
    
    [_owner switchState:[[fgDragViewOverEdge alloc] initForView:view onNode:node withFlag:flagIndex]];
}

@end
