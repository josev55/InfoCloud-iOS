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
	NSString *draftFile;
	CWebViewController *webView;
	BOOL flag;
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

- (BOOL)shouldAutorotate{
	return [self.mDraftArray count] == 0 ? false : true;
}

-(NSUInteger)supportedInterfaceOrientations{
	if ([self.mDraftArray count] == 0) {
		return UIInterfaceOrientationMaskPortrait;
	}
	return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft | toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[self willRotateToInterfaceOrientation:UIInterfaceOrientationPortrait duration:0];
	}	
	NSLog(@"ro: %@",flag ? @"YES" : @"NO");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.mDraftTableView reloadData];
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
	if ([self.mDraftArray count] == 0) {
		cell.mDraftLabel.text = @"";
	} else {
		NSArray *listData = [self.mDraftDict objectForKey:[self.mDraftArray objectAtIndex:[indexPath section]]];
		CDraftModel *model = [listData objectAtIndex:indexPath.row];
		cell.mDraftImage.image = [UIImage imageNamed:@"notepad.png"];
		cell.mDraftLabel.text = [[model.data stringByReplacingOccurrencesOfString:@"draft_" withString:@""] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
	}
	return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if ([self.mDraftArray count] == 0) {
		return 1;
	}
	NSArray *list = [self.mDraftDict objectForKey:[self.mDraftArray objectAtIndex:section]];
	return list.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	if ([self.mDraftArray count] == 0) {
		return 1;
	}
	return self.mDraftArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if ([self.mDraftArray count] == 0) {
		return @"";
	}
	return [[self.mDraftArray objectAtIndex:section] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([self.mDraftArray count] == 0) {
		return self.mDraftTableView.bounds.size.height;
	}
	return 90;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
	if (self.mDraftArray.count == 0) {
		return NO;
	}
	return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([self.mDraftArray count] == 0) {
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
	} else {
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
		draftFile = model.data;
		[self performSegueWithIdentifier:@"draftWeb" sender:nil];
	}
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if ([[segue identifier] isEqualToString:@"draftWeb"]) {
		CWebViewController *web = [segue destinationViewController];
		web.delegate = self;
		[web setIsDraft];
		[web setHtmlFile:htmlFile];
		[web setFormName:formName];
		[web setDraftFilename:draftFile];
		[web setJson:[json stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
	}
}

//End of UITableViewDelegate Methods

- (IBAction)enterEdit:(id)sender {
	[self.mDraftTableView reloadData];
}

-(void)didReloadDataAtDataSource{
	CDraftsParser *parser = [[CDraftsParser alloc] initWithFilePath:[NSString stringWithFormat:@"%@/forms/drafts.xml",app.documentPath]];
	[parser parse];
	self.mDraftDict = [parser mDraftDict];
	self.mDraftArray = [[mDraftDict allKeys] mutableCopy];
	[self.mDraftTableView reloadData];
}
@end
