//
//  f3ViewController.m
//  PuzzlePrototype
//
//  Created by Serge Menard on 13-10-08.
//  Copyright (c) 2013 FrozenfrogGames. All rights reserved.
//

#import "fgGameAdapter.h"
#import "fgViewCanvas.h"
#import "fgViewAdapter.h"
#import "fgDataAdapter.h"

@interface fgGameAdapter ()

@property (strong, nonatomic) EAGLContext *context;

@end

@implementation fgGameAdapter

@synthesize context = _context;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self != nil)
    {
        director = [[f3GameDirector alloc] init:[fgViewAdapter class]];
        adaptee = [[f3GameAdaptee alloc] init];
    }
    
    return self;
}

- (void)loadView {
    
    self.view = [fgViewCanvas alloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (self.context != nil)
    {
        fgViewCanvas *canvas = (fgViewCanvas *)self.view;
        canvas = [canvas init:self.context scene:director.Scene];
        canvas.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        
        [director readFrom:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    else
    {
        // TODO throw f3Exception @"Failed to create ES context"
    }
    
    [EAGLContext setCurrentContext:self.context];
}

- (void)dealloc
{
    if ([EAGLContext currentContext] == self.context)
    {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)viewOrientationDidChange:(NSNotification *)notification {
    
    [(fgViewCanvas *)self.view deviceOrientationDidChange];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [EAGLContext setCurrentContext:self.context];
    
    if ([EAGLContext currentContext] == self.context)
    {
        [EAGLContext setCurrentContext:nil];
    }
    
	self.context = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil))
    {
        self.view = nil;
        
        if ([EAGLContext currentContext] == self.context)
        {
            [EAGLContext setCurrentContext:nil];
        }
        
        self.context = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];

        // TODO trigger f3Exception
    }
    
    // TODO dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    [adaptee update:self.timeSinceLastUpdate];
    
    [director.Scene refresh]; // TODO refresh adapter list only if the view tree has changed
}

#pragma mark - Touch based methods

- (CGPoint)locationInRelative:(UITouch *)_touch {

    fgViewCanvas *canvas = (fgViewCanvas *)self.view;

    CGPoint absolutePoint = [_touch locationInView:self.view];
    
    float relativeX = (absolutePoint.x - (canvas.Screen.width / 2.f)) / canvas.Unit.width;
    float relativeY = ((canvas.Screen.height - absolutePoint.y) - (canvas.Screen.height / 2.f)) / canvas.Unit.height;

    return CGPointMake(relativeX, relativeY);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    NSArray *touchArray = [[event touchesForView:self.view] allObjects];

    for (id touch in touchArray)
    {
        CGPoint relativePoint = [self locationInRelative:touch];

        [adaptee.Grid notifyInput:relativePoint type:INPUT_BEGAN];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSArray *touchArray = [[event touchesForView:self.view] allObjects];
    
    for (id touch in touchArray)
    {
        CGPoint relativePoint = [self locationInRelative:touch];

        [adaptee.Grid notifyInput:relativePoint type:INPUT_MOVED];
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {

    NSArray *touchArray = [[event touchesForView:self.view] allObjects];
    
    for (id touch in touchArray)
    {
        CGPoint relativePoint = [self locationInRelative:touch];

        [adaptee.Grid notifyInput:relativePoint type:INPUT_ENDED];
    }
    
    [adaptee setFocusController:nil];
}

@end
