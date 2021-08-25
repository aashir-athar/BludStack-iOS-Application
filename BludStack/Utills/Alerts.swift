

import Foundation
import UIKit

class Alerts {
    
    static func showAlert(on controller: UIViewController?, title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        controller?.present(alert, animated: true)
    }

    
    static func showAlertWith(on vc: UIViewController?, with title:String, message: String?, onSuccess closure: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .`default`, handler: { _ in
            closure()
        }))
        vc?.present(alert, animated: true)
    }
}
