//
//  GameLogic.h
//  BubbleBlitz
//
//  Created by Kelvin on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import "cocos2d.h"

enum operators
{
    ADDITION,
    SUBTRACTION,
    MULTIPlICATION,
    DIVISION,
    REMAINDER,
    FRACTION
};

@interface GameLogic : NSObject{

}

+(int)genNum;
+(int)getVal:(int)i;
+(int)getValExprOp:(int)i expr:(NSString**)str op:(operators*)op;
+(NSString*)getExpr:(int)i mode:(int)m;
+(operators)getOp:(int)i;

@end
