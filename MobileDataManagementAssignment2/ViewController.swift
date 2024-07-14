
import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate


class ViewController: UIViewController, MoviesTableViewCellProtocol {
    
    @IBOutlet weak var movieslist: UITableView!
    
    var movies: [MoviesList] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        movieslist.register(UINib.init(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
        movieslist.rowHeight = UITableView.automaticDimension
        movieslist.estimatedRowHeight = 30;
        movieslist.tableFooterView = UIView()
        movieslist.delegate = self
        movieslist.dataSource = self
        movieslist.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "MoviesList")
        
        let arr = try?
        (appDelegate.persistentContainer.viewContext.fetch(request)) as? [MoviesList] ?? []
        movies = arr ?? []
        movieslist.reloadData()
    }

    func deleteMovies(indexPath: IndexPath) {
        
        let modal = movies.remove(at: indexPath.row)
        
        appDelegate.persistentContainer.viewContext.delete(modal)
        
        appDelegate.saveContext()
        movieslist.reloadData()
    }

    func editMovies(indexPath: IndexPath) {
        let vc: AddEditViewController = AddEditViewController.instantiateViewController(identifier: .main)
        vc.movies = movies[indexPath.row]
        self.pushVC(vc)
    }
    
    @IBAction func plusAction(_ sender: UIBarButtonItem) {
        let vc: AddEditViewController = AddEditViewController.instantiateViewController(identifier: .main)
        self.pushVC(vc)
    }
    
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell") as? MoviesTableViewCell {
            let modal = movies[indexPath.row]
            cell.title.text = modal.title
            cell.studio.text = modal.studio
            cell.rating.text = modal.criticsRating
            if let data = modal.moviesData, let image = UIImage(data: data) {
                cell.moviesImage.image = image
            } else {
                cell.moviesImage.sd_setImageCustom(url: modal.image ?? "",placeHolderImage: UIImage(named: "image"))
            }
            
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
            
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

