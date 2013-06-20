//
//  Turntable.m
//  EASMonster
//
//  Created by ProgDenisMac on 09.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import "Turntable.h"

static const int		Turntable_Tonarm_number 		= 10;
static NSString* const	Turntable_Tonarm				= @"turntable_ton_%04d.png";
static const CGFloat	Turntable_Tonarm_Sensetivity[DeviceOrientation_Count]	=	{-4.00f, -4.00f};

static const int		Turntable_Disc_number = 3;
static NSString* const	Turntable_Disc[Turntable_Disc_number] =
{
	@"turntable_disc_0000.png",
	@"turntable_disc_0001.png",
	@"turntable_disc_0002.png"
};

static const int		Turntable_Buttons_number = 6;
static NSString* const	Turntable_Buttons[Turntable_Buttons_number][2] =
{
	{@"turntable_but_0_prs.png", @"turntable_but_0_nor.png"},
	{@"turntable_but_1_prs.png", @"turntable_but_1_nor.png"},
	{@"turntable_but_2_prs.png", @"turntable_but_2_nor.png"},
	{@"turntable_but_3_prs.png", @"turntable_but_3_nor.png"},
	{@"turntable_but_4_prs.png", @"turntable_but_4_nor.png"},
	{@"turntable_but_5_prs.png", @"turntable_but_5_nor.png"}
};
static NSString* const	Turntable_Music[Turntable_Buttons_number] =
{
	@"turntable_mus_0.mp3",
	@"turntable_mus_1.mp3",
	@"turntable_mus_2.mp3",
	@"turntable_mus_3.mp3",
	@"turntable_mus_4.mp3",
	@"turntable_mus_5.mp3",
};

static const CGRect Turntable_Buttons_Rect[Turntable_Buttons_number][DeviceOrientation_Count]	=
{
    {{{ 122, 540}, {  92, 184}}, {{  35, 604}, {  92, 184}}},
    {{{ 254, 540}, {  92, 184}}, {{ 167, 604}, {  92, 184}}},
    {{{ 382, 540}, {  92, 184}}, {{ 295, 604}, {  92, 184}}},
    {{{ 506, 540}, {  92, 184}}, {{ 418, 604}, {  92, 184}}},
    {{{ 629, 540}, {  92, 184}}, {{ 542, 604}, {  92, 184}}},
    {{{ 753, 540}, {  92, 184}}, {{ 666, 604}, {  92, 184}}},
};

static const FileItemInfo Turntable_Background	=
{
    @"turntable_background.jpg",
    {{{ 138,   0}, {  748,  748}}, {{   9, 126}, {  748,  748}}}
};

static const CGRect Turntable_Disc_Rect[DeviceOrientation_Count]	=
{
    {{ 385, -140}, {  537,  537}},
    {{ 177, -140}, {  537,  537}}
};

static const FileItemInfo Turntable_Logo1	=
{
    @"turntable_logo1.png",
    {{{ 570,  37}, { 166,  167}}, {{ 362,  34}, { 167,  166}}}
};

static const FileItemInfo Turntable_Logo2	=
{
    @"turntable_logo2.png",
    {{{ 50,  20}, { 208,  114}}, {{ 550, 415}, { 208,  114}}}
};

static const CGRect Turntable_Tonarm_Rect[DeviceOrientation_Count]	=
{
    {{ 711, -42}, { 382, 477}},
    {{ 498, -42}, { 382, 477}}
};

static const FileItemInfo Turntable_Description	=
{
    @"turntable_description.html",
    {{{ 57, 340}, { 721, 174}}, {{ 31, 734}, { 721, 174}}}
};


@implementation Turntable

static int	tonarm_pos	= -1;
static int	tonarm_req	= 0;
static int	tonarm_sel	= 0;
static bool	music_play	= false;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_operationQueue = [[NSOperationQueue alloc] init];
        _base			= -1;
        _music			= -1;
        
        [self setBackgroundColor:[UIColor blackColor]];        
        {
            _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Turntable_Background.fileName]];
            [self addSubview:_background];
        }
        {
            _disc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Turntable_Background.fileName]];
            NSMutableArray* arr = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < Turntable_Disc_number; ++i)
                [arr addObject:[UIImage imageNamed:Turntable_Disc[i]]];
            
            [_disc setImage:[arr objectAtIndex:0]];
            [_disc setAnimationImages:arr];
            [_disc setAnimationDuration:0.25f];
            [_disc startAnimating];
            
            [self addSubview:_disc];
            
            [arr release];
        }
        
        {
            _tonarm						 = [[UIImageView alloc] init];
            UIPanGestureRecognizer	*pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
            
            [pan setMaximumNumberOfTouches:1];
            [_tonarm addGestureRecognizer:pan];
            [_tonarm setUserInteractionEnabled:TRUE];
            
            [self addSubview:_tonarm];
            [pan release];
        }

        {
            _logo1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Turntable_Logo1.fileName]];
            _logo2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Turntable_Logo2.fileName]];
            [_logo1 setFrame:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
            [self addSubview:_logo1];
            [self addSubview:_logo2];
        }

        {
            for(int i = 0; i < Turntable_Buttons_number; ++i) {
                for(int j = 0; j < 2; ++j) {
                    _images[i][j] = [UIImage imageNamed:Turntable_Buttons[i][j]];
                    [_images[i][j] retain];
                }
                _buttons[i] = [self createButtonNumber:i];
                [self addSubview:_buttons[i]];
                [_buttons[i] retain];
            }
        }
        
        if(Turntable_Description.fileName != nil) {
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
            	NSURL* url = [NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:Turntable_Description.fileName]];
            	if(!url)
                	url = [NSURL URLWithString:@"about:blank"];
                [_description loadRequest: [NSURLRequest requestWithURL:url]];
            }
            
            [self addSubview:_description];
        }
        [self updateButtons];
        [self loadAudio:tonarm_sel];
        [self setTonarmPhase:0];
        
        [self resize:detectDeviceOrientation()];
    }
    return self;
}

- (void) dealloc {
    [_player stop];
    [_player release];

    [_operation 		cancel];
    [_operation 		release];
    [_operationQueue 	release];
    
    [self stopAll];
    
    [_background 	release];

    [_logo1 		release];
    [_logo2 		release];

    [_tonarm		release];
    
    [_description	release];
    
    for(int i = 0; i < Turntable_Buttons_number; ++i) {
        for(int j = 0; j < 2; ++j) {
            [_images[i][j] release];
        }
        [_buttons[i] release];
    }
    
    [super dealloc];
}

- (void) gesture:(UIPanGestureRecognizer*)sender {
    UIGestureRecognizerState state = [sender state];
    
    if(state == UIGestureRecognizerStateBegan) {
        _base 			= tonarm_pos;
        _gestposition 	= [sender locationInView:_tonarm].x;
        return;
    }
    if(state == UIGestureRecognizerStateChanged) {
        int p = _base + (int)(([sender locationInView:_tonarm].x - _gestposition) / Turntable_Tonarm_Sensetivity[detectDeviceOrientation()]);
        [self setTonarmPhase:p];
        return;
    }
    if(state == UIGestureRecognizerStateCancelled || state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateFailed) {
        _base = -1;
        if(tonarm_pos == Turntable_Tonarm_number - 1) {
            [self playsound];
            tonarm_req = tonarm_pos;
            return;
        }
        [self stopsound];
        if(tonarm_pos < (Turntable_Tonarm_number - 1 - tonarm_pos)) {
            tonarm_req = 0;
        } else {
            tonarm_req = Turntable_Tonarm_number - 1;
        }
        _gestposition = tonarm_pos;
        return;
    }
    return;
}

- (void) resize:(DeviceOrientation)orient {
    [_background setFrame:Turntable_Background.rects[orient]];
    
    [_disc setFrame: Turntable_Disc_Rect[orient]];
    
    {
	    CGRect rect = Turntable_Logo1.rects[orient];
	    CGSize curf = [_logo1 frame].size, curb = [_logo1 bounds].size;
        curb.width	= rect.size.width * curb.width / curf.width;
        curb.height	= rect.size.height * curb.height / curf.height;
        CGPoint cen	= CGPointMake(rect.size.width * 0.5f, rect.size.height * 0.5f);
        [_logo1 setCenter:CGPointMake(rect.origin.x + cen.x, rect.origin.y + cen.y)];
        [_logo1 setBounds:CGRectMake(0, 0, rect.size.width, rect.size.height)];//CGRectMake(cen.x - curb.width * 0.5f, cen.y - curb.height, curb.width, curb.height)];
    }
    [_logo2 setFrame:Turntable_Logo2.rects[orient]];

    [_tonarm setFrame:Turntable_Tonarm_Rect[orient]];
    
    for(int i = 0; i < Turntable_Buttons_number; ++i)
        [_buttons[i] setFrame:Turntable_Buttons_Rect[i][orient]];
    
    [_description	setFrame:Turntable_Description.rects[orient]];
    [_description	reload];
    return;
}

- (void) loadAudio:(int)music {
    if(_music == music)
        return;
    
    [_player stop];
    [_player release];
    _player = nil;
    
    if(music < 0 || music >= Turntable_Buttons_number)
        return;
    
    tonarm_sel =  music;
    NSURL* url = [NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:Turntable_Music[music]]];
    if(url) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [_player setNumberOfLoops:-1];
    }
    if(music_play)
        [_player play];
    return;
}

- (void) startTimer {
	if(_timer == nil) {
		_timer = [NSTimer timerWithTimeInterval:(1.0f / 30)
                                         target:self
                                       selector:@selector(onTimer:)
                                       userInfo:nil
                                        repeats:TRUE];
        [_timer retain];
		[[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
	}
	return;
}

- (void) stopTimer {
	[_timer invalidate];
    [_timer release];
    _timer = nil;
	return;
}

- (void) onTimer:(NSTimer*)a_timer {
    
    CGAffineTransform trs = CGAffineTransformMakeRotation(_angle);
    
    _angle += M_PI / 60;
    [_logo1 setTransform:trs];
    
    if(_base == -1 && tonarm_pos != tonarm_req) {
        int r = tonarm_req;
        _gestposition = _gestposition * 0.8f + 0.2f * tonarm_req;
        [self setTonarmPhase:(int)(_gestposition + 0.5f)];
        tonarm_req = r;
    }
    
    return;
}

- (void) stopAll {
    [self stopsound];
    [_disc stopAnimating];
    [self stopTimer];
    return;
}

- (void) pause {
    [_disc stopAnimating];
    [self stopTimer];
    return;
}

- (void) start {
    [_disc startAnimating];
    [self onTimer:nil];
    [self startTimer];
    
    if(music_play)
    	[self playsound];
    return;
}

- (UIButton*) createButtonNumber:(int)number{
    UIButton *ret = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [ret addTarget:self action:@selector(onKeyDown:) forControlEvents:UIControlEventTouchUpInside];
    [ret setTag:number];
    
    return ret;
}


- (void)onKeyDown:(id)sender {
    int t = [sender tag];
    
    if(tonarm_sel != t) {
        
        tonarm_sel = t;
        [self updateButtons];
        [self loadAudio:tonarm_sel];
        if(music_play) {
        	[self playsound];
        }
    }
    return;
}

- (void) updateButtons {
    for(int i = 0; i < Turntable_Buttons_number; ++i)
        if(i != tonarm_sel)
            [_buttons[i] setImage:_images[i][1] forState:UIControlStateNormal];
    	else
	 		[_buttons[i] setImage:_images[i][0] forState:UIControlStateNormal];
    return;
}

- (void) loadImageFromFile:(NSString*)name {
	UIImage *image = [UIImage imageNamed:name];
    
    // Unpack image if neeed
    if(image == nil || [_operation isCancelled])
    {
        [_operation release];
        _operation = nil;
     	return;
    }
    
    CGImageRef img = [image CGImage];
    
	int width = image.size.width;
	int height = image.size.height;
	
    CGColorSpaceRef dstSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, width, height,
                                             8, width * 4, dstSpace,
                                             kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(dstSpace);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), img);
    CGImageRef upckImg = CGBitmapContextCreateImage(ctx);
	
    image = [[[UIImage alloc] initWithCGImage: upckImg] autorelease];
    
    CGImageRelease(upckImg);
    CGContextRelease(ctx);
    
	[self performSelectorOnMainThread:@selector(postLoadImageFromFile:) withObject:image waitUntilDone:FALSE];
	return;
}

- (void) setTonarmPhase:(int)phase {
    if(phase < 0)
        phase = 0;
    else {
	    if(phase >= Turntable_Tonarm_number - 1) {
	        phase = Turntable_Tonarm_number - 1;
        }
    }

    if(_operation != nil) {
        tonarm_req = phase;
        return;
    }

    NSString* name = [NSString stringWithFormat:Turntable_Tonarm, phase];
    
    if([_tonarm image] == nil) {
        tonarm_req = tonarm_pos = phase;
        [_tonarm setImage:[UIImage imageNamed:name]];
        return;
    }
    if(tonarm_pos != phase) {
        tonarm_req = tonarm_pos = phase;
	    _operation			= [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImageFromFile:) object:name];
    	[_operationQueue	addOperation:_operation];
    }
    return;
}

- (void) postLoadImageFromFile:(UIImage*)image {
    if(image != nil)
	    [_tonarm setImage:image];
    [_operation release];
    _operation = nil;
    
    if(_base != -1) {
        if(tonarm_pos != tonarm_req) {
            [self setTonarmPhase:tonarm_req];
        }
        return;
    } else {
        if(tonarm_pos == tonarm_req) {
            if(tonarm_pos == Turntable_Tonarm_number - 1) {
                [self playsound];
                return;
            }
            [self stopsound];
            return;
        }    
    }
    return;
}

- (void) stopsound {
    if(music_play) {
        music_play = false;
        [_player stop];
    }
    return;
}

- (void) playsound {
    if(![_player isPlaying]) {
	    music_play = true;
        [_player setCurrentTime:0.0];
    	[_player play];
    }
    return;
}

@end
