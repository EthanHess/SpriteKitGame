//
//  GameScene.m
//  FlappyBirdObjC
//
//  Created by Ethan Hess on 1/2/16.
//  Copyright (c) 2016 Ethan Hess. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    //get numerical properties
    
    self.score = 0;
    self.gameOver = NO; 

    //set delegates and add children
    
    self.physicsWorld.contactDelegate = self;
//    [self addChild:self.labelContainer];
//    [self addChild:self.movingObjects];
    
    self.movingObjects = [[SKSpriteNode alloc]init];
    self.labelContainer = [[SKSpriteNode alloc]init];
    
    [self makeBackground];
    
    //set up scene
    
    self.scoreLabel = [[SKLabelNode alloc]initWithFontNamed:@"Helvetica"];
    self.scoreLabel.fontSize = 60;
    self.scoreLabel.text = @"0";
    self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70);
    [self addChild:self.scoreLabel];
    
    //textures
    
    SKTexture *birdTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"flappy1.png"]];
    SKTexture *birdTextureTwo = [SKTexture textureWithImage:[UIImage imageNamed:@"flappy2.png"]];
    
    SKAction *action = [SKAction animateWithTextures:@[birdTexture, birdTextureTwo] timePerFrame:1.0];
    SKAction *makeBirdFlap = [SKAction repeatActionForever:action];
    
    self.bird = [[SKSpriteNode alloc]initWithTexture:birdTexture];
    self.bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self.bird runAction:makeBirdFlap];
    
    self.bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:birdTexture.size.height / 2];
    self.bird.physicsBody.dynamic = YES;
    self.bird.physicsBody.allowsRotation = NO;
    
    self.bird.physicsBody.categoryBitMask = Bird;
    self.bird.physicsBody.contactTestBitMask = Object;
    self.bird.physicsBody.collisionBitMask = Object;
    
    [self addChild:self.bird];
    
    //adds ground physics body at bottom of screen
    
    SKNode *ground = [[SKNode alloc]init];
    ground.position = CGPointMake(0, 0);
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.view.frame.size.width, 1)];
    ground.physicsBody.dynamic = NO;
    
    ground.physicsBody.categoryBitMask = Object;
    ground.physicsBody.contactTestBitMask = Object;
    ground.physicsBody.collisionBitMask = Object;
    
    [self addChild:ground];
    
    //timer
    
    self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(makePipes) userInfo:nil repeats:YES];
    
}

- (void)makePipes {
    
    CGFloat gapHeight = self.bird.size.height * 4;
    UInt32 movementAmount = arc4random_uniform(self.frame.size.height / 2);
    CGFloat pipeOffSet = movementAmount - self.frame.size.height / 4;
    
    //move pipes
    
    SKAction *movePipes = [SKAction moveByX:-self.frame.size.width * 2 y:0 duration: self.frame.size.width / 100];
    SKAction *removePipes = [SKAction removeFromParent];
    SKAction *moveAndRemovePipes = [SKAction sequence:@[movePipes, removePipes]];
    
    //pipeTexture
    
    SKTexture *pipeTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"pipe1.png"]];
    self.pipeOne = [SKSpriteNode spriteNodeWithTexture:pipeTexture];
    self.pipeOne.position = CGPointMake(CGRectGetMidX(self.frame) + self.frame.size.width, CGRectGetMidY(self.frame) + pipeTexture.size.height / 2 + gapHeight / 2 + pipeOffSet);
    [self.pipeOne runAction:moveAndRemovePipes];
    
    self.pipeOne.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipeTexture.size];
    self.pipeOne.physicsBody.dynamic = NO;
    
    self.pipeOne.physicsBody.categoryBitMask = Object;
    self.pipeOne.physicsBody.contactTestBitMask = Object;
    self.pipeOne.physicsBody.collisionBitMask = Object;

    [self.movingObjects addChild:self.pipeOne];
    [self addChild:self.movingObjects];
    
    SKTexture *pipeTextureTwo = [SKTexture textureWithImage:[UIImage imageNamed:@"pipe2.png"]];
    self.pipeTwo = [SKSpriteNode spriteNodeWithTexture:pipeTextureTwo];
    self.pipeTwo.position = CGPointMake(CGRectGetMidX(self.frame) + self.frame.size.width, CGRectGetMidY(self.frame) - pipeTextureTwo.size.height / 2 - gapHeight / 2 + pipeOffSet);
    [self.pipeTwo runAction:moveAndRemovePipes];
    
    self.pipeTwo.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipeTexture.size];
    self.pipeTwo.physicsBody.dynamic = NO;
    
    //CATEGORY BIT MASKS
    
    self.pipeTwo.physicsBody.categoryBitMask = Object;
    self.pipeTwo.physicsBody.contactTestBitMask = Object;
    self.pipeTwo.physicsBody.collisionBitMask = Object;
    
    [self.movingObjects addChild:self.pipeTwo];
    
    //Establish gap in between pipes
    
    SKNode *gap = [[SKNode alloc]init];
    gap.position = CGPointMake(CGRectGetMidX(self.frame) + self.frame.size.width, CGRectGetMidY(self.frame) + pipeOffSet);
    [gap runAction:moveAndRemovePipes];
    gap.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.pipeOne.size.width, gapHeight)];
    gap.physicsBody.dynamic = NO;
    
    // Category bit masks
    
    gap.physicsBody.categoryBitMask = Gap;
    gap.physicsBody.contactTestBitMask = Bird;
    gap.physicsBody.collisionBitMask = Gap;
    
    [self.movingObjects addChild:gap]; 
}

- (void)makeBackground {
    
    SKTexture *backgroundTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"bg.png"]];
    
    SKAction *moveBackground = [SKAction moveByX: - backgroundTexture.size.width y:0 duration:0];
    SKAction *replaceBackground = [SKAction moveByX:backgroundTexture.size.width y:0 duration:0];
    SKAction *moveBackgroundForever = [SKAction repeatActionForever:[SKAction sequence:@[moveBackground, replaceBackground]]];
    
    for (CGFloat i = 0; i < 3; i ++) {
        
        self.backgroundImageNode = [[SKSpriteNode alloc]initWithTexture:backgroundTexture];
        self.backgroundImageNode.position = CGPointMake(backgroundTexture.size.width / 2 + backgroundTexture.size.width * i, CGRectGetMidY(self.frame));
        self.backgroundImageNode.zPosition = -5;
        
        //maybe change ?
        self.backgroundImageNode.yScale = self.frame.size.height;
        
        //
        [self.backgroundImageNode runAction:moveBackgroundForever];
        [self.movingObjects addChild:self.backgroundImageNode];
        
    }
}

#pragma contact delegate method

- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    if (contact.bodyA.collisionBitMask == Gap || contact.bodyB.collisionBitMask == Gap) {
        
        self.score ++;
        self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
    }
    
    else {
       
        if (self.gameOver == NO) {
            
            self.gameOver = YES;
            self.speed = 0;
            
            self.gameOverLabel.fontName = @"Helvetica";
            self.gameOverLabel.fontSize = 30;
            self.gameOverLabel.text = @"Game Over! Tap to play again...";
            self.gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            [self.labelContainer addChild:self.gameOverLabel];
            [self addChild:self.labelContainer];
        }
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.gameOver == NO) {
        
        self.bird.physicsBody.velocity = CGVectorMake(0, 0);
        [self.bird.physicsBody applyImpulse:CGVectorMake(0, 50)];
    }
    
    else {
        
        self.score = 0;
        self.scoreLabel.text = @"0";
        
        self.bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.bird.physicsBody.velocity = CGVectorMake(0, 0);
        
        [self.movingObjects removeAllChildren];
        [self makeBackground];
        
        self.speed = 1;
        self.gameOver = NO;
        [self.labelContainer removeAllChildren]; 
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
