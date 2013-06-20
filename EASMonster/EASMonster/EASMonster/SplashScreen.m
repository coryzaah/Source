//
//  SplashScreen.m
//  EASMonster
//
//  Created by ProgDenisMac on 12.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import "SplashScreen.h"

static const FileItemInfo SplashScreend_Background	=
{
    @"splashscreen_background.jpg",
    {
        {{ 138,   0}, {  748,  748}},
        {{   9, 126}, {  748,  748}}
    }
};

@implementation SplashScreen

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        {
            _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SplashScreend_Background.fileName]];

            [self addSubview:_background];
        }
        [self resize:detectDeviceOrientation()];
    }
    return self;
}

- (void) dealloc {
    [_background	release];
    
    [super dealloc];
}

- (void) resize:(DeviceOrientation)orient {
    [_background	setFrame:SplashScreend_Background.rects[orient]];
    
    return;
}

- (void) stopAll {
}

- (void) pause {
}

- (void) start {
}

@end
