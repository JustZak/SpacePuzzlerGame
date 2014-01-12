//
//  GameObject.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 6/22/13.
//
//

#import "GameObject.h"
#import "Box2D.h"

@interface GameObject(){

}

@end

@implementation GameObject

-(void) removeObject{
    [self.sprite removeFromParentAndCleanup:YES];
}

-(CCAnimation*)loadAnimationFromPlist:(NSString *)animationName forGameObject:(NSString *)objectName;{
    //1
    NSString *path = [[NSBundle mainBundle] pathForResource:objectName ofType:@"plist"];
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    //2
    NSDictionary *animationSettings = [plistDictionary objectForKey:animationName];
    
    CCAnimation *animation = [CCAnimation animation];
    //4
    animation.delayPerUnit = [[animationSettings objectForKey:@"delay"] floatValue];
    //5
    NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];
    //6
    for (NSString *frameNumber in animationFrameNumbers) {
        NSString *frameName = [NSString stringWithFormat:@"%@%@.png",objectName,frameNumber];
        //[animation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        [animation addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    //7
    return animation; }


@end
