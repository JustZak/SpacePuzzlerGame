//
//  HelloWorldLayer.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 6/13/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import "cocos2d.h"
#import "Box2D.h"
#import "HUDLayer.h"
#import "RootViewController.h"

#define PTM_RATIO 32.0

enum CollisionFilter {
    BOUNDARY = 0x0001,
    SHIP = 0x0002,
    PROJECTILE = 0x0004,
    ENEMY = 0x0008,
};

enum SpriteTags {
    TAGS_PROJECTILE = 1,
    TAGS_LASER_SWITCH = 2,
    TAGS_PLAYER = 3,
    TAGS_WALL = 4,
    TAGS_ENEMY = 5,
    TAGS_LASER_BEAM = 6,
    TAGS_GRAVITY_BOMB = 7,
    TAGS_PORTAL = 8
};

enum PlayerMovement {
    LEFT = 0,
    RIGHT = 1,
    STOPPING = 2,
    STOPPED = 3
};

@class HUDLayer;

@interface GameLayer : CCLayer {
}

-(void)selectAmmo:(NSInteger)ammo;
-(id)initWithRootViewController:(RootViewController*)rootViewController level:(NSInteger)levelNum;
-(void)startMove:(NSInteger)direction;
-(void)endMove;
+ (id)scene:(RootViewController*)rootViewController level:(NSInteger)levelNum;

@end