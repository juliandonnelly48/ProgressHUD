

import UIKit
import AudioToolbox

class SpecialAnimationTwo: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = SpecialAnimationTwo
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dimView: UIView!
    
    private var model: DataOfferObjectLib?
    
    var continueButtonTapped: (() -> Void)?
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
        
    }
    
    func showAlertAndPush() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dimView.isHidden = false
            
            
            UIView.animate(withDuration: 1) {
                self.layoutIfNeeded()
            }
        }
    }
    
    func updateTitle(with index: Int) {
        titleLabel.text = String(format: model?.settingsTitle ?? "", "\(index)")
    }
    
    func setup(with model: DataOfferObjectLib?) {
        self.model = model
        
        
        
        if model?.bzz ?? false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(bzzz), userInfo: nil, repeats: true)
        }
        
        guard let settingsUrl = URL(string: "https://checkerorganizerapp.com\(model?.settingsIcon ?? "")") else { return }
        
        iconImageView.kf.setImage(with: settingsUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        
    }
    
    @objc func bzzz() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
}
