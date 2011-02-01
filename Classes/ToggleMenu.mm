//
//  ToggleMenu.m
//  BubbleBlitz
//
//  Created by Robert Backman on 1/30/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//

#import "ToggleMenu.h"


@implementation ToggleMenu

@synthesize toggleOn;

-(id)initWithString:(NSString*)lbl selector:(SEL)s  value:(bool)val
{
	self = [super initWithTarget:nil selector:s];
	if( self ) 
	{
		toggleOn = val;
		labelString = lbl;
		
		if (toggleOn) 
		{
			label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ ON",labelString] dimensions:CGSizeMake(256, 64)  alignment:CCTextAlignmentRight fontName:@"Marker Felt" fontSize:32];
		}
		else 
		{
			label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ OFF",labelString] dimensions:CGSizeMake(256, 64)  alignment:CCTextAlignmentRight fontName:@"Marker Felt" fontSize:32];
			
		}

			[self setContentSize:CGSizeMake(256, 80)];
		

		[self addChild:label];
	}
	
	return self;
}

+(id)toggleMenuWithString:(NSString*)label selector:(SEL)s  value:(bool)val
{
	return [[[ToggleMenu alloc]	initWithString:label selector:s  value:val] autorelease];
}

-(void) selected
{
	toggleOn = !toggleOn;
	if(toggleOn)
		[label setString:[NSString stringWithFormat:@"%@ ON",labelString]];
	else 
		[label setString:[NSString stringWithFormat:@"%@ OFF",labelString]];
}

@end
