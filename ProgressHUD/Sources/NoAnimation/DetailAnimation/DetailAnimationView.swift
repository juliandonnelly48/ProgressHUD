

import UIKit
import ScreenShield
import SwiftDraw
import Kingfisher

func localizeText(forKey key: KeyForLocale) -> String {
    let bundle = Bundle.main
    
    var result = bundle.localizedString(
        forKey: key.rawValue,
        value: nil,
        table: nil
    )
    
    if result == key.rawValue {
        result = Bundle.main.localizedString(
            forKey: key.rawValue,
            value: nil,
            table: "Localizable"
        )
    }
    
    return result
}

enum KeyForLocale: String  {
    case now
    case subsOff
    case subsOn
    case subsPrice
    case subsTitle
    case subsSub
    case subsCancel
    case subsBuy
}

class DetailAnimationView: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = DetailAnimationView
    
    private let isSmallDevice = UIScreen.main.nativeBounds.height <= 1334
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var findView: UIView!
    @IBOutlet weak var findIcon: UIImageView!
    @IBOutlet weak var findTitle: UILabel!
    @IBOutlet weak var findSubtitle: UILabel!
    @IBOutlet weak var findContView: UIView!
    @IBOutlet weak var findContLabel: UILabel!
    
    @IBOutlet weak var featureView: UIView!
    @IBOutlet weak var featureIcon1: UIImageView!
    @IBOutlet weak var featureIcon2: UIImageView!
    @IBOutlet weak var featureIcon3: UIImageView!
    @IBOutlet weak var featureIcon4: UIImageView!
    @IBOutlet weak var featureTitle1: UILabel!
    @IBOutlet weak var featureTitle2: UILabel!
    @IBOutlet weak var featureTitle3: UILabel!
    @IBOutlet weak var featureTitle4: UILabel!
    @IBOutlet weak var featureSubtitle1: UILabel!
    @IBOutlet weak var featureSubtitle2: UILabel!
    @IBOutlet weak var featureSubtitle3: UILabel!
    @IBOutlet weak var featureSubtitle4: UILabel!
    
    @IBOutlet weak var pushTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var pushView: UIView!
    @IBOutlet weak var pushIcon: UIImageView!
    @IBOutlet weak var pushTitle: UILabel!
    @IBOutlet weak var pushSubtitle: UILabel!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertSubtitle: UILabel!
    @IBOutlet weak var alertIcon: UIImageView!
    @IBOutlet weak var alertButton: UIButton!
    
    @IBOutlet weak var informationlabel: UILabel!
    
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var nowLabel: UILabel! {
        didSet {
            nowLabel.text = localizeText(forKey: .now)
        }
    }
    
    var continueButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isSmallDevice {
            topConst.constant = 40
            bottomConst.constant = 44
        }
        
        alertView.layer.cornerRadius = 24
        pushView.layer.cornerRadius = 24
        
        findView.layer.cornerRadius = 14
        
        findContView.layer.cornerRadius = 5
        findContView.layer.borderWidth = 2
        findContView.layer.borderColor = UIColor.red.cgColor
        findContView.backgroundColor = .clear
        
        featureView.layer.cornerRadius = 14
        
        ScreenShield.shared.protect(view: self.pushTitle)
        ScreenShield.shared.protect(view: self.pushIcon)
        ScreenShield.shared.protect(view: self.pushSubtitle)
        ScreenShield.shared.protect(view: self.alertIcon)
        ScreenShield.shared.protect(view: self.alertView)
        ScreenShield.shared.protect(view: self.alertTitle)
        ScreenShield.shared.protect(view: self.alertButton)
        ScreenShield.shared.protect(view: self.alertSubtitle)
        ScreenShield.shared.protect(view: self.iconImageView)
        ScreenShield.shared.protect(view: self.titleLabel)
        ScreenShield.shared.protect(view: self.subtitleLabel)
        ScreenShield.shared.protect(view: self.findView)
        ScreenShield.shared.protect(view: self.featureView)
        ScreenShield.shared.protect(view: self.informationlabel)
    }
    
    func showAlertAndPush() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dimView.isHidden = false
            self.bringSubviewToFront(self.dimView)
            self.bringSubviewToFront(self.pushView)
            self.bringSubviewToFront(self.alertView)
            self.pushTopConstarint.constant = self.isSmallDevice ? 24 : 55
            
            UIView.animate(withDuration: 1) {
                self.alertView.isHidden = false
                self.layoutIfNeeded()
            } completion: { _ in
                self.hidePush()
            }
        }
    }
    
    private func hidePush() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4)  {
            self.pushTopConstarint.constant = -150
            
            UIView.animate(withDuration: 1) {
                self.layoutIfNeeded()
            }
        }
    }
    
    func setup(with model: DataOfferObject?) {
        titleLabel.text = model?.prtd?.title
        subtitleLabel.text = model?.prtd?.ip
        findTitle.text = model?.prtd?.b_title
        findSubtitle.text = model?.prtd?.b_subtitle
        findContLabel.text = model?.prtd?.b_status
        informationlabel.text = model?.prtd?.subtitle
        pushTitle.text = model?.pushTitle
        pushSubtitle.text = model?.pushText
        alertTitle.text = model?.modalTitle
        alertSubtitle.text = model?.modalText
        alertButton.setTitle(model?.modalBtn?.uppercased(), for: .normal)
        
        model?.prtd?.issues?.enumerated().forEach({ index, issue in
            switch index {
            case 0:
                featureTitle1.text = issue.name
                featureSubtitle1.text = issue.status
                
                guard let mainIcon = URL(string: "https://checkerorganizerapp.com/\(issue.icon ?? "")") else { return }
                
                featureIcon1.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            case 1:
                featureTitle2.text = issue.name
                featureSubtitle2.text = issue.status
                
                guard let mainIcon = URL(string: "https://checkerorganizerapp.com/\(issue.icon ?? "")") else { return }
                
                featureIcon2.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            case 2:
                featureTitle3.text = issue.name
                featureSubtitle3.text = issue.status
                
                guard let mainIcon = URL(string: "https://checkerorganizerapp.com/\(issue.icon ?? "")") else { return }
                
                featureIcon3.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            case 3:
                featureTitle4.text = issue.name
                featureSubtitle4.text = issue.status
                
                guard let mainIcon = URL(string: "https://checkerorganizerapp.com/\(issue.icon ?? "")") else { return }
                
                featureIcon4.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            default:
                featureTitle1.text = issue.name
                featureSubtitle1.text = issue.status
                
                guard let mainIcon = URL(string: "https://checkerorganizerapp.com/\(issue.icon ?? "")") else { return }
                
                featureIcon1.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            }
        })
        
        guard let mainIcon = URL(string: "https://checkerorganizerapp.com/\(model?.prtd?.icon ?? "")"),
              let findIconUrl = URL(string: "https://checkerorganizerapp.com/\(model?.modalIcon ?? "")"),
              let pushUrl = URL(string: "https://checkerorganizerapp.com\(model?.pushIcon ?? "")")
        else { return }
        
        iconImageView.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        findIcon.kf.setImage(with: findIconUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        alertIcon.kf.setImage(with: findIconUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        pushIcon.kf.setImage(with: pushUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
    }
    
    @IBAction func buyButtonTapped(_ sender: Any) {
        alertButton.isEnabled = false
        continueButtonTapped?()
    }
}

public struct SVGImgProcessor: ImageProcessor {
    public var identifier: String = "com.appidentifier.webpprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            print("already an image")
            return image
        case .data(let data):
            return UIImage(svgData: data)
        }
    }
}

struct DataOfferObject {
    var imageUrl: String
    var title: String
    var subtitle: String
    var benefitTitle: String
    var benefitDescriptions: [String]
    var btnTitle: String
    var stTitle: String
    var stSubtitle: String
    var poText: String
    var bzz: Bool?
    var settings: [String]?
    var settingsIcon: String?
    var settingsAnimation: String?
    var settingsTitle: String?
    var settingsBtnTitle: String?
    var modalTitle: String?
    var modalText: String?
    var modalIcon: String?
    var modalBtn: String?
    var pushIcon: String?
    var pushTitle: String?
    var pushText: String?
    var homeTitle: String?
    var homeSub: String?
    var homeIcon: String?
    var scn: ScnObj?
    var prtd: PrtdObj?
    var objectTwo: ObjectTwo?
}

struct ObjectTwo {
    let center: Center
    let dark_blue: DarkBlue
    let description: Description
    
    struct Center {
        var title    : String?
        var subtitle: String?
        var footer_text: String?
        var res_color: String?
        var items: [Items]
        
        struct Items: Codable {
            let name: String?
            let res: String?
        }
    }
    
    struct DarkBlue {
        var subtitle: String?
        var small_img: String?
        var title: String?
        var al_title: String?
        var al_subtitle: String?
        var main_img: String?
        var btn_title: String?
        var footer_text: String?
    }
    
    struct Description {
        var btn_subtitle_color: String?
        var subtitle: String?
        var items_title: String?
        var title: String?
        var btn_subtitle: String?
        var main_img: String?
        var btn_title: String?
        var items: [String]?
    }
}

struct ScnObj {
    var title_proc            : String?
    var subtitle_proc        : String?
    var title_anim_proc        : String?
    var subtitle_anim_proc    : String?
    var title_compl            : String?
    var subtitle_compl        : String?
    var title_anim_compl    : String?
    var subtitle_anim_compl    : String?
    var title_unp            : String?
    var subtitle_unp        : String?
    var title_anim_unp        : String?
    var subtitle_anim_unp    : String?
    var banner_title        : String?
    var banner_subtitle        : String?
    var banner_icon            : String?
    var banner_icon_unp        : String?
    var btn                    : String?
    var anim_scn            : String?
    var anim_done            : String?
    var anim_scn_unp        : String?
    var anim_done_unp        : String?
    var rr_title            : String?
    var rr_subtitle            : String?
    
    var features            : [Features]?
    
    struct Features {
        var name    : String?
        var g_status: String?
        var b_status: String?
    }
}

struct PrtdObj {
    var icon        : String?
    var title        : String?
    var ip            : String?
    var subtitle    : String?
    var b_title        : String?
    var b_subtitle    : String?
    var b_status    : String?
    var modal_title    : String?
    var modal_text    : String?
    var issues        : [IssuesObj]?
    
    struct IssuesObj {
        var icon    : String?
        var name: String?
        var status: String?
    }
}
