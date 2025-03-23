import ProgressHUD

final class LoaderUtil {
    public static func show() {
        ProgressHUD.show("\(Localization.loading)...", interaction: false)
    }
    
    public static func hide() {
        ProgressHUD.dismiss()
    }
}
