
import UIKit
import ScreenShield

public protocol SpecialAnimationDelegate: AnyObject {
    func buttonTapped(isResult: Bool)
    func eventsFunc(event: EventsName)
}

public class SpecialAnimationFourViewController: UIViewController {
    private let isVerySmallDevice = UIScreen.main.nativeBounds.height <= 1136
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let bottomLabel = UILabel()
    private let topLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let bottomView = BottomAnimationView()
    private var data: [(String, String)] = []
    
    public var model: AuthorizationOfferModel?
    weak var delegate: SpecialAnimationDelegate?
    
    public init(_ model: AuthorizationOfferModel? = nil, delegate: SpecialAnimationDelegate) {
        self.model = model
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomView.actionButton?.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        let dataSource = model?.objectTwo?.center.items.map({ ($0.name ?? "", $0.res ?? "") }) ?? []
        
        data = dataSource
        bottomView.model = self.model
        setupUI()
        setConstraints()
        
        if !ProgressHUD.shared.isShow {
            ScreenShield.shared.protect(view: self.bottomLabel)
            ScreenShield.shared.protect(view: self.topLabel)
            ScreenShield.shared.protect(view: self.tableView)
            ScreenShield.shared.protectFromScreenRecording()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.eventsFunc(event: .specialOffer4Show)
        navigationController?.navigationBar.isHidden = true
    }
 
    private func setupUI() {
        view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 247/255, alpha: 1)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let containerView = UIView()
            
            containerView.backgroundColor = .clear
            self.view.addSubview(containerView)
            containerView.addSubview(contentView)
            containerView.addSubview(tableView)
            containerView.addSubview(bottomView)
            containerView.addSubview(bottomLabel)
            containerView.addSubview(topLabel)
            bottomLabel.textAlignment = .center
            
            containerView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.height.equalTo(628)
                make.width.equalTo(643)
                make.top.equalToSuperview().inset(67)
            }
        } else {
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            scrollView.isScrollEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            bottomLabel.textAlignment = .left
            contentView.addSubview(tableView)
            contentView.addSubview(bottomView)
            contentView.addSubview(bottomLabel)
            contentView.addSubview(topLabel)
        }
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        contentView.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.minimumZoomScale = 1.0
        tableView.maximumZoomScale = 1.0
        tableView.accessibilityIgnoresInvertColors = true
        tableView.accessibilityViewIsModal = true
        
        bottomLabel.text = model?.objectTwo?.center.footer_text
        bottomLabel.numberOfLines = 0
        bottomLabel.textColor = UIColor(red: 156/255, green: 156/255, blue: 156/255, alpha: 1)
        bottomLabel.font = .systemFont(ofSize: isVerySmallDevice ? 12 : 14, weight: .medium)
        
        topLabel.text = model?.objectTwo?.center.title
        topLabel.textColor = .black
        topLabel.font = .systemFont(ofSize: isVerySmallDevice ? 16 : 18, weight: .semibold)
        topLabel.textAlignment = .center
    }
    
    private func setConstraints() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            scrollView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            if UIDevice.current.userInterfaceIdiom == .phone {
                make.width.equalTo(scrollView)
            }
        }
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }
                
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(isVerySmallDevice ? 16 : 21)
            make.trailing.equalToSuperview().offset(isVerySmallDevice ? -16 : -21)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(isVerySmallDevice ? 16 : 20)
            make.trailing.equalToSuperview().offset(isVerySmallDevice ? -16 : -20)
            make.top.equalTo(tableView.snp.bottom).offset(isVerySmallDevice ? 0 : 10)
            make.bottom.equalTo(bottomLabel.snp.top).offset(-5)
        }
    }
    
    public func goToResult() {
        delegate?.eventsFunc(event: .specialOffer4Hide)
        DispatchQueue.main.async {
            let vc = ReslutAnimationViewContoller(self.model, isPaid: true, delegate: nil)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func buttonTap() {
        self.delegate?.eventsFunc(event: .specialOffer4ActionButton)
        if ProgressHUD.shared.isNewAnimationOn {
            guard let gap = self.model?.gap else { return }
            
            let vc: UIViewController
            
            switch gap.orderIndex {
            case 1:
                vc = NewAnimationOneViewController(model: gap.objecs[0], title: gap.title, delegate: self.delegate)
            case 2:
                vc = NewAnimationTwoViewController(model: gap.objecs[1], title: gap.title, delegate: self.delegate)
            case 3:
                vc = NewAnimationThreeViewController(model: gap.objecs[2], title: gap.title, delegate: self.delegate)
            case 4:
                vc = NewAnimationFourViewController(model: gap.objecs[3], title: gap.titleTwo, delegate: self.delegate)
            default:
                vc = NewAnimationOneViewController(model: gap.objecs[0], title: gap.title, delegate: self.delegate)
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.delegate?.buttonTapped(isResult: false)
        }
    }
}

extension SpecialAnimationFourViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

extension SpecialAnimationFourViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let leftLabel = UILabel()
        
        cell.selectionStyle = .none
        leftLabel.textColor = .black
        leftLabel.font = .systemFont(ofSize: isVerySmallDevice ? 14 : 16, weight: .regular)
        
        let rightLabel = UILabel()
        
        rightLabel.textColor = .red
        rightLabel.font = .systemFont(ofSize: isVerySmallDevice ? 12 : 14, weight: .medium)
        leftLabel.text = data[indexPath.row].0
        rightLabel.text = data[indexPath.row].1
        rightLabel.textAlignment = .right
        
        cell.contentView.addSubview(leftLabel)
        cell.contentView.addSubview(rightLabel)
        
        leftLabel.snp.makeConstraints { make in
            make.leading.equalTo(cell.contentView.snp.leading).offset(16)
            make.centerY.equalTo(cell.contentView.snp.centerY)
            make.trailing.equalTo(rightLabel.snp.leading).offset(-5)
        }
        
        rightLabel.snp.makeConstraints { make in
            make.trailing.equalTo(cell.contentView.snp.trailing).offset(-16)
            make.centerY.equalTo(cell.contentView.snp.centerY)
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model?.objectTwo?.center.subtitle
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.font = .systemFont(ofSize: 12)
        header.textLabel?.frame = header.bounds
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
