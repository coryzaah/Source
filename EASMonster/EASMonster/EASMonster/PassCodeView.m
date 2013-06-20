//
//  PassCodeView.m
//  EASMonster
//
//  Created by ProgDenisMac on 08.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import "PassCodeView.h"

static NSString* const		PassCodeView_DialogBackgroundImage	= @"passcode_bkg.png";
static NSString* const		PassCodeView_DialogKeyUp			= @"passcode_key_up.png";
static NSString* const		PassCodeView_DialogKeyDown			= @"passcode_key_down.png";
static NSString* const		PassCodeView_DialogKeyText			= @"passcode_key_text.png";
static NSString* const		PassCodeView_DialogValNon			= @"passcode_val_non.png";
static NSString* const		PassCodeView_DialogValPrs			= @"passcode_val_prs.png";

static const CGSize			PassCodeView_DialogSize 			= {299.0f, 382.0f};
static const int			PassCodeView_KeyNumber				= 12;
static const CGRect			PassCodeView_KeyRects[PassCodeView_KeyNumber] =
{
    {{  9.0f, 156.0f}, { 88.0f,  49.0f}},
    {{105.0f, 156.0f}, { 88.0f,  49.0f}},
    {{202.0f, 156.0f}, { 88.0f,  49.0f}},
    {{  9.0f, 213.0f}, { 88.0f,  49.0f}},
    {{105.0f, 213.0f}, { 88.0f,  49.0f}},
    {{202.0f, 213.0f}, { 88.0f,  49.0f}},
    {{  9.0f, 269.0f}, { 88.0f,  49.0f}},
    {{105.0f, 269.0f}, { 88.0f,  49.0f}},
    {{202.0f, 269.0f}, { 88.0f,  49.0f}},
    {{  9.0f, 325.0f}, { 88.0f,  49.0f}},
    {{105.0f, 325.0f}, { 88.0f,  49.0f}},
    {{202.0f, 325.0f}, { 88.0f,  49.0f}},
};
static const CGRect			PassCodeView_KeyTextRect 			= {{ 18.0f, 159.0f}, {250.0f, 202.0f}};

static const int			PassCodeView_ValNumber				= 4;
static const CGRect			PassCodeView_ValRects[PassCodeView_ValNumber] =
{
    {{  9.0f,  90.0f}, { 59.0f,  49.0f}},
    {{ 82.0f,  90.0f}, { 59.0f,  49.0f}},
    {{155.0f,  90.0f}, { 59.0f,  49.0f}},
    {{229.0f,  90.0f}, { 59.0f,  49.0f}}
};

@interface PassCodeView ()

@end


@implementation PassCodeView

@synthesize passcode		= _return;
@synthesize delegate 		= _delegate;
@dynamic 	enableCancel;

- (bool) enableCancel {
    return [[_buttons objectAtIndex:9] isEnabled];
}

- (void) setEnableCancel:(bool)enableCancel {
    [[_buttons objectAtIndex:9] setEnabled:enableCancel];
    return;
}

- (void) willMoveToSuperview:(UIView *)newSuperview {
    if(newSuperview != nil) {
        CGRect rect = [newSuperview bounds];
        rect.origin = CGPointZero;

        [self setAutoresizingMask:UIViewAutoresizingNone];
        [self setFrame:rect];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        [_dialog	setAutoresizingMask:UIViewAutoresizingNone];
        [_dialog 	setCenter:CGPointMake(rect.size.width * 0.5f, rect.size.height * 0.5f)];
        [_dialog	setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    }
    return;
}

- (id)init
{
    self = [super init];
    if (self) {
        _return	= [[NSString alloc] init];
        
        // shadow frame
        [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f]];
        [self setUserInteractionEnabled:TRUE];
        
        { // passcode dialog frame
            CGRect 		dialogRect 	= CGRectMake(0.0f, 0.0f, PassCodeView_DialogSize.width, PassCodeView_DialogSize.height);
	        _dialog 				= [[UIView alloc] init];
            [_dialog 	setBounds:dialogRect];
            [self		addSubview:_dialog];
            [_dialog 	setUserInteractionEnabled:TRUE];
            [_dialog 	setClipsToBounds:TRUE];
            [_dialog 	release];
            
            { // background image
	            UIImage* 		image 		= [UIImage imageNamed:PassCodeView_DialogBackgroundImage];
                UIImageView*	background	= [[UIImageView alloc] initWithImage:image];
	            [background setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
                [background setFrame:dialogRect];
                [_dialog addSubview:background];
                [background release];
            }
            
            { //Keys
                UIImage* img_up		= [UIImage imageNamed:PassCodeView_DialogKeyUp];
                UIImage* img_down	= [UIImage imageNamed:PassCodeView_DialogKeyDown];
                NSMutableArray* arr = [[NSMutableArray alloc] init];
            	for(int i = 0; i < PassCodeView_KeyNumber; ++i) {
                    UIButton *but = [self createButtonUp:img_up down:img_down rect:PassCodeView_KeyRects[i] number:i];
                    [_dialog addSubview:but];
                    [arr addObject:but];
                }
                _buttons	= arr;
            }
            { //Keys text
                UIImage* 		image		= [UIImage imageNamed:PassCodeView_DialogKeyText];
                UIImageView*	text		= [[UIImageView alloc] initWithImage:image];
                [text	setFrame:PassCodeView_KeyTextRect];
                [_dialog addSubview:text];
                [text	release];
            }
            { // Value indicators
                _val_non	= [UIImage imageNamed:PassCodeView_DialogValNon];
                _val_prs	= [UIImage imageNamed:PassCodeView_DialogValPrs];
                NSMutableArray* arr = [[NSMutableArray alloc] init];

            	for(int i = 0; i < PassCodeView_ValNumber; ++i) {
                    UIImageView *val = [self createValueIndicator:_val_non rect:PassCodeView_ValRects[i]];
                    [_dialog addSubview:val];
                    [arr addObject:val];
                }
                
                _indicat	= arr;
                [_val_non retain];
                [_val_prs retain];
            }
        }
    }
    return self;
}

- (void) dealloc {
    [_return	release];
    [_val_non	release];
    [_val_prs	release];
    [_indicat	release];
    [_buttons	release];
    
    [super dealloc];
    return;
}

- (UIButton*) createButtonUp:(UIImage*)up down:(UIImage*)down rect:(CGRect)rect number:(int)number{
    UIButton *ret = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [ret addTarget:self action:@selector(onKeyDown:) forControlEvents:UIControlEventTouchUpInside];
    [ret setImage:up forState:UIControlStateNormal];
    [ret setImage:down forState:UIControlStateHighlighted];
    [ret setFrame:rect];
    [ret setTag:number];
    
    return ret;
}

- (UIImageView*) createValueIndicator:(UIImage*)img rect:(CGRect)rect {
    UIImageView* val = [[[UIImageView alloc] initWithImage:img] autorelease];
    [val setFrame:rect];
    return val;
}

- (void) updateIndicators {
    int n = [_indicat count];
    int s = [_return length];
    int i;
    for(i = 0; i < s; ++i)
        [[_indicat objectAtIndex:i] setImage:_val_prs];
    for(; i < n; ++i)
        [[_indicat objectAtIndex:i] setImage:_val_non];
    return;
}

- (void)onKeyDown:(id)sender {
    int t = [sender tag];
    if(t == 9) {
        if([_delegate respondsToSelector:@selector(cancelPasscode:)])
            [_delegate performSelector:@selector(cancelPasscode:) withObject:self];
        return;
    }
    if(t == 11) {
        int l = [_return length];
        if(l > 0) {
            NSRange r;
            r.location 	= 0;
            r.length	= l - 1;
            NSString* t = [_return substringWithRange:r];
            [_return release];
            _return = t;
            [_return retain];
            [self updateIndicators];
        }
        return;
    }
    if([_return length] >= 4)
        return;
    if(t == 10)
        t = 0;
    else
        ++t;
    NSString *v = [_return stringByAppendingFormat:@"%d", t];
    [v retain];
    [_return release];
    _return = v;
    [_return retain];
    [self updateIndicators];
    if([v length] >= 4) {
        if([_delegate respondsToSelector:@selector(enterPasscode:)])
            [_delegate performSelector:@selector(enterPasscode:) withObject:self];
        return;
    }
    return;
}

- (void)reset {
    _return = @"";
    [self updateIndicators];
    return;
}


@end
