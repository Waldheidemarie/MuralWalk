//
//  MuralController.swift
//  CityArt
//
//  Created by Colin Smith on 7/3/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation
import CloudKit

class MuralController {
    
   static let shared = MuralController()
    
    let ckManager = CloudKitManager()
    var savedMurals: [Mural] = []
    
    func figureOutIfMuralExists(mural: Mural, completion: @escaping (Int) -> Void) -> Bool {
        var muralBool = false
        var counter = -1
        for muralLoop in self.savedMurals {
            counter += 1
            if muralLoop.muralID == mural.muralID {
                muralBool = true
                break
            }
            else {
                muralBool = false
            }
        }
        if muralBool {
            completion(counter)
            return true
        }
        else {
            return false
        }
    }
    
    func saveToPersistentStore() {
        
    }
    
    func loadFromPersistentStore(){
        
    }
    
    func addCommentTo(mural: Mural, text: String){
        let newComment = Comment(text: text)
        mural.comments.append(newComment)
        
    }
}
