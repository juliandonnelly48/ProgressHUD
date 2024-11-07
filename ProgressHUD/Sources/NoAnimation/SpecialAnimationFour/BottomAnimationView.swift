
import UIKit
import ScreenShield
import SnapKit

final class BottomAnimationView: UIView {
    private let isVerySmallDevice = UIScreen.main.nativeBounds.height <= 1136
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: isVerySmallDevice ? 14 : 16, weight: .semibold)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: isVerySmallDevice ? 10 : 12, weight: .regular)
        label.textColor = UIColor(red: 103/255, green: 103/255, blue: 103/255, alpha: 1)
        return label
    }()
    
    private lazy var linesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: isVerySmallDevice ? 12 : 14, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    var actionButton: UIButton?
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        return view
    }()
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: isVerySmallDevice ? 12 : 14, weight: .medium)
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
    
    var model: DataOfferObjectLib? {
        didSet {
            titleLabel.text = model?.objectTwo?.description.title
            subtitleLabel.text = model?.objectTwo?.description.subtitle
            linesLabel.text = (model?.objectTwo?.description.items_title ?? "") + createText()
            actionButton?.setTitle(model?.objectTwo?.description.btn_title, for: .normal)
            footerLabel.text = model?.objectTwo?.description.btn_subtitle
            
            guard let mainUrl = URL(string: model?.objectTwo?.description.main_img ?? "") else { return }
            
            iconImageView.kf.setImage(with: mainUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
        if !ProgressHUD.shared.isShow {
            ScreenShield.shared.protect(view: self.iconImageView)
            ScreenShield.shared.protect(view: self.titleLabel)
            ScreenShield.shared.protect(view: self.subtitleLabel)
            ScreenShield.shared.protect(view: self.linesLabel)
            ScreenShield.shared.protect(view: self.actionButton ?? UIView())
            ScreenShield.shared.protect(view: self.lineView)
            ScreenShield.shared.protect(view: self.footerLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func createText() -> String {
        var text: String = ""
        
        model?.objectTwo?.description.items?.forEach {
            text.append("\n \($0)")
        }
        
        return text
    }
    
    private func setupView() {
        actionButton = UIButton(type: .system)
        actionButton?.backgroundColor = UIColor(red: 52/255, green: 120/255, blue: 246/255, alpha: 1)
        actionButton?.setTitleColor(.white, for: .normal)
        actionButton?.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        actionButton?.layer.cornerRadius = 19
        
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(linesLabel)
        addSubview(lineView)
        addSubview(actionButton ?? UIView())
        addSubview(footerLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        linesLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.3)
            make.top.equalTo(linesLabel.snp.bottom).offset(20)
        }
        
        actionButton?.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(38)
        }
        
        footerLabel.snp.makeConstraints { make in
            make.top.equalTo(actionButton!.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}
