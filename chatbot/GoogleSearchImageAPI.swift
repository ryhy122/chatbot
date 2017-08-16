//
//  GoogleSearchImageAPI.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/21.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import UIKit


class GoogleSearchImageAPI {
    
    
    // APIを利用するためのアプリケーションID
    let apikey: String = "AIzaSyCA_rFsbNICtHdaXUDabvyacZ8hUGOkqTU"
    
    //APIを利用するためのサーチエンジンキー
    let cx: String = "006184595147758379133:3t6gtf3pdcy"
    
    //利用するAPIのサーチタイプ
    let searchType: String = "image"
    
    // APIのURL
    let entryUrl: String = "https://www.googleapis.com/customsearch/v1"
    
    //関連画像URLを格納する配列
    var wordImageArray: [String] = [String]()
    
    // パラメータのURLエンコード処理
    func encodeParameter(key: String, value: String) -> String? {
        // 値をエンコードする
        guard let escapedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            // エンコード失敗
            return nil
        }
        // エンコードした値をkey=valueの形式で返却する
        return "\(key)=\(escapedValue)"
    }
    
    func search(query: String, completion: @escaping ((UIImage) -> Void)) {
        
        wordImageArray.removeAll()
        
        // パラメータを指定する
        let parameter = ["key": apikey,"cx":cx,"searchType":searchType,"q":query]
        
        // パラメータをエンコードしたURLを作成する
        let requestUrl = createRequestUrl(parameter: parameter)
        
        // APIをリクエストする
        request(requestUrl: requestUrl) { result in
            if let url = URL(string: self.wordImageArray[0]) {
                let req = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: req, completionHandler: {data, response, error in
                    if let data = data {
                        if let anImage = UIImage(data: data) {
                            DispatchQueue.main.async {
                                completion(anImage)
                            }
                        }
                    }
                })
                task.resume()
            }
        }
    }
    // URL作成処理
    func createRequestUrl(parameter: [String: String]) -> String {
        var parameterString = ""
        for key in parameter.keys {
            // 値の取り出し
            guard let value = parameter[key] else {
                // 値なし。次のfor文の処理を行なう
                continue
            }
            
            // 既にパラメータが設定されていた場合
            if parameterString.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                // パラメータ同士のセパレータである&を追加する
                parameterString += "&"
            }
            
            
            
            // 値をエンコードする
            guard let encodeValue = encodeParameter(key: key, value: value) else {
                // エンコード失敗。次のfor文の処理を行なう
                continue
            }
            // エンコードした値をパラメータとして追加する
            parameterString += encodeValue
            
        }
        let requestUrl = entryUrl + "?" + parameterString
        return requestUrl
    }
    
    // 検索結果をパース
    func parseData(items: [Any], resultHandler: @escaping (([String]?) -> Void)) {
        
        for item in items {
            
            // レスポンスデータから画像の情報を取得する
            guard let item = item as? [String: Any], let imageURL = item["link"] as? String else {
                resultHandler(nil)
                return
            }
            print(imageURL)
            
            // 配列に追加
            wordImageArray.append(imageURL)
        }
        
        resultHandler(wordImageArray)
    }
    
    // リクエストを行なう
    func request(requestUrl: String, resultHandler: @escaping (([String]?) -> Void)) {
        // URL生成
        guard let url = URL(string: requestUrl) else {
            // URL生成失敗
            resultHandler(nil)
            return
        }
        
        // リクエスト生成
        let request = URLRequest(url: url)
        
        // APIをコールして検索を行う
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            // 通信完了後の処理
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")
            
            guard error == nil else {
                resultHandler(nil)
                return
            }
            
            // JSONで返却されたデータをパースして格納する
            guard let data = data else {
                // データなし
                resultHandler(nil)
                return
            }
            
            // JSON形式への変換処理
            guard let jsonData = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
                // 変換失敗
                resultHandler(nil)
                return
            }
            
            // データを解析
            guard let resultSet = jsonData["items"] as? [Any] else {
                // データなし
                resultHandler(nil)
                return
            }
            self.parseData(items: resultSet, resultHandler: resultHandler)
        }
        // 通信開始
        task.resume()
    }
}
