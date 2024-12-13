
import UIKit
import SnapKit

final class NewAnimationFourViewController: UIViewController {
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
    
    private var alert: CustomAlertViewFour!
    private var model: Objec!
    private var myCount = 20
    private var titleText = ""
    private var timer: Timer?
    private var progress: Float = 0.0
    private var labelCount = 0
    private let redColor = UIColor(red: 255/255, green: 57/255, blue: 39/255, alpha: 1)
    private let defaultColor = UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1)
    private let defaultGray = UIColor.init(red: 124/255, green: 124/255, blue: 124/255, alpha: 1)

    private var isAnimating = false
    
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
        alert = CustomAlertViewFour(iconName: model.messIcon,
                                 titleLabelText: model.messTlt,
                                 descriptionFirstLabelText: model.messTltCmpl ?? "",
                                 descriptionLowLabelText: model.messSbtlt,
                                 goButtonText: model.messBtn, strArray: model.messTltRed ?? [""])
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

        scrollView.backgroundColor = .clear
        scrollView.layer.cornerRadius = 20
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
        }

        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
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
        guard !isAnimating else { return }
        
        if progress < 1.0 {
            isAnimating = true
            
            progress += 1.0 / Float(myCount)
            progressView.setProgressValue(progress: progress)

            let niceAddText = makeNiceStr(str: model.strigsSubtlt ?? "", num: labelCount + 1)
            let boxView = LongBoxView(titleText: model.strigs[labelCount].name,
                                      subtitleText: niceAddText,
                                      addText: model.strigsTlt ?? "",
                                      addRes: model.strigsRes ?? "",
                                      iconName: model.strigs[labelCount].icn ?? "")

            boxView.alpha = 0.0
            labelCount += 1
            stackView.insertArrangedSubview(boxView, at: 0)

            UIView.animate(withDuration: 0.3, animations: {
                boxView.alpha = 1.0
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    UIView.animate(withDuration: 0.3, animations: {
                        let num = Int.random(in: 1...3)
                        boxView.finishConfig(num: num)
                    }) { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.isAnimating = false
                        }
                    }
                }
            }
            
            scrollView.layoutIfNeeded()
        } else {
            timer?.invalidate()
            showCustomAlert()
        }
    }
    
    private func makeNiceStr(str: String, num: Int) -> String {
        guard !str.isEmpty else {
            return ""
        }
        
        let modifiedString = String(num) + str.dropFirst()
        
        return modifiedString
    }

    private func showCustomAlert() {
        UIView.animate(withDuration: 0.2) {
            self.dimmView.alpha = 1
            self.alert.alpha = 1
        }
    }
}
