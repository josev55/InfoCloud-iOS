//
//  CDraftViewController.m
//  Forms
//
//  Created by Jose Vildosola on 20-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CDraftViewController.h"
#import "CDraftsParser.h"
#import "CDraftModel.h"
#import "CAppDelegate.h"
#import "CDraftItemCell.h"
#import "CWebViewController.h"
#import "CDraftItemParser.h"

@interface CDraftViewController ()

@end

@implementation CDraftViewController{
	CAppDelegate *app;
	NSString *htmlFile;
	NSString *formName;
	NSString *json;
}
@synthesize mDraftArray, mDraftTableView, mDraftDict;
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
	self.mDraftTableView.dataSource = self;
	self.mDraftTableView.delegate = self;
	app = (CAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	CDraftsParser *parser = [[CDraftsParser alloc] initWithFilePath:[NSString stringWithFormat:@"%@/forms/drafts.xml",app.documentPath]];
	[parser parse];
	self.mDraftDict = [parser mDraftDict];
	self.mDraftArray = [[mDraftDict allKeys] mutableCopy];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//UITableViewDelegate Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identifier = @"Cell";
	CDraftItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = (CDraftItemCell *)[[[NSBundle mainBundle] loadNibNamed:@"UIDraftCell" owner:self options:nil] objectAtIndex:0];
	}
	NSArray *listData = [self.mDraftDict objectForKey:[self.mDraftArray objectAtIndex:[indexPath section]]];
	CDraftModel *model = [listData objectAtIndex:indexPath.row];
	cell.mDraftImage.image = [UIImage imageNamed:@"notepad.png"];
	cell.mDraftLabel.text = [[model.data stringByReplacingOccurrencesOfString:@"draft_" withString:@""] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
	return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	NSArray *list = [self.mDraftDict objectForKey:[self.mDraftArray objectAtIndex:section]];
	return list.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return self.mDraftArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [[self.mDraftArray objectAtIndex:section] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 90;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	NSArray *list = [self.mDraftDict objectForKey:[self.mDraftArray objectAtIndex:[indexPath section]]];
	CDraftModel *model = [list objectAtIndex:indexPath.row];
	formName = [model.refName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
	NSString *path = [NSString stringWithFormat:@"%@/forms/%@",app.documentPath,model.refName];
	for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil]) {
		if ([[file pathExtension] isEqualToString:@"html"]) {
			htmlFile = file;
		}
	}
	CDraftItemParser *parser = [[CDraftItemParser alloc] initWithFilePath:[NSString stringWithFormat:@"%@/forms/%@.xml",app.documentPath,model.data]];
	[[parser parser] parse];
	json = [parser getDataAsJSON];
	[self performSegueWithIdentifier:@"draftWeb" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if ([[segue identifier] isEqualToString:@"draftWeb"]) {
		CWebViewController *web = [segue destinationViewController];
		[web setIsDraft];
		[web setHtmlFile:htmlFile];
		[web setFormName:formName];
		[web setJson:[json stringByReplacingOccurrencesOfString:@"\n" withString:@""]];

	}
}

//End of UITableViewDelegate Methods

- (IBAction)enterEdit:(id)sender {
	[self.mDraftTableView setEditing:YES];
}
@end
