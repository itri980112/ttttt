@interface UIImage (RoundedCorner)
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
- (UIImage *)makeRoundedImage:(UIImage *) image radius: (float) radius;
- ( UIImage * )makeRoundCropImage:( UIImage * )image;

@end
