

import UIKit

class SettingCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var item: SettingModel! {
        didSet {
            updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        cellView.dropShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell() {
        iconImageView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }
}

struct SettingModel {
    let icon: String
    let title: String
    let description: String
}
