
import UIKit

struct HelpLongBox {
    static let screenSE1 = UIScreen.main.nativeBounds.height <= 1333
    static let screenSE3 = UIScreen.main.nativeBounds.height <= 1334
}

final class LongBoxView: UIView {
    private let icon: UIImageView = {
        let icon = UIImageView()
        
        icon.contentMode = .scaleToFill
        
        return icon
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 18 : (HelpLongBox.screenSE3 ? (HelpLongBox.screenSE1 ? 12 : 14) : 15), weight: .medium)
        label.textColor = UIColor(red: 124/255, green: 124/255, blue: 124/255, alpha: 1)
        label.textAlignment = .left
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 18 : (HelpLongBox.screenSE3 ? (HelpLongBox.screenSE1 ? 11 : 12) : 14), weight: .medium)
        label.textColor = UIColor(red: 124/255, green: 124/255, blue: 124/255, alpha: 1)
        label.textAlignment = .left
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.spacing = 10
        
        return stack
    }()
    
    private var progress: Float = 0.5
    private var titleText: String = ""
    private var subtitleText: String!
    private var addText: String = ""
    private var addRes: String = ""
    private var iconName: String!
    private let defaultGray = UIColor.init(red: 124/255, green: 124/255, blue: 124/255, alpha: 1)
    private let defaultRedColor = UIColor(red: 255/255, green: 57/255, blue: 39/255, alpha: 1)
    
    init(titleText: String, subtitleText: String, addText: String, addRes: String, iconName: String) {
        self.titleText = titleText
        self.subtitleText = subtitleText
        self.iconName = iconName
        self.addText = addText
        self.addRes = addRes
        
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        addSubview(stackView)
        addSubview(icon)
        
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.04
        layer.shadowOffset = .zero
        layer.shadowRadius = 4
                
        let fullText = "[\(titleText)] \(addText)"
        let attributedString = NSMutableAttributedString(string: fullText)
        let timeRange = NSRange(location: 0, length: "[\(titleText)]".count)
        
        attributedString.addAttribute(.foregroundColor, value: defaultGray, range: timeRange)
        let messageRange = NSRange(location: timeRange.length + 1, length: addText.count)
        let messageColor: UIColor = .black
        
        attributedString.addAttribute(.foregroundColor, value: messageColor, range: messageRange)
        titleLabel.attributedText = attributedString
        
        subtitleLabel.text = subtitleText
        guard let mainIcon = URL(string: iconName) else { return }
        
        icon.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
    }
    
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(UIDevice.current.userInterfaceIdiom == .pad ? 60 : 38)
            make.verticalEdges.equalToSuperview().inset(UIDevice.current.userInterfaceIdiom == .pad ? 22 : 10)
        }
        
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIDevice.current.userInterfaceIdiom == .pad ? 23 : 13)
            make.size.equalTo(UIDevice.current.userInterfaceIdiom == .pad ? 30 : 20)
            make.trailing.equalTo(stackView.snp.leading).offset(UIDevice.current.userInterfaceIdiom == .pad ? -11 : -7)
        }
    }
    
    func finishConfig(num: Int) {
        addRes = addRes.replacingOccurrences(of: "%", with: "\(num) ")
        subtitleLabel.text = addRes
        subtitleLabel.textColor = defaultRedColor
    }
}
