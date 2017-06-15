#import "StringHelper.h"

@implementation NSString (StringHelper)

- (CGFloat)textHeightForFont:(UIFont *)font withMaxWidth:(CGFloat)maxWidth {
	//Calculate the expected size based on the font and linebreak mode of your label
    
	CGFloat maxHeight = 9999;
	CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
	CGSize expectedLabelSize = [self sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
	
	return expectedLabelSize.height;
}

- (CGFloat)textWidthForFont:(UIFont *)font withMaxHeight:(CGFloat)maxHeight
{
    //Calculate the expected size based on the font and linebreak mode of your label
    
	CGFloat maxWidth = 9999;
	CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
	CGSize expectedLabelSize = [self sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
	
	return expectedLabelSize.width;
}

@end
