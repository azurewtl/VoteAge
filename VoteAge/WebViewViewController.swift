//
//  WebViewViewController.swift
//  VoteAge
//
//  Created by caiyang on 15/1/23.
//  Copyright (c) 2015年 azure. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController, UIWebViewDelegate{

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var webView: UIWebView!
    var webStr = NSString()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = NSURL(string: webStr)
        webView.delegate = self
        if url == nil {
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
            webView.hidden = true
        }else {
        var request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        }
        // Do any additional setup after loading the view.
    }
    func webViewDidStartLoad(webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        webView.hidden = true
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
