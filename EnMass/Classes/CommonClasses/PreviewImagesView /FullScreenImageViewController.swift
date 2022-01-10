//
//  FullScreenImageViewController.swift
//  ActiiTalk
//
//  Created by Adeel on 14/09/2020.
//  Copyright © 2020 Whizpool. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit



class FullScreenImageViewController: UIViewController, UIGestureRecognizerDelegate {

    /****************************************/
    //MARK: declarations
    /****************************************/
    
    var displayImage                : UIImage?
    var displayImageString          = String()
    var panGestureRecognizer        : UIPanGestureRecognizer?
    var originalPosition            : CGPoint?
    var currentPositionTouched      : CGPoint?
    
    /****************************************/
    //MARK: outlets
    /****************************************/
    
    @IBOutlet var fullScreenImageView       : UIImageView!
    @IBOutlet weak var indicatorHolderView  : UIView!
    
    /****************************************/
    //MARK: controllers Lifecycle
    /****************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.fullScreenImageView.image = displayImage
        fullScreenImageView.frame = UIScreen.main.bounds
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        fullScreenImageView.addGestureRecognizer(panGestureRecognizer!)
        fullScreenImageView.isUserInteractionEnabled = true
        indicatorHolderView.isHidden = true
        
        if displayImageString != ""
        {
            if displayImage == nil
            {
                indicatorHolderView.isHidden = false
            }
            
            let url = URL(string: displayImageString)
            
            let image = load(fileURL: url!)
            self.fullScreenImageView.image = image
        }
        
    }
    
    private func load(fileURL: URL) -> UIImage? {
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }

    
    /****************************************/
    //MARK: Actions
    /****************************************/
    
    @IBAction func crossImageButtonTapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /****************************************/
    //MARK: Selectors
    /****************************************/
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            let velocity = panGesture.velocity(in: view)
            if velocity.y <= 0
            {
                self.view.center = self.originalPosition!
            }
            else
            {
                view.frame.origin = CGPoint(
                    x: originalPosition!.x - self.view.frame.width / 2,  //translation.x,
                    y: translation.y
                )
            }
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.y >= 1000 {
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }

}
