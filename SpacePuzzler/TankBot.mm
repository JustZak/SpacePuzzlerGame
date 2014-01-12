//
//  TankBot.m
//  SpacePuzzler
//
//  Created by Zachary Reik on 7/25/13.
//
//

#import "TankBot.h"
#import "GameLayer.h"
#import "BotPart.h"

@interface TankBot(){
    
    BotPart* _torso;
    BotPart* _head;
    BotPart* _leftShoulder;
    BotPart* _leftArm;
    BotPart* _leftFist;
    BotPart* _leftTread;
    BotPart* _rightShoulder;
    BotPart* _rightArm;
    BotPart* _rightFist;
    BotPart* _rightTread;
}
@end

@implementation TankBot

-(void)moveLeft{
    b2Body* ltb = [_leftTread getBodyPart];
    ltb->ApplyLinearImpulse(b2Vec2(0, -2), ltb->GetWorldCenter());
    
}

-(void)moveRight{
    b2Body* rtb = [_rightTread getBodyPart];
    rtb->ApplyLinearImpulse(b2Vec2(0, -2), rtb->GetWorldCenter());
}

-(id)initWithWorld:(b2World*)world withPosition:(b2Vec2)position{
    if (self = [super init]){
        CCSprite* torsoS = [CCSprite spriteWithFile:@"tankBotTorso.png"];
        CCSprite* headS = [CCSprite spriteWithFile:@"tankBotHead.png"];
        CCSprite* leftShoulderS = [CCSprite spriteWithFile:@"tankBotLeftShoulder.png"];
        CCSprite* leftArmS = [CCSprite spriteWithFile:@"tankBotLeftArm.png"];
        CCSprite* leftFistS = [CCSprite spriteWithFile:@"tankBotLeftFist.png"];
        CCSprite* leftTreadS = [CCSprite spriteWithFile:@"tankBotLeftTread.png"];
        CCSprite* rightShoulderS = [CCSprite spriteWithFile:@"tankBotRightShoulder.png"];
        CCSprite* rightArmS = [CCSprite spriteWithFile:@"tankBotRightArm.png"];
        CCSprite* rightFistS = [CCSprite spriteWithFile:@"tankBotRightFist.png"];
        CCSprite* rightTreadS = [CCSprite spriteWithFile:@"tankBotRightTread.png"];
        
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
        
        float torsoWidth = torsoS.contentSize.width/PTM_RATIO;
        float torsoX = torso->GetPosition().x;
        float torsoY = torso->GetPosition().y;
        
        int num = 6;
        b2Vec2 verts[] = {
            b2Vec2(-18.1f / PTM_RATIO, 31.6f / PTM_RATIO),
            b2Vec2(-25.0f / PTM_RATIO, 29.2f / PTM_RATIO),
            b2Vec2(-24.0f / PTM_RATIO, -30.6f / PTM_RATIO),
            b2Vec2(24.0f / PTM_RATIO, -30.1f / PTM_RATIO),
            b2Vec2(25.0f / PTM_RATIO, 29.5f / PTM_RATIO),
            b2Vec2(20.2f / PTM_RATIO, 32.1f / PTM_RATIO)
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
        
        bodyDef.position.Set(torsoX, torsoY + (20.6f / PTM_RATIO));
        b2Body *head = world->CreateBody(&bodyDef);
        head->SetGravityScale(gravityScale);
        
        b2Vec2 verts2[] = {
            b2Vec2(-5.7f / PTM_RATIO, 13.0f / PTM_RATIO),
            b2Vec2(-16.0f / PTM_RATIO, 3.2f / PTM_RATIO),
            b2Vec2(-13.5f / PTM_RATIO, -10.4f / PTM_RATIO),
            b2Vec2(13.6f / PTM_RATIO, -10.5f / PTM_RATIO),
            b2Vec2(15.7f / PTM_RATIO, 4.5f / PTM_RATIO),
            b2Vec2(6.4f / PTM_RATIO, 12.5f / PTM_RATIO)
        };
        poly.Set(verts2, 6);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.userData = (void*)TAGS_ENEMY;
        head->CreateFixture(&fixDef);
        
        _head = [[BotPart alloc] initWithBody:head withSprite:headS withBot:self];
        head->SetUserData((__bridge void*)_head);
        
        // ****************** Left Side ******************
        
        // ******* Left Shoulder *******
        
        bodyDef.position.Set(torsoX - torsoWidth/2, torsoY + 11/PTM_RATIO);
        b2Body *leftShoulder = world->CreateBody(&bodyDef);
        leftShoulder->SetGravityScale(gravityScale);
                
        poly.SetAsBox(leftShoulderS.contentSize.width/2/PTM_RATIO, leftShoulderS.contentSize.height/2/PTM_RATIO);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.userData = (void*)TAGS_ENEMY;
        leftShoulder->CreateFixture(&fixDef);
        
        _leftShoulder = [[BotPart alloc] initWithBody:leftShoulder withSprite:leftShoulderS withBot:self];
        leftShoulder->SetUserData((__bridge void*)_leftShoulder);

        // ******* Left Arm *******
        
        bodyDef.position.Set(leftShoulder->GetPosition().x - leftShoulderS.contentSize.width/2/PTM_RATIO - leftArmS.contentSize.width/2/PTM_RATIO, leftShoulder->GetPosition().y - leftArmS.contentSize.height/2/PTM_RATIO + leftShoulderS.contentSize.height/2/PTM_RATIO);
        b2Body *leftArm = world->CreateBody(&bodyDef);
        leftArm->SetGravityScale(gravityScale);
        
        b2Vec2 verts3[] = {
            b2Vec2(-5.7f / PTM_RATIO, 15.2f / PTM_RATIO),
            b2Vec2(-7.7f / PTM_RATIO, -14.9f / PTM_RATIO),
            b2Vec2(1.4f / PTM_RATIO, -15.1f / PTM_RATIO),
            b2Vec2(4.5f / PTM_RATIO, -13.1f / PTM_RATIO),
            b2Vec2(4.6f / PTM_RATIO, 3.1f / PTM_RATIO),
            b2Vec2(7.7f / PTM_RATIO, 4.9f / PTM_RATIO),
            b2Vec2(7.5f / PTM_RATIO, 13.2f / PTM_RATIO),
            b2Vec2(5.5f / PTM_RATIO, 15.0f / PTM_RATIO)
        };
        poly.Set(verts3, 8);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.userData = (void*)TAGS_ENEMY;
        leftArm->CreateFixture(&fixDef);
        
        _leftArm = [[BotPart alloc] initWithBody:leftArm withSprite:leftArmS withBot:self];
        leftArm->SetUserData((__bridge void*)_leftArm);

        // ******* Left Fist *******
        
        bodyDef.position.Set(leftArm->GetPosition().x, leftArm->GetPosition().y - leftArmS.contentSize.height/2/PTM_RATIO - leftFistS.contentSize.height/3/PTM_RATIO);
        b2Body *leftFist = world->CreateBody(&bodyDef);
        leftFist->SetGravityScale(gravityScale);

        b2Vec2 verts4[] = {
            b2Vec2(-2.5f / PTM_RATIO, 14.5f / PTM_RATIO),
            b2Vec2(-9.2f / PTM_RATIO, 3.7f / PTM_RATIO),
            b2Vec2(-9.2f / PTM_RATIO, -9.7f / PTM_RATIO),
            b2Vec2(-2.1f / PTM_RATIO, -13.5f / PTM_RATIO),
            b2Vec2(4.1f / PTM_RATIO, -13.4f / PTM_RATIO),
            b2Vec2(8.9f / PTM_RATIO, -8.7f / PTM_RATIO),
            b2Vec2(8.7f / PTM_RATIO, 5.2f / PTM_RATIO),
            b2Vec2(3.9f / PTM_RATIO, 14.5f / PTM_RATIO)
        };
        poly.Set(verts4, 8);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.userData = (void*)TAGS_ENEMY;
        leftFist->CreateFixture(&fixDef);
        
        _leftFist = [[BotPart alloc] initWithBody:leftFist withSprite:leftFistS withBot:self];
        leftFist->SetUserData((__bridge void*)_leftFist);
        // ******** Left Tread ********
        
        bodyDef.position.Set(torsoX - torsoWidth/2, torsoY - leftTreadS.contentSize.height/2/PTM_RATIO);
        b2Body *leftTread = world->CreateBody(&bodyDef);
        leftTread->SetGravityScale(gravityScale);
        
        poly.SetAsBox(leftTreadS.contentSize.width/2/PTM_RATIO, leftTreadS.contentSize.height/2/PTM_RATIO);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.1f;
        fixDef.userData = (void*)TAGS_ENEMY;
        leftTread->CreateFixture(&fixDef);
        
        _leftTread = [[BotPart alloc] initWithBody:leftTread withSprite:leftTreadS withBot:self];
        leftTread->SetUserData((__bridge void*)_leftTread);
        
        // ****************** Right Side ******************
        
        // ******* Right Shoulder *******
        
        bodyDef.position.Set(torsoX + torsoWidth/2, torsoY + 11/PTM_RATIO);
        b2Body *rightShoulder = world->CreateBody(&bodyDef);
        rightShoulder->SetGravityScale(gravityScale);
        
        poly.SetAsBox(rightShoulderS.contentSize.width/2/PTM_RATIO, rightShoulderS.contentSize.height/2/PTM_RATIO);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.userData = (void*)TAGS_ENEMY;
        rightShoulder->CreateFixture(&fixDef);
        
        _rightShoulder = [[BotPart alloc] initWithBody:rightShoulder withSprite:rightShoulderS withBot:self];
        rightShoulder->SetUserData((__bridge void*)_rightShoulder);
        
        // ******* Right Arm *******
        
        bodyDef.position.Set(rightShoulder->GetPosition().x + rightShoulderS.contentSize.width/2/PTM_RATIO + rightArmS.contentSize.width/2/PTM_RATIO, rightShoulder->GetPosition().y - rightArmS.contentSize.height/2/PTM_RATIO + rightShoulderS.contentSize.height/2/PTM_RATIO);
        b2Body *rightArm = world->CreateBody(&bodyDef);
        rightArm->SetGravityScale(gravityScale);
        
        b2Vec2 verts5[] = {
            b2Vec2(-5.7f / PTM_RATIO, 15.2f / PTM_RATIO),
            b2Vec2(-7.6f / PTM_RATIO, 13.2f / PTM_RATIO),
            b2Vec2(-7.9f / PTM_RATIO, 5.2f / PTM_RATIO),
            b2Vec2(-4.7f / PTM_RATIO, 2.9f / PTM_RATIO),
            b2Vec2(-4.7f / PTM_RATIO, -12.7f / PTM_RATIO),
            b2Vec2(-1.6f / PTM_RATIO, -14.7f / PTM_RATIO),
            b2Vec2(7.7f / PTM_RATIO, -14.9f / PTM_RATIO),
            b2Vec2(5.6f / PTM_RATIO, 15.2f / PTM_RATIO)
        };
        poly.Set(verts5, 8);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.userData = (void*)TAGS_ENEMY;
        rightArm->CreateFixture(&fixDef);
        
        _rightArm = [[BotPart alloc] initWithBody:rightArm withSprite:rightArmS withBot:self];
        rightArm->SetUserData((__bridge void*)_rightArm);
        
        // ******** Right Fist ********
        
        bodyDef.position.Set(rightArm->GetPosition().x, rightArm->GetPosition().y - rightArmS.contentSize.height/2/PTM_RATIO - rightFistS.contentSize.height/3/PTM_RATIO);
        b2Body *rightFist = world->CreateBody(&bodyDef);
        rightFist->SetGravityScale(gravityScale);
        
        b2Vec2 verts6[] = {
            b2Vec2(-4.2f / PTM_RATIO, 14.1f / PTM_RATIO),
            b2Vec2(-9.1f / PTM_RATIO, 5.2f / PTM_RATIO),
            b2Vec2(-9.2f / PTM_RATIO, -8.5f / PTM_RATIO),
            b2Vec2(-4.2f / PTM_RATIO, -13.6f / PTM_RATIO),
            b2Vec2(1.9f / PTM_RATIO, -13.5f / PTM_RATIO),
            b2Vec2(9.0f / PTM_RATIO, -9.9f / PTM_RATIO),
            b2Vec2(9.0f / PTM_RATIO, 3.5f / PTM_RATIO),
            b2Vec2(2.2f / PTM_RATIO, 13.9f / PTM_RATIO)
        };
        poly.Set(verts6, 8);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.5f;
        fixDef.userData = (void*)TAGS_ENEMY;
        rightFist->CreateFixture(&fixDef);
        
        _rightFist = [[BotPart alloc] initWithBody:rightFist withSprite:rightFistS withBot:self];
        rightFist->SetUserData((__bridge void*)_rightFist);
        
        // ******** Right Tread ********
        
        bodyDef.position.Set(torsoX + torsoWidth/2, torsoY - rightTreadS.contentSize.height/2/PTM_RATIO);
        b2Body *rightTread = world->CreateBody(&bodyDef);
        rightTread->SetGravityScale(gravityScale);
        
        poly.SetAsBox(rightTreadS.contentSize.width/2/PTM_RATIO, rightTreadS.contentSize.height/2/PTM_RATIO);
        
        fixDef.density = 0.2f;
        fixDef.friction = 0.5f;
        fixDef.restitution = 0.1f;
        fixDef.userData = (void*)TAGS_ENEMY;
        rightTread->CreateFixture(&fixDef);
        
        _rightTread = [[BotPart alloc] initWithBody:rightTread withSprite:rightTreadS withBot:self];
        rightTread->SetUserData((__bridge void*)_rightTread);
        
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
        jointDef.localAnchorA = b2Vec2(0.0f / PTM_RATIO, 22.9f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(0.0f / PTM_RATIO, -9.5f / PTM_RATIO);
        jointDef.lowerAngle = -10.0f / (180.0f / M_PI);
        jointDef.upperAngle = 10.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_head.joints addObject:val];
        [_torso.joints addObject:val];
        
        // ******************** Left Side *********************
        
        // Torso to Left Shoulder
        
        jointDef.bodyA = torso;
        jointDef.bodyB = leftShoulder;
        jointDef.localAnchorA = b2Vec2(-25.6f / PTM_RATIO, 19.7f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(6.0f / PTM_RATIO, 0.1f / PTM_RATIO);
        jointDef.lowerAngle = -5.0f / (180.0f / M_PI);
        jointDef.upperAngle = 5.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_leftShoulder.joints addObject:val];
        [_torso.joints addObject:val];
        
        // Left Shoulder to Left Arm
        
        jointDef.bodyA = leftShoulder;
        jointDef.bodyB = leftArm;
        jointDef.localAnchorA = b2Vec2(-6.0f / PTM_RATIO, 0.1f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(8.9f / PTM_RATIO, 10.6f / PTM_RATIO);
        jointDef.lowerAngle = -10.0f / (180.0f / M_PI);
        jointDef.upperAngle = 10.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_leftShoulder.joints addObject:val];
        [_leftArm.joints addObject:val];
        
        // Left Arm to Left Fist
        
        jointDef.bodyA = leftArm;
        jointDef.bodyB = leftFist;
        jointDef.localAnchorA = b2Vec2(-2.3f / PTM_RATIO, -15.3f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(0.9f / PTM_RATIO, 14.9f / PTM_RATIO);
        jointDef.lowerAngle = -10.0f / (180.0f / M_PI);
        jointDef.upperAngle = 10.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_leftFist.joints addObject:val];
        [_leftArm.joints addObject:val];
        
        // Torso to Left Tread
        
        jointDef.bodyA = torso;
        jointDef.bodyB = leftTread;
        jointDef.localAnchorA = b2Vec2(-24.5f / PTM_RATIO, -19.9f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(7.7f / PTM_RATIO, -0.9f / PTM_RATIO);
        jointDef.lowerAngle = -1.0f / (180.0f / M_PI);
        jointDef.upperAngle = 1.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_leftTread.joints addObject:val];
        [_torso.joints addObject:val];
        
        // ******************** Right Side *********************
        
        // Torso to Right Shoulder
        
        jointDef.bodyA = torso;
        jointDef.bodyB = rightShoulder;
        jointDef.localAnchorA = b2Vec2(25.6f / PTM_RATIO, 19.7f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(-6.0f / PTM_RATIO, 0.1f / PTM_RATIO);
        jointDef.lowerAngle = -5.0f / (180.0f / M_PI);
        jointDef.upperAngle = 5.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_rightShoulder.joints addObject:val];
        [_torso.joints addObject:val];
        
        // Right Shoulder to Right Arm
        
        jointDef.bodyA = rightShoulder;
        jointDef.bodyB = rightArm;
        jointDef.localAnchorA = b2Vec2(6.0f / PTM_RATIO, 0.1f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(-8.9f / PTM_RATIO, 10.6f / PTM_RATIO);
        jointDef.lowerAngle = -10.0f / (180.0f / M_PI);
        jointDef.upperAngle = 10.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_rightShoulder.joints addObject:val];
        [_rightArm.joints addObject:val];
        
        // Right Arm to Right Fist
        
        jointDef.bodyA = rightArm;
        jointDef.bodyB = rightFist;
        jointDef.localAnchorA = b2Vec2(2.3f / PTM_RATIO, -15.3f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(-0.9f / PTM_RATIO, 14.9f / PTM_RATIO);
        jointDef.lowerAngle = -10.0f / (180.0f / M_PI);
        jointDef.upperAngle = 10.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_rightArm.joints addObject:val];
        [_rightFist.joints addObject:val];
        
        // Torso to Right Tread
        
        jointDef.bodyA = torso;
        jointDef.bodyB = rightTread;
        jointDef.localAnchorA = b2Vec2(24.5f / PTM_RATIO, -19.9f / PTM_RATIO);
        jointDef.localAnchorB = b2Vec2(-7.7f / PTM_RATIO, -0.9f / PTM_RATIO);
        jointDef.lowerAngle = -1.0f / (180.0f / M_PI);
        jointDef.upperAngle = 1.0f / (180.0f / M_PI);
        
        joint = world->CreateJoint(&jointDef);
        val = [NSValue valueWithPointer:joint];
        [_rightTread.joints addObject:val];
        [_torso.joints addObject:val];
    }
    
    return self;
}

-(NSMutableArray*)getBotParts{
    NSMutableArray* botParts = [NSMutableArray array];
    [botParts addObject:_torso];
    [botParts addObject:_head];
    [botParts addObject:_leftShoulder];
    [botParts addObject:_leftArm];
    [botParts addObject:_leftFist];
    [botParts addObject:_leftTread];
    [botParts addObject:_rightShoulder];
    [botParts addObject:_rightArm];
    [botParts addObject:_rightFist];
    [botParts addObject:_rightTread];
    
    return botParts;
}


@end
