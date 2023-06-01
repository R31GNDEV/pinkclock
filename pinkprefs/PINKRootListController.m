#import <Foundation/Foundation.h>
#import "PINKRootListController.h"
#import <spawn.h>
#import <Preferences/PSTableCell.h>

id daRootListViewController;

@implementation PINKRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)viewWillLoad {
   daRootListViewController = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    daRootListViewController = self;

    UIBarButtonItem *respring = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
    self.navigationItem.rightBarButtonItem = respring;
}

- (void)respring:(id)sender {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Respring"
                         message:@"Are you sure you want to respring?"
                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *defaultAction = [UIAlertAction
        actionWithTitle:@"No"
                  style:UIAlertActionStyleCancel
                handler:^(UIAlertAction *action){
                }];

    UIAlertAction *yes = [UIAlertAction
        actionWithTitle:@"Yes"
                  style:UIAlertActionStyleDestructive
                handler:^(UIAlertAction *action) {
                    pid_t pid;
                    FILE *file;
                    const char* args[] = {"sbreload", NULL};
                    if ((file = fopen("/var/jb/usr/bin/sbreload","r"))) {
                     fclose(file);
                     posix_spawn(&pid, "/var/jb/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
                    } else {
                     posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
                    }
                }];

    [alert addAction:defaultAction];
    [alert addAction:yes];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)openGithubKota {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://github.com/R31GNDEV"]
	options:@{}
	completionHandler:nil];
}

-(void)openGithubSnoolie {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://github.com/0xilis"]
	options:@{}
	completionHandler:nil];
}

-(void)transDiscord {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://discord.gg/queer"]
	options:@{}
	completionHandler:nil];
}




- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
 return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
 return @"Row title";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
 UILabel *label = (id)view;
 if (!label) {
  label= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor whiteColor];
  label.text = @"this is a label";
 }
 return label;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
 return 3;
}

@end

/*@interface PSTableCell : UITableViewCell
@end

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(PSSpecifier *)specifier;
- (CGFloat)preferredHeightForWidth:(CGFloat)width;
@end*/



#define kWidth [[UIApplication sharedApplication] keyWindow].frame.size.width

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)arg1;

@optional
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1;
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 inTableView:(id)arg2;
@end

@interface CustomCell : PSTableCell <PreferencesTableCustomView> {
	UILabel *_label;
}
@end

@implementation CustomCell
- (id)initWithSpecifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	if (self) {
		//_label = [[UILabel alloc] initWithFrame:[self frame]];
		_label = [[UILabel alloc] initWithFrame:CGRectMake(0, -15, kWidth, 120)];
		[_label setNumberOfLines:1];
		[_label setText:@"You can use attributed text to make this prettier."];
		[_label setBackgroundColor:[UIColor clearColor]];
		[_label setShadowColor:[UIColor whiteColor]];
		[_label setShadowOffset:CGSizeMake(0,1)];
		[_label setTextAlignment:NSTextAlignmentCenter];

		[self addSubview:_label];
		
		UIPickerView *daFontPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 120 + 15)];
		daFontPicker.delegate = daRootListViewController;
		daFontPicker.dataSource = daRootListViewController;
		[_label addSubview:daFontPicker];
	}
	return self;
}

- (void)createAvailableFonts {
    NSMutableArray<NSString *> *unsortedFontsArray = [NSMutableArray new];
    for (NSString *eachFontFamily in UIFont.familyNames) {
        for (NSString *eachFontName in [UIFont fontNamesForFamilyName:eachFontFamily]) {
            [unsortedFontsArray addObject:eachFontName];
        }
    }
    self.availableFonts = [NSMutableArray arrayWithArray:[unsortedFontsArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
	// Return a custom cell height.
	return 60.f;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
 return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
 return @"Row title";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}

NSArray *fontList;

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
 UILabel *label = (id)view;
 if (!label) {
  label= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor whiteColor];
  label.text = fontList[row];
  label.font = [UIFont fontWithName:fontList[row] size:16.0];
 }
 return label;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
 return fontList.count;
}

- (void)respring:(id)sender {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Respring"
                         message:@"Are you sure you want to respring?"
                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *defaultAction = [UIAlertAction
        actionWithTitle:@"No"
                  style:UIAlertActionStyleCancel
                handler:^(UIAlertAction *action){
                }];

    UIAlertAction *yes = [UIAlertAction
        actionWithTitle:@"Yes"
                  style:UIAlertActionStyleDestructive
                handler:^(UIAlertAction *action) {
                    pid_t pid;
                    FILE *file;
                    const char* args[] = {"sbreload", NULL};
                    if ((file = fopen("/var/jb/usr/bin/sbreload","r"))) {
                     fclose(file);
                     posix_spawn(&pid, "/var/jb/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
                    } else {
                     posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
                    }
                }];

    [alert addAction:defaultAction];
    [alert addAction:yes];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)openGithubKota {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://github.com/R31GNDEV"]
	options:@{}
	completionHandler:nil];
}

-(void)openGithubSnoolie {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://github.com/0xilis"]
	options:@{}
	completionHandler:nil];
}

-(void)transDiscord {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://discord.gg/queer"]
	options:@{}
	completionHandler:nil];
}

@end
