

import UIKit
import Kingfisher
import AudioToolbox

class SpecialAnimationView: UIView, InstanceFromNibProtocol{
    typealias InstanceFromNibType = SpecialAnimationView
    private let isSmallDevice = UIScreen.main.nativeBounds.height <= 1334
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var benefitTitleLabel: UILabel!
    
    @IBOutlet var benefitViews: [UIView]!{
        didSet{
            benefitViews.forEach({
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor.systemGray.cgColor
                $0.layer.cornerRadius = 15
            })
        }
    }
    
    @IBOutlet var benefitLabels: [UILabel]!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var continueButtonHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var continueButtonBottomContraint: NSLayoutConstraint!
    
    var timer: Timer?
    var continueButtonTapped: (() -> Void)?
    var closeButtonTapped: (() -> Void)?
    var restoreButtonTapped: (() -> Void)?
    
    var model: DataOfferObjectLib? {
        didSet {
            guard let model else { return }
            
            let imURL = URL(string: model.imageUrl)!
            mainImageView.kf.setImage(with: imURL, placeholder: UIImage(resource: .present), options: [.processor(SVGImgProcessor())])
            titleLabel.text = "\(model.settings?.count ?? 20)" + " " + (model.scn?.title_anim_unp?.uppercased() ?? "")
            subtitleLabel.text = model.subtitle
            benefitTitleLabel.text = model.benefitTitle
            benefitLabels.forEach {
                $0.text = model.benefitDescriptions[$0.tag]
            }
            buyButton.setTitle(model.btnTitle, for: .normal)
            priceLabel.isHidden = true
            closeButton.isHidden = priceLabel.isHidden
            restoreButton.isHidden = closeButton.isHidden
            if model.bzz ?? false {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(bzzz), userInfo: nil, repeats: false)
            }
            
            if isSmallDevice {
                imageHeightContraint.constant = 250
                continueButtonHeightContraint.constant = 40
                continueButtonBottomContraint.constant = 10
            }
        }
    }
    
    @objc func bzzz() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        continueButtonTapped?()
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        closeButtonTapped?()
    }
    
    @IBAction func restoreButtonTapped(_ sender: UIButton) {
        restoreButtonTapped?()
    }
}
