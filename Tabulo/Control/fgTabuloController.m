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

- (void)update:(NSTimeInterval)_elapsed {

    int appendCount = [pendingAppend count];

    if (appendCount > 0)
    {
        for (int i = 0; i < appendCount; ++i)
        {
            [components addObject:[pendingAppend objectAtIndex:i]];
        }

        [pendingAppend removeAllObjects];
    }

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
            if ([pendingRemove containsObject:component])
            {
                [pendingRemove removeObject:component];
            }
            
            [components removeObjectAtIndex:i];
        }
    }
    
    int removeCount = [pendingRemove count];
    
    if (removeCount > 0)
    {
        for (int i = 0; i < removeCount; ++i)
        {
            [components removeObject:[pendingRemove objectAtIndex:i]];
        }
        
        [pendingRemove removeAllObjects];
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
    
    if (componentAtHome == componentCount)
    {
        fgTabuloDirector *director = (fgTabuloDirector *)[f3GameDirector Director];
        
        [components removeAllObjects];

        [director nextScene];
    }
}

@end
