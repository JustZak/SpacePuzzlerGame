//
//  BotPart.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 8/16/13.
//
//

#import "BotPart.h"

@interface BotPart(){
    b2Body* _bodyPart;
    NSMutableArray* _joints;
}

@end

@implementation BotPart

-(id)initWithBody:(b2Body*)bodyPart withSprite:(CCSprite*)sprite withBot:(GameEnemy*)bot{
    if (self == [super init]){
        self.bot = bot;
        self.sprite = sprite;
        _bodyPart = bodyPart;
        self.joints = [NSMutableArray array];
    }
    return self;
}

-(b2Body*)getBodyPart{
    return _bodyPart;
}

@end
