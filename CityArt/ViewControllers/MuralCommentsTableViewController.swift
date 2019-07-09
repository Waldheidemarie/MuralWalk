//
//  MuralCommentsTableViewController.swift
//  CityArt
//
//  Created by Colin Smith on 7/8/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class MuralCommentsTableViewController: UITableViewController {
    
 
    //MARK: - IB Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var artistLabel: UILabel!
    
    var mural: Mural? {
        didSet{
            loadViewIfNeeded()
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func updateUI(){
        titleLabel.text = mural?.title
        descriptionLabel.text = mural?.artworkDescription
        artistLabel.text = mural?.artist
        
    }
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let comments = mural?.comments else {return 0}
        return comments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? MuralCommentTableViewCell else {return UITableViewCell()}
        
            cell.userLabel.text = "HardCoded User"
            cell.timestampLabel.text = mural?.comments[indexPath.row].timeStamp.formatDate()
            cell.contentLabel.text = mural?.comments[indexPath.row].text
        

        return cell
    }


    @IBAction func postCommentButtonPressed(_ sender: UIButton) {
        let newCommentController = UIAlertController(title: "Post New Comment", message: "What would you like to say about his mural?", preferredStyle: .alert)
        newCommentController.addTextField { (textField) in
            textField.placeholder = "Type your comment..."
        }
        var returned = 0
        let addAction = UIAlertAction(title: "Add", style: .default) { (add) in
            guard let textFields = newCommentController.textFields else {return}
            guard let newCommentContent = textFields[0].text else {return}
            let newComment = Comment(text: newCommentContent)
            guard let mural = self.mural else {return}
            if MuralController.shared.figureOutIfMuralExists(mural: mural, completion: {(index) in
                 // How do I get this function to complete with an int IF the return value is true?
                returned = index
            }) {
                // If possible Get the index of the Mural in the Mural SoT that matches the registration ID currently in this View controller find that particular mural and append the new comment to it.
                let muralToAppend = MuralController.shared.savedMurals[returned]
                //This has propoer scope to be able to pull that mural and then append newComment to that mural
                muralToAppend.comments.append(newComment)
                MuralController.shared.savedMurals.remove(at: returned)
                MuralController.shared.savedMurals.insert(muralToAppend, at: returned)
                self.tableView.reloadData()
                //HAHAHAHAHAAAAAAAAA Maybe that hack is kinda close? LOL probably not but I'm impressed you came up with this.
            }else {
                self.mural?.comments.append(newComment)
                MuralController.shared.savedMurals.append(mural)
                
            }
            
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
