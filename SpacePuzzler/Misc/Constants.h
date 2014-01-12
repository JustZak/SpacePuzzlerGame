//
//  Constants.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 10/21/13.
//
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

enum CollisionFilter {
    BOUNDARY = 0x0001,
    PLAYER_SHIP = 0x0002,
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

enum WeaponType {
    BOUNCER=0,
    LAZER=1,
    GRAVITY_BOMB=2,
    MISSILE=3
};

enum EnemyType {
    YELLOW = 0,
    TANK = 1,
    LUNKER = 2
};


@end
