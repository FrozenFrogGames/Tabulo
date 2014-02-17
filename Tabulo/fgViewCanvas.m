//
//  f3DirectorAdapter.m
//  PuzzlePrototype
//
//  Created by Serge Menard on 13-10-08.
//  Copyright (c) 2013 FrozenfrogGames. All rights reserved.
//

#import "fgViewCanvas.h"
#import "fgViewAdapter.h"
#import "../../Framework/Framework/Control/f3GameAdaptee.h"
#import "../../Framework/Framework/View/f3ViewScene.h"

@implementation fgViewCanvas

- (id)init:(EAGLContext *)_context {

    self = [super init];

    if (self != nil)
    {
        self.context = _context;

        targetOrientationIsPortrait = false;
        currentOrientationIsPortrait = false;

        screenSize = CGSizeZero;
        unitSize = CGSizeMake(64.f, 64.f);
        textureLoaded = [NSMutableArray array];
    }

    return self;
}

- (CGSize) Screen {
    
    return screenSize;
}

- (CGSize) Unit {
    
    return unitSize;
}

- (bool)OrientationIsPortrait {

    return targetOrientationIsPortrait;
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

    glClearColor(1.f, 1.f, 1.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT);

    f3ViewScene *scene = [f3GameDirector Director].Scene;
    
    if (CGSizeEqualToSize(screenSize, CGSizeZero))
    {
        const UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
        
        if (UIDeviceOrientationIsPortrait(deviceOrientation))
        {
            targetOrientationIsPortrait = true;
        }
        else if (UIDeviceOrientationIsLandscape(deviceOrientation))
        {
            targetOrientationIsPortrait = false;
        }

        currentOrientationIsPortrait = targetOrientationIsPortrait;

        const CGSize deviceResolution = [[UIScreen mainScreen] bounds].size;

        if (currentOrientationIsPortrait)
        {
            screenSize = deviceResolution;
        }
        else
        {
            screenSize.width = deviceResolution.height;
            screenSize.height = deviceResolution.width;
        }

        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES)
        {
            screenSize.width = screenSize.width * [[UIScreen mainScreen] scale];
            screenSize.height = screenSize.height * [[UIScreen mainScreen] scale];
        }

        unitSize = [[f3GameAdaptee Producer] computeUnitSize:screenSize];
        
        [scene deviceOrientationDidChange:currentOrientationIsPortrait];
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

            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES) // support RETINA display
            {
                screenSize.width = screenSize.width * [[UIScreen mainScreen] scale];
                screenSize.height = screenSize.height * [[UIScreen mainScreen] scale];
            }

            currentOrientationIsPortrait = targetOrientationIsPortrait;
        }

        [scene deviceOrientationDidChange:currentOrientationIsPortrait];
    }

    if (scene != nil)
    {
        fgViewAdapter *currentView = (fgViewAdapter *)[scene firstView];
        
        while (currentView != nil)
        {
            [currentView updatePosition:screenSize Scale:unitSize];

            [currentView drawItem:(NSObject<IViewCanvas> *)self];

            currentView = (fgViewAdapter *)[scene nextView];
        }
    }
}

- (void)clearRessource {

    for (NSUInteger index =0; index < [textureLoaded count]; ++index)
    {
        GLKTextureInfo *textureInfo = [textureLoaded objectAtIndex:index];
        GLuint textureName = textureInfo.name;
        glDeleteTextures(1, &textureName);
    }
    
    [textureLoaded removeAllObjects];
}

- (NSUInteger)loadRessource:(NSString *)_name {

    NSString *filepath = [[NSBundle mainBundle] pathForResource:_name ofType:nil];
    NSError *fileerror;

    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filepath options:nil error:&fileerror];

    if (textureInfo != nil)
    {
        [textureLoaded addObject:textureInfo];

        return [textureLoaded indexOfObject:textureInfo];
    }

    return NSUIntegerMax;
}

- (GLKTextureInfo *)getTexture:(NSInteger)_index {

    if ([textureLoaded count] > _index)
    {
        return [textureLoaded objectAtIndex:_index];
    }

    return nil;
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

        case DRAW_LINE_STRIP:
        case DRAW_TRIANGLE_FAN:
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
