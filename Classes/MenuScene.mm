//
//  MenuScene.m
//  BubbleBlitz
//
//  Created by Robert Backman on 1/28/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"

// enums that will be used as tags
enum {
	kTagMenuBackground = -1,
	kTagMenuButton1,
	kTagDiffLabel
};


// HelloWorld implementation
@implementation MenuScene


//static MenuScene *sharedMenuScene = nil;

+(id)scene
{
	/*if (sharedMenuScene == nil) 
	{
		sharedMenuScene = [[[MenuScene alloc] init] autorelease];
	}
	return sharedMenuScene;	
	*/
	return [[[MenuScene alloc] init] autorelease];
}

-(void) resumeGame: (id) sender
{
	[[CCDirector sharedDirector] popScene];
}
-(void)makeHarder: (id) sender
{
	[[GameScene scene] setDifficulty:[[GameScene scene] difficulty]+1];
	
	CCLabelTTF *difficultyLabel = (CCLabelTTF*)[self getChildByTag:kTagDiffLabel];
	[difficultyLabel setString:[NSString stringWithFormat:@"Difficulty %d",[[GameScene scene] difficulty]]];
	
	
}
-(void)makeEasier: (id) sender
{
	int diff = [[GameScene scene] difficulty];
	if (diff>1) {
		[[GameScene scene] setDifficulty:[[GameScene scene] difficulty]-1];
		
		CCLabelTTF *difficultyLabel = (CCLabelTTF*)[self getChildByTag:kTagDiffLabel];
		[difficultyLabel setString:[NSString stringWithFormat:@"Difficulty %d",[[GameScene scene] difficulty]]];
		
	}
}

-(id) init
{
	if( (self=[super init])) {
		
		background = [CCSprite spriteWithFile:@"menuBackground.jpg"];
		background.anchorPoint = ccp(0,0);
		background.position = ccp(0,0);
		
		[self addChild:background z:kTagMenuBackground tag:kTagMenuBackground];
		//[background runAction:[WavePool  waveWithImage:background size:ccg(30,30)]];
		
		
		
		//this just pops the menu scene from the director
		CCMenuItemImage *resumeButton = [CCMenuItemImage itemFromNormalImage:@"resume.png" selectedImage:@"resume.png" target:self selector:@selector(resumeGame:)];
		[resumeButton setScale:3];
		
		
		//to change the difficulty
		//there are two buttons harder and easier and a lable which displays the gamescane difficulty
		//we may want to make a slider or maybe derive a menu button which has all these elements
		
		int diff = [[GameScene scene] difficulty];
		CCLabelTTF *difficultyLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Difficulty %d",diff] fontName:@"Marker Felt" fontSize:32];
		[self addChild:difficultyLabel z:0 tag:kTagDiffLabel];
		difficultyLabel.position = ccp( 100,320);
	
		
		CCMenuItem *harder = [CCMenuItemFont itemFromString: @"Harder" target: self selector:@selector(makeHarder:)];
		harder.position = ccp(0,-64);
		CCMenuItem *easier = [CCMenuItemFont itemFromString: @"Easier" target: self selector:@selector(makeEasier:)];
		easier.position	= ccp(0,-128);
		
		CCMenu *menu = [CCMenu menuWithItems:resumeButton,harder,easier, nil];
		
		menu.position = ccp(256,400);
		
		[self addChild: menu z:1];

		
		// enable touches
		self.isTouchEnabled = YES;
		
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		screenSize = [CCDirector sharedDirector].winSize;
		
	
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( screenSize.width/2, screenSize.height-50);
		
		//[self schedule: @selector(tick:)];
		
		first = YES;
	}
	return self;
}



@end
