//
//  Robot.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 6/30/13.
//
//

#import "YellowBot.h"
#import "BotPart.h"
#import "GameLayer.h"

@interface YellowBot(){
    BotPart* _torso;
    BotPart* _head;
    BotPart* _leftShoulder;
    BotPart* _leftHand;
    BotPart* _leftThigh;
    BotPart* _leftFoot;
    BotPart* _rightShoulder;
    BotPart* _rightHand;
    BotPart* _rightThigh;
    BotPart* _rightFoot;}
@end

@implementation YellowBot

-(id)initWithWorld:(b2World*)world withPosition:(b2Vec2)position{
    if (self = [super init]){
        CCSprite* torsoS = [CCSprite spriteWithFile:@"yellowBotTorso.png"];
        CCSprite* headS = [CCSprite spriteWithFile:@"yellowBotHead.png"];
        CCSprite* leftShoulderS = [CCSprite spriteWithFile:@"yellowBotLeftShoulder.png"];
        CCSprite* leftHandS = [CCSprite spriteWithFile:@"yellowBotLeftHand.png"];
        CCSprite* leftThighS = [CCSprite spriteWithFile:@"yellowBotLeftThigh.png"];
        CCSprite* leftFootS = [CCSprite spriteWithFile:@"yellowBotLeftFoot.png"];
        CCSprite* rightShoulderS = [CCSprite spriteWithFile:@"yellowBotRightShoulder.png"];
        CCSprite* rightHandS = [CCSprite spriteWithFile:@"yellowBotRightHand.png"];
        CCSprite* rightThighS = [CCSprite spriteWithFile:@"yellowBotRightThigh.png"];
        CCSprite* rightFootS = [CCSprite spriteWithFile:@"yellowBotRightFoot.png"];
        
        // ******* Reusable defs for ragdoll robot *******
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        
        b2FixtureDef fixDef;
        b2PolygonShape poly;
        
        int gravityScale = 1;
        
        
        // ******* Torso *******
        
        bodyDef.position.Set(position.x, position.y);
        b2Body* torso = world->CreateBody(&bodyDef);
        torso->SetGravityScale(gravityScale);
        
        int num = 8;
        b2Vec2 verts[] = {
            b2Vec2(-13.0f / PTM_RATIO, 16.1f / PTM_RATIO),
            b2Vec2(-15.9f / PTM_RATIO, 14.6f / PTM_RATIO),
            b2Vec2(-15.9f / PTM_RATIO, -0.4f / PTM_RATIO),
            b2Vec2(-2.0f / PTM_RATIO, -15.5f / PTM_RATIO),
            b2Vec2(2.1f / PTM_RATIO, -15.5f / PTM_RATIO),
            b2Vec2(15.9f / PTM_RATIO, -0.2f / PTM_RATIO),
            b2Vec2(15.8f / PTM_RATIO, 15.6f / PTM_RATIO),
            b2Vec2(12.9f / PTM_RATIO, 16.2f / PTM_RATIO)
        };
    
        poly.Set(verts, num);
        
        fixDef.shape = &poly;
        fixDef.density = 1.0f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.filter.categoryBits = ENEMY;
        fixDef.filter.maskBits = ENEMY | PROJECTILE | BOUNDARY;
        fixDef.userData = (void*)TAGS_ENEMY;
        torso->CreateFixture(&fixDef);
        
        _torso = [[BotPart alloc] initWithBody:torso withSprite:torsoS withBot:self];
        torso->SetUserData((__bridge void*) _torso);
        
        // ******* Head ********
        bodyDef.position.Set(torso->GetPosition().x, torso->GetPosition().y + torsoS.contentSize.height/2/PTM_RATIO + headS.contentSize.height/2/PTM_RATIO);
        b2Body* head = world->CreateBody(&bodyDef);
        head->SetGravityScale(gravityScale);
        
        num = 10;
        b2Vec2 verts2[] = {
            b2Vec2(-6.0f / PTM_RATIO, 12.1f / PTM_RATIO),
            b2Vec2(-11.8f / PTM_RATIO, 4.2f / PTM_RATIO),
            b2Vec2(-11.8f / PTM_RATIO, -6.6f / PTM_RATIO),
            b2Vec2(-7.9f / PTM_RATIO, -6.4f / PTM_RATIO),
            b2Vec2(-8.0f / PTM_RATIO, -11.4f / PTM_RATIO),
            b2Vec2(8.1f / PTM_RATIO, -11.1f / PTM_RATIO),
            b2Vec2(7.9f / PTM_RATIO, -6.3f / PTM_RATIO),
            b2Vec2(12.0f / PTM_RATIO, -6.3f / PTM_RATIO),
            b2Vec2(11.8f / PTM_RATIO, 7.5f / PTM_RATIO),
            b2Vec2(5.9f / PTM_RATIO, 11.9f / PTM_RATIO)
        };
        poly.Set(verts2, num);

        fixDef.density = 0.5f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.2f;
        head->CreateFixture(&fixDef);
        
        _head = [[BotPart alloc] initWithBody:head withSprite:headS withBot:self];
        head->SetUserData((__bridge void*) _head);
        
        // ******* Left Shoulder *******
        
        bodyDef.position.Set(torso->GetPosition().x - torsoS.contentSize.width/2/PTM_RATIO - leftShoulderS.contentSize.width/2/PTM_RATIO, torso->GetPosition().y + torsoS.contentSize.height/5/PTM_RATIO);
        b2Body* leftShoulder = world->CreateBody(&bodyDef);
        leftShoulder->SetGravityScale(gravityScale);
        
        num = 10;
        b2Vec2 verts3[] = {
            b2Vec2(2.4f / PTM_RATIO, 10.2f / PTM_RATIO),
            b2Vec2(0.5f / PTM_RATIO, 8.3f / PTM_RATIO),
            b2Vec2(0.5f / PTM_RATIO, 3.6f / PTM_RATIO),
            b2Vec2(-7.3f / PTM_RATIO, -5.6f / PTM_RATIO),
            b2Vec2(-7.3f / PTM_RATIO, -9.2f / PTM_RATIO),
            b2Vec2(-0.4f / PTM_RATIO, -9.0f / PTM_RATIO),
            b2Vec2(-0.5f / PTM_RATIO, -6.4f / PTM_RATIO),
            b2Vec2(7.7f / PTM_RATIO, -1.3f / PTM_RATIO),
            b2Vec2(7.6f / PTM_RATIO, 5.6f / PTM_RATIO),
            b2Vec2(6.3f / PTM_RATIO, 10.2f / PTM_RATIO)
        };
        poly.Set(verts3, num);
        
        fixDef.density = 0.5f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.2f;
        leftShoulder->CreateFixture(&fixDef);
        
        _leftShoulder = [[BotPart alloc] initWithBody:leftShoulder withSprite:leftShoulderS withBot:self];
        leftShoulder->SetUserData((__bridge void*) _leftShoulder);
        
        // ******* Left Hand *******
        
        bodyDef.position.Set(leftShoulder->GetPosition().x - leftShoulderS.contentSize.width/4/PTM_RATIO, leftShoulder->GetPosition().y - leftShoulderS.contentSize.height/2/PTM_RATIO - leftHandS.contentSize.height/2/PTM_RATIO);
        b2Body* leftHand = world->CreateBody(&bodyDef);
        leftHand->SetGravityScale(gravityScale);
        
        num = 11;
        b2Vec2 verts4[] = {
            b2Vec2(-4.1f / PTM_RATIO, 14.4f / PTM_RATIO),
            b2Vec2(-4.1f / PTM_RATIO, 2.7f / PTM_RATIO),
            b2Vec2(-7.0f / PTM_RATIO, -2.6f / PTM_RATIO),
            b2Vec2(-6.9f / PTM_RATIO, -11.5f / PTM_RATIO),
            b2Vec2(-0.9f / PTM_RATIO, -13.4f / PTM_RATIO),
            b2Vec2(1.0f / PTM_RATIO, -13.4f / PTM_RATIO),
            b2Vec2(7.7f / PTM_RATIO, -6.2f / PTM_RATIO),
            b2Vec2(7.4f / PTM_RATIO, -1.3f / PTM_RATIO),
            b2Vec2(1.1f / PTM_RATIO, 4.4f / PTM_RATIO),
            b2Vec2(-0.0f / PTM_RATIO, 10.8f / PTM_RATIO),
            b2Vec2(-0.1f / PTM_RATIO, 14.2f / PTM_RATIO)
        };
        poly.Set(verts4, num);
        
        fixDef.density = 0.5f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.2f;
        leftHand->CreateFixture(&fixDef);
        
        _leftHand = [[BotPart alloc] initWithBody:leftHand withSprite:leftHandS withBot:self];
        leftHand->SetUserData((__bridge void*) _leftHand);
        
        // ******** Left Thigh ********
        
        bodyDef.position.Set(torso->GetPosition().x - 8/PTM_RATIO, torso->GetPosition().y - torsoS.contentSize.height/2/PTM_RATIO + 4/PTM_RATIO - leftThighS.contentSize.height/2/PTM_RATIO);
        b2Body* leftThigh = world->CreateBody(&bodyDef);
        leftThigh->SetGravityScale(gravityScale);
        
        num = 6;
        b2Vec2 verts5[] = {
            b2Vec2(-0.1f / PTM_RATIO, 5.8f / PTM_RATIO),
            b2Vec2(-2.9f / PTM_RATIO, 3.0f / PTM_RATIO),
            b2Vec2(-3.0f / PTM_RATIO, 0.2f / PTM_RATIO),
            b2Vec2(-2.9f / PTM_RATIO, -4.5f / PTM_RATIO),
            b2Vec2(2.9f / PTM_RATIO, -4.6f / PTM_RATIO),
            b2Vec2(2.9f / PTM_RATIO, 5.9f / PTM_RATIO)
        };
        poly.Set(verts5, num);
        
        fixDef.density = 0.5f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.2f;
        leftThigh->CreateFixture(&fixDef);
        
        _leftThigh = [[BotPart alloc] initWithBody:leftThigh withSprite:leftThighS withBot:self];
        leftThigh->SetUserData((__bridge void*) _leftThigh);
        
        // ******** Left Foot ********
        
        bodyDef.position.Set(leftThigh->GetPosition().x, leftThigh->GetPosition().y - leftFootS.contentSize.height/2/PTM_RATIO - leftThighS.contentSize.height/2/PTM_RATIO);
        b2Body* leftFoot = world->CreateBody(&bodyDef);
        leftFoot->SetGravityScale(gravityScale);
        
        poly.SetAsBox(leftFootS.contentSize.width/2/PTM_RATIO, leftFootS.contentSize.height/2/PTM_RATIO);
        
        fixDef.density = 0.5f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.2f;
        leftFoot->CreateFixture(&fixDef);
        
        _leftFoot = [[BotPart alloc] initWithBody:leftFoot withSprite:leftFootS withBot:self];
        leftFoot->SetUserData((__bridge void*) _leftFoot);

        // ******* Right Shoulder *******
        
        bodyDef.position.Set(torso->GetPosition().x + torsoS.contentSize.width/2/PTM_RATIO + rightShoulderS.contentSize.width/2/PTM_RATIO, torso->GetPosition().y + torsoS.contentSize.height/5/PTM_RATIO);
        b2Body* rightShoulder = world->CreateBody(&bodyDef);
        rightShoulder->SetGravityScale(gravityScale);
        
        num = 10;
        b2Vec2 verts6[] = {
            b2Vec2(-6.6f / PTM_RATIO, 10.2f / PTM_RATIO),
            b2Vec2(-7.4f / PTM_RATIO, 5.4f / PTM_RATIO),
            b2Vec2(-7.4f / PTM_RATIO, -1.5f / PTM_RATIO),
            b2Vec2(0.6f / PTM_RATIO, -6.6f / PTM_RATIO),
            b2Vec2(0.8f / PTM_RATIO, -9.2f / PTM_RATIO),
            b2Vec2(7.9f / PTM_RATIO, -9.2f / PTM_RATIO),
            b2Vec2(7.5f / PTM_RATIO, -5.4f / PTM_RATIO),
            b2Vec2(-0.4f / PTM_RATIO, 3.6f / PTM_RATIO),
            b2Vec2(-0.5f / PTM_RATIO, 8.7f / PTM_RATIO),
            b2Vec2(-2.5f / PTM_RATIO, 10.5f / PTM_RATIO)
        };
        poly.Set(verts6, num);
        
        fixDef.density = 0.5f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.2f;
        rightShoulder->CreateFixture(&fixDef);
        
        _rightShoulder = [[BotPart alloc] initWithBody:rightShoulder withSprite:rightShoulderS withBot:self];
        rightShoulder->SetUserData((__bridge void*) _rightShoulder);
        
        // ******** Right Hand ********
        
        bodyDef.position.Set(rightShoulder->GetPosition().x + rightShoulderS.contentSize.width/4/PTM_RATIO, rightShoulder->GetPosition().y - rightShoulderS.contentSize.height/2/PTM_RATIO - rightHandS.contentSize.height/2/PTM_RATIO);
        b2Body* rightHand = world->CreateBody(&bodyDef);
        rightHand->SetGravityScale(gravityScale);
        
        num = 10;
        b2Vec2 verts7[] = {
            b2Vec2(-0.1f / PTM_RATIO, 14.1f / PTM_RATIO),
            b2Vec2(-1.0f / PTM_RATIO, 4.6f / PTM_RATIO),
            b2Vec2(-7.0f / PTM_RATIO, -1.4f / PTM_RATIO),
            b2Vec2(-6.7f / PTM_RATIO, -6.4f / PTM_RATIO),
            b2Vec2(-1.9f / PTM_RATIO, -13.2f / PTM_RATIO),
            b2Vec2(4.7f / PTM_RATIO, -13.5f / PTM_RATIO),
            b2Vec2(7.6f / PTM_RATIO, -11.3f / PTM_RATIO),
            b2Vec2(7.0f / PTM_RATIO, -2.4f / PTM_RATIO),
            b2Vec2(4.0f / PTM_RATIO, 2.6f / PTM_RATIO),
            b2Vec2(4.0f / PTM_RATIO, 14.2f / PTM_RATIO)
        };
        poly.Set(verts7, num);
        
        fixDef.density = 0.5f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.2f;
        rightHand->CreateFixture(&fixDef);
        
        _rightHand = [[BotPart alloc] initWithBody:rightHand withSprite:rightHandS withBot:self];
        rightHand->SetUserData((__bridge void*) _rightHand);
        
        // ******** Right Thigh ********
        
        bodyDef.position.Set(torso->GetPosition().x + 8/PTM_RATIO, torso->GetPosition().y - torsoS.contentSize.height/2/PTM_RATIO + 4/PTM_RATIO - rightThighS.contentSize.height/2/PTM_RATIO);
        b2Body* rightThigh = world->CreateBody(&bodyDef);
        rightThigh->SetGravityScale(gravityScale);
        
        num = 6;
        b2Vec2 verts8[] = {
            b2Vec2(-2.5f / PTM_RATIO, 5.8f / PTM_RATIO),
            b2Vec2(-2.9f / PTM_RATIO, -4.6f / PTM_RATIO),
            b2Vec2(3.7f / PTM_RATIO, -4.6f / PTM_RATIO),
            b2Vec2(2.9f / PTM_RATIO, 2.9f / PTM_RATIO),
            b2Vec2(0.1f / PTM_RATIO, 5.2f / PTM_RATIO),
            b2Vec2(0.0f / PTM_RATIO, 6.0f / PTM_RATIO)
        };
        poly.Set(verts8, num);
        
        fixDef.density = 0.5f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.2f;
        rightThigh->CreateFixture(&fixDef);
        
        _rightThigh = [[BotPart alloc] initWithBody:rightThigh withSprite:rightThighS withBot:self];
        rightThigh->SetUserData((__bridge void*) _rightThigh);
        
        // ******** Right Foot ********
        
        bodyDef.position.Set(rightThigh->GetPosition().x, rightThigh->GetPosition().y - rightFootS.contentSize.height/2/PTM_RATIO - rightThighS.contentSize.height/2/PTM_RATIO);
        b2Body* rightFoot = world->CreateBody(&bodyDef);
        rightFoot->SetGravityScale(gravityScale);
        
        poly.SetAsBox(rightFootS.contentSize.width/2/PTM_RATIO, rightFootS.contentSize.height/2/PTM_RATIO);
        
        fixDef.density = 0.5f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.2f;
        rightFoot->CreateFixture(&fixDef);
        
        _rightFoot = [[BotPart alloc] initWithBody:rightFoot withSprite:rightFootS withBot:self];
        rightFoot->SetUserData((__bridge void*) _rightFoot);
        
        // *******************
        // Joints
        // *******************
        
        b2RevoluteJointDef jointDef;
        jointDef.enableLimit = true;
        b2Vec2 pos;
        b2Joint* joint;
        NSValue* val;
        
        // Torso to Head
        
        jointDef.bodyA = torso;
        jointDef.bodyB = head;
        jointDef.localAnchorA = b2Vec2(0.0f / PTM_RATIO, 16.4f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(0.0f / PTM_RATIO, -11.2f / PTM_RATIO);
        jointDef.lowerAngle = -10.0f / (180.0f / M_PI);
        jointDef.upperAngle = 10.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_head.joints addObject:val];
        [_torso.joints addObject:val];
        
        // Torso to Left Shoulder
        
        jointDef.bodyA = torso;
        jointDef.bodyB = leftShoulder;
        jointDef.localAnchorA = b2Vec2(-15.6f / PTM_RATIO, 11.1f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(8.1f / PTM_RATIO, 5.2f / PTM_RATIO);
        jointDef.lowerAngle = -5.0f / (180.0f / M_PI);
        jointDef.upperAngle = 5.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_leftShoulder.joints addObject:val];
        [_torso.joints addObject:val];
        
        // Left Shoulder to Left Hand
        
        jointDef.bodyA = leftShoulder;
        jointDef.bodyB = leftHand;
        jointDef.localAnchorA = b2Vec2(-5.5f / PTM_RATIO, -9.4f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(-2.1f / PTM_RATIO, 14.0f / PTM_RATIO);
        jointDef.lowerAngle = -10.0f / (180.0f / M_PI);
        jointDef.upperAngle = 10.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_leftShoulder.joints addObject:val];
        [_leftHand.joints addObject:val];
        
        // Torso to Left Thigh
        
        jointDef.bodyA = torso;
        jointDef.bodyB = leftThigh;
        jointDef.localAnchorA = b2Vec2(-4.5f / PTM_RATIO, -13.1f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(2.2f / PTM_RATIO, 5.9f / PTM_RATIO);
        jointDef.lowerAngle = -10.0f / (180.0f / M_PI);
        jointDef.upperAngle = 10.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_leftThigh.joints addObject:val];
        [_torso.joints addObject:val];
        
        // Left Thigh to Left Foot
        
        jointDef.bodyA = leftThigh;
        jointDef.bodyB = leftFoot;
        jointDef.localAnchorA = b2Vec2(-0.5f / PTM_RATIO, -4.5f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(1.0f / PTM_RATIO, 10.2f / PTM_RATIO);
        jointDef.lowerAngle = -10.0f / (180.0f / M_PI);
        jointDef.upperAngle = 10.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_leftThigh.joints addObject:val];
        [_leftFoot.joints addObject:val];
        
        // ***** RIGHT SIDE *****
        
        // Torso to Right Shoulder
        
        jointDef.bodyA = torso;
        jointDef.bodyB = rightShoulder;
        jointDef.localAnchorA = b2Vec2(15.6f / PTM_RATIO, 11.1f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(-8.1f / PTM_RATIO, 5.2f / PTM_RATIO);
        jointDef.lowerAngle = -5.0f / (180.0f / M_PI);
        jointDef.upperAngle = 5.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_rightShoulder.joints addObject:val];
        [_torso.joints addObject:val];
        
        // Right Shoulder to Right Hand
        
        jointDef.bodyA = rightShoulder;
        jointDef.bodyB = rightHand;
        jointDef.localAnchorA = b2Vec2(5.5f / PTM_RATIO, -9.4f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(2.1f / PTM_RATIO, 14.0f / PTM_RATIO);
        jointDef.lowerAngle = -10.0f / (180.0f / M_PI);
        jointDef.upperAngle = 10.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_rightShoulder.joints addObject:val];
        [_rightHand.joints addObject:val];
        
        // Torso to Right Thigh
        
        jointDef.bodyA = torso;
        jointDef.bodyB = rightThigh;
        jointDef.localAnchorA = b2Vec2(4.5f / PTM_RATIO, -13.1f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(-2.2f / PTM_RATIO, 5.9f / PTM_RATIO);
        jointDef.lowerAngle = -10.0f / (180.0f / M_PI);
        jointDef.upperAngle = 10.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_rightThigh.joints addObject:val];
        [_torso.joints addObject:val];
        
        // Right Thigh to Right Foot
        
        jointDef.bodyA = rightThigh;
        jointDef.bodyB = rightFoot;
        jointDef.localAnchorA = b2Vec2(0.5f / PTM_RATIO, -4.5f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(-1.0f / PTM_RATIO, 10.2f / PTM_RATIO);
        jointDef.lowerAngle = -10.0f / (180.0f / M_PI);
        jointDef.upperAngle = 10.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_rightThigh.joints addObject:val];
        [_rightFoot.joints addObject:val];

    }
    
    return self;
}

-(NSMutableArray*)getBotParts{
    NSMutableArray* botParts = [NSMutableArray array];
    [botParts addObject:_torso];
    [botParts addObject:_head];
    [botParts addObject:_leftShoulder];
    [botParts addObject:_leftHand];
    [botParts addObject:_leftThigh];
    [botParts addObject:_leftFoot];
    [botParts addObject:_rightShoulder];
    [botParts addObject:_rightHand];
    [botParts addObject:_rightThigh];
    [botParts addObject:_rightFoot];
    
    return botParts;
}

@end
