//
//  NoteListVC.swift
//  TakeNote
//
//  Created by Chris Cosentino on 2018-07-31.
//  Copyright © 2018 Chris Cosentino. All rights reserved.
//

import UIKit
import Firebase

class NoteListVC: UITableViewController {

    var note = [Note]()
    
    var handle: AuthStateDidChangeListenerHandle?
    var valueToPass:String!
    
   
    @IBOutlet var NotesTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NotesTableView.delegate = self
        self.NotesTableView.dataSource = self
        
        DataService.ds.REF_BASE.child("users").child((Auth.auth().currentUser?.uid)!).observe(.value) { (snapshot) in
            self.note.removeAll()
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                print("Note Title:\(snap.key)")
                if snap.key == "email" || snap.key == "provider"{ // if the snapshot key contains email or provider
                    //do nothing,
                }else{ //add the note titles to array
                    let n = Note(title: snap.key)
                    self.note.append(n)
                    
                }
                
            }
            self.sortList()
            self.NotesTableView.reloadData()
            print(self.note)
        }
    }
    
   
  
    
        override func viewWillAppear(_ animated: Bool) {
            handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                
                if user != nil{//if a user is signed in
                    self.fetchNoteList(uid: (user?.uid)!)
                }else{
                    print("No user exists")
                }
            }
        }
    
        override func viewWillDisappear(_ animated: Bool) {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
        
        
        func fetchNoteList(uid: String){
            print(uid)
        }
        
   
    @IBAction func settingsBtn(_ sender: Any) {
       self.showSettingsActionSheet()
    }
    
    
    func showSettingsActionSheet(){ // shows an action sheet that has option to sign the user out
         let firebaseAuth = Auth.auth()
        let alert = UIAlertController(title: "Settings", message: firebaseAuth.currentUser?.email, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive , handler:{ (UIAlertAction)in
            print("User click sign out button")
            
            do {
                try firebaseAuth.signOut()//Signs user out
                self.dismiss(animated: true, completion: nil)//goes back to login screen
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError) //prints an error signing out
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")//Dismiss from actionsheet
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
  
    
    @IBAction func addNoteBtn(_ sender: Any) { //Create a note
       self.showTitleAlert()
    }
    

    func showTitleAlert(){ //Presents an alert that makes the user create a note with a title
        
        let alert = UIAlertController(title: "Enter a title for the list", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter note title"
            textField.keyboardAppearance = .dark
            textField.keyboardType = .webSearch
            textField.returnKeyType = .default
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
            // do nothing when cancel button pressed
        }))
        
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { action in
            // do something when save button pressed
            if alert.textFields![0].text!.count > 20{
               self.showErrorAlert(errorMesssage: "Note title must be less than 20 characters")
            }else{
                
            
                let title = alert.textFields![0].text!//gets the first textfield
                self.valueToPass = title
                
                let content = ["content": "" ] //Creates the content field in the database
                //Need to update create the note in the db
                
                DataService.ds.REF_BASE.child("users").child((Auth.auth().currentUser?.uid)!).child(title).setValue(content)
                
                
                self.performSegue(withIdentifier: SEGUE_TO_NOTE, sender: self)
            }
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return note.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotesTableView.dequeueReusableCell(withIdentifier: NOTE_CELL_ID, for: indexPath) as! NoteListCell
        
        cell.noteTitleLbl.text = note[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! NoteListCell
        
        valueToPass = currentCell.noteTitleLbl.text
        NotesTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: SEGUE_TO_NOTE, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.remove(child: note[indexPath.row].title)
            
            self.note.remove(at: indexPath.row)
            self.NotesTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    //Prepares the segue to to go the note screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SEGUE_TO_NOTE) {
            // initialize new view controller and cast it as your view controller
            let noteController = segue.destination as! NoteVC
            // your new view controller should have property that will store passed value
            noteController.passedTitle = valueToPass
        }
    }
    
    
    
    /*
     Delete the note in the database
     Gets called when the swipe to delete is used
     */
    private func remove(child: String) {
        
        let ref = DataService.ds.REF_BASE.child("users").child((Auth.auth().currentUser?.uid)!).child(child)
        
        ref.removeValue { error, _ in
            print(error)
        }
    }
    
    /**
     Sorts out the sorts array
     */
    private func sortList() {
        self.note.sort(by: { $0.title.lowercased() < $1.title.lowercased() }) // Sort the list alphabetically
        self.NotesTableView.reloadData(); // notify the table view the data has changed
    }
    



}


