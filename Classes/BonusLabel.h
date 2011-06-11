//
//  BonusLabel.h
//  BubbleBlitz
//
//  Created by Robert Backman on 6/10/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BonusLabel : CCNode 
{
     CCLabelTTF* bonusLabel; 
     float labelScale;
}

-(id)initWithPosition:(CGPoint)p value:(int)v;
+(id)bonusLabelWithPosition:(CGPoint)p value:(int)v;

@end
