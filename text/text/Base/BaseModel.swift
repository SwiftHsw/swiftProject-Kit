//
//  BaseModel.swift
//  text
//
//  Created by 黄世文 on 2022/2/24.
//

import UIKit
import KakaJSON

class BaseModel: NSObject,Convertible {

    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        return property.name
    }
    
    
    required override init(){
        
    }
    
    
}
protocol Copyable: Codable {
    func clone() -> Self
}

extension Copyable {
    
    func clone() -> Self {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            fatalError("encode失败")
        }
        let decoder = JSONDecoder()
        guard let target = try? decoder.decode(Self.self, from: data) else {
           fatalError("decode失败")
        }
        return target
    }
    
}
