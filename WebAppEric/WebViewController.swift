//
//  WebViewController.swift
//  
//
//  Created by Alisson Enz Rossi on 3/11/17.
//
//

import UIKit
import SVProgressHUD
import LNRSimpleNotifications

class WebViewController: UIViewController {
    
    
    //MARK:- Constants
    
    
//    let kWEBPAGESTRING = "http://PLACE_YOUR_URL_HERE"
    let kWEBPAGESTRING = "http://google.com"

    
    //MARK:- Variables
    
    
    var notificationManager:LNRNotificationManager!
    var firstLoad = true
    
    
    //MARK:- IBOutlets
    
    
    @IBOutlet weak var webView: UIWebView!
    
    
    //MARK:- ViewController Lifecicle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Cofigure Alert
        self.notificationManager = LNRNotificationManager()
        self.notificationManager.notificationsPosition = LNRNotificationPosition.top
        self.notificationManager.notificationsBackgroundColor = .red
        self.notificationManager.notificationsTitleTextColor = .white
        self.notificationManager.notificationsBodyTextColor = .white
        self.notificationManager.notificationsSeperatorColor = .clear
        
        // Set delegate and alpha
        self.webView.delegate = self
        self.webView.scrollView.delegate = self
        self.webView.alpha = 0
        
        //Set backgound color
        self.view.backgroundColor = UIColor(red: 0.06, green: 0.06, blue: 0.06, alpha: 1)
        
        // Create page request
        if let pageURL = URL(string: self.kWEBPAGESTRING) {
            let pageRequest = URLRequest(url: pageURL)
            self.webView.loadRequest(pageRequest)
        } else {
            self.showErrorMessage(title: "Error", message: "This url could not be created.")
        }
    }
    
    
    //MARK:- Custom Functions
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showErrorMessage(title:String, message:String) {
        LNRNotificationManager().showNotification(notification: LNRNotification(title: title, body: "\(message)\nTap to reload.", duration: LNRNotificationDuration.endless.rawValue, onTap: { () in
            self.webView.reload()
        }, onTimeout: nil))
    }
}


//MARK:- UIWebViewDelegate


extension WebViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        if webView.isLoading {
            SVProgressHUD.show()
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
        
        if self.firstLoad {
            self.firstLoad = false
            
            //Animate WebView
            UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseInOut, animations: {
                self.webView.alpha = 1
            }, completion: nil)
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error)
        SVProgressHUD.dismiss()
        
        if error._code == NSURLErrorNotConnectedToInternet || error._code == NSURLErrorNetworkConnectionLost {
            self.showErrorMessage(title: "Error", message: error.localizedDescription)
        }
    }
}


//MARK:- UIScrollViewDelegate


extension WebViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.contentOffset.y < -40 {
            self.webView.reload()
        }
    }
}
