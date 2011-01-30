//
//  ToggleMenu.h
//  BubbleBlitz
//
//  Created by Robert Backman on 1/30/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//

#import "cocos2d.h"


@interface ToggleMenu : CCMenuItem {
	bool toggleOn;
	CCLabelTTF* label;
	NSString* labelString;
}

-(id)initWithString:(NSString*)string selector:(SEL)s;
+(id)toggleMenuWithString:(NSString*)string selector:(SEL)s;
@property(nonatomic,readonly)bool toggleOn;;

@end
