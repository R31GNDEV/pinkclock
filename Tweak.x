/*
Pink Clock : Created by Kota & Snoolie
*/

#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include <objc/runtime.h>

#ifndef kCFCoreFoundationVersionNumber_iOS_16_0
#define kCFCoreFoundationVersionNumber_iOS_16_0 1946.10
#endif
#define kSLSystemVersioniOS16 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_16_0

/*

Headers

*/

@interface _UIStatusBarStringView : UILabel {
	BOOL _hidesImage;
	UIImage* _image;
	UIImage* _shadowImage;
	double _strength;
	UIImageView* _imageView;
	UIImageView* _shadowImageView;
	long long _options;
}
@property (nonatomic, retain) UIImage *image;
/*
@property (nonatomic, strong, readwrite) UIColor *textColor;
@property (nonatomic, strong, readwrite) UIFont *font;
@property (nonatomic, strong, readwrite) UIColor *shadowColor;
@property (nonatomic, strong, readwrite) CGSize *shadowOffset;
@property(class, nonatomic, readonly) UIColor *placeholderTextColor;
*/
@property (copy, nonatomic) UIColor *pinColor;
@property (nonatomic) CGFloat pinColorAlpha; 
@property (nonatomic) CGFloat bodyColorAlpha;
@property CGFloat shadowRadius;
@property float shadowOpacity;
- (id)_labelborderFillColor;
- (id)_labelTextColor;
@end

/*
RGB code Created by Snoolie :3, you can find it here: 
*/
UIColor* colorFromHexString(NSString* hexString) {
    NSString *daString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![daString containsString:@"#"]) {
        daString = [@"#" stringByAppendingString:daString];
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:daString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];

    NSRange range = [hexString rangeOfString:@":" options:NSBackwardsSearch];
    NSString* alphaString;
    if (range.location != NSNotFound) {
        alphaString = [hexString substringFromIndex:(range.location + 1)];
    } else {
        alphaString = @"1.0"; //no opacity specified - just return 1 :/
    }

    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:[alphaString floatValue]];
}

NSUserDefaults *_preferences;
BOOL _enabled;

%hook _UIStatusBarStringView

-(CALayer *)layer {
  CALayer *origLayer = %orig;
  UIColor *kota;
  NSString *colorString = [_preferences objectForKey:@"colorOneString"];
  NSLog(@"[*]Pink Clock Text Color: %@",colorString);
  if (colorString) {
    kota = colorFromHexString(colorString);
    self.textColor = kota;
  }
  NSString *glowColorString = [_preferences objectForKey:@"shadowColor"];
  NSLog(@"[*]Pink Clock Shadow: %@",glowColorString);
  if (glowColorString) {
    origLayer.shadowColor = colorFromHexString(glowColorString).CGColor;
  }
  origLayer.shadowOpacity = 1;
  origLayer.shadowOffset = CGSizeMake(0.0f,4.0f);
  return origLayer;
}

-(void)setFont:(UIFont *)font {
 NSString *labelText = self.text;
 if (labelText) {
  if ([labelText containsString:@":"]) {
   %orig([UIFont fontWithName:@"ChalkboardSE-Bold" size:font.pointSize]); //run original code with new font
   return; //return so we don't hit the other %orig
  }
 }
 %orig;
}
%end

%ctor {
	_preferences = [[NSUserDefaults alloc] initWithSuiteName:@"online.transrights.pinkclock"];
	[_preferences registerDefaults:@{
		@"enabled" : @YES,
	}];
	_enabled = [_preferences boolForKey:@"enabled"];
	if(_enabled) {
		NSLog(@"[Pink Clock] Enabled");
		%init();
	} else {
		NSLog(@"[Pink Clock] Disabled, bye!");
	}
}