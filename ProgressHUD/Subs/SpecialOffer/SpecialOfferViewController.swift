

import UIKit
import ProgressHUD
import ScreenShield
import Firebase
import FirebaseAnalytics

class SpecialOfferViewController: UIViewController {
    private lazy var offerView:SpecialOfferView = {
        SpecialOfferView.instanceFromNib()
    }()
    
    var dismissed: (() -> ())?
    private let networkManager = NetworkManager()

    init(_ model: DataOfferObject? = nil){
        super.init(nibName: nil, bundle: nil)
        self.offerView.model = model
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = offerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScreenShield.shared.protect(view: self.view)
        ScreenShield.shared.protectFromScreenRecording()
        
        bindToView()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        offerView.timer?.invalidate()
    }
    
    private func bindToView() {
        offerView.continueButtonTapped = { [weak self] in
            guard let selectedTariff = Storage.allTariffs?.first else { return }
            
            self?.purchase(tarif: selectedTariff)
        }
        
        offerView.closeButtonTapped = { [weak self] in
            guard let self else { return }
            
            self.dismiss(animated: true)
        }
        
        offerView.restoreButtonTapped = { [weak self] in
            self?.restoreAction()
        }
        
        guard let price = Storage.allTariffs?.first.map({$0.localizedPrice ?? "$\($0.price)"}) else { return }
        offerView.priceLabel.text =  "\(price) per year. Cancel anytime"
    }
    
    private func purchase(tarif: TariffObject) {
        showProgressAction()
        
        networkManager.buyTarif(tarif: tarif) { [weak self] purchasedTarif, success, _ in
            DispatchQueue.main.async {
                self?.offerView.buyButton.isEnabled = true
            }
            
            if success {
                self?.showSuccessAction()
                Storage.saveCurrentTarif(purchasedTarif)
                
                DispatchQueue.main.async {
                    let vc = ReslutViewContoller(self?.offerView.model)
                    let nc = UINavigationController(rootViewController: vc)
                    
                    nc.modalPresentationStyle = .fullScreen
                    
                    self?.present(nc, animated: true)
                }
            } else {                
                DispatchQueue.main.async {
                    self?.showFailureAction()
                }
            }
        }
    }
    
    func restoreAction() {
        showProgressAction()
        
        NetworkManager().restore { [weak self] tarif, error in
            if let tarif = tarif {
                DispatchQueue.main.async {
                    self?.showSuccessAction()
                    
                    Storage.saveCurrentTarif(tarif)
                    
                    DispatchQueue.main.async {
                        self?.dismiss(animated: true)
                    }
                }
            } else {
                self?.showFailureAction()
            }
        }
    }
    
    private func showProgressAction() {
        ProgressHUD.animate(interaction: false)
    }
    
    private func showSuccessAction() {
        ProgressHUD.success(interaction: false)
    }
    
    private func showFailureAction() {
        ProgressHUD.failed(interaction: false)
    }
}
