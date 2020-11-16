//
//  SpeechSynthesis.h
//  chalkboardmath
//
//  Created by Kurt Niemi on 7/18/12.
//  Copyright (c) 2012 22nd Century Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeechSynthesis : NSObject

+ (SpeechSynthesis *) sharedInstance;
- (NSData *)synthesizeText:(NSString *)text;

+ (void)speak:(NSString *)text;
+ (void)playSound:(NSString *)filePath;


@end
