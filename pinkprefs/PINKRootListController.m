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

@end
