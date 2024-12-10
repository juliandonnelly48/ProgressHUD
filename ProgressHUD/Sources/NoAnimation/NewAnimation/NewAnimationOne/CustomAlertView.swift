
import UIKit

final class CustomAlertView: UIView {
    private let icon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let descriptionFirstLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let descriptionSecondLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 110/255, green: 112/255, blue: 101/255, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let descriptionBackView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .black.withAlphaComponent(0.06)
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    private let descriptionLowLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.36)
        
        return view
    }()
    
    private lazy var goButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.addTarget(self, action: #selector(goButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    private var iconName = ""
    private var titleLabelText = ""
    private var descriptionFirstLabelText = ""
    private var descriptionSecondLabelText = ""
    private var descriptionLowLabelText = ""
    private var goButtonText = ""
    
    var goButtonCompletion: (() -> ())?
    
    init(iconName: String, titleLabelText: String, descriptionFirstLabelText: String, descriptionSecondLabelText: String, descriptionLowLabelText: String, goButtonText: String) {
        self.iconName = iconName
        self.titleLabelText = titleLabelText
        self.descriptionFirstLabelText = descriptionFirstLabelText
        self.descriptionSecondLabelText = descriptionSecondLabelText
        self.descriptionLowLabelText = descriptionLowLabelText
        self.goButtonText = goButtonText
        
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }

    private func setupUI() {
        backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        layer.cornerRadius = 14

        addSubview(icon)
        addSubview(titleLabel)
        addSubview(descriptionBackView)
        addSubview(descriptionFirstLabel)
        addSubview(descriptionSecondLabel)
        addSubview(descriptionLowLabel)
        addSubview(lineView)
        addSubview(goButton)
        
        guard let mainIcon = URL(string: iconName) else { return }
        
        icon.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        titleLabel.text = titleLabelText
        descriptionFirstLabel.text = descriptionFirstLabelText
        descriptionSecondLabel.text = descriptionSecondLabelText
        descriptionLowLabel.text = descriptionLowLabelText
        goButton.setTitle(goButtonText, for: .normal)

        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        descriptionFirstLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        descriptionSecondLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(descriptionFirstLabel.snp.bottom).offset(3)
        }
        
        descriptionBackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(descriptionFirstLabel.snp.top).offset(-5)
            make.bottom.equalTo(descriptionSecondLabel.snp.bottom).offset(5)
        }
        
        descriptionLowLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(descriptionSecondLabel.snp.bottom).offset(20)
        }
        
        lineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(descriptionLowLabel.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        goButton.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(44)
        }
    }

    @objc private func goButtonAction() {
        goButtonCompletion?()
    }
}
