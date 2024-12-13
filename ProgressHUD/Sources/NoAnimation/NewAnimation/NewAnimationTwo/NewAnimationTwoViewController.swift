
import UIKit
import SnapKit

final class NewAnimationTwoViewController: UIViewController {
    private var progressView: TopProgressView!
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let dimmView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .black.withAlphaComponent(0.4)
        
        return view
    }()
    
    private var alert: CustomAlertViewTwo!
    private var model: Objec!
    private var myCount = 20
    private var titleText = ""
    private var timer: Timer?
    private var progress: Float = 0.0
    private var labelCount = 0
    private var localCounter = 0
    private var globalCounter = 0
    private let redColor = UIColor(red: 255/255, green: 57/255, blue: 39/255, alpha: 1)
    private let defaultColor = UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1)
    private let defaultGray = UIColor.init(red: 124/255, green: 124/255, blue: 124/255, alpha: 1)

    weak var delegate: SpecialAnimationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        startProgress()
        alert.goButtonCompletion = { [weak self] in
            self?.delegate?.buttonTapped(isResult: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    init(model: Objec, title: String, delegate: SpecialAnimationDelegate?) {
        self.model = model
        self.titleText = title
        self.myCount = model.strigs.count
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        progressView = TopProgressView(text: model.prgrsTitle)
        alert = CustomAlertViewTwo(iconName: model.messIcon,
                                 titleLabelText: model.messTlt,
                                 subtitleLabelText: "\(model.messTltPrc ?? "")\n\(model.messTltCmpl ?? "")",
                                 descriptionFirstLabelText: model.subMessTlt ?? "",
                                 descriptionSecondLabelText: "\(model.subMessTxtOne ?? "")\n\(model.subMessTxtTwo ?? "")\n\(model.subMessTxtThree ?? "")",
                                 descriptionLowLabelText: model.messSbtlt,
                                 goButtonText: model.messBtn)

        titleLabel.text = titleText
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(UIDevice.current.userInterfaceIdiom == .pad ? 80 : 25)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(32)
        }

        scrollView.backgroundColor = .white
        scrollView.layer.cornerRadius = 20
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.horizontalEdges.equalToSuperview().inset(32)
        }

        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
            make.width.equalTo(scrollView.snp.width).offset(-30)
        }
        
        view.addSubview(dimmView)
        view.addSubview(alert)
        
        dimmView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alert.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(UIDevice.current.userInterfaceIdiom == .pad ? 0.39 : 0.8)
        }
        
        dimmView.alpha = 0
        alert.alpha = 0
    }

    private func startProgress() {
        let randomInterval = Double.random(in: 0.4...1.3)
        
        timer = Timer.scheduledTimer(withTimeInterval: randomInterval, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            self.updateProgress()
            self.startProgress()
        }
    }
    
    private func updateProgress() {
        if progress < 1.0, globalCounter < 3 {
            progress += 1.0 / Float(myCount)
            progressView.setProgressValue(progress: progress)
            
            let label = UILabel()
            label.numberOfLines = 0
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let timeString = formatter.string(from: Date())
            let fullText = "[\(timeString)] \(model.strigs[labelCount].name)"
            let attributedString = NSMutableAttributedString(string: fullText)
            let timeRange = NSRange(location: 0, length: "[\(timeString)]".count)
            attributedString.addAttribute(.foregroundColor, value: defaultGray, range: timeRange)
            let messageRange = NSRange(location: timeRange.length + 1, length: model.strigs[labelCount].name.count)
            let messageColor: UIColor = model.strigs[labelCount].color?.contains("red") == true ? redColor : defaultColor
            attributedString.addAttribute(.foregroundColor, value: messageColor, range: messageRange)
            label.attributedText = attributedString
            label.font = .systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 18 : 15, weight: .medium)
            label.alpha = 0.0
            labelCount += 1
            
            stackView.addArrangedSubview(label)

            UIView.animate(withDuration: 0.3) {
                label.alpha = 1.0
            }

            scrollView.layoutIfNeeded()
            let contentHeight = scrollView.contentSize.height
            let visibleHeight = scrollView.bounds.height
            if contentHeight > visibleHeight {
                let offsetY = contentHeight - visibleHeight
                scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
            }
            
            localCounter += model.strigs[labelCount].color?.contains("red") == true ? 1 : 0
            
            if localCounter < 3 {
                self.globalCounter = localCounter
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.globalCounter = self.localCounter
                }
            }
        } else {
            timer?.invalidate()
            showCustomAlert()
        }
    }

    private func showCustomAlert() {
        UIView.animate(withDuration: 0.2) {
            self.dimmView.alpha = 1
            self.alert.alpha = 1
        }
    }
}
