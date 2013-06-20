//
//  PassCodeView.h
//  EASMonster
//
//  Created by ProgDenisMac on 08.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PassCodeView;

@protocol PassCodeView_Delegate <NSObject>
@optional
- (void) enterPasscode:(PassCodeView*)sender;
- (void) cancelPasscode:(PassCodeView*)sender;
@end


@interface PassCodeView : UIView {
    UIView*		_dialog;
    NSArray*	_indicat;
    NSArray*	_buttons;
    UIImage*	_val_non;
    UIImage*	_val_prs;
    NSString*	_return;
}

@property (nonatomic, strong, readonly)		NSString*					passcode;
@property (nonatomic, strong, retain)		id<PassCodeView_Delegate>	delegate;
@property (nonatomic)						bool						enableCancel;

- (void)reset;

@end
