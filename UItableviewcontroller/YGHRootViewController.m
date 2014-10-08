//
//  YGHRootViewController.m
//  UItableviewcontroller
//
//  Created by mac on 14-9-23.
//  Copyright (c) 2014年 ___YUGUIHUA___. All rights reserved.
//

#import "YGHRootViewController.h"

@interface YGHRootViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_data;
    NSMutableArray *paths;
    UITableView *table;
}
@end

@implementation YGHRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem=self.editButtonItem;
        //[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(bn)];
        // Custom initialization
    }
    return self;
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [table setEditing:editing animated:animated];
}
-(UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row%2==0)
    return UITableViewCellEditingStyleDelete;
//    return UITableViewCellEditingStyleInsert;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return YES;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *index=@[@"1",@"2",@"3",@"4",@"5",@"6"];
    return index;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}
-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if(sourceIndexPath.section==proposedDestinationIndexPath.section)
    return proposedDestinationIndexPath;
    else
        return sourceIndexPath;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //先把sourceindexpatH对应的数据删除，再把他插入到
    NSUInteger i=sourceIndexPath.section;
    NSMutableArray *source=[NSMutableArray arrayWithArray:_data[sourceIndexPath.section]];
    [paths removeAllObjects];
    NSString *tem=source[sourceIndexPath.row] ;
    [source removeObjectAtIndex:sourceIndexPath.row];
    [source insertObject:tem atIndex:destinationIndexPath.row];
 
    [_data replaceObjectAtIndex:destinationIndexPath.section withObject:source];
   
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:sourceIndexPath.section] withRowAnimation:UITableViewRowAnimationMiddle];
    [tableView reloadData];
   //[tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
  
     //[tableView reloadRowsAtIndexPaths:path2 withRowAnimation:NO];
    
}
-(void)bn
{
    table.editing=!table.editing;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   paths=[[NSMutableArray alloc]init];
   table=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    table.dataSource=self;
    table.delegate=self;
    [self.view addSubview:table];
    table.separatorColor=[UIColor redColor];
    table.separatorStyle=UITableViewCellSeparatorStyleSingleLine ;
    table.rowHeight=50;
    //table.editing=YES;
   // _data=[[NSMutableArray alloc]initWithCapacity:30];
    NSArray *first=@[@"cat",@"dog",@"tiger"];
    NSArray *secon=@[@"李四",@"张三",@"王五",@"李四",@"张三",@"王五"];
    _data=[[NSMutableArray alloc]initWithObjects:first,secon, nil];
    
    

    // Do any additional setup after loading the view.
}
//delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"header%d",section];
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"footer%d",section];
}
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [NSString stringWithFormat:@"delete%d",indexPath.row];
//}
//datasoure
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data[section] count];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {   if([_data[indexPath.section] count]>1)
        { NSMutableArray *ary=[NSMutableArray arrayWithArray:_data[indexPath.section]];
            [ary  removeObjectAtIndex:indexPath.row];
            [_data replaceObjectAtIndex:indexPath.section withObject:ary];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];}
             else
             {
            [_data  removeObjectAtIndex:indexPath.section];
            
                 [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                // [tableView reloadData];
             }}
            break;
        case UITableViewCellEditingStyleInsert:
        {
            NSMutableArray *ary=[NSMutableArray arrayWithArray:_data[indexPath.section]];
            [ary  insertObject:@"monkey" atIndex:indexPath.row+1];
            [_data replaceObjectAtIndex:indexPath.section withObject:ary];
            
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [tableView reloadData];
        }
        default:
            break;
    }
   
    
}//可以滑动出现delete
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"cell";
    NSUInteger j=indexPath.section;
    NSUInteger k=indexPath.row;
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell==nil)
    {cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];}
    cell.imageView.image=[UIImage imageNamed:@"qq.png"];
  cell.textLabel.text=_data[indexPath.section][indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text=[NSString stringWithFormat: @"好人%d",indexPath.row];
    NSLog(@"%@",cell);

    return cell;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
