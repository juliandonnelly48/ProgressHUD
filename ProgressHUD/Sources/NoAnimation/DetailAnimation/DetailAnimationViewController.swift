

import UIKit
import ScreenShield

class DetailAnimationViewController: UIViewController {
    private let detailInformView = DetailAnimationView.instanceFromNib()
    private let model: DataOfferObjectLib?
//    private let networkManager = NetworkManager()

    weak var delegate: SpecialAnimationDelegate?
    
    init(_ model: DataOfferObjectLib? = nil, delegate: SpecialAnimationDelegate) {
        self.model = model
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
        
        detailInformView.setup(with: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailInformView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        detailInformView.continueButtonTapped = { [weak self] in
//            guard let selectedTariff = Storage.allTariffs?.first else { return }
//            
//            self?.purchase(tarif: selectedTariff)
            self?.delegate?.buttonTapped()
        }
        
        ScreenShield.shared.protectFromScreenRecording()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        detailInformView.showAlertAndPush()
    }
    
//    private func purchase(tarif: TariffObject) {
//        showProgressAction()
//        
//        networkManager.buyTarif(tarif: tarif) { [weak self] purchasedTarif, success, _ in
//            DispatchQueue.main.async {
//                self?.detailInformView.alertButton.isEnabled = true
//            }
//            
//            if success {
//                self?.showSuccessAction()
//                Storage.saveCurrentTarif(purchasedTarif)
//                
//                DispatchQueue.main.async {
//                    let vc = ReslutAnimationViewContoller(self?.model)
//                    
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self?.showFailureAction()
//                }
//            }
//        }
//    }
    
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
