import UIKit

protocol AskStockCodeProtocol {
    func ask(presentingViewController: UIViewController, onStockCode:@escaping (String) -> ())
}

final class AskStockCodeService: AskStockCodeProtocol {
    
    func ask(presentingViewController: UIViewController, onStockCode:@escaping (String) -> ()){
        let alertController = UIAlertController(title: "주식", message: "종목 코드를 입력하세요", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "종목코드"
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let stockCode = alertController.textFields?[0].text, !stockCode.isEmpty else { return }
            alertController.dismiss(animated: true, completion: nil)
            onStockCode(stockCode)
        }))
        presentingViewController.present(alertController, animated: true, completion: nil)
    }
    
}
