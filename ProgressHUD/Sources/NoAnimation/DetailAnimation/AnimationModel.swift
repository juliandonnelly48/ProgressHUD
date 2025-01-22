

import Foundation

public struct EnterModel: Codable {
    public var token: String
    public var screen: Int?
    public var screen2: Int?
    public var offer: AuthorizationOfferObject?
    
    enum CodingKeys: String, CodingKey {
        case token
        case screen, screen2
        case offer = "specialize"
    }
}

public struct AuthorizationOfferObject: Codable {
    public var isActive: Bool
    public var data: AuthorizationOfferModel?
    
    enum CodingKeys: String, CodingKey {
        case isActive = "is_active"
        case data
    }
}

public struct AuthorizationOfferModel: Codable {
    var imageUrl: String
    var title: String
    var subtitle: String
    var benefitTitle: String
    var benefitDescriptions: [String]
    var btnTitle: String
    public var stTitle: String
    public var stSubtitle: String
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
    var scn: ScnModel?
    var prtd: PrtdModel?
    var objectTwo: ObjectTwo?
    var gap: Gap?
    var sheet: SheetObject?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case title
        case subtitle
        case benefitTitle = "benefit_title"
        case benefitDescriptions = "benefit_descriptions"
        case btnTitle = "btn_title"
        case stTitle = "st_title1"
        case stSubtitle  = "st_title2"
        case poText = "po_text"
        case bzz
        case settingsAnimation = "settings_anime"
        case settings
        case settingsTitle = "settings_title"
        case settingsBtnTitle = "settings_btn"
        case settingsIcon = "settings_icon"
        case modalTitle = "modal_title"
        case modalText = "modal_text"
        case modalIcon = "modal_icon"
        case modalBtn = "modal_btn"
        case pushIcon = "push_icon"
        case pushTitle = "push_title"
        case pushText = "push_text"
        case homeTitle = "home_title"
        case homeSub = "home_sub"
        case homeIcon = "home_icon"
        case scn, prtd, gap, sheet
        case objectTwo = "object_2"
    }
}

struct ScnModel: Codable {
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
    
    struct Features: Codable {
        var name    : String?
        var g_status: String?
        var b_status: String?
    }
}

struct ObjectTwo: Codable {
    let center: Center
    let dark_blue: DarkBlue
    let description: Description
    
    struct Center: Codable {
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
    
    struct DarkBlue: Codable {
        var subtitle: String?
        var small_img: String?
        var title: String?
        var al_title: String?
        var al_subtitle: String?
        var al_subtitle_no_bio: String?
        var main_img: String?
        var btn_title: String?
        var footer_text: String?
    }
    
    struct Description: Codable {
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

struct PrtdModel: Codable{
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
    
    struct IssuesObj: Codable {
        var icon    : String?
        var name: String?
        var status: String?
    }
}

struct Gap: Codable {
    let orderIndex: Int
    let title: String
    let titleTwo: String
    let objecs: [Objec]

    enum CodingKeys: String, CodingKey {
        case titleTwo = "title_two"
        case orderIndex = "order_index"
        case title, objecs
    }
}

struct Objec: Codable {
    let prgrsTitle: String
    let strigs: [Strig]
    let messIcon, messTlt: String
    let subMessTlt, subMessTxt: String?
    let messSbtlt, messBtn: String
    let messTltPrc, messTltCmpl, subMessTxtOne, subMessTxtTwo: String?
    let subMessTxtThree, strigsTlt, strigsSubtlt, strigsRes: String?
    let messTltRed: [String]?

    enum CodingKeys: String, CodingKey {
        case prgrsTitle = "prgrs_title"
        case strigs
        case messIcon = "mess_icon"
        case messTlt = "mess_tlt"
        case subMessTlt = "sub_mess_tlt"
        case subMessTxt = "sub_mess_txt"
        case messSbtlt = "mess_sbtlt"
        case messBtn = "mess_btn"
        case messTltPrc = "mess_tlt_prc"
        case messTltCmpl = "mess_tlt_cmpl"
        case subMessTxtOne = "sub_mess_txt_one"
        case subMessTxtTwo = "sub_mess_txt_two"
        case subMessTxtThree = "sub_mess_txt_three"
        case strigsTlt = "strigs_tlt"
        case strigsSubtlt = "strigs_subtlt"
        case strigsRes = "strigs_res"
        case messTltRed = "mess_tlt_red"
    }
}

struct Strig: Codable {
    let name: String
    let color: String?
    let icn: String?
}

struct SheetObject: Codable {
    let title_1:String
    let title_2:String
    let subtitle:String
    let status_1:String
    let status_2:String
    let status_3:String
    let status_4:String
    let btn_1:String
    let btn_2:String
    let inf_1:String
    let inf_2:String
    let inf_3:String
    let ic_1:String
    let ic_2:String
    let ic_3:String
    let ic_4:String
    let ic_5:String
}
