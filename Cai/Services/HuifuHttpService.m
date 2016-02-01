//
//  HuifuHttpService.m
//  Cai
//
//  Created by Cameron Ling on 5/2/15.
//  Copyright (c) 2015 启竹科技. All rights reserved.
//

#import "HuifuHttpService.h"

@implementation HuifuHttpService


+ (NSString *)getFormDataString:(NSDictionary*)dictionary {
    if( ! dictionary) {
        return nil;
    }
    NSArray* keys = [dictionary allKeys];
    NSMutableString* resultString = [[NSMutableString alloc] init];
    for (int i = 0; i < [keys count]; i++)  {
        NSString *key          = [NSString stringWithFormat:@"%@", [keys objectAtIndex: i]];
        NSString *value        = [NSString stringWithFormat:@"%@", [dictionary valueForKey: [keys objectAtIndex: i]]];

        NSString *encodedKey   = [self escapeString:key];
        NSString *encodedValue = [self escapeString:value];

        NSString *kvPair       = [NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue];
        if(i > 0) {
            [resultString appendString:@"&"];
        }
        [resultString appendString:kvPair];
    }
    return resultString;
}

+ (NSString *)escapeString:(NSString *)string {
    if(string == nil || [string isEqualToString:@""]) {
        return @"";
    }
    NSString *outString     = [NSString stringWithString:string];
    outString                   = [outString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // BUG IN stringByAddingPercentEscapesUsingEncoding
    // WE NEED TO DO several OURSELVES
    outString = [self replace:outString lookFor:@"&" replaceWith:@"%26"];
    outString = [self replace:outString lookFor:@"?" replaceWith:@"%3F"];
    outString = [self replace:outString lookFor:@"=" replaceWith:@"%3D"];
    outString = [self replace:outString lookFor:@"+" replaceWith:@"%2B"];
    outString = [self replace:outString lookFor:@";" replaceWith:@"%3B"];
    
    return outString;
}

+ (NSString *)replace:(NSString *)originalString lookFor:(NSString *)find replaceWith:(NSString *)replaceWith {
    if ( ! originalString || ! find) {
        return originalString;
    }
    
    if( ! replaceWith) {
        replaceWith = @"";
    }
    
    NSMutableString *mstring = [NSMutableString stringWithString:originalString];
    NSRange wholeShebang = NSMakeRange(0, [originalString length]);
    
    [mstring replaceOccurrencesOfString: find
                             withString: replaceWith
                                options: 0
                                  range: wholeShebang];
    
    return [NSString stringWithString: mstring];
}

// 表单方式，需改写，暂时不用
- (void)UIWebViewWithPost:(UIWebView *)uiWebView url:(NSString *)url params:(NSMutableArray *)params
{
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    [s appendString: [NSString stringWithFormat:@"<html><body onload=\"document.forms[0].submit()\">"
                      "<form method=\"post\" action=\"%@\">", url]];
    if([params count] % 2 == 1) { NSLog(@"UIWebViewWithPost error: params don't seem right"); return; }
    for (int i=0; i < [params count] / 2; i++) {
        [s appendString: [NSString stringWithFormat:@"<input type=\"hidden\" name=\"%@\" value=\"%@\" >\n", [params objectAtIndex:i*2], [params objectAtIndex:(i*2)+1]]];
    }
    [s appendString: @"</input></form></body></html>"];
    //NSLog(@"%@", s);
    [uiWebView loadHTMLString:s baseURL:nil];
}
@end
