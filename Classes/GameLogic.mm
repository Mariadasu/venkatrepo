//
//  GameLogic.m
//  BubbleBlitz
//
//  Created by Kelvin on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import "cocos2d.h"
//#import "Box2D.h"
//#import "GLES-Render.h"
#import "GameConfig.h"
#import "GameLogic.h"
#import "GameScene.h"

@implementation GameLogic

int MAXNUM = 10000;

+(int)genNum
{
    int v = 0, effNum = 0, count = 0;
    operators op;
    NSString *str;
    bool fraction = [[GameScene scene] fraction];
    do
    {
        v = rand() % MAXNUM;
        v = (rand()%2)?-v:v;
        effNum = [self getValExprOp:v expr:&str op:&op];
        count++;
        if (effNum > 9 && effNum <= 100)
            printf("Number between 9-100 %d = %d", v, effNum);
    } while (effNum == 0 || (effNum <= 100 && fraction && effNum > 9) ||    // It's not 0 or between -9 and 9
             (!fraction && effNum > 9) || effNum < -9);                     // fractions are 102-809
    if (count > 3)
        printf("Count is %d\n", count);
    
    printf("Final generated %d and str %s\n", v, [str UTF8String]);
    return v;
}

+(int)getVal:(int)i
{
    NSString *str;
    operators op;
    return [self getValExprOp:i expr:&str op:&op];
}

+(int)getValExprOp:(int)i expr:(NSString **)str op:(operators*)op
{
    int fourthD = i/1000;
    i = i%1000;
    int thirdD = i/100;
    i = i%100;
    int secondD = i/10;
    int firstD = i%10;
    int retVal = secondD+firstD;
    *op = ADDITION;
    *str = [NSString stringWithFormat:@"%d + %d", secondD, firstD];
    
    if (fourthD && [[GameScene scene] fraction])
    {
        fourthD = (fourthD < 0)?-fourthD:fourthD;
        firstD = (firstD < 0)?-firstD:firstD;
        if (fourthD < firstD) {
            retVal = 1000 * fourthD + firstD;
            
            if (firstD % fourthD == 0)
                retVal = 1000*fourthD + firstD/fourthD;
            else if (fourthD == 6 && firstD == 8)
                retVal = 1000*3+4;
            
            *op = FRACTION;
            *str = [NSString stringWithFormat:@" %d \n---\n %d", fourthD, firstD];
            return retVal;
        }
    } //else 
    if (thirdD && ([[GameScene scene] multiplication] || 
                   [[GameScene scene] division] || [[GameScene scene] remainder]))
    {
        
        int multVal = thirdD * firstD;
        thirdD = (thirdD < 0)?-thirdD:thirdD;
        firstD = (firstD < 0)?-firstD:firstD;
        if (multVal < -9 || multVal > 9) 
        {
            if (thirdD % firstD == 0)
            {
                retVal = thirdD / firstD;
                *op = DIVISION;
                *str = [NSString stringWithFormat:@"%d / %d", thirdD, firstD]; 
                // printf("Division %d / %d = %d\n", thirdD, firstD, retVal);
            } else
            {
                retVal = thirdD % firstD;
                *op = REMAINDER;
                *str = [NSString stringWithFormat:@"%d %% %d", thirdD, firstD];
            }
        } else 
        {
            retVal = multVal;
            *op = MULTIPlICATION;
            *str = [NSString stringWithFormat:@"%d * %d", thirdD, firstD]; 
            // printf("Multiply %d * %d = %d\n", thirdD, firstD, retVal);
        }
        
    } // else {
    // retVal = secondD + firstD;
    
    // Do subtraction if the values are two digits
    
    if (retVal < -9 || retVal > 9) 
    {
        retVal = secondD - firstD;
        *op = SUBTRACTION;
        *str = [NSString stringWithFormat:@"%d - %d", secondD, firstD]; 
        //printf("Sub %d - %d = %d\n", secondD, firstD, retVal);
    }
    /*   This is the default case
     else
     {
     retVal = secondD + firstD;
     *op = ADDITION;
     *str = [NSString stringWithFormat:@"%d + %d", secondD, firstD]; 
     //printf("Add %d + %d = %d\n", secondD, firstD, retVal);
     } */
    
    // }
    
    return retVal;
}

+(NSString*)getExpr:(int)i mode:(int)m
{
    NSString *str;
    operators op;
    int val = [self getValExprOp:i expr:&str op:&op];
    
    if (m == 0)
        return [NSString stringWithFormat:@""];
    else if (m == 1)
        return [NSString stringWithFormat:@"%d",val];
    
    return str; // [NSString stringWithString:str];
}

+(operators)getOp:(int)i
{
    NSString *str;
    operators op;
    [self getValExprOp:i expr:&str op:&op];
    return op;
}

@end
