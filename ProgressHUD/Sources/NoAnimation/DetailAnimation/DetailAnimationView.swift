

import UIKit
import ScreenShield
import SwiftDraw
import Kingfisher

func localizeText(forKey key: KeyForLocale) -> String {
    let bundle = Bundle.module
    
    var result = bundle.localizedString(
        forKey: key.rawValue,
        value: nil,
        table: nil
    )
    
    if result == key.rawValue {
        result = Bundle.module.localizedString(
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
    
    func setup(with model: DataOfferObjectLib?) {
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
                
                guard let mainIcon = URL(string: issue.icon ?? "") else { return }
                
                featureIcon1.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            case 1:
                featureTitle2.text = issue.name
                featureSubtitle2.text = issue.status
                
                guard let mainIcon = URL(string: issue.icon ?? "") else { return }
                
                featureIcon2.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            case 2:
                featureTitle3.text = issue.name
                featureSubtitle3.text = issue.status
                
                guard let mainIcon = URL(string: issue.icon ?? "") else { return }
                
                featureIcon3.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            case 3:
                featureTitle4.text = issue.name
                featureSubtitle4.text = issue.status
                
                guard let mainIcon = URL(string: issue.icon ?? "") else { return }
                
                featureIcon4.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            default:
                featureTitle1.text = issue.name
                featureSubtitle1.text = issue.status
                
                guard let mainIcon = URL(string: issue.icon ?? "") else { return }
                
                featureIcon1.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            }
        })
        
        guard let mainIcon = URL(string: model?.prtd?.icon ?? ""),
              let findIconUrl = URL(string: model?.modalIcon ?? ""),
              let pushUrl = URL(string: model?.pushIcon ?? "")
        else { return }
        
        iconImageView.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        findIcon.kf.setImage(with: findIconUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        alertIcon.kf.setImage(with: findIconUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        pushIcon.kf.setImage(with: pushUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
    }
    
    @IBAction func buyButtonTapped(_ sender: Any) {
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

public struct DataOfferObjectLib {
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
    var scn: ScnObjLib?
    var prtd: PrtdObjLib?
    var objectTwo: ObjectTwoLib?
    
    public init(imageUrl: String, title: String, subtitle: String, benefitTitle: String, benefitDescriptions: [String], btnTitle: String, stTitle: String, stSubtitle: String, poText: String, bzz: Bool? = nil, settings: [String]? = nil, settingsIcon: String? = nil, settingsAnimation: String? = nil, settingsTitle: String? = nil, settingsBtnTitle: String? = nil, modalTitle: String? = nil, modalText: String? = nil, modalIcon: String? = nil, modalBtn: String? = nil, pushIcon: String? = nil, pushTitle: String? = nil, pushText: String? = nil, homeTitle: String? = nil, homeSub: String? = nil, homeIcon: String? = nil, scn: ScnObjLib? = nil, prtd: PrtdObjLib? = nil, objectTwo: ObjectTwoLib? = nil) {
        self.imageUrl = imageUrl
        self.title = title
        self.subtitle = subtitle
        self.benefitTitle = benefitTitle
        self.benefitDescriptions = benefitDescriptions
        self.btnTitle = btnTitle
        self.stTitle = stTitle
        self.stSubtitle = stSubtitle
        self.poText = poText
        self.bzz = bzz
        self.settings = settings
        self.settingsIcon = settingsIcon
        self.settingsAnimation = settingsAnimation
        self.settingsTitle = settingsTitle
        self.settingsBtnTitle = settingsBtnTitle
        self.modalTitle = modalTitle
        self.modalText = modalText
        self.modalIcon = modalIcon
        self.modalBtn = modalBtn
        self.pushIcon = pushIcon
        self.pushTitle = pushTitle
        self.pushText = pushText
        self.homeTitle = homeTitle
        self.homeSub = homeSub
        self.homeIcon = homeIcon
        self.scn = scn
        self.prtd = prtd
        self.objectTwo = objectTwo
    }
}

public struct ObjectTwoLib {
    let center: CenterLib
    let dark_blue: DarkBlueLib
    let description: DescriptionLib
    
    public init(center: CenterLib, dark_blue: DarkBlueLib, description: DescriptionLib) {
        self.center = center
        self.dark_blue = dark_blue
        self.description = description
    }
    
    public struct CenterLib {
        var title    : String?
        var subtitle: String?
        var footer_text: String?
        var res_color: String?
        var items: [ItemsLib]
        
        public init(title: String? = nil, subtitle: String? = nil, footer_text: String? = nil, res_color: String? = nil, items: [ItemsLib]) {
            self.title = title
            self.subtitle = subtitle
            self.footer_text = footer_text
            self.res_color = res_color
            self.items = items
        }
        
        public struct ItemsLib {
            let name: String?
            let res: String?
            
            public init(name: String?, res: String?) {
                self.name = name
                self.res = res
            }
        }
    }
    
    public struct DarkBlueLib {
        var subtitle: String?
        var small_img: String?
        var title: String?
        var al_title: String?
        var al_subtitle: String?
        var main_img: String?
        var btn_title: String?
        var footer_text: String?
        
        public init(subtitle: String? = nil, small_img: String? = nil, title: String? = nil, al_title: String? = nil, al_subtitle: String? = nil, main_img: String? = nil, btn_title: String? = nil, footer_text: String? = nil) {
            self.subtitle = subtitle
            self.small_img = small_img
            self.title = title
            self.al_title = al_title
            self.al_subtitle = al_subtitle
            self.main_img = main_img
            self.btn_title = btn_title
            self.footer_text = footer_text
        }
    }
    
    public struct DescriptionLib {
        var btn_subtitle_color: String?
        var subtitle: String?
        var items_title: String?
        var title: String?
        var btn_subtitle: String?
        var main_img: String?
        var btn_title: String?
        var items: [String]?
        
        public init(btn_subtitle_color: String? = nil, subtitle: String? = nil, items_title: String? = nil, title: String? = nil, btn_subtitle: String? = nil, main_img: String? = nil, btn_title: String? = nil, items: [String]? = nil) {
            self.btn_subtitle_color = btn_subtitle_color
            self.subtitle = subtitle
            self.items_title = items_title
            self.title = title
            self.btn_subtitle = btn_subtitle
            self.main_img = main_img
            self.btn_title = btn_title
            self.items = items
        }
    }
}

public struct ScnObjLib {
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
    
    var features            : [FeaturesLib]?
    
    public init(title_proc: String? = nil, subtitle_proc: String? = nil, title_anim_proc: String? = nil, subtitle_anim_proc: String? = nil, title_compl: String? = nil, subtitle_compl: String? = nil, title_anim_compl: String? = nil, subtitle_anim_compl: String? = nil, title_unp: String? = nil, subtitle_unp: String? = nil, title_anim_unp: String? = nil, subtitle_anim_unp: String? = nil, banner_title: String? = nil, banner_subtitle: String? = nil, banner_icon: String? = nil, banner_icon_unp: String? = nil, btn: String? = nil, anim_scn: String? = nil, anim_done: String? = nil, anim_scn_unp: String? = nil, anim_done_unp: String? = nil, rr_title: String? = nil, rr_subtitle: String? = nil, features: [FeaturesLib]? = nil) {
        self.title_proc = title_proc
        self.subtitle_proc = subtitle_proc
        self.title_anim_proc = title_anim_proc
        self.subtitle_anim_proc = subtitle_anim_proc
        self.title_compl = title_compl
        self.subtitle_compl = subtitle_compl
        self.title_anim_compl = title_anim_compl
        self.subtitle_anim_compl = subtitle_anim_compl
        self.title_unp = title_unp
        self.subtitle_unp = subtitle_unp
        self.title_anim_unp = title_anim_unp
        self.subtitle_anim_unp = subtitle_anim_unp
        self.banner_title = banner_title
        self.banner_subtitle = banner_subtitle
        self.banner_icon = banner_icon
        self.banner_icon_unp = banner_icon_unp
        self.btn = btn
        self.anim_scn = anim_scn
        self.anim_done = anim_done
        self.anim_scn_unp = anim_scn_unp
        self.anim_done_unp = anim_done_unp
        self.rr_title = rr_title
        self.rr_subtitle = rr_subtitle
        self.features = features
    }
    
    public struct FeaturesLib {
        var name    : String?
        var g_status: String?
        var b_status: String?
        
        public init(name: String? = nil, g_status: String? = nil, b_status: String? = nil) {
            self.name = name
            self.g_status = g_status
            self.b_status = b_status
        }
    }
}

public struct PrtdObjLib {
    var icon        : String?
    var title        : String?
    var ip            : String?
    var subtitle    : String?
    var b_title        : String?
    var b_subtitle    : String?
    var b_status    : String?
    var modal_title    : String?
    var modal_text    : String?
    var issues        : [IssuesObjLib]?
    
    public init(icon: String? = nil, title: String? = nil, ip: String? = nil, subtitle: String? = nil, b_title: String? = nil, b_subtitle: String? = nil, b_status: String? = nil, modal_title: String? = nil, modal_text: String? = nil, issues: [IssuesObjLib]? = nil) {
        self.icon = icon
        self.title = title
        self.ip = ip
        self.subtitle = subtitle
        self.b_title = b_title
        self.b_subtitle = b_subtitle
        self.b_status = b_status
        self.modal_title = modal_title
        self.modal_text = modal_text
        self.issues = issues
    }
    
    public struct IssuesObjLib {
        var icon    : String?
        var name: String?
        var status: String?
        
        public init(icon: String? = nil, name: String? = nil, status: String? = nil) {
            self.icon = icon
            self.name = name
            self.status = status
        }
    }
}
