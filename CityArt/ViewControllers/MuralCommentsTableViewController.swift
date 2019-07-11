//
//  MuralCommentsTableViewController.swift
//  CityArt
//
//  Created by Colin Smith on 7/8/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit
import CloudKit
class MuralCommentsTableViewController: UITableViewController {
    
    
    var comments: [Comment] = []
 
    //MARK: - IB Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var artistLabel: UILabel!
    
    var streetArt: StreetArt?{
        didSet{
            loadViewIfNeeded()
            updateUI()
        }
    }
    
    var mural: Mural? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mural = mural else {return}
        MuralController.shared.fetchComments(mural: mural) { (comments) in
            self.comments = comments
        }
    }
    func updateUI(){
        titleLabel.text = streetArt?.title
        descriptionLabel.text = streetArt?.artworkDescription
        artistLabel.text = streetArt?.artist
        
    }
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        guard let comments = mural?.comments else {return 0}
        
        return comments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? MuralCommentTableViewCell else {return UITableViewCell()}
        
        let comment = comments[indexPath.row]
        
        cell.userLabel.text = "HardCoded User"
        cell.timestampLabel.text = "\(comment.timeStamp.formatDate())"
        cell.contentLabel.text = comment.text
        
//            cell.userLabel.text = "HardCoded User"
//            cell.timestampLabel.text = mural?.comments[indexPath.row].timeStamp.formatDate()
//            cell.contentLabel.text = mural?.comments[indexPath.row].text
        

        return cell
    }


    @IBAction func postCommentButtonPressed(_ sender: UIButton) {
        let newCommentController = UIAlertController(title: "Post New Comment", message: "What would you like to say about his mural?", preferredStyle: .alert)
        newCommentController.addTextField { (textField) in
            textField.placeholder = "Type your comment..."
        }
        
        
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (add) in
            
            //We are now inside the completion block that runs when a new comment is posted.
            
            guard let textFields = newCommentController.textFields else {return}
            guard let newCommentContent = textFields[0].text else {return}
            guard let mural = self.mural else {
                guard let art = self.streetArt else {return}
                let newMural = Mural(muralID: art.muralID)
                
                MuralController.shared.saveMural(muralID: newMural.muralID, hasComment: true) { (mural) in
                    //not sure why we need to complete with this
                    guard let mural = mural else {return}
                    let muralReference = CKRecord.Reference(recordID: mural.recordID, action: .deleteSelf)
                    let newComment = Comment(text: newCommentContent, muralReference: muralReference)
                    MuralController.shared.saveComment(comment: newComment) { (success) in
                        print("We Finally Did it \(muralReference)")
                    }
                }
                return
            }
            
           
            // IF a mural has a comment then it already exists in iCloud. If this boolean is FALSE that means that we are creating a new CKRecord for this mural
            
            
            if mural.hasComment {
                // Append comment to Mural that already exists by finding it's recordID and setting this comment's muralReference number to that value
                let muralReference = CKRecord.Reference(recordID: mural.recordID, action: .deleteSelf)
                let newComment = Comment(text: newCommentContent, muralReference: muralReference)
                
                //All we are doing in this saveComment function is saving a new record with the Comment object. We are relying on the comment to keep track of it's own parent
                MuralController.shared.saveComment(comment: newComment) { (success) in
                    print(muralReference)
                }
            }
            else{
                // WE are creating a brand new Mural because we found this boolean to be false
                
                
                // We need to switch this local mural's has comment value to true and then call the function that saves this mural to iCloud.
                guard let mural = self.mural else {return}
                
                
                MuralController.shared.saveMural(muralID: mural.muralID, hasComment: true) { (mural) in
                    //not sure why we need to complete with this
                    guard let mural = mural else {return}
                    let muralReference = CKRecord.Reference(recordID: mural.recordID, action: .deleteSelf)
                    let newComment = Comment(text: newCommentContent, muralReference: muralReference)
                    MuralController.shared.saveComment(comment: newComment) { (success) in
                        print("We Finally Did it \(muralReference)")
                    }
                }
            }
            
            
            
            
            
            /*
 
            
            if MuralController.shared.figureOutIfMuralExists(mural: mural, completion: {(index) in
                 // How do I get this function to complete with an int IF the return value is true?
                
                
                
                // OK well I figured that out BUT the result was STUPID AS SHIT
                
       
                
                // WHY ARE YOU DOING THIS? JUST FIND A WAY TO SAVE THE MURAL TO THE CLOUD AND FETCH THEM ONCE THEY ARE UP THERE!!!!!
                
                
                
                
                
                // YOU'RE CREATING TERRIBLE, UNREADABLE CODE THAT DOESN'T EVEN WORK DUE TO YOUR LACK OF EXPERIENCE!!!!!!
                
                
                
                // FIX THAT!
                
                
                
                
                
                
                
            }) {
                // If possible Get the index of the Mural in the Mural SoT that matches the registration ID currently in this View controller find that particular mural and append the new comment to it.
                
                
                
                //let muralToAppend = MuralController.shared.savedMurals[returned]
                //This has propoer scope to be able to pull that mural and then append newComment to that mural
                self.comments.append(newComment)
               // MuralController.shared.savedMurals.remove(at: returned)
              //  MuralController.shared.savedMurals.insert(muralToAppend, at: returned)
                self.tableView.reloadData()
            }else {
                self.comments.append(newComment)
                MuralController.shared.saveMural(muralID: mural.muralID) { (mural) in
                    guard let mural = mural else {return}
                    let muralReference = CKRecord.Reference(recordID: mural.recordID, action: .deleteSelf)
                    print("Successfully Saved Mural ID with recordID: \(mural.recordID) ::: \(muralReference)")
                    newComment.muralReference = muralReference
                    //Function to save comment record
                    MuralController.shared.saveComment(comment: newComment) { (success) in
                        print("We saved a comment")
                    }
                }
            }
                   */
            self.tableView.reloadData()
        }
        
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            newCommentController.dismiss(animated: true, completion: nil)
        }
        newCommentController.addAction(cancelAction)
        newCommentController.addAction(addAction)
        
        present(newCommentController, animated: true, completion: nil)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
}
