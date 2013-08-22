//
//  CMenuViewController.m
//  Forms
//
//  Created by Jose Vildosola on 12-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CMenuViewController.h"
#import "CMenuItem.h"
#import "CMenuItemCell.h"
#import "CAppDelegate.h"

@interface CMenuViewController ()

@end

@implementation CMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.mMenuTableview.delegate = self;
	self.mMenuTableview.dataSource = self;
	menuItems = [[NSMutableArray alloc] init];
	CMenuItem *menuItem = [[CMenuItem alloc] init];
	menuItem.itemImage = [UIImage imageNamed:@"nuevo.png"];
	menuItem.label = @"Nuevo";
	[menuItems addObject:menuItem];
	menuItem = [[CMenuItem alloc] init];
	menuItem.itemImage = [UIImage imageNamed:@"edit.png"];
	menuItem.label = @"Borradores";
	[menuItems addObject:menuItem];
	menuItem = [[CMenuItem alloc] init];
	menuItem.itemImage = [UIImage imageNamed:@"outbox.png"];
	menuItem.label = @"Bandeja de Salida";
	[menuItems addObject:menuItem];
	menuItem = [[CMenuItem alloc] init];
	menuItem.itemImage = [UIImage imageNamed:@"settings.png"];
	menuItem.label = @"Ajustes";
	[menuItems addObject:menuItem];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return menuItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *identifier = @"Cell";
	CMenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = (CMenuItemCell*)[[[NSBundle mainBundle] loadNibNamed:@"UIMenuCell" owner:self options:nil] objectAtIndex:0];
	}
	cell.menuImage.image = [[menuItems objectAtIndex:indexPath.row] itemImage];
	cell.menuLabel.text = [[menuItems objectAtIndex:indexPath.row] label];
	return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGRect screen = [tableView bounds];
	if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
		return 120;
	}
	return screen.size.height / [self tableView:tableView numberOfRowsInSection:0];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	switch (indexPath.row) {
		case 0:
			[self performSegueWithIdentifier:@"nuevo" sender:nil];
			break;
		case 1:
			[self performSegueWithIdentifier:@"draft" sender:nil];
			break;
		default:
			break;
	}

}

//End of delegate

@end
