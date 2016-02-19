//
//  ViewController.swift
//  Songs
//
//  Created by Pravin Kandala on 2/14/16.
//  Copyright © 2016 Pravin Kandala. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sArtist: UITextField!
    @IBOutlet weak var sRelease: UITextField!
    @IBOutlet weak var sName: UITextField!
    @IBOutlet weak var sAlbum: UITextField!
   
    @IBOutlet weak var status: UILabel!
    
    var song:Songs?
    
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        //keyboard property
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
        
        
        if let s = song
        {
            sArtist.text = s.sArtist
            sName.text = s.sName
            sAlbum.text = s.sAlbum
            sRelease.text = s.sRelease
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    Follwing code is used for moving scrollview up when keyboard is popped.
//    This piece of code is taken 
//    from http://stackoverflow.com/questions/26689232/scrollview-and-keyboard-swift
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInset
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    //Function to save records at song registration page

    @IBAction func saveData(sender: AnyObject) {
        
        if ((sArtist.text!.isEmpty)  || (sName.text!.isEmpty) || (sAlbum.text!.isEmpty) || (sRelease.text!.isEmpty)) {
            let alert = UIAlertView()
            alert.title = "Incomplete"
            alert.message = "Please Enter all Fields"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
        
        else{
        
        if song == nil {
        let entityDescription =
        NSEntityDescription.entityForName("Songs",
            inManagedObjectContext: managedObjectContext)
        
            //managedobjectmodel created to instert into core data
           song = Songs(entity: entityDescription!,
            insertIntoManagedObjectContext: managedObjectContext)
        
        }
        
        
        song?.sArtist = sArtist.text
        song?.sName = sName.text
        song?.sAlbum = sAlbum.text
        song?.sRelease = sRelease.text
        
        
        do
        {
            try managedObjectContext.save()

            sArtist.text = ""
            sName.text = ""
            sAlbum.text = ""
            sRelease.text = ""
            status.text = "Saved Successfully"
        }  catch let error as NSError {
            status.text = "Error:\(error)"
        }
    }
    
    
    
    }

}

