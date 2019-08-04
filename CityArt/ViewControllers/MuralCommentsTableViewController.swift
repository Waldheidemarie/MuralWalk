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
        guard let newMuralID = self.streetArt?.muralID else {return}
        MuralController.shared.fetchMuralByID(muralID: newMuralID) { (mural) in
            if let mural = mural {
                MuralController.shared.fetchComments(mural: mural) { (comments) in
                    self.comments = comments
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }else {
                print("actually just don't do anything and await further instructions")
            }
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
    
    //MARK: - Posting to CloudKit
    @IBAction func postCommentButtonPressed(_ sender: UIButton) {
        let newCommentController = UIAlertController(title: "Post New Comment", message: "What would you like to say about his mural?", preferredStyle: .alert)
        newCommentController.addTextField { (textField) in
            textField.placeholder = "Type your comment..."
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { (add) in
            
            //We are now inside the completion block that runs when a new comment is posted.
            
            guard let textFields = newCommentController.textFields else {return}
            guard let newCommentContent = textFields[0].text else {return}
        
            guard let art = self.streetArt else {return}
            
            //perform fetch on mural id from the street art object
            //complete with an optional mural
            //if mural pass it into the save comment function
            MuralController.shared.fetchMuralByID(muralID: art.muralID) { (mural) in
                if let mural = mural {
                    let muralReference = CKRecord.Reference(recordID: mural.recordID, action: .deleteSelf)
                    let newComment = Comment(text: newCommentContent, muralReference: muralReference)
                    MuralController.shared.saveComment(comment: newComment) { (success) in
                        print("we successfully saved a comment")
                    }
                }
                else {
                    //if nil, initialize new mural and pas it into the save function
                    let newMural = Mural(muralID: art.muralID)
                    MuralController.shared.saveMural(muralID: newMural.muralID, hasComment: true) { (mural) in
                        //not sure why we need to complete with this
                        guard let mural = mural else {return}
                        let muralReference = CKRecord.Reference(recordID: mural.recordID, action: .deleteSelf)
                        let newComment = Comment(text: newCommentContent, muralReference: muralReference)
                        MuralController.shared.saveComment(comment: newComment) { (success) in
                            print("We Finally Did it \(muralReference)")
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            newCommentController.dismiss(animated: true, completion: nil)
        }
        newCommentController.addAction(cancelAction)
        newCommentController.addAction(addAction)
        
        present(newCommentController, animated: true) {
            self.loadViewIfNeeded()
        }
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
