

import UIKit
import ScreenShield

final class SpinnerView: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = SpinnerView
    private let isVerySmallDevice = UIScreen.main.nativeBounds.height <= 1136
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
    @IBOutlet var stackViews: [UIStackView]!
    @IBOutlet var heights: [NSLayoutConstraint]!
    @IBOutlet weak var iconWidth: NSLayoutConstraint!
    @IBOutlet weak var iconHeight: NSLayoutConstraint!
    private var isPaid: Bool = false
    
    var greenDoneComplition: (() -> Void)?
    var tariffButtonTapped: (() -> Void)?
    var progressSwitchTapped: ((Bool) -> Void)?
    var goEvent: ((EventsName) -> Void)?
    var openSheetVCTapped: (() -> Void)?
    
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
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
            subtitleLabel.font = .systemFont(ofSize: 18, weight: .medium)
            iconWidth.constant = 105
            iconHeight.constant = 105
            featuresNameLabels.forEach { label in
                label.font = .systemFont(ofSize: 15, weight: .medium)
            }
            
            featuresStatusLabels.forEach { label in
                label.font = .systemFont(ofSize: 18, weight: .semibold)
            }
            
            heights.forEach { height in
                height.constant = 83
            }
        } else {
            if isVerySmallDevice {
                stackViews.forEach { stackview in
                    stackview.axis = .vertical
                }
                
                heights.forEach { height in
                    height.constant = 110
                }
            }
        }
    }
    
    func setup(with model: AuthorizationOfferModel?, isPaid: Bool) {
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
            
            guard UIApplication.shared.canOpenURL(url) else {
                self.goEvent?(.specialOffer5Error)
                return
            }
            self.goEvent?(.specialOffer5T5Settings)
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
            
            guard UIApplication.shared.canOpenURL(url) else {
                self.goEvent?(.specialOffer5Error)
                return
            }
            self.goEvent?(.specialOffer5T3Settings)
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
            
            guard UIApplication.shared.canOpenURL(url) else {
                self.goEvent?(.specialOffer5Error)
                return
            }
            self.goEvent?(.specialOffer5T4Settings)
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
        goEvent?(.specialOffer5T0)
        if !isPaid {
            sender.setOn(false, animated: true)
            tariffButtonTapped?()
        }
    }
    
    @IBAction func oneAction(_ sender: UISwitch) {
        goEvent?(.specialOffer5T1)
        if isPaid {
            progressSwitchTapped?(sender.isOn)
            if sender.isOn {
                if ProgressHUD.shared.isSheet {
                    openSheetVCTapped?()
                } else {
                    showProgressAction()
                    
                    Storage.featuresStates[1] = sender.isOn
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.showSuccessAction()
                    }
                }
            } else {
                Storage.featuresStates[1] = sender.isOn
            }
        } else {
            sender.setOn(false, animated: true)
            tariffButtonTapped?()
        }
    }
    
    @IBAction func twoAction(_ sender: UISwitch) {
        goEvent?(.specialOffer5T2)
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
        goEvent?(.specialOffer5T3)
        if isPaid {
            Storage.featuresStates[3] = sender.isOn
            progressSwitchTapped?(sender.isOn)
            if sender.isOn {
                ProgressHUD.animate(localizeText(forKey: .alertText), interaction: false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showSuccessAction()
                    self.goPrivacy()
                }
            }
        } else {
            sender.setOn(false, animated: true)
            tariffButtonTapped?()
        }
    }
    
    @IBAction func fourAction(_ sender: UISwitch) {
        goEvent?(.specialOffer5T5)
        if isPaid {
            Storage.featuresStates[4] = sender.isOn
            progressSwitchTapped?(sender.isOn)
            if sender.isOn {
                ProgressHUD.animate(localizeText(forKey: .alertText), interaction: false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showSuccessAction()
                    self.goPass()
                }
            }
        } else {
            sender.setOn(false, animated: true)
            tariffButtonTapped?()
        }
    }
    
    @IBAction func fiveAction(_ sender: UISwitch) {
        goEvent?(.specialOffer5T4)
        if isPaid {
            Storage.featuresStates[5] = sender.isOn
            progressSwitchTapped?(sender.isOn)
            if sender.isOn {
                ProgressHUD.animate(localizeText(forKey: .alertText), interaction: false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showSuccessAction()
                    self.goSafari()
                }
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
