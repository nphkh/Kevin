#import <UIKit/UIKit.h>

@interface NSString (StringHelper)

- (CGFloat)textHeightForFont:(UIFont *)font withMaxWidth:(CGFloat)maxWidth;
- (CGFloat)textWidthForFont:(UIFont *)font withMaxHeight:(CGFloat)maxHeight;

@end

