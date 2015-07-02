//
//  UIImage+Orientation.m
//  Xplorer
//
//  Created by Xavier on 2014/10/13.
//
//

#import "UIImage+Orientation.h"


@implementation UIImage (Orientation)


- (UIImage*)imageByNormalizingOrientation
{
	if (self.imageOrientation == UIImageOrientationUp)
	{
		return self;
	}

	CGSize size = self.size;
	UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
	[self drawInRect:(CGRect){{0, 0}, size}];
	UIImage* normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return normalizedImage;
}


- (UIImage*)fixOrientation:(UIImageOrientation)orientation
{
#if 1
	// No-op if the orientation is already correct
	if (orientation == UIImageOrientationUp)
	{
		return self;
	}
#endif

	// We need to calculate the proper transformation to make the image upright.
	// We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
	CGAffineTransform transform = CGAffineTransformIdentity;

	switch (orientation)
	{
	case UIImageOrientationDown:
	case UIImageOrientationDownMirrored:
		transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
		transform = CGAffineTransformRotate(transform, M_PI);
		break;

	case UIImageOrientationLeft:
	case UIImageOrientationLeftMirrored:
		transform = CGAffineTransformTranslate(transform, self.size.width, 0);
		transform = CGAffineTransformRotate(transform, M_PI_2);
		break;

	case UIImageOrientationRight:
	case UIImageOrientationRightMirrored:
		transform = CGAffineTransformTranslate(transform, 0, self.size.height);
		transform = CGAffineTransformRotate(transform, -M_PI_2);
		break;
	case UIImageOrientationUp:
	case UIImageOrientationUpMirrored:
		break;
	}

	switch (orientation)
	{
	case UIImageOrientationUpMirrored:
	case UIImageOrientationDownMirrored:
		transform = CGAffineTransformTranslate(transform, self.size.width, 0);
		transform = CGAffineTransformScale(transform, -1, 1);
		break;

	case UIImageOrientationLeftMirrored:
	case UIImageOrientationRightMirrored:
		transform = CGAffineTransformTranslate(transform, self.size.height, 0);
		transform = CGAffineTransformScale(transform, -1, 1);
		break;
	case UIImageOrientationUp:
	case UIImageOrientationDown:
	case UIImageOrientationLeft:
	case UIImageOrientationRight:
		break;
	}

	// Now we draw the underlying CGImage into a new context, applying the transform
	// calculated above.
	CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
			CGImageGetBitsPerComponent(self.CGImage), 0,
			CGImageGetColorSpace(self.CGImage),
			CGImageGetBitmapInfo(self.CGImage));
	CGContextConcatCTM(ctx, transform);
	switch (orientation)
	{
	case UIImageOrientationLeft:
	case UIImageOrientationLeftMirrored:
	case UIImageOrientationRight:
	case UIImageOrientationRightMirrored:
		// Grr...
		CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
		break;

	default:
		CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
		break;
	}

	// And now we just create a new UIImage from the drawing context
	CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
	UIImage* img = [UIImage imageWithCGImage:cgimg];
	CGContextRelease(ctx);
	CGImageRelease(cgimg);
	return img;
}


// Debug
#define rad(angle) ((angle) / 180.0 * M_PI)


- (CGAffineTransform)orientationTransformedRectOfImage:(UIImage*)img
{
	CGAffineTransform rectTransform;
	switch (img.imageOrientation)
	{
	case UIImageOrientationLeft:
		rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -img.size.height);
		break;
	case UIImageOrientationRight:
		rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -img.size.width, 0);
		break;
	case UIImageOrientationDown:
		rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -img.size.width, -img.size.height);
		break;
	default:
		rectTransform = CGAffineTransformIdentity;
	};

	return CGAffineTransformScale(rectTransform, img.scale, img.scale);
}


- (UIImage*)croppedImageInRect:(CGRect)visibleRect
{
	//transform visible rect to image orientation
	CGAffineTransform rectTransform = [self orientationTransformedRectOfImage:self];
	visibleRect = CGRectApplyAffineTransform(visibleRect, rectTransform);

	//crop image
	CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], visibleRect);
	UIImage* result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
	CGImageRelease(imageRef);
	return result;
}


@end
