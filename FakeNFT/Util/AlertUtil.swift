import UIKit

final class AlertUtil {
    public static func show(error message: String, in viewController: UIViewController) {
        let alert = UIAlertController(
            title: Localization.errorTitle,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
