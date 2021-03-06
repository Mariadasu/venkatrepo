//
//  MenuScene.m
//  BubbleBlitz
//
//  Created by Robert Backman on 1/28/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//

#import "SettingScene.h"
#import "GameScene.h"
#import "ToggleMenu.h"

// enums that will be used as tags
enum {
	kTagMenuBackground = -1,
	kTagMenuButton1,
	kTagDiffLabel
};


// HelloWorld implementation
@implementation SettingScene


static SettingScene *sharedSettingScene = nil;

+(id)scene
{
	if (sharedSettingScene == nil) 
	{
		sharedSettingScene = [[[SettingScene alloc] init] autorelease];
	}
	return sharedSettingScene;	
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
-(void)divToggle: (id) sender
{
	[[GameScene scene] setDivision:[(ToggleMenu*)sender toggleOn]];	
}
-(void)remToggle: (id) sender
{
	[[GameScene scene] setRemainder:[(ToggleMenu*)sender toggleOn]];	
}
-(void)subToggle: (id) sender
{
	[[GameScene scene] setSubtraction:[(ToggleMenu*)sender toggleOn]];	
}
-(void)addToggle: (id) sender
{
	[[GameScene scene] setAddition:[(ToggleMenu*)sender toggleOn]];	
}
-(void)multToggle: (id) sender
{
	[[GameScene scene] setMultiplication:[(ToggleMenu*)sender toggleOn]];	
}

-(void)symToggle: (id) sender
{
	[[GameScene scene] setSymbols:[(ToggleMenu*)sender toggleOn]];	
}

-(void)fracToggle: (id) sender
{
	[[GameScene scene] setFraction:[(ToggleMenu*)sender toggleOn]];	
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
		
		screenSize = [CCDirector sharedDirector].winSize;
	
		
		
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
	
		
		CCMenuItem *harder = [CCMenuItemFont itemFromString: @"Harder" target: self selector:@selector(makeHarder:) ];
		harder.position = ccp(0,-64);
		CCMenuItem *easier = [CCMenuItemFont itemFromString: @"Easier" target: self selector:@selector(makeEasier:)];
		easier.position	= ccp(0,-128);
		
        ToggleMenu* symT = [ToggleMenu toggleMenuWithString:@"Symbols" target: self selector:@selector(symToggle:) value:[[GameScene scene] symbols]];
		symT.position = ccp(0,-192); // 
		ToggleMenu* addT = [ToggleMenu toggleMenuWithString:@"Addition" target: self selector:@selector(addToggle:) value:[[GameScene scene] addition]];
		addT.position = ccp(0,-256); // 320
		ToggleMenu* subT = [ToggleMenu toggleMenuWithString:@"Subtraction" target: self selector:@selector(subToggle:) value:[[GameScene scene] subtraction]];
		subT.position = ccp(0,-320); // 384
		ToggleMenu* divT = [ToggleMenu toggleMenuWithString:@"Division" target: self selector:@selector(divToggle:) value:[[GameScene scene] division]];
		divT.position = ccp(0,-384); // 192
		ToggleMenu* multT = [ToggleMenu toggleMenuWithString:@"Multiplication" target: self selector:@selector(multToggle:) value:[[GameScene scene] multiplication]];
		multT.position = ccp(0,-448); // 256
		ToggleMenu* remT = [ToggleMenu toggleMenuWithString:@"Remainder" target: self selector:@selector(remToggle:) value:[[GameScene scene] remainder]];
		remT.position = ccp(0,-512);
		ToggleMenu* fracT = [ToggleMenu toggleMenuWithString:@"Fraction" target: self selector:@selector(fracToggle:) value:[[GameScene scene] fraction]];
		fracT.position = ccp(0,-576);
        
		
		CCMenu *menu = [CCMenu menuWithItems:resumeButton,harder,easier,symT,addT,subT,divT,multT,remT, fracT, nil];
		
		menu.position = ccp(512,screenSize.height-32);
		
		[self addChild: menu z:1];

		
		// enable touches
		self.isTouchEnabled = YES;
		
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		
	
		
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
