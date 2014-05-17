//
//  STTweetLabel.m
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 12/14/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

#import "STTweetLabel.h"
#import "BaseUtil.h"
#import "BaseDefine.h"

@implementation SRRweetLabelModel



@end

@implementation STTweetLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set the basic properties
//        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        [self setNumberOfLines:0];
        [self setLineBreakMode:NSLineBreakByCharWrapping];
        
        // Alloc and init the arrays which stock the touchable words and their location
        touchLocations = [[NSMutableArray alloc] init];
        touchWords = [[NSMutableArray alloc] init];
        
        // Init touchable words colors
        _colorLink = UIColorFromRGB(0x967dd9);
        _colorHashtag = UIColorFromRGB(0x967dd9);
    }
    return self;
}

- (void)awakeFromNib
{
//    [self setBackgroundColor:[UIColor clearColor]];
    [self setUserInteractionEnabled:YES];
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    
    // Alloc and init the arrays which stock the touchable words and their location
    touchLocations = [[NSMutableArray alloc] init];
    touchWords = [[NSMutableArray alloc] init];
    
    // Init touchable words colors
    _colorLink = UIColorFromRGB(0x967dd9);
    _colorHashtag = UIColorFromRGB(0x967dd9);
}

- (void)drawTextInRect:(CGRect)rect
{
    if (_fontHashtag == nil)
    {
        _fontHashtag = self.font;
    }
    
    if (_fontLink == nil)
    {
        _fontLink = self.font;
    }
    
    [touchLocations removeAllObjects];
    [touchWords removeAllObjects];
    
    // Separate words by spaces and lines
    NSArray *words = [[self htmlToText:self.text] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Init a point which is the reference to draw words
    CGPoint drawPoint = CGPointMake(0.0, 0.0);
    // Calculate the size of a space with the actual font
    CGSize sizeSpace = [BaseUtil sizeOfTextInFont:@" " width:rect.size.width height:NSIntegerMax font:self.font];

//    CGSize sizeSpace = [BaseUtil sizeOfTextInFont:@" " width:rect.size.width font:self.font];

    [self.textColor set];

    // Regex to catch @mention #hashtag and link http(s)://
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@([A-Z0-9a-z\u4e00-\u9fa5]+)|#[^#]+#" options:NSRegularExpressionCaseInsensitive error:&error];//((@|#)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)_]+))|  |(http(s)?://([A-Z0-9a-z._-]*(/)?)*)
//|#[^#]+#     @([A-Z0-9a-z\u4e00-\u9fa5]+)
    // Regex to catch newline
    NSRegularExpression *regexNewLine = [NSRegularExpression regularExpressionWithPattern:@"\\n" options:NSRegularExpressionCaseInsensitive error:&error];
    
    for (NSString *wholeWord in words)
    {
        NSTextCheckingResult *match = [regex firstMatchInString:wholeWord options:0 range:NSMakeRange(0, [wholeWord length])];
        
        // Dissolve the word (for example a hashtag: #youtube!, we want only #youtube)
        NSString *preCharacters = [wholeWord substringToIndex:match.range.location];
        NSString *wordCharacters = [wholeWord substringWithRange:match.range];
        NSString *postCharacters = [wholeWord substringFromIndex:match.range.location + match.range.length];
        
//        NSString* word = [wholeWord substringWithRange:NSMakeRange(i, 1)];
        
//        CGSize sizeWord = [BaseUtil sizeOfTextInFont:wholeWord width:rect.size.width font:self.font];
//        
//        // Test if the new word must be in a new line
//        if (drawPoint.x + sizeWord.width > rect.size.width)
//        {
//            drawPoint = CGPointMake(0.0, drawPoint.y + sizeWord.height);
//        }
//        
//        // Draw the prefix of the word (if it has a prefix)
//        if (![preCharacters isEqualToString:@""])
//        {
//            [self.textColor set];
//            CGSize sizePreCharacters = [BaseUtil sizeOfTextInFont:preCharacters width:rect.size.width font:self.font];
//            [preCharacters drawAtPoint:drawPoint withFont:self.font];
//            drawPoint = CGPointMake(drawPoint.x + sizePreCharacters.width, drawPoint.y);
//        }
//        
//        // Draw the touchable word
//        if (![wordCharacters isEqualToString:@""])
//        {
//            // Set the color for mention/hashtag OR weblink
//            if ([wordCharacters hasPrefix:@"#"] || [wordCharacters hasPrefix:@"@"])
//            {
//                [_colorHashtag set];
//            }
//            else if ([wordCharacters hasPrefix:@"http"])
//            {
//                [_colorLink set];
//            }
//            
//            CGSize sizeWordCharacters = [wordCharacters sizeWithFont:self.font];
//            [wordCharacters drawAtPoint:drawPoint withFont:self.font];
//            
//            // Stock the touchable zone
//            [touchWords addObject:wordCharacters];
//            [touchLocations addObject:[NSValue valueWithCGRect:CGRectMake(drawPoint.x, drawPoint.y, sizeWordCharacters.width, sizeWordCharacters.height)]];
//            
//            drawPoint = CGPointMake(drawPoint.x + sizeWordCharacters.width, drawPoint.y);
//        }
//        
//        // Draw the suffix of the word (if it has a suffix) else the word is not touchable
//        if (![postCharacters isEqualToString:@""])
//        {
//            [self.textColor set];
//            
//            NSTextCheckingResult *matchNewLine = [regexNewLine firstMatchInString:postCharacters options:0 range:NSMakeRange(0, [postCharacters length])];
//            
//            // If a newline is match
//            if (matchNewLine)
//            {
//                [[postCharacters substringToIndex:matchNewLine.range.location] drawAtPoint:drawPoint withFont:self.font];
//                drawPoint = CGPointMake(0.0, drawPoint.y + sizeWord.height);
//                [[postCharacters substringFromIndex:matchNewLine.range.location + matchNewLine.range.length] drawAtPoint:drawPoint withFont:self.font];
//                drawPoint = CGPointMake(drawPoint.x + [[postCharacters substringFromIndex:matchNewLine.range.location + matchNewLine.range.length] sizeWithFont:self.font].width, drawPoint.y);
//            }
//            else
//            {
//                CGSize sizePostCharacters = [postCharacters sizeWithFont:self.font];
//                [postCharacters drawAtPoint:drawPoint withFont:self.font];
//                drawPoint = CGPointMake(drawPoint.x + sizePostCharacters.width, drawPoint.y);
//            }
//        }
//        
//        drawPoint = CGPointMake(drawPoint.x + sizeSpace.width, drawPoint.y);
        
        for (int i = 0; i<wholeWord.length; i++) {
            BOOL hasDraw = NO;
            
            NSString* word = [wholeWord substringWithRange:NSMakeRange(i, 1)];

            CGSize sizeWord = [BaseUtil sizeOfTextInFont:word width:rect.size.width height:NSIntegerMax font:self.font];

//            CGSize sizeWord = [BaseUtil sizeOfTextInFont:word width:rect.size.width font:self.font];
            
            // Test if the new word must be in a new line
            if (drawPoint.x + sizeWord.width > rect.size.width)
            {
                CGFloat wholeHeight = [BaseUtil getHeightByString:self.text font:self.font allwidth:rect.size.width];
                
                drawPoint = CGPointMake(0.0, drawPoint.y + sizeWord.height);
            }
            
            // Draw the prefix of the word (if it has a prefix)
            if (![preCharacters isEqualToString:@""] && i < preCharacters.length)
            {
                [self.textColor set];
                hasDraw = YES;
                [word drawAtPoint:drawPoint withFont:self.font];
                drawPoint = CGPointMake(drawPoint.x + sizeWord.width, drawPoint.y);
                continue;
            }
            
            // Draw the touchable word
            if (![wordCharacters isEqualToString:@""])
            {
                // Set the color for mention/hashtag OR weblink
                if ([wordCharacters hasPrefix:@"#"])
                {
                    [_colorHashtag set];
                }else if([wordCharacters hasPrefix:@"@"])
                {
                    [_colorLink set];
                }
//                else if ([wordCharacters hasPrefix:@"http"])
//                {
//                    [_colorLink set];
//                }
                
                hasDraw = YES;
                [word drawAtPoint:drawPoint withFont:self.font];
                
                // Stock the touchable zone
                [touchWords addObject:wordCharacters];
                [touchLocations addObject:[NSValue valueWithCGRect:CGRectMake(drawPoint.x, drawPoint.y, sizeWord.width, sizeWord.height)]];
                
                drawPoint = CGPointMake(drawPoint.x + sizeWord.width, drawPoint.y);
            }
            
            // Draw the suffix of the word (if it has a suffix) else the word is not touchable
            if (![postCharacters isEqualToString:@""])
            {
                [self.textColor set];
                
                NSTextCheckingResult *matchNewLine = [regexNewLine firstMatchInString:postCharacters options:0 range:NSMakeRange(0, [postCharacters length])];
                
                // If a newline is match
                if (matchNewLine)
                {
                    if ([word isEqualToString:@"|"] && [[wholeWord substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"\\n"]) {
                        drawPoint = CGPointMake(0.0, drawPoint.y + sizeWord.height);
                        i += 1;
                    }else{
                        [word drawAtPoint:drawPoint withFont:self.font];
                        drawPoint = CGPointMake(drawPoint.x + sizeWord.width, drawPoint.y);
                    }
//                    [[postCharacters substringToIndex:matchNewLine.range.location] drawAtPoint:drawPoint withFont:self.font];
//                    drawPoint = CGPointMake(0.0, drawPoint.y + sizeWord.height);
//                    [[postCharacters substringFromIndex:matchNewLine.range.location + matchNewLine.range.length] drawAtPoint:drawPoint withFont:self.font];
//                    drawPoint = CGPointMake(drawPoint.x + [[postCharacters substringFromIndex:matchNewLine.range.location + matchNewLine.range.length] sizeWithFont:self.font].width, drawPoint.y);
                }
                else
                {
                    if (!hasDraw) {
                        [word drawAtPoint:drawPoint withFont:self.font];
                        drawPoint = CGPointMake(drawPoint.x + sizeWord.width, drawPoint.y);
                    }
                }
            }
        }
        drawPoint = CGPointMake(drawPoint.x + sizeSpace.width, drawPoint.y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = event.allTouches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    
    [touchLocations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        CGRect touchZone = [obj CGRectValue];
        
        if (CGRectContainsPoint(touchZone, touchPoint))
        {
            //A touchable word is found
            
            NSString *url = [touchWords objectAtIndex:idx];
            
            if ([[touchWords objectAtIndex:idx] hasPrefix:@"@"])
            {
                //Twitter account clicked
                if ([_delegate respondsToSelector:@selector(twitterAccountClicked:)]) {
                    [_delegate twitterAccountClicked:[url substringFromIndex:1]];
                }
            }
            else if ([[touchWords objectAtIndex:idx] hasPrefix:@"#"])
            {
                //Twitter hashtag clicked
                if ([_delegate respondsToSelector:@selector(twitterHashtagClicked:)]) {
                    [_delegate twitterHashtagClicked:[url substringWithRange:NSMakeRange(1, url.length-2)]];
                }
            }
            else if ([[touchWords objectAtIndex:idx] hasPrefix:@"http"])
            {
                //Twitter hashtag clicked
                if ([_delegate respondsToSelector:@selector(websiteClicked:)]) {
                    [_delegate websiteClicked:url];
                }
            }
        }
    }];
}

- (NSString *)htmlToText:(NSString *)htmlString
{
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    
    // Newline character (if you have a better idea...)
//    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\\n"  withString:@"|newLine|"];
    
   
    // Extras
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<3" withString:@"♥"];
    
    return htmlString;
}

@end
