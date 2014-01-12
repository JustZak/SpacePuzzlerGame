//
//  GameEnemy.h
//  SpacePuzzler
//
//  Created by Zachary Reik on 7/24/13.
//
//

#import <Foundation/Foundation.h>

enum EnemyType {
    YELLOW = 0,
    TANK = 1,
    LUNKER = 2
};

@interface GameEnemy : NSObject

-(NSMutableArray*)getBotParts;

@end
