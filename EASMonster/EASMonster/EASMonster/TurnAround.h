//
//  TurnAround.h
//  EASMonster
//
//  Created by ProgDenisMac on 08.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceSupport.h"

@interface TurnAround : UIView<FrameResize> {
    UIImageView*			_logo;
    UIImageView*			_background;
    UIImageView*			_borderDown;
    
    UIView*					_shooseCol;
    UIView*					_shooseMic;
    UIImage*				_imageKeyCol[4];
    UIImage*				_imageKeyMic[4];
    UIButton*				_shooseCol_Blk;
    UIButton*				_shooseCol_Wht;
    UIButton*				_shooseMic_On;
    UIButton*				_shooseMic_Off;

    UIImageView*			_show;
    UISlider*				_slider;
    UIImageView*			_slider_back;
    UIImageView*			_text;
    int						_request;
    NSInvocationOperation*	_operation;
	NSOperationQueue*		_operationQueue;
    
	UIWebView*				_description;
}

@end
