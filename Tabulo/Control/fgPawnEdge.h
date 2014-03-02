//
//  fgPawnEdge.h
//  Tabulo
//
//  Created by Serge Menard on 2014-03-01.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgTabuloEdge.h"

@interface fgPawnEdge : fgTabuloEdge

- (id)init:(int)_flag origin:(f3GraphNode *)_origin target:(f3GraphNode *)_target input:(f3GraphNode *)_input;

@end
