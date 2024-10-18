

import UIKit

class DotTableViewCell: UITableViewCell {
    var t: Timer?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        let view = UIView(frame: CGRect(x: 40, y: 30, width: 15, height: 4))
        
        view.backgroundColor = .gray
        view.layer.cornerRadius = 2
        
        addSubview(view)
        
        t = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            UIView.animate(withDuration: 0.3, delay: 0) {
                view.alpha = 0
            }
            
            UIView.animate(withDuration: 0.3, delay: 0.3) {
                view.alpha = 1
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        t?.invalidate()
    }
}
