//
//  MovieTableViewController.swift
//  Mupee
//
//  Created by Stefanus Hermawan Sebastian on 25/04/22.
//

import UIKit
import CoreData
import UserNotifications

class MovieTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    
    
    var searchController: UISearchController!
    
    var searchResult: [MovieMO] = []
    
    var fetchResultController: NSFetchedResultsController<MovieMO>!
    
    //array untuk nampung hasil fetch dari core data
    var movies: [MovieMO] = []
    
    //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hidesBarsOnSwipe = true
        
        // Fetch data from data store
        let fetchRequest: NSFetchRequest<MovieMO> = MovieMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "isWatched", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    movies = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        
        // Search bar method
        searchController = UISearchController(searchResultsController: nil)
//        self.navigationItem.searchController = searchController
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = UIColor(red: 128, green: 0, blue: 0)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        // Customize search bar
        searchController.searchBar.placeholder = "Search movies..."
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        
        //notifications
        prepareNotification()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if searchController.isActive {
            return searchResult.count
        }else {
            return movies.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MovieTableViewCell
        
        // Determine if we get the movie from search result or the original array
        let movie = searchController.isActive ? searchResult[indexPath.row] : movies[indexPath.row]
        
        // Configure the cell
        cell.titleLabel.text = movie.title
        cell.descriptionLabel.text = movie.summary
        
        if let movieImage = movie.image {
            cell.movieImageView.image = UIImage(data: movieImage as Data)
        }
        
        cell.accessoryType = movie.isWatched ?  .checkmark : .none
        cell.tintColor = UIColor(red: 128, green: 0, blue: 0)

        return cell
    }
    
    //MARK: - UITableViewDelegate Protocol
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        }else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, sourceView, completionHandler in
            //Delete the row from datasource
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let movieToDelete = self.fetchResultController.object(at: indexPath)
                
                context.delete(movieToDelete)
                appDelegate.saveContext()
            }
            
            //Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { action, sourceView, completionHandler in
            let defaultText = "Don't forget to watch " + self.movies[indexPath.row].title!
            let activityController: UIActivityViewController
            
            if let movieImage = self.movies[indexPath.row].image, let imageToShare = UIImage(data: movieImage as Data){
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            }else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(red: 231, green: 76, blue: 60)
        deleteAction.image = UIImage(named: "delete")
        
        shareAction.backgroundColor = UIColor(red: 254, green: 149, blue: 38)
        shareAction.image = UIImage(named: "share")
        
        let swipeCofiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeCofiguration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let checkInAction = UIContextualAction(style: .normal, title: "Watch") { action, sourceView, completionHandler in
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let cell = tableView.cellForRow(at: indexPath) as! MovieTableViewCell
                self.movies[indexPath.row].isWatched = (self.movies[indexPath.row].isWatched) ? false : true
                cell.accessoryType = (self.movies[indexPath.row].isWatched) ? .checkmark : .none
                cell.tintColor = UIColor(red: 128, green: 0, blue: 0)
                appDelegate.saveContext()
            }
            
            completionHandler(true)
        }
        
        checkInAction.backgroundColor = UIColor(red: 39, green: 174, blue: 96)
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
                destinationController.movie = (searchController.isActive) ? searchResult[indexPath.row] : movies[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Fetch Request Methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        if let fetchedObjects = controller.fetchedObjects {
            movies = fetchedObjects as! [MovieMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //MARK: - SearchBar Methods
    func filterContent(for searchText: String) {
        searchResult = movies.filter({ movie in
            if let title = movie.title {
                let isMatch = title.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }else {
                return false
            }
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    //MARK: - Notification
    
    func prepareNotification() {
        //Make sure the movie arr is not empty
        if movies.count == 0 {
            return
        }
        
        //pick movie randomly
        let randomNum = Int(arc4random_uniform(UInt32(movies.count)))
        if movies[randomNum].isWatched == false {
            let suggestedMovie = movies[randomNum]
            //create the user notif
            let content = UNMutableNotificationContent()
            content.title = "Movie You Haven't Watched"
            content.subtitle = ""
            content.body = "Don't forget to watch \(suggestedMovie.title!)"
            content.sound = UNNotificationSound.default
            
            //attachment
            let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            let tempFileURL = tempDirURL.appendingPathComponent("suggested-movie.jpg")
            
            if let image = UIImage(data: suggestedMovie.image! as Data) {
                try? image.jpegData(compressionQuality: 1.0)?.write(to: tempFileURL)
                if let movieImage = try? UNNotificationAttachment(identifier: "movieImage", url: tempFileURL, options: nil) {
                    content.attachments = [movieImage]
                }
            }
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            let request = UNNotificationRequest(identifier: "mupee.movieSuggesion", content: content, trigger: trigger)
            
            //Schedule the notif
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }else {
            let suggestedMovie = movies[randomNum]
            //create the user notif
            let content = UNMutableNotificationContent()
            content.title = "Movie You Haven't Watched"
            content.subtitle = ""
            content.body = "Don't forget to watch your movie"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            let request = UNNotificationRequest(identifier: "mupee.movieSuggesion", content: content, trigger: trigger)
            
            //Schedule the notif
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
    }

}
