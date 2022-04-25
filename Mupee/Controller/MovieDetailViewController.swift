//
//  MovieDetailViewController.swift
//  Mupee
//
//  Created by Stefanus Hermawan Sebastian on 25/04/22.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: MovieDetailHeaderView!
    
    var movie: Movie = Movie()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        
        // Configure the header view
        headerView.headerImageView.image = UIImage(named: movie.image)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
