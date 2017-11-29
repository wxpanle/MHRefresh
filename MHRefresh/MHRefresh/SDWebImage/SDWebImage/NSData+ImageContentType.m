/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Fabrice Aneche
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "NSData+ImageContentType.h"


@implementation NSData (ImageContentType)

+ (SDImageFormat)sd_imageFormatForImageData:(nullable NSData *)data {
    if (!data) {
        return SDImageFormatUndefined;
    }
    
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return SDImageFormatJPEG; //FFD8DDE1
        case 0x89:
            return SDImageFormatPNG; //89504E47
        case 0x47:
            return SDImageFormatGIF; //47494638
        case 0x49:
        case 0x4D:
            return SDImageFormatTIFF; //0X49492A00 0X4D4D002A
        case 0x52:
            // R as RIFF for WEBP 524946462A73010057454250
            //52 49 46 46 2A 73 01  00  57 45 42 50
            //R   I  F  F  * S  SOH NUL W  E  B  P
            if (data.length < 12) {   //WEBP格式长度大于12
                return SDImageFormatUndefined;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) { //
                return SDImageFormatWebP;
            }
    }
    return SDImageFormatUndefined;
}

@end
