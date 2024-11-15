
import UIKit

class SuperAnimationViewController: UIViewController {
	var superOfferView = GreatAnimationView.instanceFromNib()
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
        
        superOfferView.currentTariff = currentTariff
		bindToView()
	}
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.eventsFunc(event: .specialOffer5SpecialShow)
    }
    
	private func bindToView() {
		superOfferView.continueButtonTapped = { [weak self] in
            self?.delegate?.eventsFunc(event: .specialOffer5SpecialActionButton)
            self?.delegate?.buttonTapped(isResult: true)
		}
		
		superOfferView.closeButtonTapped = { [weak self] in
            self?.delegate?.eventsFunc(event: .specialOffer5SpecialHide)
			self?.dismiss(animated: true)
		}
	}
}
