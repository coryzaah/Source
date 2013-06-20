//
//  SingleGame.m
//  EASMonster
//
//  Created by ProgDenisMac on 12.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import "SingleGame.h"

const CGSize SingleGame_Size					= { 431, 128};

static const CGRect SingleGame_Image_Rect		= {{  0,   0}, { 82, 100}};
static const CGRect SingleGame_Description_Rect	= {{ 83,   3}, {287, 90}};
static const CGRect SingleGame_Play_Rect		= {{  0, 109}, { 81, 18}};

static NSString* const SingleGame_Background	= @"games_single_back.png";
static NSString* const SingleGame_Play			= @"games_play.png";

@implementation SingleGame

- (id)initWithInfo:(SingleGameInfo)info
{
    self = [super init];
    if (self) {
        _background	= [[UIImageView alloc] initWithImage:[UIImage imageNamed:SingleGame_Background]];
        [_background setFrame:CGRectMake(0.0f, 0.0f, SingleGame_Size.width, SingleGame_Size.height)];
        [self addSubview:_background];
        
        _image		= [[UIImageView alloc] initWithImage:[UIImage imageNamed:info.imageFileName]];
        [_image		setFrame:SingleGame_Image_Rect];
        [self addSubview:_image];

		{
            _description = [[UIWebView alloc] init];
            [_description setFrame:SingleGame_Description_Rect];
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
            	NSURL* url = [NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:info.textFileName]];
            	if(!url)
                	url = [NSURL URLWithString:@"about:blank"];
                [_description loadRequest: [NSURLRequest requestWithURL:url]];
            }
            
            [self addSubview:_description];
        }
        
        _play		= [UIButton buttonWithType:UIButtonTypeCustom];
        [_play		addTarget:self action:@selector(onKeyDown:) forControlEvents:UIControlEventTouchUpInside];
        [_play		setImage:[UIImage imageNamed:SingleGame_Play] forState:UIControlStateNormal];
        [_play		setFrame:SingleGame_Play_Rect];
        [self 		addSubview:_play];
        
        _link		= [info.link copy];
    }
    return self;
}

- (void) dealloc {
    [_background	release];
    [_image 		release];
    [_description	release];
    [_play			release];
    [_link			release];
    
    [super dealloc];
}

- (void) onKeyDown:(UIButton*)button {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_link]];
    return;
}

- (void)reload {
    [_description reload];
    
    return;
}

@end
