//
//  ViewExtension.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 16/10/23.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}
