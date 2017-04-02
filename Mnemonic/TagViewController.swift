//
//  TagViewController.swift
//  tribb
//
//  Created by Avery Lamp on 11/7/16.
//  Copyright © 2016 Charles Marino. All rights reserved.
//

import UIKit

protocol TagViewControllerDelegate {
    func tagViewClicked(_ button: UIButton)
    func tagAdditionError(_ reason: String)
}

class TagViewController: UIViewController {

    var textFont = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
    var tagsToAdd = [String]()
    let tagHeight = 30
    let tagSpacing = 10
    let extraWidthPerTag:CGFloat = 25
    var tagButtons = [UIButton]()
    var delegate: TagViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func addTagsToView(){
        self.view.subviews.forEach {
            $0.removeFromSuperview()
        }
        tagButtons = [UIButton]()
        var firstRow = [String]()
        var secondRow = [String]()
        if tagsToAdd.count > 3{
            firstRow.append(contentsOf: tagsToAdd[0..<3])
            secondRow.append(contentsOf: tagsToAdd[3..<tagsToAdd.count])
        }else{
            firstRow.append(contentsOf: tagsToAdd[0..<tagsToAdd.count])
        }
        
        var firstRowViews = [UIButton]()
        var i = 0
        var totalCount = 0
        for string in firstRow{
            
            let nsstring = NSAttributedString(string: string, attributes: [NSFontAttributeName : textFont])
            let strWidth = nsstring.widthWithConstrainedHeight(100) + extraWidthPerTag
            let button = UIButton()
            button.tag = totalCount
            button.setTitle(string, for: UIControlState())
            button.titleLabel?.font = textFont
            button.backgroundColor = UIColor(red: 1.000, green: 0.486, blue: 0.647, alpha: 1.00)
            button.layer.cornerRadius = CGFloat(tagHeight) / 2
            button.addTarget(self, action: #selector(TagViewController.tagButtonClicked(_:)), for: .touchUpInside)

            if firstRowViews.count > 0{
                let precedingView = firstRowViews[i - 1]
                button.frame = CGRect(x:  Int(precedingView.frame.origin.x + precedingView.frame.width) + tagSpacing, y: 0, width: Int(strWidth), height: tagHeight)
            }else{
                button.frame = CGRect(x: 0, y: 0, width: Int(strWidth), height: tagHeight)
            }
            firstRowViews.append(button)
            self.view.addSubview(button)
            i += 1
            totalCount += 1
        }
        var centeredOffset: CGFloat = 0
        let viewCenter = self.view.frame.width / 2
        switch firstRowViews.count {
        case 1:
            centeredOffset = viewCenter - firstRowViews.first!.center.x
        case 2:
            centeredOffset = viewCenter - (firstRowViews[0].frame.origin.x + firstRowViews[1].frame.origin.x + firstRowViews[1].frame.width) / 2
        case 3:
            centeredOffset = viewCenter - (firstRowViews[0].frame.origin.x + firstRowViews[2].frame.origin.x + firstRowViews[2].frame.width) / 2
        default:
            centeredOffset = 0
        }
        firstRowViews.forEach {
            $0.center.x += centeredOffset
            if secondRow.count > 0 {
                $0.center.y = self.view.frame.height / 2 - CGFloat(tagHeight) / 2 - CGFloat(tagSpacing) / 2
            }else{
                $0.center.y = self.view.frame.height / 2
            }

        }
        // Second row
        
        i = 0
        var secondRowViews = [UIButton]()
        for string in secondRow{
            
            let nsstring = NSAttributedString(string: string, attributes: [NSFontAttributeName : textFont])
            let strWidth = nsstring.widthWithConstrainedHeight(100) + extraWidthPerTag
            let button = UIButton()
            button.tag = totalCount
            button.setTitle(string, for: UIControlState())
            button.titleLabel?.font = textFont
            button.backgroundColor = UIColor(red: 1.000, green: 0.486, blue: 0.647, alpha: 1.00)
            button.layer.cornerRadius = CGFloat(tagHeight) / 2
            button.addTarget(self, action: #selector(TagViewController.tagButtonClicked(_:)), for: .touchUpInside)
            
            if secondRowViews.count > 0{
                let precedingView = secondRowViews[i - 1]
                button.frame = CGRect(x:  Int(precedingView.frame.origin.x + precedingView.frame.width) + tagSpacing, y: 0, width: Int(strWidth), height: tagHeight)
            }else{
                button.frame = CGRect(x: 0, y: 0, width: Int(strWidth), height: tagHeight)
            }
            secondRowViews.append(button)
            self.view.addSubview(button)
            i += 1
            totalCount += 1
        }
        centeredOffset = 0
        switch secondRowViews.count {
        case 1:
            centeredOffset = viewCenter - secondRowViews.first!.center.x
        case 2:
            centeredOffset = viewCenter - (secondRowViews[0].frame.origin.x + secondRowViews[1].frame.origin.x + secondRowViews[1].frame.width) / 2
        case 3:
            centeredOffset = viewCenter - (secondRowViews[0].frame.origin.x + secondRowViews[2].frame.origin.x + secondRowViews[2].frame.width) / 2
        default:
            centeredOffset = 0
        }
        secondRowViews.forEach {
            $0.center.x += centeredOffset
            $0.center.y = self.view.frame.height / 2 + CGFloat(tagHeight) / 2 + CGFloat(tagSpacing) / 2
        }
        tagButtons.append(contentsOf: firstRowViews)
        tagButtons.append(contentsOf: secondRowViews)
        
    }
    
    let alphaFadeDuration = 0.5
    let translationDuration = 1.0
    
    func addSingleTagView(_ text: String){
        var firstRowViews = [UIButton]()
        var secondRowViews = [UIButton]()
        if tagButtons.count > 3{
            firstRowViews.append(contentsOf: tagButtons[0..<3])
            secondRowViews.append(contentsOf: tagButtons[3..<tagButtons.count])
        }else{
            firstRowViews.append(contentsOf: tagButtons[0..<tagButtons.count])
        }
        if tagButtons.count > 5{
            return
        }
        var rowToAddViews = firstRowViews
        var firstOfRow = false
        if firstRowViews.count == 3{
            rowToAddViews = secondRowViews
            if secondRowViews.count == 0 {
                UIView.animate(withDuration: translationDuration, animations: { 
                    firstRowViews.forEach { $0.center.y -= CGFloat(self.tagHeight / 2)  + CGFloat(self.tagSpacing / 2) }
                })
            }
        }
        if rowToAddViews.count == 0 {
            firstOfRow = true
        }
        
        let nsstring = NSAttributedString(string: text, attributes: [NSFontAttributeName : textFont])
        let strWidth = nsstring.widthWithConstrainedHeight(100) + extraWidthPerTag
        let button = UIButton()
        button.tag = tagButtons.count
        button.setTitle(text, for: UIControlState())
        button.titleLabel?.font = textFont
        button.backgroundColor = UIColor(red: 1.000, green: 0.486, blue: 0.647, alpha: 1.00)
        button.layer.cornerRadius = CGFloat(tagHeight) / 2
        button.alpha = 0.0
        self.view.addSubview(button)
        
        rowToAddViews.append(button)
        tagButtons.append(button)
        tagsToAdd.append(text)
        button.addTarget(self, action: #selector(TagViewController.tagButtonClicked(_:)), for: .touchUpInside)
        
        if firstOfRow == false{
            let precedingView =  rowToAddViews[rowToAddViews.count - 2]
            let newButtonFrame = CGRect(x: precedingView.frame.origin.x + precedingView.frame.width + CGFloat(tagSpacing), y: precedingView.frame.origin.y, width: strWidth, height: CGFloat(tagHeight))
            button.frame = newButtonFrame
            var centeredOffset: CGFloat = 0
            let viewCenter = self.view.frame.width / 2
            switch rowToAddViews.count {
            case 1:
                centeredOffset = viewCenter - rowToAddViews.first!.center.x
            case 2:
                centeredOffset = viewCenter - (rowToAddViews[0].frame.origin.x + rowToAddViews[1].frame.origin.x + rowToAddViews[1].frame.width) / 2
            case 3:
                centeredOffset = viewCenter - (rowToAddViews[0].frame.origin.x + rowToAddViews[2].frame.origin.x +  rowToAddViews[2].frame.width) / 2
            default:
                centeredOffset = 0
            }
            UIView.animate(withDuration: translationDuration, animations: { 
                rowToAddViews.forEach{
                    $0.center.x += centeredOffset
                }
            })
        }else{
            let newButtonFrame = CGRect(x: 0, y: 0, width: strWidth, height: CGFloat(tagHeight))
            button.frame = newButtonFrame
            if tagButtons.count == 1 {
                button.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
            }else{
                button.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + CGFloat(tagHeight / 2) + CGFloat(tagSpacing / 2))
            }
        }
        
        UIView.animate(withDuration: alphaFadeDuration, animations: { 
            button.alpha = 1.0
        }) 
        
    }
    
    func tagButtonClicked(_ sender: UIButton){
        if delegate != nil {
            delegate?.tagViewClicked(sender)
        }
    }
    
    func removeTag(_ string: String){
        if let index = tagsToAdd.index(of: string){
            tagsToAdd.remove(at: index)
        }
        var index = -1
        print("Tag Buttons Count \(tagButtons.count)")
        for i in 0..<tagButtons.count{
            print("Tag - \(tagButtons[i].titleLabel!.text!)")
            if tagButtons[i].titleLabel!.text! == string  {
                print("Removing Tag FOUND - \(string)")
                index = i
            }
        }
        if index >= 0{
            print("Removing tag Button")
            tagButtons[index].removeFromSuperview()
            tagButtons.remove(at: index)
        }
        print(tagsToAdd)
        addTagsToView()
    }
}

extension NSAttributedString {

    func widthWithConstrainedHeight(_ height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: 1000, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return boundingBox.width
    }
}

