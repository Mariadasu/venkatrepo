//
//  MenuScene.h
//  BubbleBlitz
//
//  Created by Robert Backman on 1/28/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//


#import "cocos2d.h"


// HelloWorld Layer
@interface MenuScene : CCLayer
{
	bool first;
	CCSprite* background;
	CGSize screenSize;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

@end
