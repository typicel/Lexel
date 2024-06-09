//
//  SegmentedPicker.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/8/24.
//

import SwiftUI

struct SegmentedPicker<SelectionValue, Content>: View
where SelectionValue: Hashable, Content: View {
    
    @Binding var _selection: SelectionValue?
    
    @Binding var _items: [SelectionValue]
    
    private var selectionColor: Color = .blue
    
    private var content: (SelectionValue) -> Content
    
    init(
        selection: Binding<SelectionValue?>,
        items: Binding<[SelectionValue]>,
        selectionColor: Color = .blue,
        @ViewBuilder content: @escaping (SelectionValue) -> Content
    ) {
        _selection = selection
        _items = items
        self.selectionColor = selectionColor
        self.content = content
    }
    
    
    var body: some View {
        
    }
}

#Preview {
    SegmentedPicker()
}
