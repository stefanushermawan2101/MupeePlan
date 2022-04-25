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
        
        // Configure the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        // Customize the navBar
        navigationController?.navigationBar.tintColor = UIColor(red: 128, green: 0, blue: 0)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieDetailIconTextCell.self), for: indexPath) as! MovieDetailIconTextCell
            cell.shortTextLabel.text = movie.title
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieDetailTextCell.self), for: indexPath) as! MovieDetailTextCell
            cell.descriptionLabel.text = movie.description
            
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
    
}
