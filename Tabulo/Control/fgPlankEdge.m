//
//  fgPlankEdge.m
//  Tabulo
//
//  Created by Serge Menard on 2014-03-01.
//  Copyright (c) 2014 Frozenfrog Games. All rights reserved.
//

#import "fgPlankEdge.h"
#import "../fgTabuloDirector.h"
#import "../../../Framework/Framework/Model/f3VectorHandle.h"
#import "../../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../../Framework/Framework/Control/f3GraphSchemaStrategy.h"
#import "../../../Framework/Framework/Control/f3GraphSchema.h"
#import "../../../Framework/Framework/Control/f3ControlSequence.h"
#import "../../../Framework/Framework/Control/f3TransformCommand.h"
#import "../../../Framework/Framework/Control/f3SetAngleCommand.h"
#import "../../../Framework/Framework/Control/f3SetOffsetCommand.h"

@implementation fgPlankEdge

+ (float)getOrientationFlag:(float)_angle {

    float orientationAngle = (_angle < 168.75f) ? _angle : _angle - 191.25f;
    
    if (orientationAngle < 11.25f || orientationAngle >= 168.75f)
    {
        return 0x00000000;
    }
    else if (orientationAngle < 33.75f)
    {
        return (0x00000001 << 0xB);
    }
    else if (orientationAngle < 56.25f)
    {
        return (0x00000002 << 0xB);
    }
    else if (orientationAngle < 78.75f)
    {
        return (0x00000003 << 0xB);
    }
    else if (orientationAngle < 101.25f)
    {
        return (0x00000004 << 0xB);
    }
    else if (orientationAngle < 123.75f)
    {
        return (0x00000005 << 0xB);
    }
    else if (orientationAngle < 146.25f)
    {
        return (0x00000006 << 0xB);
    }
    else // if (orientationAngle < 168.75f)
    {
        return (0x00000007 << 0xB);
    }
}

- (id)init:(NSNumber *)_originKey target:(NSNumber *)_targetKey rotation:(NSNumber *)_rotationKey {
    
    return [self init:_originKey target:_targetKey rotation:_rotationKey plank:UINT8_MAX];
}

- (id)init:(NSNumber *)_originKey target:(NSNumber *)_targetKey rotation:(NSNumber *)_rotationKey plank:(uint8_t)_plank {

    self = [super init:_originKey target:_targetKey rotation:_rotationKey];

    if (self != nil)
    {
        CGPoint originPoint = [[f3GraphNode nodeForKey:_originKey] Position];
        CGPoint targetPoint = [[f3GraphNode nodeForKey:_targetKey] Position];
        CGPoint rotationPoint = [[f3GraphNode nodeForKey:_rotationKey] Position];

        targetAngle = [f3GraphEdge angleBetween:targetPoint and:rotationPoint];

        orientationFlag = [fgPlankEdge getOrientationFlag:targetAngle];

        rotationAngle = targetAngle - [f3GraphEdge angleBetween:originPoint and:rotationPoint];

        if (rotationAngle > 180.f)
        {
            rotationAngle -= 360.f;
        }
        else if (rotationAngle < -180.f)
        {
            rotationAngle += 360.f;
        }

        switch (_plank)
        {
            case TABULO_PLANK_Small:
                rotationRadius = 1.75f; // small plank is 3.5 (3.42) units
                break;
                
            case TABULO_PLANK_Long:
                rotationRadius = 3.5f; // long plank is 7 (7.07) units length
                break;

            case TABULO_PLANK_Medium: // medium plank is 5 (4.95) units
                rotationRadius = 2.5f;
                break;

            default:
                rotationRadius = 0.f; // TODO throw f3Exception
                break;
        }
    }

    return self;
}

- (float)Angle {

    return targetAngle;
}

- (void)buildGraphCommand:(f3ControlBuilder *)_builder view:(f3ViewAdaptee *)_view slowMotion:(float)_slowmo {

    f3GraphNode *rotationNode = [f3GraphNode nodeForKey:rotationKey];
    f3GraphNode *targetNode = [f3GraphNode nodeForKey:targetKey];
    f3FloatArray *angleHandle = [f3FloatArray buildHandleForFloat32:1, FLOAT_BOX(targetAngle), nil];

    float speed = [f3GraphEdge distanceBetween:[f3GraphNode nodeForKey:originKey].Position to:targetNode.Position] /2.f *_slowmo;

    f3ControlSequence *command = [[f3ControlSequence alloc] init];
    f3TransformCommand *transform = [[f3TransformCommand alloc] initWithView:_view Point:[rotationNode getPositionHandle]
                                                                    Rotation:rotationAngle Radius:rotationRadius Angle:targetAngle Speed:speed];
    [command appendComponent:transform];
    f3ControlComposite *composite = [[f3ControlComposite alloc] init];
    [composite appendComponent:[[f3SetOffsetCommand alloc] initWithView:_view Offset:[targetNode getPositionHandle]]];
    [composite appendComponent:[[f3SetAngleCommand alloc] initWithView:_view Angle:angleHandle]];
    [command appendComponent: composite];
    [_builder push:command];
}

- (f3NodeFlags)apply:(f3NodeFlags)_target origin:(f3NodeFlags)_origin {

    if (_origin != 0x00000000 && (_origin & TABULO_PAWN_MASK) == 0x00000000)
    {
        f3NodeFlags result = _origin & (TABULO_PLANK_MASK | TABULO_HOLE_MASK);

        return result | orientationFlag;
    }

    // TODO throw f3Exception

    return 0x00000000;
}

@end
