//
//  LunkerBot.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 9/16/13.
//
//

#import "GameEnemy.h"
#import "cocos2d.h"
#import "Box2D.h"

@interface LunkerBot : GameEnemy

-(id)initWithWorld:(b2World*)world withPosition:(b2Vec2)position;

@end
