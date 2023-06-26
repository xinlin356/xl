//
//  NSString+Users.m
//  lifestyle
//
//  Created by wd on 15/8/20.
//  Copyright (c) 2015年 Wei Chuang Le ,Ltd. All rights reserved.
//

#import "NSString+Users.h"
#import <AdSupport/AdSupport.h>




@implementation NSString (Users)

- (NSString *)phonetics
{
    NSMutableString *source = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *capsString = [source stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return capsString;
}

+ (NSString *)stringWith:(NSString*)sourceString Chartype:(CharType)charType
{
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *capsString = [source stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    switch (charType) {
        case CharType_UppercaseString: {
            capsString = [capsString uppercaseString];
            break;
        }
        case CharType_LowercaseString: {
            capsString = [capsString lowercaseString];
            break;
        }
        case CharType_CapitalizedFirstChar: {
            capsString = [capsString capitalizedString];
            break;
        }
        default: {
            break;
        }
    }
    return capsString;
}

+ (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxsize: (CGSize)maxSize
{
    NSDictionary *arrts = @{NSFontAttributeName: font};
    
//    if (iOS7) {
        return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
//    } else {
//        return [text sizeWithFont:font];
//    }
}

- (CGSize)sizeWithFont:(UIFont *)font andMaxsize:(CGSize)maxSize
{
    NSDictionary *arrts = @{NSFontAttributeName: (font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]])};
//    if (iOS7) {
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
//    } else {
//        return [self sizeWithFont:font];
//    }
}

+ (BOOL)checkURL:(NSString *)urlString
{
    NSString *matchUrlStr = urlString;
    if (![urlString hasPrefix:@"http"]) {
        matchUrlStr = [NSString stringWithFormat:@"http://www.%@",urlString];
    }
     NSString *urlRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(m.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlRegex];
    
    BOOL isUrl = [urlTest evaluateWithObject:matchUrlStr];
    return isUrl;
}

- (BOOL)containsDesignatedString:(NSString *)aString
{
    NSRange range = [self rangeOfString:aString];
    return range.length > 0;
}

+ (NSString*)dictionaryToBase64DataJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
//    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * jsonStr = [jsonData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return jsonStr;
}

- (BOOL)isMobileNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSString* cu2=@"^1[3|4|5|7|8][0-9]{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextex=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",cu2];
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES)
        ||([regextex evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
/**
 *
 */
+ (UIFont *)getFontWithString:(NSString *)fontStr
{
    if (![fontStr isKindOfClass:[NSNull class]]) {
        if ([fontStr floatValue] > 6) {
            return  [UIFont systemFontOfSize:[fontStr floatValue]];
        }
    }
    return [UIFont systemFontOfSize:13];
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return HexRGB(0x000000);//如果非十六进制，返回黑色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回黑色
        return HexRGB(0x000000);
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (NSString *)appendURLStringAndIDFA {
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return [NSString stringWithFormat:@"%@%@", self, idfa];
}

- (NSString *)convertSmallImageUrlToBigImageUrl {
    NSString *noExtensionString = [self stringByDeletingPathExtension];
    NSString *extension = [self pathExtension];
    NSString *bigImageUrl = [[NSString stringWithFormat:@"%@@b", noExtensionString] stringByAppendingPathExtension:extension];
    return bigImageUrl;
}

+ (NSString *)getTimestamp:(NSString*)mStr{
    
    NSTimeInterval interval    =[mStr doubleValue] / 1000.0;
    
    NSDate *date              = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    [formatter setDateFormat:@"MM-dd"];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    
    NSString *dateString      = [formatter stringFromDate: date];
    
    NSLog(@"时间戳对应的时间是:%@",dateString);
    
    return dateString;
    
}

+ (NSString *)getYYTimestamp:(NSString*)mStr{
    
    NSTimeInterval interval    =[mStr doubleValue] / 1000.0;
    
    NSDate *date              = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    
    NSString *dateString      = [formatter stringFromDate: date];
    
    NSLog(@"时间戳对应的时间是:%@",dateString);
    
    return dateString;
    
}


@end
