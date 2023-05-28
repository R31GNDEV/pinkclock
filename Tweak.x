#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include <objc/runtime.h>
/*
Vars
*/
CAGradientLayer *gradientLayer;
UIColor *colorOne;
UIColor *colorTwo;
UIColor *borderColor;
/*
Prefs
*/
static NSString *colorOneString;
static NSString *colorTwoString;
static NSString *borderColorString;

#ifndef kCFCoreFoundationVersionNumber_iOS_16_0
#define kCFCoreFoundationVersionNumber_iOS_16_0 1946.10
#endif
#define kSLSystemVersioniOS16 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_16_0

/*

Headers

*/

@interface _UILegibilityView : UIView {
	BOOL _hidesImage;
	UIImage* _image;
	UIImage* _shadowImage;
	double _strength;
	UIImageView* _imageView;
	UIImageView* _shadowImageView;
	long long _options;
}
@property (nonatomic,retain) UIImage * image;                               //@synthesize image=_image - In the implementation block
@property (nonatomic,retain) UIImage * shadowImage;                         //@synthesize shadowImage=_shadowImage - In the implementation block
@property (nonatomic,retain) UIImageView * imageView;                       //@synthesize imageView=_imageView - In the implementation block
@property (nonatomic,retain) UIImageView * shadowImageView;                 //@synthesize shadowImageView=_shadowImageView - In the implementation block
@property (assign,nonatomic) long long options;                             //@synthesize options=_options - In the implementation block
@property (nonatomic,readonly) long long style; 
@property (assign,nonatomic) double strength;                               //@synthesize strength=_strength - In the implementation block
@property (assign,nonatomic) BOOL hidesImage;                               //@synthesize hidesImage=_hidesImage - In the implementation block
@property (copy, nonatomic) UIColor *textColor;
@property(class, nonatomic, readonly) UIColor *labelColor;
@property(class, nonatomic, readonly) UIColor *secondaryLabelColor;
@property(class, nonatomic, readonly) UIColor *tertiaryLabelColor;
@property(class, nonatomic, readonly) UIColor *quaternaryLabelColor;
@property (nonatomic) CGFloat pinColorAlpha; 
@property (nonatomic) CGFloat bodyColorAlpha;
@property(class, nonatomic, readonly) UIColor *placeholderTextColor;
- (id)_labelborderFillColor;
- (id)_labelTextColor;
@end
@interface _UIStatusBarStringView : UILabel
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, strong, readwrite) UIColor *textColor;
@property (nonatomic, strong, readwrite) UIFont *font;
@property(class, nonatomic, readonly) UIColor *placeholderTextColor;
@end
@interface NSUserDefaults (PinkClock)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end
@interface CALayer (PinkClock)
@property (nonatomic, retain) NSString *compositingFilter;
@property (nonatomic, assign) BOOL allowsGroupOpacity;
@property (nonatomic, assign) BOOL allowsGroupBlending;
@end
/*

Pink Clock

*/
%hook _UIStatusBarStringView
-(void)setTextColor:(UIColor *)textColor {
 NSString *labelText = self.text;
 if (labelText) {
  if ([labelText containsString:@":"]) {
   %orig([UIColor systemPinkColor]); //run original code with systemPinkColor
   return; //return so we don't hit the other %orig
  }
 }
 %orig;
}
-(void)setFont:(UIFont *)font {
 NSString *labelText = self.text;
 if (labelText) {
  if ([labelText containsString:@":"]) {
   %orig([UIFont fontWithName:@"Baskerville-Italic" size:font.pointSize]); //run original code with new font
   return; //return so we don't hit the other %orig
  }
 }
 %orig;
}
/*
-(CALayer *)layer {
 CALayer *origLayer = %orig;
 origLayer.cornerRadius = 4.0;
 origLayer.borderWidth = 1.0;
 origLayer.shadowColor = [UIColor systemPinkColor].CGColor;
 origLayer.borderColor = [UIColor systemPinkColor].CGColor;
 return origLayer;
}
*/
%end

/*
%ctor {
	_preferences = [[NSUserDefaults alloc] initWithSuiteName:@"online.transrights.colorstat"];
	_enabled = [_preferences boolForKey:@"enabled"];
	if(_enabled) {
		NSLog(@"[Pink Clock] Enabled");
		%init();
	} else {
		NSLog(@"[Pink Clock] Disabled, heading out!");
	}
}
*/
