//
//  SpeechSynthesis.m
//  chalkboardmath
//
//  Created by Kurt Niemi on 7/18/12.
//  Copyright (c) 2012 22nd Century Software, LLC. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "SpeechSynthesis.h"

@interface SpeechSynthesis()
@property(nonatomic,strong) NSArray *phraseArray;
@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
@end

@implementation SpeechSynthesis

+ (SpeechSynthesis *) sharedInstance
{
    static SpeechSynthesis *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SpeechSynthesis alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    return self;
}

+ (void)speak:(NSString *)text
{
    SpeechSynthesis *synthesis = [SpeechSynthesis sharedInstance];
    NSData *audioData = [synthesis synthesizeText:text];
    
    NSError *error;
    synthesis.audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    [synthesis.audioPlayer prepareToPlay];
    [synthesis.audioPlayer play];
}

+ (void)playSound:(NSString *)filePath
{
    SpeechSynthesis *synthesis = [SpeechSynthesis sharedInstance];
    NSURL *audioURL = [NSURL fileURLWithPath:filePath];
    NSError *error;
    synthesis.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
    [synthesis.audioPlayer prepareToPlay];
    [synthesis.audioPlayer play];
}

- (NSArray *)phraseArray {
    if (_phraseArray == nil) {
        
        NSMutableArray *phrases = [[NSMutableArray alloc] init];
                
        [phrases addObject:@"0"];
        [phrases addObject:@"1"];
        [phrases addObject:@"2"];
        [phrases addObject:@"3"];
        [phrases addObject:@"4"];
        [phrases addObject:@"5"];
        [phrases addObject:@"6"];
        [phrases addObject:@"7"];
        [phrases addObject:@"8"];
        [phrases addObject:@"9"];
        [phrases addObject:@"10"];
        [phrases addObject:@"11"];
        [phrases addObject:@"12"];
        [phrases addObject:@"13"];
        [phrases addObject:@"14"];
        [phrases addObject:@"15"];
        [phrases addObject:@"16"];
        [phrases addObject:@"17"];
        [phrases addObject:@"18"];
        [phrases addObject:@"19"];
        [phrases addObject:@"20"];
        [phrases addObject:@"30"];
        [phrases addObject:@"40"];
        [phrases addObject:@"50"];
        [phrases addObject:@"60"];
        [phrases addObject:@"70"];
        [phrases addObject:@"80"];
        [phrases addObject:@"90"];
        [phrases addObject:@"100"];
        [phrases addObject:@"equals"];
        [phrases addObject:@"minus"];
        [phrases addObject:@"plus"];
        [phrases addObject:@"times"];
        [phrases addObject:@"divided by"];

        
        [phrases addObject:@"correct0"];
        [phrases addObject:@"correct1"];
        [phrases addObject:@"correct2"];
        [phrases addObject:@"correct3"];
        [phrases addObject:@"correct4"];
        [phrases addObject:@"correct5"];
        [phrases addObject:@"correct6"];
        [phrases addObject:@"correct7"];
        [phrases addObject:@"correct8"];
        [phrases addObject:@"correct9"];
        [phrases addObject:@"correct10"];
        [phrases addObject:@"correct11"];
        [phrases addObject:@"correct12"];
        [phrases addObject:@"correct13"];
        [phrases addObject:@"correct14"];
        [phrases addObject:@"correct15"];
        [phrases addObject:@"correct16"];
        [phrases addObject:@"correct17"];
        [phrases addObject:@"correct18"];

        
        [phrases addObject:@"incorrect0"];
        [phrases addObject:@"incorrect1"];
        [phrases addObject:@"incorrect2"];
        [phrases addObject:@"incorrect3"];
        [phrases addObject:@"incorrect4"];
        [phrases addObject:@"incorrect5"];
        [phrases addObject:@"incorrect6"];
        [phrases addObject:@"incorrect7"];
        [phrases addObject:@"incorrect8"];
        [phrases addObject:@"incorrect9"];
        [phrases addObject:@"incorrect10"];
        [phrases addObject:@"incorrect11"];
        [phrases addObject:@"incorrect12"];
        [phrases addObject:@"incorrect13"];
        [phrases addObject:@"incorrect14"];
        [phrases addObject:@"incorrect15"];
        [phrases addObject:@"incorrect16"];
        [phrases addObject:@"incorrect17"];
        [phrases addObject:@"incorrect18"];
        
        _phraseArray = [phrases copy];
    }
    return _phraseArray;
}

- (NSData *)synthesizeText:(NSString *)text
{
    NSArray *textArray = [text componentsSeparatedByString:@" "];
    NSString *currentString;
    
    long totalAudioLen = 0;
    long totalDataLen = 0;
    long longSampleRate = 11025.0*4;
    int channels = 1;
    long byteRate = 705600/8;

    NSMutableData * soundFileData = [NSMutableData alloc];
    NSMutableData * audioData = [NSMutableData alloc];
    
    for (int i=0; i < [textArray count]; i++)
    {
       if (currentString == nil)
       {
           currentString = [textArray objectAtIndex:i];
       }
       else 
       {
           currentString = [currentString stringByAppendingFormat:@" %@", [textArray objectAtIndex:i]];
       }
        
        if ([self.phraseArray indexOfObject:currentString] != NSNotFound)
        {
            // match (get audio and append to file)
            NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        
            // We only support English (en and spanish)
            if ([language hasPrefix:@"en"]) {
                language = @"en";
            }
            
            // We only support English (en and spanish)
            if ([language hasPrefix:@"es"]) {
                language = @"es";
            }
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:currentString ofType:@"wav" inDirectory:[NSString stringWithFormat:@"audio/%@",language]];
            NSData *wavData = [NSData dataWithContentsOfFile:filePath];
            long wavDataSize = [wavData length] - 44;
            NSData *rawWavData= [NSMutableData dataWithData:[wavData subdataWithRange:NSMakeRange(44, wavDataSize)]];
            
            totalAudioLen += [rawWavData length];            
            totalDataLen = totalAudioLen + 44;  
            
            [audioData appendData:rawWavData];
            
            currentString = nil;
        }
    }

    Byte *header = (Byte*)malloc(44);
    header[0] = 'R';  // RIFF/WAVE header
    header[1] = 'I';
    header[2] = 'F';
    header[3] = 'F';
    header[4] = (Byte) (totalDataLen & 0xff);
    header[5] = (Byte) ((totalDataLen >> 8) & 0xff);
    header[6] = (Byte) ((totalDataLen >> 16) & 0xff);
    header[7] = (Byte) ((totalDataLen >> 24) & 0xff);
    header[8] = 'W';
    header[9] = 'A';
    header[10] = 'V';
    header[11] = 'E';
    header[12] = 'f';  // 'fmt ' chunk
    header[13] = 'm';
    header[14] = 't';
    header[15] = ' ';
    header[16] = 16;  // 4 bytes: size of 'fmt ' chunk
    header[17] = 0;
    header[18] = 0;
    header[19] = 0;
    header[20] = 1;  // format = 1
    header[21] = 0;
    header[22] = (Byte) channels;
    header[23] = 0;
    header[24] = (Byte) (longSampleRate & 0xff);
    header[25] = (Byte) ((longSampleRate >> 8) & 0xff);
    header[26] = (Byte) ((longSampleRate >> 16) & 0xff);
    header[27] = (Byte) ((longSampleRate >> 24) & 0xff);
    header[28] = (Byte) (byteRate & 0xff);
    header[29] = (Byte) ((byteRate >> 8) & 0xff);
    header[30] = (Byte) ((byteRate >> 16) & 0xff);
    header[31] = (Byte) ((byteRate >> 24) & 0xff);
    header[32] = (Byte) (2 * 8 / 8);  // block align
    header[33] = 0;
    header[34] = 16;  // bits per sample
    header[35] = 0;
    header[36] = 'd';
    header[37] = 'a';
    header[38] = 't';
    header[39] = 'a';
    header[40] = (Byte) (totalAudioLen & 0xff);
    header[41] = (Byte) ((totalAudioLen >> 8) & 0xff);
    header[42] = (Byte) ((totalAudioLen >> 16) & 0xff);
    header[43] = (Byte) ((totalAudioLen >> 24) & 0xff);
    
    NSData *headerData = [NSData dataWithBytesNoCopy:header length:44];

    [soundFileData appendData:[headerData subdataWithRange:NSMakeRange(0, 44)]];
    [soundFileData appendData:audioData];

    return soundFileData;
}

@end
