//
//  Binding+Extention.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/12/17.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

extension Binding {
    
    init<T>(isNotNil source: Binding<T?>, defaultValue: T) where Value == Bool {
        self.init(get: { source.wrappedValue != nil },
                  set: { source.wrappedValue = $0 ? defaultValue : nil })
    }
    
    init(_ source: Binding<Value?>, _ defaultValue: Value) {
        
        self.init(get:{
            if source.wrappedValue == nil {
                source.wrappedValue = defaultValue
            }
            return source.wrappedValue ?? defaultValue
            
        },set:{
            source.wrappedValue = $0
        })
    }

}

