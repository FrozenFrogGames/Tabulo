//
//  fgTabuloController.m
//  Tabulo
//
//  Created by Serge Menard on 14-01-10.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloController.h"
#import "fgPawnController.h"
#import "../View/fgTabuloDirector.h"

@implementation fgTabuloController

- (void)updateComponents:(NSTimeInterval)_elapsed {

    int componentCount = [components count];

    for (int i = 0; i < componentCount; ++i) // update all components in parallel
    {
        [[components objectAtIndex:i] update:_elapsed];
    }

    for (int i = (componentCount -1); i >= 0; --i)
    {
        f3ControlComponent *component = (f3ControlComponent *)[components objectAtIndex:i];
        
        if (component.finished)
        {
            if (![pendingRemove containsObject:component])
            {
                [pendingRemove addObject:component];
            }
        }
    }

    int componentAtHome = 0;

    for (int i = (componentCount -1); i >= 0; --i)
    {
        if (((fgPawnController *)[components objectAtIndex:i]).isHome)
        {
            ++componentAtHome;
        }
        else
        {
            break;
        }
    }
    
    hasFinished = (componentAtHome == componentCount);

    if (hasFinished) // TODO notify TabuloState (that replace GameState when into a level?) that the game is over
    {
        fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
        
        [self removeAllComponents];
        
        [director showDialog:DIALOG_Next];
    }
}

@end
