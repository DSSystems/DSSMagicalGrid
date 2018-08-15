//
//  ViewController.swift
//  DSSMagicalGrid
//
//  Created by David on 27/07/18.
//  Copyright © 2018 DS_Systems. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var cells = [String: UIView]()
    
    let numViewPerRow = 15

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(containerView)
        guard let window = UIApplication.shared.keyWindow else {return}
        containerView.frame = window.safeAreaLayoutGuide.layoutFrame
        containerView.backgroundColor = .lightGray
        let size: CGFloat = containerView.frame.width / CGFloat(numViewPerRow)

        for j in 0...28 {
            for i in 0...numViewPerRow - 1 {
                let cellView = UIView()
                
                cellView.backgroundColor = UIColor().randomColor()
                cellView.layer.borderWidth = 0.5
                cellView.layer.borderColor = UIColor.black.cgColor
                cellView.frame = CGRect(x: size * CGFloat(i), y: CGFloat(j) * size, width: size, height: size)
                cellView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
                
                containerView.addSubview(cellView)
                
                let key = "\(i)|\(j)"
                cells[key] = cellView
            }
        }
    }
    
    var selectedCellView: UIView?
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        let size: CGFloat = containerView.frame.width / CGFloat(numViewPerRow)

        let i = Int(location.x / size)
        let j = Int(location.y / size)
        let key = "\(i)|\(j)"
        guard let cellView = cells[key] else { return }
        
        if selectedCellView != cellView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.selectedCellView?.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
        
        selectedCellView = cellView
        containerView.bringSubview(toFront: cellView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            cellView.layer.transform = CATransform3DMakeScale(3, 3, 3)
//            cellView?.backgroundColor = .black
        }, completion: nil)
        
        if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                cellView.layer.transform = CATransform3DIdentity
            }) { (_) in
                
            }
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }
}

extension UIView {
    func fillToSuperview(padding: UIEdgeInsets = .zero) {
        guard let top = superview?.safeAreaLayoutGuide.topAnchor, let bottom = superview?.safeAreaLayoutGuide.bottomAnchor, let leading = superview?.safeAreaLayoutGuide.leadingAnchor, let trailing = superview?.safeAreaLayoutGuide.trailingAnchor else {
            return
        }
            
        translatesAutoresizingMaskIntoConstraints = false
        [
            topAnchor.constraint(equalTo: top, constant: padding.top),
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom),
            leadingAnchor.constraint(equalTo: leading, constant: padding.left),
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right)
        ].forEach({$0.isActive = true})
    }
}

extension UIColor {
    func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
