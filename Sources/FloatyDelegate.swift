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
@objc public protocol FloatyDelegate
{
    /**
     Indicates that the user has tapped on a FAB widget that does not
     contain any defined sub items.
     - parameter fab: The FAB widget that was selected by the user.
     */
    @objc optional func emptyFloatySelected(_ floaty: Floaty)
    
    @objc optional func floatyWillOpen(_ floaty: Floaty)
    
    @objc optional func floatyDidOpen(_ floaty: Floaty)
    
    @objc optional func floatyWillClose(_ floaty: Floaty)
    
    @objc optional func floatyDidClose(_ floaty: Floaty)
    
    /**
     This method has been deprecated. Use floatyWillOpen and floatyDidOpen instead.
     */
    @objc optional func floatyOpened(_ floaty: Floaty)
    
    /**
     This method has been deprecated. Use floatyWillClose and floatyDidClose instead.
     */
    @objc optional func floatyClosed(_ floaty: Floaty)
}
