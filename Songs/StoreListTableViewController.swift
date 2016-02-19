//
//  StoreListTableViewController.swift
//  Songs
//
//  Created by Pravin Kandala on 2/14/16.
//  Copyright © 2016 Pravin Kandala. All rights reserved.
//

import UIKit
import CoreData

class StoreListTableViewController: UITableViewController {
    
    
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
    
    var songs = [Songs]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
        //pull-to-refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        
        
        
    }
    
    
    //Function to search songs of a particular artist
    
    
    func filterSongs(searchText: String){
        
        let request = NSFetchRequest(entityName: "Songs")
        do {
            
            let predicate = NSPredicate(format: "sArtist contains %@", searchText)
            
            request.predicate = predicate
            
            songs = try managedObjectContext.executeFetchRequest(request) as! [Songs]
            
            tableView.reloadData()
            
            
            
        } catch {
            print(error)
        }
        
        
    }
    
    
    //Creating a poppup controller to search artists
    
    
    @IBAction func searchRecords(sender: AnyObject) {
        
        //create the alert controller
        
        let s = UIAlertController(title: "Search", message: "Enter Artist name", preferredStyle: UIAlertControllerStyle.Alert)
        
        // Add the text field
        
        s.addTextFieldWithConfigurationHandler{(sArtist:UITextField!) -> Void in
            sArtist.placeholder = "Artist Name"
        }
        
        // Create alert action button
        
        let sbutton = UIAlertAction(title:"Search", style: UIAlertActionStyle.Default){(alert:UIAlertAction!) in
            
            let sArtist = s.textFields![0]
            
            self.filterSongs(sArtist.text!)
            
            s.dismissViewControllerAnimated(true, completion: nil)
        }
        
        //Adding it to controller
        s.addAction(sbutton)
        
        //add cancel action style
        
        let cbutton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel){(alert: UIAlertAction!) in
            s.dismissViewControllerAnimated(true, completion: nil)
        }
        s.addAction(cbutton)
        
        presentViewController(s, animated: true, completion: nil)
        
        
        
    }//end of searchRecords
    
    
    //pull to display all records.
    
    func refresh(sender:AnyObject)
    {
        self.getAll()
        self.refreshControl!.endRefreshing()
    }
    
    
    //display all records
    
    func getAll(){
        let request = NSFetchRequest(entityName: "Songs")
        do {
            songs = try managedObjectContext.executeFetchRequest(request) as! [Songs]
            
            self.tableView.reloadData()
            
        } catch {
            print(error)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        //    var error:NSError?
        
        self.getAll()
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let song = songs[indexPath.row]
        
        //display elements to the cell
        cell.textLabel?.text = song.sName
    
        cell.detailTextLabel?.text = "By: \(song.sArtist! as String), Album: \(song.sAlbum! as String), Year: \(song.sRelease! as String)"
        cell.detailTextLabel?.numberOfLines = 2
        cell.detailTextLabel?.lineBreakMode = .ByWordWrapping
        
        return cell
    }
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            // remove the deleted item from the model
            //   let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            managedObjectContext.deleteObject(songs[indexPath.row] as NSManagedObject)
            
            songs.removeAtIndex(indexPath.row)
            do
            {
                try managedObjectContext.save()
                
            }  catch let error as NSError {
                print("Error:\(error)")
            }
            // tableView.reloadData()
            
            //tableView.reloadData()
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
            
        }
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    
    //Function to edit songs when swipe left
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "editSong"{
            let v = segue.destinationViewController as! ViewController
            let indexpath = self.tableView.indexPathForSelectedRow
            v.song = songs[(indexpath?.row)!]
        }
        
    }
}
