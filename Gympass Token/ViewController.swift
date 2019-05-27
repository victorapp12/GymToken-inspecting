//
//  ViewController.swift
//  Gympass Token
//
//  Created by Victor Palhares on 26/05/2019.
//  Copyright © 2019 Victor Palhares. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet weak var getTokenButton: UIButton!
    @IBOutlet weak var tokenLabel: UILabel!
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        setupHomePage()
    }

    func setupHomePage() {
        let url = URL(string: GymPassURL.home.name())!
        let request = URLRequest(url: url)
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
        webView.load(request)
        view.addSubview(webView)
    }
    
    @IBAction func getToken(_ sender: Any) {
        let url = URL(string: GymPassURL.dailyToken.name())!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func getDailyTokenHTML() {
        webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: { (innerHTML, error) in
            do {
                let dailyTokenResponse = try DailyTokenResponse(innerHTML)
                self.tokenLabel.text = dailyTokenResponse.token
            } catch {}
        })
    }
    
    @IBAction func shareToken(_ sender: Any) {
        if let text = self.tokenLabel.text {
            let textToShare: [Any] = [text]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let webViewURL = webView.url?.absoluteString {
            switch(webViewURL) {
            case GymPassURL.dailyToken.name():
                self.getDailyTokenHTML()
            case GymPassURL.home.name():
                break
            case GymPassURL.login.name():
                break
            default: break
            }
        }
    }
}

enum GymPassURL {
    case home
    case login
    case dailyToken
    
    func name() -> String {
        switch self {
        case .home:
            return "https://www.gympass.com/"
        case .login:
            return "https://www.gympass.com/"
        case .dailyToken:
            return "https://www.gympass.com/end-user/br/daily-token"
        }
    }
}
