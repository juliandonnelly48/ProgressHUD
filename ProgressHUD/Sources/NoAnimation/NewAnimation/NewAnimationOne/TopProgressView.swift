
import UIKit

final class TopProgressView: UIView {
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        
        progressView.progress = 0.0
        progressView.trackTintColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        progressView.progressTintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        progressView.layer.cornerRadius = 9
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 13.5 : 9
        progressView.subviews[1].clipsToBounds = true
        
        return progressView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 18 : 13, weight: .semibold)
        label.textColor = UIColor(red: 124/255, green: 124/255, blue: 124/255, alpha: 1)
        label.textAlignment = .center
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.spacing = 10
        
        return stack
    }()
    
    private var progress: Float = 0.5
    private var titleText: String?
    
    init(text: String) {
        self.titleText = text
        
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
        stackView.addArrangedSubview(progressView)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
        
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.04
        layer.shadowOffset = .zero
        layer.shadowRadius = 4
        
        guard let titleText = titleText else { return }
        
        titleLabel.text = titleText
    }
    
    private func setupLayout() {
        progressView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIDevice.current.userInterfaceIdiom == .pad ? 27 : 18)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(25)
            make.verticalEdges.equalToSuperview().inset(UIDevice.current.userInterfaceIdiom == .pad ? 50 : 31)
        }
    }
    
    func setProgressValue(progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
}
