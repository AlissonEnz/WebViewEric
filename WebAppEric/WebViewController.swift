//
//  WebViewController.swift
//  
//
//  Created by Alisson Enz Rossi on 3/11/17.
//
//

import UIKit
import WebKit
import SVProgressHUD
import LNRSimpleNotifications

class WebViewController: UIViewController {
    
    
    //MARK:- Constants
    
    
    //fileprivate let kWEBPAGESTRING = "https://www.studtime.com/app/index.php"
    fileprivate let kWEBPAGESTRING = "https://google.com"
    
    
    //MARK:- Variables
    
    
    fileprivate var notificationManager:LNRNotificationManager!
    fileprivate var firstLoad = true
    fileprivate var webView:WKWebView!
    
    
    //IBOutlets
    
    
    @IBOutlet weak var viewToAddWebView: UIView!
    
    
    //MARK:- ViewController Lifecicle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create WebView
        let configuration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.viewToAddWebView.addSubview(webView)
        [self.webView.topAnchor.constraint(equalTo: self.viewToAddWebView.topAnchor),
         self.webView.bottomAnchor.constraint(equalTo: self.viewToAddWebView.bottomAnchor),
         self.webView.leftAnchor.constraint(equalTo: self.viewToAddWebView.leftAnchor),
         self.webView.rightAnchor.constraint(equalTo: self.viewToAddWebView.rightAnchor)].forEach  { $0.isActive = true }

        //Cofigure Alert
        self.notificationManager = LNRNotificationManager()
        self.notificationManager.notificationsPosition = LNRNotificationPosition.top
        self.notificationManager.notificationsBackgroundColor = .red
        self.notificationManager.notificationsTitleTextColor = .white
        self.notificationManager.notificationsBodyTextColor = .white
        self.notificationManager.notificationsSeperatorColor = .clear
        
        // Set delegate and alpha
        self.webView.navigationDelegate = self
        self.webView.alpha = 0
        
        //Set backgound color
        self.view.backgroundColor = UIColor(red: 0.06, green: 0.06, blue: 0.06, alpha: 1)
        
        // Create page request
        if let pageURL = URL(string: self.kWEBPAGESTRING) {
            let pageRequest = URLRequest(url: pageURL)
            self.webView.load(pageRequest)
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


extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        SVProgressHUD.dismiss()
        
        if error._code == NSURLErrorNotConnectedToInternet || error._code == NSURLErrorNetworkConnectionLost {
            self.showErrorMessage(title: "Error", message: error.localizedDescription)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
        SVProgressHUD.dismiss()
        
        if error._code == NSURLErrorNotConnectedToInternet || error._code == NSURLErrorNetworkConnectionLost {
            self.showErrorMessage(title: "Error", message: error.localizedDescription)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        
        if self.firstLoad {
            self.firstLoad = false
            
            //Animate WebView
            UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseInOut, animations: {
                self.webView.alpha = 1
            }, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
}
