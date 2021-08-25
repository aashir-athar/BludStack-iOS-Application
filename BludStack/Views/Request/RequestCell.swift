

import UIKit

class RequestCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var bloodGroupLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var acceptedIcon: UIImageView!
    let locationService = LocationService()
    
    var request: ObjectRequest! {
        didSet {
            updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
//        accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        acceptedIcon.isHidden = true
        cellView.dropShadow()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        acceptedIcon.tintColor = .secondaryColor
        acceptedIcon.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func updateCell() {
        locationService.convertLatLongToAddress(latitude: request.latitude, longitude: request.longitude) { [self] (address) in
            locationLabel.text = address
        }
        bloodGroupLabel.text = "Blood Group: \(request.bloodGroup ?? "")"
        if (request.isCompleted ?? false) || (request.donorId ?? "") != ""{
            acceptedIcon.isHidden = false
        }
        if (request.isCompleted ?? false){
            acceptedIcon.tintColor = .green
            dateLabel.text = "Completed"
        }else if (request.isUrgent ?? false){
            dateLabel.text = "Urgent"
        }else{
            dateLabel.text = request.date
        }
    }
}


