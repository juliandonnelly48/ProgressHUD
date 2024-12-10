

import UIKit
import AudioToolbox

final class SpecialAnimationTwo: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = SpecialAnimationTwo
    
    private let isVerySmallDevice = UIScreen.main.nativeBounds.height <= 1136
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var iconWidth: NSLayoutConstraint!
    @IBOutlet weak var iconHeight: NSLayoutConstraint!
    
    private var model: DataOfferObjectLib?
    
    var continueButtonTapped: (() -> Void)?
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            iconWidth.constant = 145
            iconHeight.constant = 145
            titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        } else {
            if isVerySmallDevice {
                iconWidth.constant = 60
                iconHeight.constant = 60
            }
        }
        
        containerView.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
        tableView.minimumZoomScale = 1.0
        tableView.maximumZoomScale = 1.0
        tableView.accessibilityIgnoresInvertColors = true
        tableView.accessibilityViewIsModal = true
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
        
        guard let settingsUrl = URL(string: model?.settingsIcon ?? "") else { return }
        
        iconImageView.kf.setImage(with: settingsUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
    }
    
    @objc func bzzz() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
