import SVProgressHUD

protocol ProgressHudProtocol{
    func show()
    func dismiss()
}

final class ProgressHudService : ProgressHudProtocol {
    func show() {
        SVProgressHUD.show()
    }
    
    func dismiss() {
        SVProgressHUD.dismiss()
    }
}
