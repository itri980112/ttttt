//
//  UIImage+Orientation.h
//  Xplorer
//
//  Created by Xavier on 2014/10/13.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientation)

- (UIImage*)imageByNormalizingOrientation;
- (UIImage*)fixOrientation:(UIImageOrientation)orientation;
- (UIImage*)croppedImageInRect:(CGRect)visibleRect;

@end
