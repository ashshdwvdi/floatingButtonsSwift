//
//  ViewController.swift
//  floatingMenu
//
//  Created by doodleblue-92 on 28/02/18.
//  Copyright © 2018 doodleblue-92. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var floatingButton = FloatingButton()
    let backgroundImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "background"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        
        addFloatMenu()
    }
    
    func setupBackground(){
        let windoSize = UIScreen.main.bounds
        self.view.addSubview(backgroundImage)
        backgroundImage.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .zero, size: CGSize(width: windoSize.width, height: windoSize.height))
        
        let descLabelText = "You can tap on the left drawer button in yellow to see sub menu button and drag it on the left edge number of buttons is dynamic just make changes in code and done."
        
        let descLabel = UILabel()
        descLabel.text = descLabelText
        descLabel.textColor = .white
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.9)
        
        view.addSubview(descLabel)
        descLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .zero, size: CGSize(width: windoSize.width, height: windoSize.height / 4))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6.0) {
            descLabel.removeFromSuperview()
        }
    }
    
    func addFloatMenu(){
        var floatingButton = FloatingButton()
        floatingButton = FloatingButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.height/2, width: 50, height: 50))
        floatingButton.setImage(#imageLiteral(resourceName: "arrow-left"), for: .normal)
        floatingButton.backgroundColor = UIColor.yellow.withAlphaComponent(0.7)
        self.view.addSubview(floatingButton)
    }
}


class FloatingButton: UIButton{

    let constantHeight = UIScreen.main.bounds.width * 0.2
    var actionButtonsArray = [UIButton]()
    var verticalStackView = UIStackView()
    var horizontalStackView = UIStackView()
    let appColorBlue = UIColor(displayP3Red: 66.0/255.0, green: 176/255.0, blue: 209/255.0, alpha: 1.0)
    var toggleMenuState = false{
        didSet{
            UIView.animate(withDuration: 0.4, animations: {
                self.transform = CGAffineTransform(rotationAngle: self.toggleMenuState ? ((180.0 * CGFloat(Double.pi)) / 180.0) : 0)
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addShadowToButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Error has occured")
    }
    
    func addShadowToButton(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: -3, height: 3)
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let superview = superview{

            if !toggleMenuState {
                self.updateUIWhenButtonPressed(view: superview, showMenu: true)
                toggleMenuState = true
            }else{
                closeMenu()
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            self.center.y = touch.location(in: self.superview).y
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if self.center.y > CGFloat(verticalStackView.subviews.count) * constantHeight{
                UIView.animate(withDuration: 0.7, animations: {
                    self.center.y = UIScreen.main.bounds.height - CGFloat(self.verticalStackView.subviews.count + 1) * self.constantHeight
                })
            }else{
                self.center.y = touch.location(in: self.superview).y
            }
        }
    }
   
    func getButtonAndAssets(){
        
    }
    
    func updateUIWhenButtonPressed(view: UIView, showMenu: Bool){
        if showMenu{
            /// Remove from the view if this is already added somehow
            [verticalStackView, horizontalStackView].forEach({$0.removeFromSuperview()})
            
            /// Vertical stack view is pinned to bottom of the view so it can accomodate more elements
            
            let buttonsArray = ButtonDataModelClass.MyStory
            let minimumButtons = buttonsArray.count/2
            let additionalButton = buttonsArray.count % 2
            
            let horizontalCount = minimumButtons - 1
            let verticalCount = (minimumButtons + additionalButton) - 1
        

            var verticalViews = [UIView]()
            var horizontalViews = [UIView]()
            
            for i in 0...verticalCount{
                let button = floatingButton(i)
                verticalViews.append(button)
            }
            
            for i in 0...horizontalCount{
                let button = floatingButton(verticalViews.count + i)
                horizontalViews.append(button)
            }

            /// Vertical view
            verticalStackView = UIStackView(arrangedSubviews: verticalViews)
            verticalStackView.distribution = .fillEqually
            verticalStackView.axis = .vertical
            verticalStackView.spacing = 10.0
            
            /// Horizontal view
            horizontalStackView = UIStackView(arrangedSubviews: horizontalViews)
            horizontalStackView.distribution = .fillEqually
            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = 10.0
        
            /// Add views to the parent view on press
            [verticalStackView, horizontalStackView].forEach({view.addSubview($0)})

            horizontalStackView.anchor(top: nil, leading: verticalStackView.trailingAnchor, bottom: verticalStackView.bottomAnchor, trailing: nil, padding: UIEdgeInsetsMake(0.0, 4.0, 0.0, 0.0), size: CGSize(width: constantHeight * CGFloat(horizontalViews.count), height: constantHeight))
            
            verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: UIEdgeInsetsMake(0.0, 10.0, 10.0, 0.0),size: CGSize(width: constantHeight, height: constantHeight * CGFloat(verticalViews.count)))
            
        }else{
            /// Remove views to the parent view on press & re add the floating button
            [verticalStackView, horizontalStackView].forEach({$0.removeFromSuperview()})
            
        }
    }
    
    
    /// Add Menu type parameter to replace the images and button text
    func floatingButton(_ tag: Int) -> UIButton{
        
            /// crete the outer
            let button = UIButton(type: .custom)
            button.tag = tag
        
//            button.setTitle(ButtonDataModelClass.MyStory[tag], for: .normal)
            button.setImage(#imageLiteral(resourceName: "suggested"), for: .normal)
            button.tintColor = UIColor.white
            button.backgroundColor = .orange
            button.addTarget(self, action: #selector(handleActionButtonEvents(sender:)), for: .touchUpInside)
            
            /// Rounded corners
            button.layer.cornerRadius = constantHeight/2
            button.clipsToBounds = true
            
            ///Button Shadow
            button.layer.shadowColor = UIColor.gray.cgColor
            button.layer.shadowRadius = 1
            button.layer.shadowOffset = CGSize(width: -1, height: 2)
            button.layer.shadowOpacity = 0.5
            button.layer.masksToBounds = false
            
            actionButtonsArray.append(button)
            return button
    }

    @objc func handleActionButtonEvents(sender: UIButton){
        sender.backgroundColor = UIColor.purple
        switch sender.tag{
        case 0:
            print(sender.tag)

        case 1:
            print(sender.tag)
            print("1")
        case 2:
            print(sender.tag)
            print("2")
        case 3:
            print(sender.tag)
            print("3")
        case 4:
            print(sender.tag)
            print("4")
        case 5:
            print(sender.tag)
            print("5")
        default : print("Not handled...")
        }

//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
//            self.closeMenu()
//        })
    }
    
    func closeMenu(){
        toggleMenuState = false
        DispatchQueue.main.async(){
            if let superview = self.superview{
                self.updateUIWhenButtonPressed(view: superview, showMenu: false)
            }
        }
    }
    
    
}


struct ButtonDataModelClass{
    static let MyStory = ["btn1","btn2","btn3","btn4"]
}


extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero){
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing{
            trailing.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0{
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0{
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}












