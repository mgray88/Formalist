//
//  FormValue.swift
//  Formalist
//
//  Created by Indragie Karunaratne on 2016-05-25.
//  Copyright © 2016 Seed Platform, Inc. All rights reserved.
//

/// A reference type that wraps a value used by a form element and allows for
/// observation of changes to the value.
public final class FormValue<ValueType: Equatable> {
    fileprivate var observerTokens = [ObserverToken<ValueType>]()
    
    /// The underlying value.
    public var value: ValueType {
        get { return _value }
        set {
            guard _value != newValue else { return }
            _value = newValue
            for token in observerTokens {
                token.observer(value)
            }
        }
    }
    fileprivate var _value: ValueType
    
    /**
     Initializes the receiver with an initial value
     
     - parameter initialValue: The initial value
     
     - returns: An initialized instance of the receiver
     */
    public init(_ initialValue: ValueType) {
        self._value = initialValue
    }
    
    /**
     Adds an observer to the list of observers for `value`
     
     - parameter observer: A closure that is invoked when `value` changes.
     The parameter passed to the closure is the updated value.
     
     - returns: A token that can be used to remove the added observer
     */
    public func addObserver(_ observer: @escaping (ValueType) -> Void) -> ObserverToken<ValueType> {
        let token = ObserverToken(observer: observer)
        observerTokens.append(token)
        return token
    }
    
    /**
     Removes an observer from the list of observers for `value`
     
     - parameter token: The token for the observer to remove
     
     - returns: A boolean value that indicates whether the observer was removed,
     which will be `true` if the token represented an existing observer, or `false`
     if not.
     */
    public func removeObserverWithToken(_ token: ObserverToken<ValueType>) -> Bool {
        if let index = observerTokens.firstIndex(of: token) {
            observerTokens.remove(at: index)
            return true
        } else {
            return false
        }
    }
}

/// A token that represents an observer. This is returned from `FormValue.addObserver(_:)`
/// and passed into `FormValue.removeObserverWithToken(_:)`
public final class ObserverToken<ValueType>: Equatable {
    fileprivate typealias Observer = (ValueType) -> Void
    fileprivate let observer: Observer
    
    fileprivate init(observer: @escaping Observer) {
        self.observer = observer
    }
}

public func ==<ValueType>(lhs: ObserverToken<ValueType>, rhs: ObserverToken<ValueType>) -> Bool {
    return lhs === rhs
}
