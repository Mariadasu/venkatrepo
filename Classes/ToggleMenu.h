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

-(id)initWithString:(NSString*)string target:(id)t selector:(SEL)s value:(bool)val;
+(id)toggleMenuWithString:(NSString*)string target:(id)t selector:(SEL)s  value:(bool)val;
@property(nonatomic,readonly)bool toggleOn;;

@end
