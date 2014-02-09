//
//  fgClickViewOnLevel.h
//  Tabulo
//
//  Created by Serge Menard on 2014-02-02.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "../../../Framework/Framework/Control/f3ClickOnNode.h"

@interface fgClickOnLevel : f3ClickOnNode {

    NSUInteger levelIndex;
}

- (id)initWithNode:(f3GraphNode *)_node useLevel:(NSUInteger)_index;

@end
