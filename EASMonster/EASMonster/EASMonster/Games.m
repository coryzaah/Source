//
//  Games.m
//  EASMonster
//
//  Created by ProgDenisMac on 12.04.13.
//  Copyright (c) 2013 HAAB. All rights reserved.
//

#import "Games.h"

static const FileItemInfo Games_Background	=
{
    @"games_background.jpg",
    {{{ 138,   0}, {  748,  748}}, {{   9, 126}, {  748,  748}}}
};

static const FileItemInfo Games_Logo	=
{
    @"games_logo.png",
    {{{ 795,  30}, { 208,  114}}, {{ 540,  29}, { 208,  114}}}
};

static const int Games_Count = 4;
static const SingleGameInfo Games_info[Games_Count] = {
    {
        @"games_img_00.jpg",
        @"games_txt_00.html",
        @"https://itunes.apple.com/us/app/madden-nfl-12-by-ea-sports/id456083786",
        {{ 140, 200}, { 196, 192}},
    },
    {
        @"games_img_01.jpg",
        @"games_txt_01.html",
        @"https://itunes.apple.com/us/app/nba-jam-by-ea-sports-for-ipad/id426282304?mt=8",
        {{ 583, 200}, { 196, 353}},
    },
    {
        @"games_img_02.jpg",
        @"games_txt_02.html",
        @"https://itunes.apple.com/us/app/tiger-woods-pga-tour-12-for/id427703804?mt=8",
        {{ 140, 440}, { 196, 520}},
    },
    {
        @"games_img_03.jpg",
        @"games_txt_03.html",
        @"https://itunes.apple.com/us/app/fifa-soccer-13-by-ea-sports/id547407138?mt=8",
        {{ 583, 440}, { 196, 698}},
    }
};


@implementation Games

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        {
            _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Games_Background.fileName]];
            _logo		= [[UIImageView alloc] initWithImage:[UIImage imageNamed:Games_Logo.fileName]];
            
            [self addSubview:_background];
            [self addSubview:_logo];
        }
        
        {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:Games_Count];
            
            for(int i = 0; i < Games_Count; ++i) {
                SingleGame* game = [[SingleGame alloc] initWithInfo:Games_info[i]];
                [self addSubview:game];
                [arr addObject:game];
            }
            
            _games = arr;
        }
        [self resize:detectDeviceOrientation()];
    }
    return self;
}

- (void) dealloc {
    [_background	release];
    [_logo			release];
    [_games			release];
    [super dealloc];
}

- (void) resize:(DeviceOrientation)orient {
    [_background	setFrame:Games_Background.rects[orient]];
    [_logo			setFrame:Games_Logo.rects[orient]];
    
    {
	    int n = [_games count];
        for(int i = 0; i < n; ++i) {
            CGPoint pos = Games_info[i].position[orient];
            [[_games objectAtIndex:i] setFrame:CGRectMake(pos.x, pos.y, SingleGame_Size.width, SingleGame_Size.height)];
        }
    }
    
    return;
}

- (void) stopAll {
}

- (void) pause {
}

- (void) start {
}

@end
