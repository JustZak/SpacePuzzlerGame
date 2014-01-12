//
//  TankBot.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 7/25/13.
//
//

#import "GameEnemy.h"
#import "cocos2d.h"
#import "Box2D.h"

@interface TankBot : GameEnemy

-(id)initWithWorld:(b2World*)world withPosition:(b2Vec2)position;
-(void)moveLeft;
-(void)moveRight;

@end
