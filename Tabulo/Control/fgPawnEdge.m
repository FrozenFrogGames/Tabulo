//
//  fgPawnEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-03-01.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgPawnEdge.h"
#import "../../../Framework/Framework/Model/f3VectorHandle.h"
#import "../../../Framework/Framework/Control/f3ControlCommand.h"
#import "../../../Framework/Framework/Control/f3TranslationCommand.h"
#import "../../../Framework/Framework/Control/f3SetOffsetCommand.h"

@implementation fgPawnEdge

- (id)init:(int)_flag origin:(f3GraphNode *)_origin target:(f3GraphNode *)_target input:(f3GraphNode *)_input {

    self = [super init:_flag origin:_origin target:_target];
    
    if (self != nil)
    {
        if (_input != nil)
        {
            inputKey = _input.Key;
        }
    }

    return self;
}

- (void)buildGraphCommand:(f3ControlBuilder *)_builder view:(f3ViewAdaptee *)_view {

    f3VectorHandle *targetPoint = [[f3GraphNode nodeForKey:targetKey] getPositionHandle];

    CGPoint originPoint = [f3GraphNode nodeForKey:originKey].Position;
    f3VectorHandle *translation = [f3VectorHandle buildHandleForWidth:targetPoint.X - originPoint.x height:targetPoint.Y - originPoint.y];

    f3ControlCommand *command = [[f3ControlCommand alloc] init];
    [command appendComponent:[[f3TranslationCommand alloc] initWithView:_view Offset:translation]];
    [command appendComponent:[[f3SetOffsetCommand alloc] initWithView:_view Offset:targetPoint]];
    [_builder push:command];
}

@end
