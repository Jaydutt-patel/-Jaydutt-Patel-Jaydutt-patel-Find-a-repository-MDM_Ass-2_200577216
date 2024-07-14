
import UIKit
import CoreData

protocol MoviesTableViewCellProtocol {
    func deleteMovies(indexPath: IndexPath)
    func editMovies(indexPath: IndexPath)
}

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var moviesImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var studio: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var edit: UIButton!
    
    var indexPath: IndexPath?
    var delegate: MoviesTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        delete.layer.borderColor = UIColor.black.cgColor
        delete.layer.borderWidth = 1
        delete.layer.cornerRadius = 10
        delete.backgroundColor = .white
        delete.clipsToBounds = true
        
        edit.layer.borderColor = UIColor.black.cgColor
        edit.layer.cornerRadius = 10
        edit.layer.borderWidth = 1
        edit.backgroundColor = .white
        edit.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        guard let index = indexPath else { return }
        delegate?.deleteMovies(indexPath: index)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        guard let index = indexPath else { return }
        delegate?.editMovies(indexPath: index)
    }
    
}
