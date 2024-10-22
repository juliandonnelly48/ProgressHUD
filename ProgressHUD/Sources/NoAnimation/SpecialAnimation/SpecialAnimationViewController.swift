

import UIKit
import ScreenShield

public class SpecialAnimationViewController: UIViewController {
    private lazy var offerView: SpecialAnimationView = {
        SpecialAnimationView.instanceFromNib()
    }()
    
    private let price: String
    var dismissed: (() -> ())?
//    private let networkManager = NetworkManager()

    weak var delegate: SpecialAnimationDelegate?
    
    public init(_ model: DataOfferObject? = nil, price: String ,delegate: SpecialAnimationDelegate) {
        self.delegate = delegate
        self.price = price
        
        super.init(nibName: nil, bundle: nil)
        
        self.offerView.model = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = offerView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        ScreenShield.shared.protect(view: self.view)
        ScreenShield.shared.protectFromScreenRecording()
        
        bindToView()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        offerView.timer?.invalidate()
    }
    
    private func bindToView() {
        offerView.continueButtonTapped = { [weak self] in
//            guard let selectedTariff = Storage.allTariffs?.first else { return }
            
//            self?.purchase(tarif: selectedTariff)
            self?.delegate?.buttonTapped()
        }
        
        offerView.closeButtonTapped = { [weak self] in
            guard let self else { return }
            
            self.dismiss(animated: true)
        }
        
//        guard let price = Storage.allTariffs?.first.map({$0.localizedPrice ?? "$\($0.price)"}) else { return }
        offerView.priceLabel.text =  "\(price) per year. Cancel anytime"
    }
    
//    private func purchase(tarif: TariffObject) {
//        showProgressAction()
//        
//        networkManager.buyTarif(tarif: tarif) { [weak self] purchasedTarif, success, _ in
//            DispatchQueue.main.async {
//                self?.offerView.buyButton.isEnabled = true
//            }
//            
//            if success {
//                self?.showSuccessAction()
//                Storage.saveCurrentTarif(purchasedTarif)
//                
//                DispatchQueue.main.async {
//                    let vc = ReslutAnimationViewContoller(self?.offerView.model)
//                    let nc = UINavigationController(rootViewController: vc)
//                    
//                    nc.modalPresentationStyle = .fullScreen
//                    
//                    self?.present(nc, animated: true)
//                }
//            } else {                
//                DispatchQueue.main.async {
//                    self?.showFailureAction()
//                }
//            }
//        }
//    }
    
//    private func showProgressAction() {
//        ProgressHUD.animate(interaction: false)
//    }
//    
//    private func showSuccessAction() {
//        ProgressHUD.success(interaction: false)
//    }
//    
//    private func showFailureAction() {
//        ProgressHUD.failed(interaction: false)
//    }
}
