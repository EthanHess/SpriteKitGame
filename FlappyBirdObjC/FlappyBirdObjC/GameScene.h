//
//  GameScene.h
//  FlappyBirdObjC
//

//  Copyright (c) 2016 Ethan Hess. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

enum ColliderType {
    Bird = 1,
    Object = 2,
    Gap = 4,
};

//typedef enum : UInt32 {
//    Bird = 1,
//    Object = 2,
//    Gap = 4,
//} ColliderType;

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property (nonatomic, strong) SKLabelNode *gameOverLabel;
@property (nonatomic, strong) SKSpriteNode *bird;
@property (nonatomic, strong) SKSpriteNode *backgroundImageNode;
@property (nonatomic, strong) SKSpriteNode *pipeOne;
@property (nonatomic, strong) SKSpriteNode *pipeTwo;
@property (nonatomic, strong) SKSpriteNode *movingObjects;
@property (nonatomic, strong) SKSpriteNode *labelContainer;
@property (nonatomic, strong) NSTimer *backgroundTimer;
@property (nonatomic, assign) int score;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) enum ColliderType colliderType;

@end
