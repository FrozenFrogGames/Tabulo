//
//  AppDelegate.h
//  Prototype
//
//  Created by Serge Menard on 13-10-24.
//  Copyright (c) 2013 Frozenfrog Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class fgGameAdapter;

@interface fgAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) fgGameAdapter *viewController;

@end
