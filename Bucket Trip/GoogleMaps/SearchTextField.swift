//
//  SearchTextField.swift
//  SearchTextField
//
//  Created by Alejandro Pasccon on 4/20/16.
//  Copyright © 2016 Alejandro Pasccon. All rights reserved.
//

import UIKit
import Gloss
import SwiftyJSON

class SearchTextField: UITextField {
    
    var enableMaterialPlaceHolder : Bool = false
    var placeholderAttributes = NSDictionary()
    var lblPlaceHolder = UILabel()
    var defaultFont = UIFont()
    var difference: CGFloat = 25.0
    var directionMaterial = placeholderDirection.placeholderUp
    var isUnderLineAvailabe : Bool = true
    
    var underLine:UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Initialize ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Initialize ()
    }
    
    func Initialize(){
        self.clipsToBounds = false
        self.addTarget(self, action: #selector(TextFiledPlaceHolder.textFieldDidChange), for: .editingChanged)
        self.EnableMaterialPlaceHolder(enableMaterialPlaceHolder: true)
        if isUnderLineAvailabe {
            underLine = UIImageView()
            underLine.backgroundColor = UIColor.init(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0)
            
            underLine.frame = CGRect(x: 0, y: self.frame.size.height-1, width : self.frame.size.width, height : 1)
            
            underLine.clipsToBounds = true
            self.addSubview(underLine)
        }
        defaultFont = self.font!
    }
    
    @IBInspectable var placeHolderColor: UIColor? = UIColor.lightGray {
        didSet {
            let atts = [NSAttributedStringKey.foregroundColor.rawValue:placeHolderColor] as! [AnyHashable : NSObject]
               self.attributedPlaceholder = NSAttributedString(string: self.placeholder! as String, attributes:atts as? [NSAttributedStringKey : Any])

        }
    }
    
    //    open var highlightAttributes: [String: AnyObject] = [NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-Light", size: 10)!]

    override internal var placeholder:String?  {
        didSet {
            //  NSLog("placeholder = \(placeholder)")
        }
        willSet {
            let atts  = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.labelFontSize)] as [AnyHashable : NSObject]
            self.attributedPlaceholder = NSAttributedString(string: newValue!, attributes:atts as? [NSAttributedStringKey : Any])
            self.EnableMaterialPlaceHolder(enableMaterialPlaceHolder: self.enableMaterialPlaceHolder)
        }
    }
    
    override internal var attributedText:NSAttributedString?  {
        didSet {
            //  NSLog("text = \(text)")
        }
        willSet {
            if (self.placeholder != nil) && (self.text != "")
            {
                let string = NSString(string : self.placeholder!)
                self.placeholderText(string)
            }
            
        }
    }
    
    
    func EnableMaterialPlaceHolder(enableMaterialPlaceHolder: Bool){
        self.enableMaterialPlaceHolder = enableMaterialPlaceHolder
        self.lblPlaceHolder = UILabel()
        self.lblPlaceHolder.frame = CGRect(x: 0, y : 0, width : 0, height :self.frame.size.height)
        self.lblPlaceHolder.font = UIFont.systemFont(ofSize: 10)
        self.lblPlaceHolder.alpha = 0
        self.lblPlaceHolder.clipsToBounds = true
        self.addSubview(self.lblPlaceHolder)
        self.lblPlaceHolder.attributedText = self.attributedPlaceholder
        //self.lblPlaceHolder.sizeToFit()
    }
    
    func placeholderText(_ placeholder: NSString){
        let atts  = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.labelFontSize)] as [AnyHashable : NSObject]
        

        self.attributedPlaceholder = NSAttributedString(string: placeholder as String , attributes:atts as? [NSAttributedStringKey : Any])
        self.EnableMaterialPlaceHolder(enableMaterialPlaceHolder: self.enableMaterialPlaceHolder)
    }
    
    override func becomeFirstResponder()->(Bool){
        let returnValue = super.becomeFirstResponder()
        return returnValue
    }
    
    override func resignFirstResponder()->(Bool){
        let returnValue = super.resignFirstResponder()
        return returnValue
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    // Public interface
    
    /// Maximum number of results to be shown in the suggestions list
    open var maxNumberOfResults = 0
    
    /// Maximum height of the results list
    open var maxResultsListHeight = 0
    
    /// Indicate if this field has been interacted with yet
    open var interactedWith = false
    
    /// Indicate if keyboard is showing or not
    open var keyboardIsShowing = false
    
    /// Set your custom visual theme, or just choose between pre-defined SearchTextFieldTheme.lightTheme() and SearchTextFieldTheme.darkTheme() themes
    open var theme = SearchTextFieldTheme.lightTheme() {
        didSet {
            tableView?.reloadData()
            
            if let placeholderColor = theme.placeholderColor {
                if let placeholderString = placeholder {
                    let myAttribute = [ NSAttributedStringKey.foregroundColor:placeholderColor]
                    self.attributedPlaceholder = NSAttributedString(string: placeholderString, attributes: myAttribute)
                }
                self.placeholderLabel?.textColor = placeholderColor
            }
        }
    }
    
    
    
    /// Show the suggestions list without filter when the text field is focused
    open var startVisible = false
    
    /// Show the suggestions list without filter even if the text field is not focused
    open var startVisibleWithoutInteraction = false {
        didSet {
            if startVisibleWithoutInteraction {
                textFieldDidChange()
            }
        }
    }
    
    /// Set an array of SearchTextFieldItem's to be used for suggestions
    func filterItems(_ items: [SearchPlaceModel]) {
        filterDataSource = items
    }
    
    
    /// Closure to handle when the user pick an item
    var itemSelectionHandler: SearchTextFieldItemHandler?
    
    /// Closure to handle when the user stops typing
    open var userStoppedTypingHandler: (() -> Void)?
    
    /// Set your custom set of attributes in order to highlight the string found in each item
    open var highlightAttributes: [String: AnyObject] = [NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-Light", size: 10)!]
    
    /// Start showing the default loading indicator, useful for searches that take some time.
    open func showLoadingIndicator() {
        self.rightViewMode = .always
        indicator.startAnimating()
    }
    
    /// Force the results list to adapt to RTL languages
    open var forceRightToLeft = false
    
    /// Hide the default loading indicator
    open func stopLoadingIndicator() {
        self.rightViewMode = .never
        indicator.stopAnimating()
    }
    
    
    /// Min number of characters to start filtering
    open var minCharactersNumberToStartFiltering: Int = 0
    
    /// If startFilteringAfter is set, and startSuggestingInmediately is true, the list of suggestions appear inmediately
    open var startSuggestingInmediately = false
    
    /// Allow to decide the comparision options
    open var comparisonOptions: NSString.CompareOptions = [.caseInsensitive]
    
    /// Set the results list's header
    open var resultsListHeader: UIView?
    
    ////////////////////////////////////////////////////////////////////////
    // Private implementation
    
    fileprivate var tableView: UITableView?
    fileprivate var shadowView: UIView?
    fileprivate var direction: Direction = .down
    fileprivate var fontConversionRate: CGFloat = 0.7
    fileprivate var keyboardFrame: CGRect?
    fileprivate var timer: Timer? = nil
    fileprivate var placeholderLabel: UILabel?
    fileprivate static let cellIdentifier = "PlaceCell"
    fileprivate let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    fileprivate var maxTableViewSize: CGFloat = 0
    
    fileprivate var filteredResults = [SearchPlaceModel]()
    fileprivate var filterDataSource = [SearchPlaceModel]() {
        didSet {
            filter(forceShowAll: false)
            buildSearchTableView()
            
            if startVisibleWithoutInteraction {
                textFieldDidChange()
            }
        }
    }
    
    fileprivate var currentInlineItem = ""
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.addTarget(self, action: #selector(SearchTextField.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(SearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(SearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(SearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchTextField.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchTextField.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchTextField.keyboardDidChangeFrame(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        
        buildSearchTableView()
        
        
        // Create the loading indicator
        indicator.hidesWhenStopped = true
        self.rightView = indicator
    }
    
    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rightFrame = super.rightViewRect(forBounds: bounds)
        rightFrame.origin.x -= 5
        return rightFrame
    }
    
    // Create the filter table and shadow view
    fileprivate func buildSearchTableView() {
        if let tableView = tableView, let shadowView = shadowView {
            tableView.layer.masksToBounds = true
            tableView.layer.borderWidth = 0.5
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.tableHeaderView = resultsListHeader
            if forceRightToLeft {
                tableView.semanticContentAttribute = .forceRightToLeft
            }
            
            shadowView.backgroundColor = UIColor.lightText
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize.zero
            shadowView.layer.shadowOpacity = 1
            
            self.window?.addSubview(tableView)
        } else {
            tableView = UITableView(frame: CGRect.zero)
            shadowView = UIView(frame: CGRect.zero)
            
            self.tableView?.register(UINib(nibName: "PlaceCell", bundle: Bundle.main), forCellReuseIdentifier: SearchTextField.cellIdentifier)
        }
        
        redrawSearchTableView()
    }
    
    fileprivate func buildPlaceholderLabel() {
        var newRect = self.placeholderRect(forBounds: self.bounds)
        var caretRect = self.caretRect(for: self.beginningOfDocument)
        let textRect = self.textRect(forBounds: self.bounds)
        
        if let range = textRange(from: beginningOfDocument, to: endOfDocument) {
            caretRect = self.firstRect(for: range)
        }
        
        newRect.origin.x = caretRect.origin.x + caretRect.size.width + textRect.origin.x
        newRect.size.width = newRect.size.width - newRect.origin.x
        
        if let placeholderLabel = placeholderLabel {
            placeholderLabel.font = self.font
            placeholderLabel.frame = newRect
        } else {
            placeholderLabel = UILabel(frame: newRect)
            placeholderLabel?.font = self.font
            placeholderLabel?.backgroundColor = UIColor.clear
            placeholderLabel?.lineBreakMode = .byClipping
            
            if let placeholderColor = self.attributedPlaceholder?.attribute(NSAttributedStringKey.foregroundColor, at: 0, effectiveRange: nil) as? UIColor {
                placeholderLabel?.textColor = placeholderColor
            } else {
                placeholderLabel?.textColor = UIColor ( red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0 )
            }
            
            self.addSubview(placeholderLabel!)
        }
    }
    
    // Re-set frames and theme colors
    fileprivate func redrawSearchTableView() {
        
        if let tableView = tableView {
            guard let frame = self.superview?.convert(self.frame, to: nil) else { return }
            
            if self.direction == .down {
                
                var tableHeight: CGFloat = 0
                if keyboardIsShowing, let keyboardHeight = keyboardFrame?.size.height {
                    tableHeight = min((tableView.contentSize.height), (UIScreen.main.bounds.size.height - frame.origin.y - frame.height - keyboardHeight))
                } else {
                    tableHeight = min((tableView.contentSize.height), (UIScreen.main.bounds.size.height - frame.origin.y - frame.height))
                }
                
                if maxResultsListHeight > 0 {
                    tableHeight = min(tableHeight, CGFloat(maxResultsListHeight))
                }
                
                // Set a bottom margin of 10p
                if tableHeight < tableView.contentSize.height {
                    tableHeight -= 10
                }
                
                var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
                tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
                tableViewFrame.origin.x += 2
                tableViewFrame.origin.y += frame.size.height + 2
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.tableView?.frame = tableViewFrame
                })
                
                var shadowFrame = CGRect(x: 0, y: 0, width: frame.size.width - 6, height: 1)
                shadowFrame.origin = self.convert(shadowFrame.origin, to: nil)
                shadowFrame.origin.x += 3
                shadowFrame.origin.y = tableView.frame.origin.y
                shadowView!.frame = shadowFrame
            } else {
                let tableHeight = min((tableView.contentSize.height), (UIScreen.main.bounds.size.height - frame.origin.y - theme.cellHeight))
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.tableView?.frame = CGRect(x: frame.origin.x + 2, y: (frame.origin.y - tableHeight), width: frame.size.width - 4, height: tableHeight)
                    self?.shadowView?.frame = CGRect(x: frame.origin.x + 3, y: (frame.origin.y + 3), width: frame.size.width - 6, height: 1)
                })
            }
            
            superview?.bringSubview(toFront: tableView)
            superview?.bringSubview(toFront: shadowView!)
            
            if self.isFirstResponder {
                superview?.bringSubview(toFront: self)
            }
            
            tableView.layer.borderColor = theme.borderColor.cgColor
            tableView.layer.cornerRadius = 2
            tableView.separatorColor = theme.separatorColor
            tableView.backgroundColor = theme.bgColor
            
            tableView.reloadData()
        }
    }
    
    // Handle keyboard events
    @objc open func keyboardWillShow(_ notification: Notification) {
        if !keyboardIsShowing && isEditing {
            keyboardIsShowing = true
            
            keyboardFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            interactedWith = true
            prepareDrawTableResult()
        }
    }
    
    @objc open func keyboardWillHide(_ notification: Notification) {
        if keyboardIsShowing {
            keyboardIsShowing = false
            direction = .down
            redrawSearchTableView()
        }
    }
    
    @objc open func keyboardDidChangeFrame(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.keyboardFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self?.prepareDrawTableResult()
        }
    }
    
    @objc open func typingDidStop() {
        if userStoppedTypingHandler != nil {
            self.userStoppedTypingHandler!()
        }
      
    }
    
    // Handle text field changes
    @objc open func textFieldDidChange() {
        if tableView == nil {
            buildSearchTableView()
        }
        
        interactedWith = true
        
        // Detect pauses while typing
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(SearchTextField.typingDidStop), userInfo: self, repeats: false)
        
        if text!.isEmpty {
            clearResults()
            tableView?.reloadData()
            if startVisible || startVisibleWithoutInteraction {
                filter(forceShowAll: true)
            }
            self.placeholderLabel?.text = ""
        } else {
            filter(forceShowAll: false)
            prepareDrawTableResult()
        }
        
        buildPlaceholderLabel()
        
        if self.enableMaterialPlaceHolder {
            if (self.text == nil) || (self.text?.characters.count)! > 0 {
                self.lblPlaceHolder.alpha = 1
                self.attributedPlaceholder = nil
                self.lblPlaceHolder.textColor = self.placeHolderColor
                let fontSize = self.font!.pointSize;
                self.lblPlaceHolder.font = UIFont.init(name: (self.font?.fontName)!, size: fontSize-3)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {() -> Void in
                if (self.text == nil) || (self.text?.characters.count)! <= 0 {
                    self.lblPlaceHolder.font = self.defaultFont
                    self.underLine.backgroundColor = UIColor.init(red: 140/255.0, green: 140/255.0, blue: 140/255.0, alpha: 1.0)
                    self.lblPlaceHolder.textColor = self.placeHolderColor
                    
                    self.lblPlaceHolder.frame = CGRect(x: self.lblPlaceHolder.frame.origin.x, y : 0, width :self.frame.size.width, height : self.frame.size.height)
                }
                else {
                    if self.directionMaterial == placeholderDirection.placeholderUp {
                        self.lblPlaceHolder.frame = CGRect(x : self.lblPlaceHolder.frame.origin.x, y : -self.difference, width : self.frame.size.width, height : self.frame.size.height)
                        
                        self.lblPlaceHolder.textColor = UIColor.init(red: 0/255, green: 208/255, blue: 244/255, alpha: 1)
                        
                        self.underLine.backgroundColor = UIColor.init(red: 0/255, green: 208/255, blue: 244/255, alpha: 1)
                        
                    }else{
                        self.lblPlaceHolder.frame = CGRect(x : self.lblPlaceHolder.frame.origin.x, y : self.difference, width : self.frame.size.width, height : self.frame.size.height)
                    }
                    
                }
            }, completion: {(finished: Bool) -> Void in
            })
        }
    }
    
    @objc open func textFieldDidBeginEditing() {
        if (startVisible || startVisibleWithoutInteraction) && text!.isEmpty {
            clearResults()
            filter(forceShowAll: true)
        }
        placeholderLabel?.attributedText = nil
    }
    
    @objc open func textFieldDidEndEditing() {
        clearResults()
        tableView?.reloadData()
        placeholderLabel?.attributedText = nil
    }
    
    @objc open func textFieldDidEndEditingOnExit() {
        if let firstElement = filteredResults.first {
            if let itemSelectionHandler = self.itemSelectionHandler {
                itemSelectionHandler(filteredResults, 0)
            }
            else {
                if let strcF:StructuredFormattingModel = firstElement.strFormat{
                    self.text = strcF.displayName()
                }
                
            }
        }
    }
    
    open func hideResultsList() {
        if let tableFrame:CGRect = tableView?.frame {
            let newFrame = CGRect(x: tableFrame.origin.x, y: tableFrame.origin.y, width: tableFrame.size.width, height: 0.0)
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = newFrame
            })
        }
    }
    
    fileprivate func filter(forceShowAll addAll: Bool) {
        clearResults()
        
        if text!.characters.count < minCharactersNumberToStartFiltering {
            return
        }
        /*
         for i in 0 ..< filterDataSource.count {
         
         let item = filterDataSource[i]
         
         //let titleFilterRange = (item.place_description! as NSString).range(of: text!, options: comparisonOptions)
         
         let subtitleFilterRange = item.subtitle != nil ? (item.subtitle! as NSString).range(of: text!, options: comparisonOptions) : NSMakeRange(NSNotFound, 0)
         
         if titleFilterRange.location != NSNotFound || subtitleFilterRange.location != NSNotFound || addAll {
         item.attributedTitle = NSMutableAttributedString(string: item.title)
         item.attributedSubtitle = NSMutableAttributedString(string: (item.subtitle != nil ? item.subtitle! : ""))
         
         item.attributedTitle!.setAttributes(highlightAttributes, range: titleFilterRange)
         
         if subtitleFilterRange.location != NSNotFound {
         item.attributedSubtitle!.setAttributes(highlightAttributesForSubtitle(), range: subtitleFilterRange)
         }
         
         filteredResults.append(item)
         }
         
         }*/
        filteredResults = filterDataSource
        
        tableView?.reloadData()
    }
    
    // Clean filtered results
    fileprivate func clearResults() {
        filteredResults.removeAll()
        tableView?.removeFromSuperview()
    }
    
    // Look for Font attribute, and if it exists, adapt to the subtitle font size
    fileprivate func highlightAttributesForSubtitle() -> [String: AnyObject] {
        var highlightAttributesForSubtitle = [String: AnyObject]()
        
        for attr in highlightAttributes {
            if attr.0 == NSAttributedStringKey.font.rawValue {
                let fontName = (attr.1 as! UIFont).fontName
                let pointSize = (attr.1 as! UIFont).pointSize * fontConversionRate
                highlightAttributesForSubtitle[attr.0] = UIFont(name: fontName, size: pointSize)
            } else {
                highlightAttributesForSubtitle[attr.0] = attr.1
            }
        }
        
        return highlightAttributesForSubtitle
    }
    
    
    // MARK: - Prepare for draw table result
    
    fileprivate func prepareDrawTableResult() {
        guard let frame = self.superview?.convert(self.frame, to: UIApplication.shared.keyWindow) else { return }
        if let keyboardFrame = keyboardFrame {
            var newFrame = frame
            newFrame.size.height += theme.cellHeight
            
            if keyboardFrame.intersects(newFrame) {
                direction = .up
            } else {
                direction = .down
            }
            
            redrawSearchTableView()
        } else {
            if self.center.y + theme.cellHeight > UIApplication.shared.keyWindow!.frame.size.height {
                direction = .up
            } else {
                direction = .down
            }
        }
    }
}

extension SearchTextField: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isHidden = !interactedWith || (filteredResults.count == 0)
        shadowView?.isHidden = !interactedWith || (filteredResults.count == 0)
        
        if maxNumberOfResults > 0 {
            return min(filteredResults.count, maxNumberOfResults)
        } else {
            return filteredResults.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PlaceCell = tableView.dequeueReusableCell(withIdentifier:SearchTextField.cellIdentifier) as! PlaceCell
        
        let place:SearchPlaceModel = self.filteredResults[indexPath.row]
        cell.fillMenuInfo(place)
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        /*
         cell!.backgroundColor = UIColor.clear
         cell!.layoutMargins = UIEdgeInsets.zero
         cell!.preservesSuperviewLayoutMargins = false
         cell!.textLabel?.font = theme.font
         cell!.detailTextLabel?.font = UIFont(name: theme.font.fontName, size: theme.font.pointSize * fontConversionRate)
         cell!.textLabel?.textColor = theme.fontColor
         cell!.detailTextLabel?.textColor = theme.fontColor
         
         cell!.textLabel?.text = filteredResults[(indexPath as NSIndexPath).row].title
         cell!.detailTextLabel?.text = filteredResults[(indexPath as NSIndexPath).row].subtitle
         cell!.textLabel?.attributedText = filteredResults[(indexPath as NSIndexPath).row].attributedTitle
         cell!.detailTextLabel?.attributedText = filteredResults[(indexPath as NSIndexPath).row].attributedSubtitle
         
         cell!.imageView?.image = filteredResults[(indexPath as NSIndexPath).row].image
         */
        
        return cell
    }
    /*
     public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return theme.cellHeight
     }
     */
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if itemSelectionHandler == nil {
            let sea = filteredResults[(indexPath as NSIndexPath).row]
            
            if let strcF:StructuredFormattingModel = sea.strFormat{
                self.text = strcF.displayName()
            }
        } else {
            let index = indexPath.row
            itemSelectionHandler!(filteredResults, index)
        }
        
        clearResults()
    }
}

////////////////////////////////////////////////////////////////////////
// Search Text Field Theme

public struct SearchTextFieldTheme {
    public var cellHeight: CGFloat
    public var bgColor: UIColor
    public var borderColor: UIColor
    public var separatorColor: UIColor
    public var font: UIFont
    public var fontColor: UIColor
    public var placeholderColor: UIColor?
    
    init(cellHeight: CGFloat, bgColor:UIColor, borderColor: UIColor, separatorColor: UIColor, font: UIFont, fontColor: UIColor) {
        self.cellHeight = cellHeight
        self.borderColor = borderColor
        self.separatorColor = separatorColor
        self.bgColor = bgColor
        self.font = font
        self.fontColor = fontColor
    }
    
    public static func lightTheme() -> SearchTextFieldTheme {
        return SearchTextFieldTheme(cellHeight: 30, bgColor: UIColor (red: 1, green: 1, blue: 1, alpha: 0.6), borderColor: UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0), separatorColor: UIColor.clear, font: UIFont.systemFont(ofSize: 10), fontColor: UIColor.black)
    }
    
    public static func darkTheme() -> SearchTextFieldTheme {
        return SearchTextFieldTheme(cellHeight: 30, bgColor: UIColor (red: 0.8, green: 0.8, blue: 0.8, alpha: 0.6), borderColor: UIColor (red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0), separatorColor: UIColor.clear, font: UIFont.systemFont(ofSize: 10), fontColor: UIColor.white)
    }
}

////////////////////////////////////////////////////////////////////////
// Filter Item

class SearchPlaceModel: Glossy {
    
    var placeId: String?
    var iconName: String
    
    var place_description: String?
    //var name: String?
    var reference: String?
    var terms:[PlaceTermModel]?
    var strFormat:StructuredFormattingModel?
    
    required init?(json: Gloss.JSON) {
        placeId = "place_id" <~~ json
        iconName = "iconName" <~~ json ?? "ic_marker_pin"
        
        place_description = "description" <~~ json
         reference = "reference" <~~ json
        // apiKey = "apiKey" <~~ json
        terms = "terms" <~~ json
        strFormat = "structured_formatting" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "place_id" ~~> placeId,
            "iconName" ~~> iconName,
            "description" ~~> place_description,
            "reference" ~~> reference,
            "terms" ~~> terms,
            "structured_formatting" ~~> strFormat
            //"apiKey" ~~> apiKey
            ])
    }
    func name() -> String {
        var name:String = ""
        guard let pts = terms, let ptv = pts[0].value else { return name }
        name = ptv
        return name
    }
    
    func desc() -> String {
        var name:String = ""
        guard let pts = terms else { return name }
        if pts.count > 3 {
            if let ptv1:String = pts[1].value, let ptv2:String = pts[2].value{
                name = "\(ptv1),\(ptv2)"
            }
        }
        return name
    }
    
    func formattedName()-> String {
        guard let detail:String = place_description else{
            return ""
        }
        guard let desA = detail.components(separatedBy: ",").first else {
            return ""
        }
        return desA
    }
    
    func formattedDetails()-> String {
        guard let detail:String = place_description else{
            return ""
        }
        let desA = detail.components(separatedBy: ",")
        if desA.count == 0 {
            return ""
        }
        else if desA.count == 2{
            return desA[1]
        }
        else if desA.count == 3{
            return "\(desA[1]),\(desA[2])"
        }
        return ""
    }
}

typealias SearchTextFieldItemHandler = (_ filteredResults: [SearchPlaceModel], _ index: Int) -> Void

////////////////////////////////////////////////////////////////////////
// Suggestions List Direction

enum Direction {
    case down
    case up
}

