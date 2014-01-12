//
//  BotPart.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 8/16/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GameEnemy.h"

@interface BotPart : NSObject

@property (strong) CCSprite* sprite;
@property (strong) NSMutableArray* joints;
@property (strong) GameEnemy* bot;

-(id)initWithBody:(b2Body*)bodyPart withSprite:(CCSprite*)sprite withBot:(GameEnemy*)bot;
-(b2Body*)getBodyPart;

@end
