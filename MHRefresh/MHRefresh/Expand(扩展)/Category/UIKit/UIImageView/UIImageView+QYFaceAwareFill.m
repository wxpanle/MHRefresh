//
//  UIImageView+QYFaceAwareFill.m
//  MHRefresh
//
//  Created by developer on 2017/10/11.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIImageView+QYFaceAwareFill.h"

@implementation UIImageView (QYFaceAwareFill)

- (CIDetector *)faceDetector {
    
    static CIDetector *faceDetector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyLow}];
    });
    return faceDetector;
}

- (void)faceAwareFill {
    
    if (!self.image) {
        return;
    }
    
    CGRect facesRect = [self rectWithFaces];
    
    if (facesRect.size.height + facesRect.size.width == 0) {
        return;
    }
    
    self.contentMode = UIViewContentModeLeft;
    
    [self scaleImageFousingOnRect:facesRect];
}

- (CGRect)rectWithFaces {
    
    CIImage *image = self.image.CIImage;
    
    if (nil == image) {
        image = [CIImage imageWithCGImage:self.image.CGImage];
    }
    
    CIDetector *detector = [self faceDetector];
    
    NSArray *features = [detector featuresInImage:image];
    
    CGRect totalFaceRects = CGRectMake(self.image.size.width / 2.0, self.image.size.height / 2.0, 0, 0);
    
    if (features.count > 0) {
        totalFaceRects = ((CIFaceFeature *)[features objectAtIndex:0]).bounds;
        
        for (CIFaceFeature *faceFeature in features) {
            totalFaceRects = CGRectUnion(totalFaceRects, faceFeature.bounds); //能够包含两个矩形的最小矩形。
        }
    }
    
    return totalFaceRects;
}

- (void)scaleImageFousingOnRect:(CGRect)facesRect {
    
    CGFloat mulit1 = self.frame.size.width / self.image.size.width;
    CGFloat mulit2 = self.frame.size.height / self.image.size.height;
    CGFloat mulit = MAX(mulit1, mulit2);
    
    facesRect.origin.y = self.image.size.height - facesRect.origin.y - facesRect.size.height;
    
    facesRect = CGRectMake(facesRect.origin.x * mulit, facesRect.origin.y * mulit, facesRect.size.width * mulit, facesRect.size.height * mulit);
    
    CGRect imageRect = CGRectZero;
    imageRect.size.width = self.image.size.width * mulit;
    imageRect.size.height = self.image.size.height * mulit;
    imageRect.origin.x = MIN(0.0, MAX(-facesRect.origin.x + self.frame.size.width/2.0 - facesRect.size.width/2.0, -imageRect.size.width + self.frame.size.width));
    imageRect.origin.y = MIN(0.0, MAX(-facesRect.origin.y + self.frame.size.height/2.0 -facesRect.size.height/2.0, -imageRect.size.height + self.frame.size.height));
    
    imageRect = CGRectIntegral(imageRect);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, YES, 2.0);
    [self.image drawInRect:imageRect];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = newImage;
    
    //This is to show the red rectangle over the faces
#ifdef DEBUGGING_FACE_AWARE_FILL
    NSInteger theRedRectangleTag = -3312;
    UIView* facesRectLine = [self viewWithTag:theRedRectangleTag];
    if (!facesRectLine) {
        facesRectLine = [[UIView alloc] initWithFrame:facesRect];
        facesRectLine.tag = theRedRectangleTag;
    }
    else {
        facesRectLine.frame = facesRect;
    }
    
    facesRectLine.backgroundColor = [UIColor clearColor];
    facesRectLine.layer.borderColor = [UIColor redColor].CGColor;
    facesRectLine.layer.borderWidth = 4.0;
    
    CGRect frame = facesRectLine.frame;
    frame.origin.x = imageRect.origin.x + frame.origin.x;
    frame.origin.y = imageRect.origin.y + frame.origin.y;
    facesRectLine.frame = frame;
    
    [self addSubview:facesRectLine];
#endif
}

@end
