//
//  COutboxViewController.m
//  Forms
//
//  Created by Jose Vildosola on 02-09-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "COutboxViewController.h"
#import "COutboxItemCell.h"
#import "COutboxModel.h"
#import "CAppDelegate.h"

@interface COutboxViewController (){
	CAppDelegate *app;
	NSDictionary *dict;
}

@end

@implementation COutboxViewController

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
	self.mTableView.dataSource = self;
	self.mTableView.delegate = self;
	app = (CAppDelegate *)[[UIApplication sharedApplication] delegate];
	dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/forms/outbox.plist",app.documentPath]];
	self.mOutboxArray = [[dict allKeys] mutableCopy];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.mOutboxArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *identifier = @"Cell";
	COutboxItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = (COutboxItemCell *)[[[NSBundle mainBundle] loadNibNamed:@"UIOutboxCell" owner:self options:nil] objectAtIndex:0];
	}
	cell.mOutboxImg.image = [UIImage imageNamed:@"edit.png"];
	cell.mOutboxLabel.text = [self.mOutboxArray objectAtIndex:indexPath.row];
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 90;
}

- (IBAction)sincronizar:(id)sender {
	
}
@end
