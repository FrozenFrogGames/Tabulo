//
//  fgTabuloController.m
//  Tabulo
//
//  Created by Serge Menard on 14-01-10.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgPawnController.h"
#import "../../../Framework/Framework/Control/f3GraphNode.h"
#import "../../../Framework/Framework/Control/f3DragViewFromNode.h"

@implementation fgPawnController

- (id)initState:(f3ControllerState *)_initState Home:(f3GraphNode *)_home {

    self = [super initState:_initState];
    
    if (self != nil)
    {
        home = _home;
    }
    
    return self;
}

- (bool)isHome {

    if ([components count] == 0 && [currentState isKindOfClass:[f3DragViewFromNode class]])
    {
        f3DragViewFromNode *dragState = (f3DragViewFromNode *)currentState;
        
        return (dragState.Node == home);
    }
    
    return false;
}

@end
