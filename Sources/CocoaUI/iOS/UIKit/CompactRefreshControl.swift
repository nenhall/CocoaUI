//
//  File.swift
//  
//
//  Created by nenhall on 5/14/25.
//

#if os(iOS)
import Foundation
import UIKit

public class CompactRefreshControl: UIRefreshControl {
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.origin.y = -80
    }
}
#endif
