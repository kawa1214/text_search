import Flutter
import UIKit

public class SwiftTextSearchPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "text_search", binaryMessenger: registrar.messenger())
    let instance = SwiftTextSearchPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    /*
    let parameters = call.arguments as! Dictionary<String, String>
    let name = parameters["name"] as! String
    if (name == nil) {
      result("error")
    }
    */

    let text = call.arguments as! String//"カウンターでワインを片手に人を待っています"

    // 言語に日本語を指定
    let tagSchemes = NSLinguisticTagger.availableTagSchemes(forLanguage: "ja")
    let linguisticTagger = NSLinguisticTagger.init(tagSchemes: tagSchemes, options: 0)
    linguisticTagger.string = text

    // 解析を実施
    var words = [] as Array<String>;
    linguisticTagger.enumerateTags(in: NSRange(location: 0, length: text.count), scheme: .tokenType, options: []) { (tag, tokenRange, sentenceRange, stop) in
      let word = (text as NSString).substring(with: tokenRange) as String
      
        words.append(word)
      
    }
    result(words)
  }
  
  /*
  public func tokenize(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("tewt")
    let parameters = call.arguments as! Dictionary<String, String>
    let name = parameters["name"] as! String
    if (name == nil) {
      result("error")
    }

    result("iOS " + name)
  }
  */
}
