//
//  fgPlankEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-03-01.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgPlankEdge.h"
#import "../View/fgTabuloDirector.h"
#import "../../../Framework/Framework/Model/f3VectorHandle.h"
#import "../../../Framework/Framework/Control/f3GraphConfig.h"
#import "../../../Framework/Framework/Control/f3ControlCommand.h"
#import "../../../Framework/Framework/Control/f3TransformCommand.h"
#import "../../../Framework/Framework/Control/f3SetAngleCommand.h"
#import "../../../Framework/Framework/Control/f3SetOffsetCommand.h"

@implementation fgPlankEdge

- (id)initFrom:(NSNumber *)_originKey targetKey:(NSNumber *)_targetKey rotation:(f3GraphNode *)_rotation {
    
    self = [super initFrom:_originKey targetKey:_targetKey];
    
    if (self != nil)
    {
        f3GraphNode *originNode = [f3GraphNode nodeForKey:_originKey], *targetNode = [f3GraphNode nodeForKey:_targetKey];
        CGPoint originPoint = originNode.Position, targetPoint = targetNode.Position, rotationPoint = _rotation.Position;

        NSArray *pawnEdges = [fgTabuloEdge edgesFromNode:_rotation withInput:targetNode];
        if ([pawnEdges count] > 0)
        {
            fgTabuloEdge *edge = (fgTabuloEdge *)[pawnEdges objectAtIndex:0];
            inputKey = edge.TargetKey;

            for (int i = 1; i < [pawnEdges count]; ++i)
            {
                edge = (fgTabuloEdge *)[pawnEdges objectAtIndex:i];

                if (inputKey != edge.TargetKey)
                {
                    // TODO throw f3Exception
                }
            }
        }
        
        if (inputKey == nil)
        {
            return nil; // TODO throw f3Exception
        }
        
        targetAngle = [f3GraphEdge computeAngleBetween:targetPoint and:rotationPoint];
        rotationAngle = targetAngle - [f3GraphEdge computeAngleBetween:originPoint and:rotationPoint];
        rotationRadius = 0.f;

        if (rotationAngle > 180.f)
        {
            rotationAngle -= 360.f;
        }
        else if (rotationAngle < -180.f)
        {
            rotationAngle += 360.f;
        }

        rotationKey = _rotation.Key;
    }

    return self;
}

- (float)Angle {

    return targetAngle;
}

- (void)setPlankType:(unsigned char)_type {
    
    switch (_type)
    {
        case TABULO_HaveSmallPlank:
            rotationRadius = 1.75f; // small plank is 3.5 (3.42) units
            break;
            
        case TABULO_HaveMediumPlank: // medium plank is 5 (4.95) units
            rotationRadius = 2.5f;
            break;
            
        case TABULO_HaveLongPlank:
            rotationRadius = 3.5f; // long plank is 7 (7.07) units length
            break;
    }
}

- (void)buildGraphCommand:(f3ControlBuilder *)_builder view:(f3ViewAdaptee *)_view {

    f3GraphNode *rotationNode = [f3GraphNode nodeForKey:rotationKey];
    f3GraphNode *targetNode = [f3GraphNode nodeForKey:targetKey];
    f3FloatArray *angleHandle = [f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(targetAngle), nil];

    f3ControlCommand *command = [[f3ControlCommand alloc] init];
    f3TransformCommand *transform = [[f3TransformCommand alloc] initWithView:_view Point:[rotationNode getPositionHandle]
                                                                    Rotation:rotationAngle Radius:rotationRadius Angle:targetAngle Speed:0.7f];
    [command appendComponent:transform];
    f3ControlComposite *composite = [[f3ControlComposite alloc] init];
    [composite appendComponent:[[f3SetOffsetCommand alloc] initWithView:_view Offset:[targetNode getPositionHandle]]];
    [composite appendComponent:[[f3SetAngleCommand alloc] initWithView:_view Angle:angleHandle]];
    [command appendComponent: composite];
    [_builder push:command];
}

@end
