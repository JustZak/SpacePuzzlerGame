//
//  HudLayer.h
//  SpaceCollector
//
//  Created by Zachary Reik on 6/8/13.
//
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"

@class GameLayer;

@interface HUDLayer : CCLayer

@property (weak) GameLayer* gameLayer;
@property (assign) BOOL moveBeginning;
@property (assign) BOOL movePressed;
@property (assign) BOOL moveDone;
@property (assign) int moveDirection;
@property (assign) CGRect guiRect;


@end
