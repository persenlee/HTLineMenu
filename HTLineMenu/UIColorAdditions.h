#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIColor(Hex)
+ (UIColor*)colorWithHex:(NSString*)hex;
+ (UIColor*)colorWithHex:(NSString*)hex andAlpha:(float)alpha;
@end