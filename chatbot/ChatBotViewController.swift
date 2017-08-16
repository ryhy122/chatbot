//  ViewController.swift
//  JSQMessageDemo
//  Created by Ryohei on 2017/01/24.
//  Copyright © 2017年 bobby. All rights reserved.
//        let bannerView : GADBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//        bannerView.adUnitID = "ca-app-pub-4269737132369132/8585555203"
//        bannerView.delegate = self
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//        view.addSubview(bannerView)
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        print("Banner loaded successfully")
//        // Reposition the banner ad to create a slide down effect
//        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
//        bannerView.transform = translateTransform
//        UIView.animate(withDuration: 1.0) {
//            bannerView.transform = CGAffineTransform.identity
//        }
//    }

import UIKit
import JSQMessagesViewController
import ChameleonFramework
import Photos

class BotViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let bot = Chatbot()
    
    let picker = UIImagePickerController()
    var answers = AnalyzedMessage()
    var chatAnswers = [String]()
    
    var messages: [JSQMessage] = []
    var history: [History] = []
    
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    var SENDER_ID = "chatbot"
    
    let exampleSentence = "Example: "
    let definition = "Definition: "
    
//    let speech = AVSpeechSynthesizer()
    var sutterance = AVSpeechUtterance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.setUp()
        self.bubbleUISetting()
        self.avatarSetting()
        self.setUI()
        setHistoryMessage()
    }

    func instanciateView() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let view = sb.instantiateViewController(withIdentifier: "TabBarVC")
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func setHistoryMessage() {
        let data = HistoryCoreModel.sharedInstance.getData()
        for d in data {
            if let word = d.word {
                self.add(sender: .user, text: word)
                if let definition = d.definition {
                    self.add(sender: .bot, text: "The definition of \(word) is: ")
                    self.add(sender: .bot, text: definition)
                }
            }
            if let example = d.example {
                self.add(sender: .bot, text: "For example, you can say like this: ")
                self.add(sender: .bot, text: example)
            }
            if let imageData = d.picture {
                if let image = UIImage(data: imageData as Data) {
                    self.add(sender: .bot, image: image)
                }
            }
            if let userImage = d.userImage {
                if let image = UIImage(data: userImage as Data) {
                    self.add(sender: .user, image: image)
                }
            }
            if let response = d.photoResponse {
                self.add(sender: .bot, text: response)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setUI() {
        self.navigationController?.navigationBar.dropShadow()
        self.inputToolbar.contentView.textView.placeHolder = "Ask vocabulary"
        self.inputToolbar.maximumHeight = 100
        self.inputToolbar.toggleSendButtonEnabled()
    }
    
    func setUp() {
        self.senderId = "user"
        self.senderDisplayName = "bot"
    }

}

extension BotViewController {

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as? JSQMessagesCollectionViewCell
        if messages[indexPath.row].senderId == senderId {
            cell?.textView?.textColor = UIColor.white
        } else {
            cell?.textView?.textColor = UIColor.darkGray
        }
        self.automaticallyScrollsToMostRecentMessage = true
        return cell!
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return self.outgoingAvatar
        }
        return self.incomingAvatar
    }
    
}


extension BotViewController {
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if indexPath.item == 0 {
            return 50
        }
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = self.messages[indexPath.item]
        if indexPath.item == 0 {
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        return nil
    }
}
///Setting
extension BotViewController {
    
    func bubbleUISetting(){
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.flatWhite)
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.flatSkyBlue)
    }
    
    func avatarSetting(){
        self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "mini")!, diameter: 100)
        self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "ghost")!, diameter: 100)
    }
    
}

///TextField Setting
extension BotViewController {
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        self.add(sender: .user, text: text)
        GoogleTranslationAPI().trasnlate("en", to: "ja", text: text) { (transaltedText) in
            DispatchQueue.main.async {
                self.add(sender: .bot, text: transaltedText)
                self.collectionView.reloadData()
            }
        }
        
        if text == DataManager.sharedInstance.retrieveVocabulary() {
            let userData = UserVocabularyModel.sharedInstance.getData()
            var categories = [String]()
            var words = [String]()
            userData.forEach({ (vocabulary) in
                words.append(vocabulary.word!)
                categories.append(vocabulary.category!)
            })
            
            self.add(sender: .bot, text: "Ok, here is your vocabulary in your list")
            self.add(sender: .bot, text: words.joined(separator: ", "))
            
        } else if text == DataManager.sharedInstance.retrievePhrase() {
            
            let userData = MyPhraseModel.sharedInstance.getData()
            
            var phrases = [String]()
            var words = [String]()
            
            userData.forEach({ (phrase) in
                phrases.append(phrase.phrase!)
                words.append(phrase.word!)
            })
            
            self.add(sender: .bot, text: "Ok, here is your phrases in your list")
            self.add(sender: .bot, text: phrases.joined(separator: "\n\n"))
            
        } else {
            
            definitionRequest()
        }
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.finishSendingMessage(animated: true)
        self.finishReceivingMessage(animated: true)
        self.receiveAutoMessage()
    }
    
    
    func definitionRequest() {
        self.answers.definitions.removeAll()
        let user = fetchText(sender: .user).last
        let beforeText = user?.text
        guard let text = SingularHandler().singlurize(word: beforeText!) else {
            print("Singularized word is nil")
            return
        }
        print("TEXT", text)
        DictionaryAPI.searchDefinition(searchWord: text, language: "en", completionHandler: {
            (voca, def, ex, status) in
            if status {
                self.answers.definitions = def
                self.answers.examples = ex
                DispatchQueue.main.async {
                    if self.answers.definitions.isEmpty {
                        self.add(sender: .bot, text: "I could not find the definiton...Is the word you typed a phrase?? I can only look up vocabulary now")
                        self.collectionView.reloadData()
                    }
                    
                    if self.answers.examples.isEmpty {
                        self.add(sender: .bot, text: "I can't find any example...I wish I could come up with something")
                        self.collectionView.reloadData()
                    }
                    
                    guard let shuffledDefinition = self.answers.definitions.shuffled().first else {
                        return
                    }
                    
                    self.add(sender: .bot, text: "The definition of \(text) is: ")
                    self.add(sender: .bot, text: shuffledDefinition)
                    self.utter(str: "The definition of \(text) is: ")
                    self.utter(str: shuffledDefinition)
                    print("Definitons shuffled and showed", shuffledDefinition)
                    
                    guard let shuffledExample = self.answers.examples.shuffled().first else {
                        return
                    }
                    self.add(sender: .bot, text: "For example, you can say like this: ")
                    self.utter(str: "For example, you can say like this: ")
                    self.add(sender: .bot, text: shuffledExample)
                    self.utter(str: shuffledExample)
                    
                    print("Example shuffled and showed", shuffledExample)
                    GoogleSearchImageAPI().search(query: shuffledExample, completion: { (image) in
                        DispatchQueue.main.async {
                            self.add(sender: .bot, image: image)
                            HistoryCoreModel.sharedInstance.add(word: text, definition: shuffledDefinition, example: shuffledExample, picture: image, image: nil, photoResponse: nil)
                            print(image, "is image supplied")
                            self.collectionView.reloadData()
                        }
                    })
                    sleep(1)
                    self.collectionView.reloadData()
                }
            } else {
                
            }
        })
    }
    
    func didFinishMessageTimer(sender: Timer) {
        print("Did finsihe message timer")
        self.finishReceivingMessage(animated: true)
    }
    

    func add(sender: SenderID, text: String) {
        var message: JSQMessage
        switch sender {
        case .bot: message = JSQMessage(senderId: "chatbot", displayName: "bot", text: text)
        case .user: message = JSQMessage(senderId: "user", displayName: "user", text: text)
        }
        self.messages.append(message)
    }
    
    func add(sender: SenderID, image: UIImage) {
        let photoItem = JSQPhotoMediaItem(image: image)
        var message: JSQMessage
        switch sender {
        case .bot: message = JSQMessage(senderId: "chatbot", displayName: "bot", media: photoItem)
        case .user: message = JSQMessage(senderId: "user", displayName: "user", media: photoItem)
        }
        self.messages.append(message)
    }
    
    func fetchText(sender: SenderID) -> [JSQMessage] {
        var fetchedText = [JSQMessage]()
        switch sender {
        case .bot:
            fetchedText = self.messages.filter {$0.senderId == "chatbot"}
        case .user:
            fetchedText = self.messages.filter {$0.senderId == "user"}
        }
        return fetchedText
    }
    
    
    func receiveAutoMessage() {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(BotViewController.didFinishMessageTimer(sender:)), userInfo: nil, repeats: false)
        print("Fired message")
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let selectedPath = self.messages[indexPath.row]
        let text = selectedPath.text
        
        if selectedPath.senderId == "user" {
            print(self.messages)
            
            if selectedPath.isMediaMessage {
                expandImage(index: indexPath.row)
                print("Image tapped id: USER")
            } else {

                let alertController = UIAlertController(title: "\(text!)", message: "Would you like to add to your vocabulary list?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) -> Void in
                    let vocab = VocabularyModel(word: text!, category: nil, image: nil, label: nil)
                    UserVocabularyModel.sharedInstance.add(vocabulary: vocab)
                }
                let no = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                alertController.addAction(yes)
                alertController.addAction(no)
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            if selectedPath.isMediaMessage {
                expandImage(index: indexPath.row)
                print("Image tapped id: Bot")
            } else {
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let view = story.instantiateViewController(withIdentifier: "PopViewController") as! PopViewController
                if let input = text {
                    view.text = input
                }
                
                self.present(view, animated: true, completion: nil)
            }
        }
    }
    
    func expandImage(index: Int) {
        let mmd : JSQMessageMediaData = self.messages[index].media!
        let photo: JSQPhotoMediaItem = mmd as! JSQPhotoMediaItem
        imageTapped(image: photo.image)
    }
    
}

extension BotViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    }
}


extension BotViewController : AVSpeechSynthesizerDelegate {
    
    func utter(str:String) {
        let speech = AVSpeechSynthesizer()
        sutterance = AVSpeechUtterance(string: str)
        sutterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        sutterance.rate = 0.43
        sutterance.pitchMultiplier = 1
        sutterance.preUtteranceDelay = 0.9
        sutterance.volume = 1
        sutterance.postUtteranceDelay = 0
        speech.delegate = self
        if speech.isSpeaking {
            speech.stopSpeaking(at: .immediate)
            speech.speak(sutterance)
        } else {
            speech.speak(sutterance)
        }
    }
    
    internal func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("読み上げ開始")
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("cancels")
    }
    internal func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("読み上げ終了")
    }
    
    internal func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
    }
    
}


class AnalyzedMessage : NSObject {
    
    dynamic var examples  = [String]()
    dynamic var definitions = [String]()
    
    func observer() {
        AnalyzedMessage.addObserver(self, forKeyPath: "examples", options: [.new], context: nil)
        AnalyzedMessage.addObserver(self, forKeyPath: "definitions", options: [.new], context: nil)
    }
    
    func removeObserver() {
        AnalyzedMessage.removeObserver(self, forKeyPath: "definitions")
        AnalyzedMessage.removeObserver(self, forKeyPath: "examples")
    }
    
    
}








