
import UIKit

class SuperOfferViewController: UIViewController {
	var superOfferView = SuperOfferView.instanceFromNib()
	
//	private let networkManager = NetworkManager()
	
    let currentTariff: String?

    weak var delegate: SpecialAnimationDelegate?
    
    init(price: String?, delegate: SpecialAnimationDelegate) {
		self.currentTariff = price
        self.delegate = delegate
        
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = superOfferView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        superOfferView.currentTariff = currentTariff /*Storage.allTariffs?.first(where: { $0.isTrial == true })*/
		bindToView()
	}
	
	private func bindToView() {
		superOfferView.continueButtonTapped = { [weak self] in
//            guard let selectedTariff = Storage.allTariffs?.first(where: { $0.isTrial == true }) else { return }
			
            self?.delegate?.buttonTapped()
//			self?.purchase(tarif: selectedTariff)
		}
		
		superOfferView.closeButtonTapped = { [weak self] in
			self?.dismiss(animated: true)
		}
	}
	
//    private func purchase(tarif: TariffObject) {
//		showProgressAction()
//		
//		networkManager.buyTarif(tarif: tarif) { [weak self] purchasedTarif, success, _ in
//			DispatchQueue.main.async {
//				self?.superOfferView.buyButton.isEnabled = true
//			}
//			
//			if success {
//				self?.showSuccessAction()
//				
//                Storage.saveCurrentTarif(purchasedTarif)
//				
//				DispatchQueue.main.async {
//					self?.dismiss(animated: true)
//				}
//			} else {
//				DispatchQueue.main.async {
//					self?.showFailureAction()
//				}
//			}
//		}
//	}
//	
//	private func showProgressAction() {
//		ProgressHUD.animate(interaction: false)
//	}
//	
//	private func showSuccessAction() {
//		ProgressHUD.success(interaction: false)
//	}
//	
//	private func showFailureAction() {
//		ProgressHUD.failed(interaction: false)
//	}
}
