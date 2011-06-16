//
//  BonusLabel.m
//  BubbleBlitz
//
//  Created by Robert Backman on 6/10/11.
//  Copyright 2011 Student: UC Merced. All rights reserved.
//

#import "BonusLabel.h"


@implementation BonusLabel




-(id)initWithPosition:(CGPoint)p value:(int)v
{
    self = [super init];
	if(self){
        
    labelScale = 0.1f;
        bonusLabel  = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",v] fontName:@"Marker Felt" fontSize:64];
        [self addChild:bonusLabel z:0];
        [bonusLabel setColor:ccc3(255,255,255)];
        bonusLabel.position = p;
        [self schedule:@selector(update:)];
        
       // [bonusLabel setVisible:NO];
    }    
    return self;
    
}
                    
+(id)bonusLabelWithPosition:(CGPoint)p value:(int)v
{
 return   [[[BonusLabel alloc] initWithPosition:p value:v]autorelease]; 
}

-(void)update:(ccTime)dt
{
    labelScale += 0.2f;
    [bonusLabel setScale:labelScale];
    if(labelScale>2.0f)
        [self removeFromParentAndCleanup:YES];
}
@end
