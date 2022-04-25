//
//  MovieTableViewController.swift
//  Mupee
//
//  Created by Stefanus Hermawan Sebastian on 25/04/22.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    var movies: [Movie] = [
        Movie(title: "Doctor Stange", description: "Mau nonton minggu depan bareng bebeb tanggal 1 Mei", image: "doctorStrange", isWatched: false),
        Movie(title: "Spiderman No Way Home", description: "Nonton maraton setelah Doctor Strange", image: "spidermanNoWayHome", isWatched: false),
        Movie(title: "The Wolverine", description: "Nonton malem ini jam 7 sendiri sambil makan Indomie", image: "theWolverine", isWatched: false),
        Movie(title: "Captain America", description: "Besok malem jam 8 nonton sebelum tidur", image: "captainAmerica", isWatched: false),
        Movie(title: "Deadpool", description: "Nonton malem minggu besok 23 April bareng temen SMA di Zoom", image: "deadpool", isWatched: false),
        Movie(title: "Deadpool 2", description: "Nonton setelah Deadpool 1 (maraton bareng temen SMA)", image: "deadpool2", isWatched: false)
    ]
    
    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MovieTableViewCell
        
        cell.titleLabel.text = movies[indexPath.row].title
        cell.descriptionLabel.text = movies[indexPath.row].description
        cell.movieImageView.image = UIImage(named:  movies[indexPath.row].image)
        
        cell.accessoryType = movies[indexPath.row].isWatched ?  .checkmark : .none

        return cell
    }
    
    //MARK: - UITableViewDelegate Protocol
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, sourceView, completionHandler in
            //Delete the row from datasource
            self.movies.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            //Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { action, sourceView, completionHandler in
            let defaultText = "Don't forget to watch " + self.movies[indexPath.row].title
            let activityController: UIActivityViewController
            
            if let imageToShare = UIImage(named: self.movies[indexPath.row].image) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            }else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        deleteAction.image = UIImage(named: "delete")
        
        shareAction.backgroundColor = UIColor(red: 254.0/255.0, green: 149.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        shareAction.image = UIImage(named: "share")
        
        let swipeCofiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeCofiguration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkInAction = UIContextualAction(style: .normal, title: "Watch") { action, sourceView, completionHandler in
            let cell = tableView.cellForRow(at: indexPath) as! MovieTableViewCell
            self.movies[indexPath.row].isWatched = (self.movies[indexPath.row].isWatched) ? false : true
            cell.accessoryType = (self.movies[indexPath.row].isWatched) ? .checkmark : .none
            completionHandler(true)
        }
        
        checkInAction.backgroundColor = UIColor(red: 39.0/255.0, green: 174.0/255.0, blue: 96.0/255.0, alpha: 1.0)
        checkInAction.image = self.movies[indexPath.row].isWatched ? UIImage(named: "undo") : UIImage(named: "tick")
        let swipeCofiguration = UISwipeActionsConfiguration(actions: [checkInAction])
        
        return swipeCofiguration
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! MovieDetailViewController
                destinationController.movie = movies[indexPath.row]
            }
        }
    }
    

}
