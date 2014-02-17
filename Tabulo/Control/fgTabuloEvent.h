//
//  fgTabuloEvent.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-16.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3GameEvent.h"

@interface fgTabuloEvent : f3GameEvent {

    NSUInteger levelIndex;
}

@property (readonly) NSUInteger Level;

- (id)init:(NSUInteger)_type level:(NSUInteger)_index;

@end
