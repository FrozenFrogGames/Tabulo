//
//  f3DirectorAdapter.m
//  PuzzlePrototype
//
//  Created by Serge Menard on 13-10-08.
//  Copyright (c) 2013 FrozenfrogGames. All rights reserved.
//

#import "fgViewCanvas.h"
#import "fgViewAdapter.h"
#import "../../Framework/Framework/View/f3ViewScene.h"

@implementation fgViewCanvas

- (id)init:(EAGLContext *)_context scene:(f3ViewScene *)_scene {

    self = [super init];

    if (self != nil)
    {
        self.context = _context;

        deviceFormat = FORMAT_MEDIUM;
        screenSize = CGSizeZero;
        unitSize = CGSizeMake(96.f, 96.f);
        textureDictionnary = [[NSMutableDictionary alloc] init];
        scene = _scene;
    }

    return self;
}

- (enum f3DeviceFormat) Format {
    
    return deviceFormat;
}

- (CGSize) Screen {
    
    return screenSize;
}

- (CGSize) Unit {
    
    return unitSize;
}

- (void)deviceOrientationDidChange {

    const UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];

    if (UIDeviceOrientationIsPortrait(deviceOrientation))
    {
        targetOrientationIsPortrait = true;
    }
    else if (UIDeviceOrientationIsLandscape(deviceOrientation))
    {
        targetOrientationIsPortrait = false;
    }
}

- (void)drawRect:(CGRect)rect {

    [super drawRect:rect];

    glClearColor(0.f, 0.f, 0.f, 1.f); // TODO get background color from the scene
    glClear(GL_COLOR_BUFFER_BIT);

    if (CGSizeEqualToSize(screenSize, CGSizeZero))
    {
        const UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
        const CGSize deviceResolution = [[UIScreen mainScreen] bounds].size;
        
        if (UIDeviceOrientationIsPortrait(deviceOrientation))
        {
            screenSize = deviceResolution;
            
            targetOrientationIsPortrait = true;
        }
        else if (UIDeviceOrientationIsLandscape(deviceOrientation))
        {
            screenSize.width = deviceResolution.height;
            screenSize.height = deviceResolution.width;

            targetOrientationIsPortrait = false;
        }

        currentOrientationIsPortrait = targetOrientationIsPortrait;

        if (screenSize.width >= 1920.f && screenSize.height >= 1080.f)
        {
            unitSize = CGSizeMake(192.f, 192.f);

            deviceFormat = FORMAT_XXL;
        }
        else if (screenSize.width >= 1280.f && screenSize.height >= 720.f)
        {
            unitSize = CGSizeMake(128.f, 128.f);

            deviceFormat = FORMAT_XL;
        }
        else if (screenSize.width >= 1020.f && screenSize.height >= 640.f)
        {
            unitSize = CGSizeMake(96.f, 96.f);

            deviceFormat = FORMAT_LARGE;
        }
        else if (screenSize.width >= 960.f && screenSize.height >= 540.f)
        {
            unitSize = CGSizeMake(96.f, 96.f);

            deviceFormat = FORMAT_MEDIUM;
        }
        else if (screenSize.width >= 800.f && screenSize.height >= 480.f)
        {
            unitSize = CGSizeMake(80.f, 80.f);

            deviceFormat = FORMAT_SMALL;
        }
        else if (screenSize.width >= 480.f && screenSize.height >= 320.f)
        {
            unitSize = CGSizeMake(48.f, 48.f);

            deviceFormat = FORMAT_XS;
        }
        else if (screenSize.width >= 320.f && screenSize.height >= 200.f)
        {
            unitSize = CGSizeMake(32.f, 32.f);

            deviceFormat = FORMAT_XXS;
        }
    }
    else
    {
        bool bOrientationHasChanged = (currentOrientationIsPortrait != targetOrientationIsPortrait);

        if (bOrientationHasChanged)
        {
            const CGSize deviceResolution = [[UIScreen mainScreen] bounds].size;

            if (targetOrientationIsPortrait)
            {
                screenSize = deviceResolution;
            }
            else
            {
                screenSize.width = deviceResolution.height;
                screenSize.height = deviceResolution.width;
            }

            currentOrientationIsPortrait = targetOrientationIsPortrait;
        }
    }

    fgViewAdapter *currentView = (fgViewAdapter *)[scene firstView];
    
    while (currentView != nil)
    {
        [currentView updatePosition:screenSize Scale:unitSize];

        [currentView drawItem:(NSObject<IViewCanvas> *)self];

        currentView = (fgViewAdapter *)[scene nextView];
    }
}

- (GLKTextureInfo *)getTextureByName:(NSString *)_name {
    
    GLKTextureInfo *textureInfo = [textureDictionnary objectForKey:_name];
    
    if (textureInfo == nil)
    {
        textureInfo = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:_name].CGImage options:nil error:nil];
        
        if (textureInfo != nil)
        {
            [textureDictionnary setObject:textureInfo forKey:_name];
            
            // TODO implement release mechanism to free unused textures
        }
        else
        {
            // TODO throw exception: texture not found
        }
    }
    
    return textureInfo;
}

- (void)beginDraw {
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    haveTextureCoordinates = false;
}

- (void)bindTextureCoordinates:(const GLvoid*)_coordinates {

    glBindVertexArrayOES(0);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, _coordinates);

    haveTextureCoordinates = true;
}

- (void)drawItem:(enum f3DrawType)_type Vertex:(const GLvoid*)_vertex Indices:(const GLvoid *)_indices Count:(int)_count {

    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, _vertex);
    
    switch (_type)
    {
        case DRAW_LINES:
        case DRAW_TRIANGLES:
            glDrawElements(_type, _count, GL_UNSIGNED_SHORT, _indices);
            break;

        case DRAW_TRIANGLE_FAN:
        case DRAW_LINE_STRIP:
            glDrawArrays(_type, 0, _count);
            break;
            
        default:
            // TODO throw f3Exception
            break;
    }
}

- (void)endDraw {

    glDisableVertexAttribArray(GLKVertexAttribPosition);

    if (haveTextureCoordinates)
    {
        glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    }
    
    glDisable(GL_BLEND);
}

@end
