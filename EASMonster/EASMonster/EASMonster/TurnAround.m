//
//  TurnAround.m
//  EASMonster
//
//  Created by ProgDenisMac on 08.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import "TurnAround.h"

static NSString* const	TurnAround_Col_Background	= @"turnaround_col_bkg.png";
static NSString* const	TurnAround_Mic_Background	= @"turnaround_mic_bkg.png";
static NSString* const	TurnAround_Slider_Thumb		= @"turnaround_slider_thumb.png";

static const int		TurnAround_Seq_length[4] =
{
    180,
    180,
    180,
    180
};

static NSString* const	TurnAround_Seq_Prefix[4]	=
{
 	@"turnaround_seq_b0_%04d.jpg",
 	@"turnaround_seq_b1_%04d.jpg",
 	@"turnaround_seq_w0_%04d.jpg",
 	@"turnaround_seq_w1_%04d.jpg",
};

static const int TurnAround_Col_Key_Count = 4;
static NSString* const	TurnAround_Col_Key[TurnAround_Col_Key_Count]=
{
 	@"turnaround_col_blk_nor.png",
 	@"turnaround_col_blk_prs.png",
 	@"turnaround_col_wht_nor.png",
 	@"turnaround_col_wht_prs.png"
};

static const int TurnAround_Mic_Key_Count = 4;
static NSString* const	TurnAround_Mic_Key[TurnAround_Mic_Key_Count]=
{
 	@"turnaround_mic_on_nor.png",
 	@"turnaround_mic_on_prs.png",
 	@"turnaround_mic_off_nor.png",
 	@"turnaround_mic_off_prs.png"
};

static const FileItemInfo TurnAround_Background	=
{
    @"turnaround_background.jpg",
    {{{ 138,   0}, {  748,  748}}, {{   9, 126}, {  748,  748}}}
};

static const FileItemInfo TurnAround_Logo	=
{
    @"turnaround_logo.png",
    {{{ 795,  30}, { 208,  114}}, {{ 540,  29}, { 208,  114}}}
};

static const FileItemInfo TurnAround_BorderDown	=
{
    @"turnaround_bor_dwn.png",
    {{{  0, 129}, { 1024, 473}}, {{-100, 164}, {  970, 473}}}
};

static const CGRect TurnAround_Show[DeviceOrientation_Count]	=
{
    {{ 143, 55}, { 787, 626}}, {{ 0, 162}, { 787, 626}}
};

static const CGRect TurnAround_Slider[DeviceOrientation_Count]	=
{
    {{ 330, 643}, { 370, 75}},
    {{ 201, 787}, { 370, 75}}
};

static const FileItemInfo TurnAround_Slider_Back =
{
    @"turnaround_slider_back.png",
    {{{ 330, 677}, { 370, 4}}, {{ 201, 821}, { 370, 4}}}
};

static const FileItemInfo TurnAround_Text	=
{
    @"turnaround_text.png",
    {{{ 437, 644}, { 163, 10}}, {{ 314, 776}, { 163, 10}}}
};

static const CGRect TurnAround_Col[DeviceOrientation_Count]	=
{
    {{ 829,  266}, { 195,  79}},
    {{ 573,  344}, { 195,  79}}
};

static const CGRect TurnAround_Mic[DeviceOrientation_Count]	=
{
    {{ 829,  347}, { 195,  79}},
    {{ 573,  430}, { 195,  79}}
};

static const CGRect TurnAround_Col_key[2] =
{
    {{ 113,  33}, { 44,  46}},
    {{ 158,  33}, { 37,  45}}
};

static const CGRect TurnAround_Mic_key[2] =
{
    {{ 153,  30}, { 39,  45}},
    {{ 106,  30}, { 39,  45}}
};

static const FileItemInfo TurnAround_Description	=
{
    @"turnaround_description.html",
    {{{ -5, 243}, { 228, 300}}, {{ 26, 827}, { 722, 200}}}
};

@implementation TurnAround

static BOOL mic_on = TRUE;
static BOOL col_wht = TRUE;
static int	img_num = 0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_request		= -1;
		_operationQueue = [[NSOperationQueue alloc] init];
        [self setBackgroundColor:[UIColor blackColor]];
        
        {
            _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TurnAround_Background.fileName]];
            [self addSubview:_background];
        }

        {
	        _show = [[UIImageView alloc] init];
    	    [self addSubview:_show];
        }

        {
            _borderDown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TurnAround_BorderDown.fileName]];
        	[self addSubview:_borderDown];
        }

        {
            _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TurnAround_Logo.fileName]];
            [self addSubview:_logo];
        }
        
        {
            for(int i = 0 ; i < TurnAround_Col_Key_Count; ++i) {
                _imageKeyCol[i] = [UIImage imageNamed:TurnAround_Col_Key[i]];
                [_imageKeyCol[i] retain];
            }
            _shooseCol = [[UIView alloc] init];
            [_shooseCol setFrame:CGRectMake(0 ,0 ,1 ,1)];
            UIImageView* bkg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TurnAround_Col_Background]];
            [bkg setFrame:CGRectMake(0 ,0 ,1 ,1)];
            [bkg setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [_shooseCol addSubview:bkg];
            [bkg release];
            
            _shooseCol_Blk = [self createButtonRect:TurnAround_Col_key[0] number:0];
            _shooseCol_Wht = [self createButtonRect:TurnAround_Col_key[1] number:1];
            [_shooseCol addSubview:_shooseCol_Blk];
            [_shooseCol addSubview:_shooseCol_Wht];
            
            [_shooseCol_Blk retain];
            [_shooseCol_Wht retain];
            [_shooseCol		retain];
            [self addSubview:_shooseCol];
        }

        {
            for(int i = 0 ; i < TurnAround_Mic_Key_Count; ++i) {
                _imageKeyMic[i] = [UIImage imageNamed:TurnAround_Mic_Key[i]];
                [_imageKeyMic[i] retain];
            }
            _shooseMic = [[UIView alloc] init];
            [_shooseMic setFrame:CGRectMake(0 ,0 ,1 ,1)];
            UIImageView* bkg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TurnAround_Mic_Background]];
            [bkg setFrame:CGRectMake(0 ,0 ,1 ,1)];
            [bkg setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [_shooseMic addSubview:bkg];
            [bkg release];

            _shooseMic_On = [self createButtonRect:TurnAround_Mic_key[0] number:2];
            _shooseMic_Off = [self createButtonRect:TurnAround_Mic_key[1] number:3];
            [_shooseMic addSubview:_shooseMic_On];
            [_shooseMic addSubview:_shooseMic_Off];
            
            [_shooseMic_On retain];
            [_shooseMic_Off retain];
            [_shooseMic		retain];
            [self addSubview:_shooseMic];            
        }
        
        if(TurnAround_Description.fileName != nil) {
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
	            NSURL* url = [NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:TurnAround_Description.fileName]];
	            if(!url)
    	            url = [NSURL URLWithString:@"about:blank"];
                [_description loadRequest: [NSURLRequest requestWithURL:url]];
            }
            
            [self addSubview:_description];
        }

        {
            _slider_back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TurnAround_Slider_Back.fileName]];
            [self addSubview:_slider_back];
            
	        _slider = [[UISlider alloc] init];
            [_slider setMinimumValue:0.0f];
            [_slider setMaximumValue:1.0f];
            [_slider setMaximumTrackImage:[[UIImage new] autorelease] forState:UIControlStateNormal];
            [_slider setThumbImage:[UIImage imageNamed:TurnAround_Slider_Thumb] forState:UIControlStateNormal];
            [_slider addTarget:self action:@selector(changeSliderPosition:) forControlEvents:UIControlEventValueChanged];
    	    [self addSubview:_slider];

            _text = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TurnAround_Text.fileName]];
            [self addSubview:_text];
        }
        
        [self updateColKey];
        [self updateMicKey];
        [self updateShow];
        [self resize:detectDeviceOrientation()];
    }
    return self;
}

- (void) dealloc {
    [_background 	release];
    [_logo			release];

    [_operation cancel];
    [_operation release];
    [_operationQueue release];
    
    [_borderDown release];

    for(int i = 0 ; i < TurnAround_Col_Key_Count; ++i)	[_imageKeyCol[i] release];
    for(int i = 0 ; i < TurnAround_Mic_Key_Count; ++i)	[_imageKeyMic[i] release];
	[_shooseCol_Blk release];
	[_shooseCol_Wht release];
	[_shooseMic_On release];
	[_shooseMic_Off release];
    [_shooseCol release];
    [_shooseMic release];

    [_show 			release];
    [_slider 		release];
    [_slider_back	release];
    [_text 			release];

    [_description	release];

    [super dealloc];
}

- (void) resize:(DeviceOrientation)orient {
    [_background 	setFrame:TurnAround_Background.rects[orient]];
    [_logo			setFrame:TurnAround_Logo.rects[orient]];
    
    [_borderDown	setFrame:TurnAround_BorderDown.rects[orient]];
    
    [_show			setFrame:TurnAround_Show[orient]];
    [_slider		setFrame:TurnAround_Slider[orient]];
    [_slider_back	setFrame:TurnAround_Slider_Back.rects[orient]];
    [_text			setFrame:TurnAround_Text.rects[orient]];
    
    [_shooseCol		setFrame:TurnAround_Col[orient]];
    [_shooseMic		setFrame:TurnAround_Mic[orient]];
    
    [_description	setFrame:TurnAround_Description.rects[orient]];
    [_description	reload];
    return;
}

- (void)changeSliderPosition:(UISlider*)slider {
    [self updateShow];
    return;
}

- (UIButton*) createButtonRect:(CGRect)rect number:(int)number{
    UIButton *ret = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [ret addTarget:self action:@selector(onKeyDown:) forControlEvents:UIControlEventTouchUpInside];
    [ret setFrame:rect];
    [ret setTag:number];
    return ret;
}

- (void) clearImage {
    img_num = -1;
    if(_operation) {
        [_operation cancel];
        [_operation release];
        _operation = nil;
    }
    return;
}

- (void) updateColKey {
    if(col_wht) {
        [_shooseCol_Blk setImage:_imageKeyCol[0] forState:UIControlStateNormal];
        [_shooseCol_Wht setImage:_imageKeyCol[3] forState:UIControlStateNormal];
    } else {
        [_shooseCol_Blk setImage:_imageKeyCol[1] forState:UIControlStateNormal];
        [_shooseCol_Wht setImage:_imageKeyCol[2] forState:UIControlStateNormal];
    }
    [self clearImage];
    [self updateShow];
    return;
}

- (void) updateMicKey {
    if(mic_on) {
        [_shooseMic_On setImage:_imageKeyMic[0] forState:UIControlStateNormal];
        [_shooseMic_Off setImage:_imageKeyMic[3] forState:UIControlStateNormal];
    } else {
        [_shooseMic_On setImage:_imageKeyMic[1] forState:UIControlStateNormal];
        [_shooseMic_Off setImage:_imageKeyMic[2] forState:UIControlStateNormal];
    }
    [self clearImage];
    [self updateShow];
    return;
}

- (void) updateShow {
    int idx;
    if(col_wht) {
        if(mic_on) {
            idx = 2;
        } else {
            idx = 3;
        }
    } else {
        if(mic_on) {
            idx = 0;
        } else {
            idx = 1;
        }
    }
    int v = (int)(TurnAround_Seq_length[idx] * [_slider value]);
    if(v >= TurnAround_Seq_length[idx]) {
        v = 0;
    }
    
    NSString* name = [NSString stringWithFormat:TurnAround_Seq_Prefix[idx], v];
    
    if([_show image] == nil) {
        [_show setImage:[UIImage imageNamed:name]];
        return;
    }
    if(_operation != nil) {
        _request = v;
        return;
    }
    img_num 	= v;
    _request	= -1;
    _operation			= [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImageFromFile:) object:name];
    [_operationQueue	addOperation:_operation];
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

- (void) postLoadImageFromFile:(UIImage*)image {
    if(image != nil)
	    [_show setImage:image];
    [_operation release];
    _operation = nil;
    if(_request != -1) {
        [self updateShow];
    }
    return;
}

- (void)onKeyDown:(id)sender {
    int t = [sender tag];
    bool up = false;
    switch(t) {
        case 0:
            if(col_wht != FALSE) {
	            col_wht = FALSE;
    	        [self updateColKey];
                up = true;
            }
            break;
        case 1:
            if(col_wht != TRUE) {
	            col_wht = TRUE;
    	        [self updateColKey];
                up = true;
            }
            break;
        case 2:
            if(mic_on != FALSE) {
	            mic_on = FALSE;
    	        [self updateMicKey];
                up = true;
            }
            break;
        case 3:
            if(mic_on != TRUE) {
	            mic_on = TRUE;
    	        [self updateMicKey];
                up = true;
            }
            break;
    }
    if(up)
        [self updateShow];
    return;
}

- (void) stopAll {
}

- (void) pause {
}

- (void) start {
}

@end
