//
//  MenuScene.m
//  BubbleBlitz
//
//  Created by Robert Backman on 1/28/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "ToggleMenu.h"
#import "SettingScene.h"

// enums that will be used as tags
enum {
	kTagMenuBackground = -1,
	kTagMenuButton1,
	kTagDiffLabel
};


// HelloWorld implementation
@implementation MenuScene


static MenuScene *sharedMenuScene = nil;

+(id)scene
{
	if (sharedMenuScene == nil) 
	{
		sharedMenuScene = [[[MenuScene alloc] init] autorelease];
	}
	return sharedMenuScene;	

}

-(void) resumeGame: (id) sender
{
    [[CCDirector sharedDirector] pushScene:[CCTransitionFlipY transitionWithDuration:2 scene:[GameScene scene]] ];
	
}
-(void) settings: (id) sender
{
	[[CCDirector sharedDirector] pushScene:[CCTransitionMoveInR transitionWithDuration:2 scene:[SettingScene scene]] ];

}
-(void)newGame: (id) sender
{
    [[CCDirector sharedDirector] pushScene:[CCTransitionMoveInL transitionWithDuration:2 scene:[GameScene scene]] ];
	[[GameScene scene] setLevel:0];	
    [[GameScene scene] setDifficulty:0];	
    [[GameScene scene] setScore:0];
	
}

-(id) init
{
	if( (self=[super init])) {
		
		background = [CCSprite spriteWithFile:@"menuBackground.jpg"];
		background.anchorPoint = ccp(0,0);
		background.position = ccp(0,0);
		
		[self addChild:background z:kTagMenuBackground tag:kTagMenuBackground];
		//[background runAction:[WavePool  waveWithImage:background size:ccg(30,30)]];
		
		screenSize = [CCDirector sharedDirector].winSize;
	
		
		
		//this just pops the menu scene from the director
		CCMenuItemImage *resumeButton = [CCMenuItemImage itemFromNormalImage:@"resume.png" selectedImage:@"resume.png" target:self selector:@selector(resumeGame:)];
		[resumeButton setScale:3];
		
        CCMenuItemFont *newGameButton = [CCMenuItemFont itemFromString:@"NEW GAME" target:self selector:@selector(newGame:)];
        CCMenuItemFont *resumeGameButton = [CCMenuItemFont itemFromString:@"RESUME" target:self selector:@selector(resumeGame:)];
        CCMenuItemFont *settings = [CCMenuItemFont itemFromString:@"SETTINGS" target:self selector:@selector(settings:)];
        
		
		
		newGameButton.position = ccp(0,-192); // 
		resumeGameButton.position = ccp(0,-256); // 320
		
		settings.position = ccp(0,-320); // 384
		 
		
		CCMenu *menu = [CCMenu menuWithItems:newGameButton,resumeGameButton,settings, nil];
		
		menu.position = ccp(512,screenSize.height-32);
		
		[self addChild: menu z:1];

		
		// enable touches
		self.isTouchEnabled = YES;
		
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		
	
		
				
		
		first = YES;
	}
	return self;
}



@end
