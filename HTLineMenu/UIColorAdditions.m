
#import "UIColorAdditions.h"

@implementation UIColor(Hex)
+ (UIColor*)colorWithHex:(NSString*)hex{
	return [UIColor colorWithHex:hex andAlpha:1.0f];
}

+ (UIColor*)colorWithHex:(NSString*)hex andAlpha:(float)alpha{
	hex = [hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if (!hex || [hex length] != 7) {
		return [UIColor clearColor];
	}
	
	unsigned red = 256, green = 256, blue = 256;
	
	NSRange redRange = {1,2};
	NSScanner *scanner = [NSScanner scannerWithString:[hex substringWithRange:redRange]];
	[scanner scanHexInt:&red];

	NSRange greenRange = {3,2};
	scanner = [NSScanner scannerWithString:[hex substringWithRange:greenRange]];
	[scanner scanHexInt:&green];
	
	NSRange blueRange = {5,2};
	scanner = [NSScanner scannerWithString:[hex substringWithRange:blueRange]];
	[scanner scanHexInt:&blue];
	
	if (red == 256 || green == 256 || blue == 256) {
		return nil;
	}
	else {
		return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
	}
}
@end