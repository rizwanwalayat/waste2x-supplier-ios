//
//  BaseViewController.swift
//  haid3r
//
//  Created by HaiD3R AwaN on 20/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit
import SDWebImage
import PDFKit

class BaseViewController: UIViewController {

    var tabbarViewHeight : CGFloat = 0.0
    var userData : RegistrationResult?
    let refreshControl = UIRefreshControl()
    let pdfView = PDFView()

    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData = DataManager.shared.getUser()?.result
        tabbarViewHeight = (UIScreen.main.bounds.height * 0.0926339)+10
        print("Bottom Const : \(tabbarViewHeight)\nscreen height : \(UIScreen.main.bounds.height)")
        

        
        
    }
    

    /**************************************************/
    
    @objc func imageSelectedFromGalleryOrCamera(selectedImage:UIImage){
        
    }
    
    func setImage(imageView:UIImageView,url:URL,placeHolder : String = "dummy")  {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_imageIndicator?.startAnimatingIndicator()
        imageView.sd_setImage(with: url) { (img, err, cahce, URI) in
            imageView.sd_imageIndicator?.stopAnimatingIndicator()
            if err == nil{
                imageView.image = img
            }else{
                imageView.image = UIImage(named: placeHolder)
            }
        }
    }
    
    func showImagePreview(fileString: String){
        let vcImageShow = FullScreenImageViewController(nibName: "FullScreenImageViewController", bundle: nil)
        vcImageShow.displayImageString = fileString
        self.present(vcImageShow, animated: true, completion: nil)
    }
    
    func pdfPreview(urlString:String){
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        let button = UIButton(frame: CGRect(x: view.frame.width - 75 - 20, y: 20, width: 75, height: 35))
        button.setTitle("Close", for: .normal)
        button.setTitleColor(UIColor.primary, for: .normal)
        button.backgroundColor = UIColor.highlight
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(closePdfPreview), for: .touchUpInside)
        pdfView.addSubview(button)
        view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        guard let pdfUrl = URL(string: urlString) else { return }
        if let document = PDFDocument(url: pdfUrl) {
            pdfView.document = document
        }
    }
    
    @objc func closePdfPreview(){
        pdfView.removeFromSuperview()
        
    }
    
    func showToast(message : String) {

       
        let toastLabel = UILabel(frame: CGRect(x: 0 , y:ScreenSize.SCREEN_HEIGHT/2, width: ScreenSize.SCREEN_WIDTH, height: 40))
        toastLabel.backgroundColor = UIColor.appColor
        toastLabel.textColor = UIColor.white
        var font = UIFont()
        if let tempFont = UIFont(name: "Poppins-Regular", size: 13)
        {
            font = tempFont
        }
        else
        {
            font = UIFont.systemFont(ofSize: 13)
        }
        
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines  =  2
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    func setAttributedTextInLable(boldString:String,emailAddress :String) -> NSMutableAttributedString
    {
        let boldfont       = UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        let activityAttribute   = [ NSAttributedString.Key.font: boldfont, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "ffffff")]
        let nameAttrString      = NSMutableAttributedString(string: boldString, attributes: activityAttribute)
        
        let emailFont            = UIFont(name: "Poppins", size: 18) ?? UIFont.systemFont(ofSize: 18)
        let nameAttribute       = [ NSAttributedString.Key.font: emailFont, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "ffffff")]
        let activityAttrString  = NSAttributedString(string: emailAddress, attributes: nameAttribute)
        
        nameAttrString.append(activityAttrString)
        
        return nameAttrString
    }
    func setAttributedTextInLable(text1:String,text2 :String,size:Int) -> NSMutableAttributedString
    {
        let firstTitle       = UIFont(name: "Poppins", size: CGFloat(size)) ?? UIFont.systemFont(ofSize: 14)
        let activityAttribute   = [ NSAttributedString.Key.font: firstTitle, NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.31, green: 0.31, blue: 0.31, alpha: 0.9)]
        let nameAttrString      = NSMutableAttributedString(string: text1, attributes: activityAttribute)
        
        let secondTitle            = UIFont(name: "Poppins-Bold", size: CGFloat(size)) ?? UIFont.systemFont(ofSize: 14)
        let nameAttribute       = [ NSAttributedString.Key.font: secondTitle, NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.31, green: 0.31, blue: 0.31, alpha: 1.0)]
        let activityAttrString  = NSAttributedString(string: text2, attributes: nameAttribute)
        
        nameAttrString.append(activityAttrString)
        return nameAttrString
    }
    
    func downloadImageFromServer(_ urlStr : String, _ completionHandler : @escaping(_ image : UIImage?, _ error: Error?, _ status: Bool?) -> Void)
    {
        guard let imageUrl = URL(string: urlStr) else { print("URL not created for imagesURL String"); return }
        
        SDWebImageManager.shared.loadImage(with: imageUrl, options: .avoidAutoSetImage, progress: nil) { image, data, error, type, success, url in
            
            completionHandler(image, error, success)
        }
    }
}
