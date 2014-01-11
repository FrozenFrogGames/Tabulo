//
//  fgTabuloController.h
//  Tabulo
//
//  Created by Serge Menard on 14-01-10.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3Controller.h"

@class f3GraphNode;

@interface fgPawnController : f3Controller {
    
    f3GraphNode *home;
}

@property (readonly) bool isHome;

- (id)initState:(f3ControllerState *)_initState Home:(f3GraphNode *)_home;

@end
