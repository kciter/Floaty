//
//  KCFloatingActionButtonDelegate.swift
//  FAB Testing
//
//  Created by Nathan Russak on 2/23/16.
//  Copyright © 2016 Nathan Russak. All rights reserved.
//

import Foundation

/**
 Optional delegate that can be used to be notified whenever the user
 taps on a FAB that does not contain any sub items.
 */
@objc public protocol KCFloatingActionButtonDelegate
{
    /**
     Indicates that the user has tapped on a FAB widget that does not
     contain any defined sub items.
     - parameter fab: The FAB widget that was selected by the user.
     */
    @objc optional func emptyKCFABSelected(_ fab: KCFloatingActionButton)
    
    @objc optional func KCFABOpened(_ fab: KCFloatingActionButton)
    
    @objc optional func KCFABClosed(_ fab: KCFloatingActionButton)
}
