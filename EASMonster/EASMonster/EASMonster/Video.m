//
//  Video.m
//  EASMonster
//
//  Created by ProgDenisMac on 12.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import "Video.h"

static const FileItemInfo Video_Background	=
{
    @"video_background.jpg",
    {{{ 138,   0}, {  748,  748}}, {{   9, 126}, {  748,  748}}}
};

static const FileItemInfo Video_Logo	=
{
    @"video_logo.png",
    {{{ 795,  30}, { 208,  114}}, {{ 540,  29}, { 208,  114}}}
};

static const FileItemInfo Video_File	=
{
    @"video_file.mp4",
    {
        {{ 186, 200}, { 690, 390}},
        {{  76, 313}, { 624, 351}}
    }
};

static const FileItemInfo Video_Description	=
{
    @"video_description.html",
    {
        {{ 190, 620}, { 690, 140}},
        {{  75, 692}, { 625, 160}}
    }
};

@implementation Video

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        {
            _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Video_Background.fileName]];
            _logo		= [[UIImageView alloc] initWithImage:[UIImage imageNamed:Video_Logo.fileName]];
            
            [self addSubview:_background];
            [self addSubview:_logo];
        }
        {
            NSURL* url = [NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:Video_File.fileName]];
            if(url != nil) {
                _player = [[MPMoviePlayerController alloc] initWithContentURL:url];
                [_player prepareToPlay];
            }
            [_player setShouldAutoplay:FALSE];
            [_player setControlStyle: MPMovieControlStyleEmbedded];
            
            [self addSubview:[_player view]];
        }
        {
            _description = [[UIWebView alloc] init];
            [_description setBackgroundColor: [UIColor clearColor] ];
            [_description setOpaque:FALSE];
            [[_description scrollView] setAlwaysBounceVertical:FALSE];
            
            UIView* cv = [[_description subviews] objectAtIndex: 0];
            if(cv != nil)
            {
                for(UIView* v in cv.subviews)
                {
                    if([v isKindOfClass:[UIImageView class]]) [v setHidden:TRUE];
                }
            }
            
            {
            	NSURL* url = [NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:Video_Description.fileName]];
            	if(!url)
                	url = [NSURL URLWithString:@"about:blank"];
                [_description loadRequest: [NSURLRequest requestWithURL:url]];
            }
            
            [self addSubview:_description];
        }
        [self resize:detectDeviceOrientation()];
    }
    return self;
}

- (void) dealloc {
    [_background	release];
    [_logo			release];
    
    [_player		stop];
    [_player		release];
    [_description	release];
    
    [super dealloc];
}

- (void) resize:(DeviceOrientation)orient {
    [_background	setFrame:Video_Background.rects[orient]];
    [_logo			setFrame:Video_Logo.rects[orient]];

    [[_player view]	setFrame:Video_File.rects[orient]];
    [_description	setFrame:Video_Description.rects[orient]];
    [_description	reload];
    return;
}

- (void) stopAll {
}

- (void) pause {
}

- (void) start {
}

@end
