

import UIKit
import ScreenShield

class SpinnerView: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = SpinnerView
    
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    
    @IBOutlet private var featuresNameLabels: [UILabel]!
    @IBOutlet private var featuresIcons: [UIImageView]!
    @IBOutlet private var featuresStatusLabels: [UILabel]!
    
    @IBOutlet private var containersViews: [UIView]!
    @IBOutlet private var switchViews: [UISwitch]!
    @IBOutlet weak private var iconContainerView: UIView!
    @IBOutlet weak var subsLockImageView: UIImageView!
    private var isPaid: Bool = false
    
    var greenDoneComplition: (() -> Void)?
    var tariffButtonTapped: (() -> Void)?
    var progressSwitchTapped: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if !ProgressHUD.shared.isShow {
            ScreenShield.shared.protect(view: self.iconImageView)
            ScreenShield.shared.protect(view: self.titleLabel)
            ScreenShield.shared.protect(view: self.subtitleLabel)
            
            featuresNameLabels.forEach { label in
                ScreenShield.shared.protect(view: label)
            }
        }
    }
    
    func setup(with model: DataOfferObjectLib?, isPaid: Bool) {
        self.isPaid = isPaid
        titleLabel.text = model?.scn?.banner_title
        subtitleLabel.text = model?.scn?.banner_subtitle
        
        featuresNameLabels.forEach({
            $0.text = model?.scn?.features?[$0.tag].name
        })
        
        Storage.featuresStates[0] = isPaid
        
        guard let mainIcon = URL(string: model?.scn?.banner_icon_unp ?? "") else { return }
        
        iconImageView.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        
        if isPaid {
            subsLockImageView.isHidden = false
            switchViews.first?.isUserInteractionEnabled = false
            
            switchViews.forEach({
                $0.setOn(Storage.featuresStates[$0.tag] ?? false, animated: true)
                featuresIcons[$0.tag].image = UIImage(resource: $0.isOn ? .good : .bad)
                featuresStatusLabels[$0.tag].textColor = UIColor().hexStringToUIColor(hex: $0.isOn ? "#65D65C" : "#E74444")
            })
            
            for i in 0...5 {
                if let item = Storage.featuresStates[i], item {
                    featuresStatusLabels[i].text = model?.scn?.features?[i].g_status
                } else {
                    featuresStatusLabels[i].text = model?.scn?.features?[i].b_status
                }
            }
        } else {
            featuresStatusLabels.forEach({
                $0.text = model?.scn?.features?[$0.tag].b_status
                $0.textColor = UIColor().hexStringToUIColor(hex: "#E74444")
            })
            
            featuresIcons.forEach {
                $0.image = UIImage(resource: .bad)
            }
        }
    }
    
    private func goPass() {
        DispatchQueue.main.async {
            let url: URL
            
            if #available(iOS 18, *) {
                url = URL(string: "App-Prefs:com.apple.Passwords")!
            } else {
                url = URL(string: "App-Prefs:PASSWORDS")!
            }
            
            guard UIApplication.shared.canOpenURL(url) else { return }
            
            UIApplication.shared.open(url)
        }
    }
    
    private func goPrivacy() {
        DispatchQueue.main.async {
            let url: URL
            
            if #available(iOS 18, *) {
                url = URL(string: "App-Prefs:Privacy")!
            } else {
                url = URL(string: "App-Prefs:Privacy")!
            }
            
            guard UIApplication.shared.canOpenURL(url) else { return }
            
            UIApplication.shared.open(url)
        }
    }
    
    private func goSafari() {
        DispatchQueue.main.async {
            let url: URL
            
            if #available(iOS 18, *) {
                url = URL(string: "App-Prefs:com.apple.mobilesafari&path=CLEAR_HISTORY_AND_DATA")!
            }
            else if #available(iOS 17.6, *) {
                url = URL(string: "App-Prefs:SAFARI&path=CLEAR_HISTORY_AND_DATA")!
            }
            else {
                url = URL(string: "App-Prefs:Safari&path=CLEAR_HISTORY_AND_DATA")!
                
            }
                    
            guard UIApplication.shared.canOpenURL(url) else { return }
            
            UIApplication.shared.open(url)
        }
    }
    
    private func showProgressAction() {
        ProgressHUD.animate(interaction: false)
    }
    
    private func showSuccessAction() {
        ProgressHUD.success(interaction: false)
    }
    
    @IBAction func zeroAction(_ sender: UISwitch) {
        if !isPaid {
            sender.setOn(false, animated: true)
            tariffButtonTapped?()
        }
    }
    
    @IBAction func oneAction(_ sender: UISwitch) {
        if isPaid {
            Storage.featuresStates[1] = sender.isOn
            progressSwitchTapped?(sender.isOn)
            if sender.isOn {
                showProgressAction()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showSuccessAction()
                }
            }
        } else {
            sender.setOn(false, animated: true)
            tariffButtonTapped?()
        }
    }
    
    @IBAction func twoAction(_ sender: UISwitch) {
        if isPaid {
            Storage.featuresStates[2] = sender.isOn
            progressSwitchTapped?(sender.isOn)
            if sender.isOn {
                showProgressAction()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showSuccessAction()
                }
            }
        } else {
            sender.setOn(false, animated: true)
            tariffButtonTapped?()
        }
    }
    
    @IBAction func threeAction(_ sender: UISwitch) {
        if isPaid {
            Storage.featuresStates[3] = sender.isOn
            progressSwitchTapped?(sender.isOn)
            if sender.isOn {
                goPrivacy()
            }
        } else {
            sender.setOn(false, animated: true)
            tariffButtonTapped?()
        }
    }
    
    @IBAction func fourAction(_ sender: UISwitch) {
        if isPaid {
            Storage.featuresStates[4] = sender.isOn
            progressSwitchTapped?(sender.isOn)
            if sender.isOn {
                goPass()
            }
        } else {
            sender.setOn(false, animated: true)
            tariffButtonTapped?()
        }
    }
    
    @IBAction func fiveAction(_ sender: UISwitch) {
        if isPaid {
            Storage.featuresStates[5] = sender.isOn
            progressSwitchTapped?(sender.isOn)
            if sender.isOn {
                goSafari()
            }
        } else {
            sender.setOn(false, animated: true)
            tariffButtonTapped?()
        }
    }
}

extension UIColor {
    func hexStringToUIColor(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
