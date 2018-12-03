
import Foundation

func loadFaceSource() ->[FaceThemeModel] {
    var subjectArray = [FaceThemeModel]()
    
    let sources = ["systemEmoji"]
    for idx in 0..<sources.count {
        let plistName = sources[idx]
        
        guard let plistPath = Bundle.main.path(forResource: plistName, ofType: "plist") else {
            break
        }
        guard let faceDic = NSDictionary.init(contentsOfFile: plistPath) else {
            break
        }
        guard let allkeys = faceDic.allKeys as? [String] else {
            break
        }
        
        let themeModel = FaceThemeModel.init()
        
        if plistName == "systemEmoji" {
            themeModel.themeStyle = .systemEmoji
            themeModel.themeIcon  = ""
        }
        
        var modelsArr = [FaceModel]()
        for idx in 0..<allkeys.count {
            let fm = FaceModel.init()
            let name = allkeys[idx]
            fm.faceTitle = name
            fm.faceIcon  = faceDic.object(forKey: name) as? String ?? ""
            modelsArr.append(fm)
        }
        
        themeModel.faceModels = modelsArr
        
        subjectArray.append(themeModel)
    }
    
    return subjectArray
    
}
