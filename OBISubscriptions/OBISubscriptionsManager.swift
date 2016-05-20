/*
 
 * AMERICA ONLINE CONFIDENTIAL INFORMATION
 
 *
 
 * Copyright (c) 2016 AOL Inc
 
 *
 
 * All Rights Reserved.  Unauthorized reproduction, transmission, or
 
 * distribution of this software is a violation of applicable laws.
 
 */

import Foundation

public let kOBISubscriptionsErrorDomain = "kOBISubscriptionsErrorDomain"

public typealias OBIInfoResultBlock = ([String]?, NSError?, String) -> Void
public typealias OBISubscribeResultBlock = (NSError?) -> Void

private let unknownErrorDescription = "Unknown error"

public class OBISubscriptionsManager {
    
    //Subscriptions/Cards info
    public class func cardsForEmail(email: String, completionBlock: OBIInfoResultBlock) {
        NetworkManager.sharedManager.creditCardsForEmail(email) { (cardModels, error) in
            if let cards = cardModels {
                var values = [String]()
                for card in cards {
                    values.append(card.paymentType + " " + card.lastFourDigits)
                }
                completionBlock(values, nil, cards.first?.guid ?? "")
            } else if let e = error {
                completionBlock(nil, e, "")
            } else {
                completionBlock(nil, nil, "")
            }
        }
    }
    
    public class func subscriptionsForEmail(email: String, completionBlock: OBIInfoResultBlock) {
        NetworkManager.sharedManager.subscriptionsForEmail(email) { (subscriptionModels, error) in
            if let subscriptions = subscriptionModels {
            var values = [String]()
            for subscription in subscriptions {
                values.append(subscription.offerName + " $" + subscription.salePrice)
            }
                completionBlock(values, nil, subscriptions.first?.guid ?? "")
            } else if let e = error {
                completionBlock(nil, e, "")
            } else {
                completionBlock(nil, nil, "")
            }
        }
    }
    
    //Subscribe
    public class func subscribeWithEmail(email: String,
        price: String,
        idNumber: String,
        cvv: String,
        month: String,
        year: String,
        firstName: String,
        lastName: String,
        address: String,
        city: String,
        state: String,
        zip: String,
        completionBlock: OBISubscribeResultBlock) {
        
        let userData = UserData()
        userData.email = email
        userData.price = price
        userData.idNumber = idNumber
        userData.cvv = cvv
        userData.month = month
        userData.year = year
        userData.firstName = firstName
        userData.lastName = lastName
        userData.address = address
        userData.city = city
        userData.state = state
        userData.zip = zip
        
        getRequestTokenForEmail(email) { (requestToken, error) in
            if let token = requestToken {
                tokenizePaymentMethod(userData, requestToken: token, completionBlock: { (cardToken, error) in
                    if let token = cardToken {
                        setupPaymentMethod(token, userData: userData, completionBlock: { (paymentMethod, error) in
                            if let method = paymentMethod {
                                subscribe(method, userData: userData, completionBlock: { (error) in
                                    completionBlock(error)
                                })
                            } else {
                                completionBlock(error)
                            }
                        })
                    } else {
                        completionBlock(error)
                    }
                })
            } else {
                completionBlock(error)
            }
        }
    }
}

private extension OBISubscriptionsManager {
    
    class func getRequestTokenForEmail(email: String, completionBlock: (RequestTokenModel?, NSError?) -> Void) {
        NetworkManager.sharedManager.getRequestToken(email) { (requestToken, error) in
            completionBlock(requestToken, error)
        }
    }
    
    class func tokenizePaymentMethod(userData: UserData, requestToken: RequestTokenModel, completionBlock: (CardTokenModel?, NSError?) -> Void) {
        let key = requestToken.reqToken.stringByReplacingOccurrencesOfString("-", withString: "")
        let encryptedString = EncryptionManager.sharedManager.encryptCard(userData.idNumber, cvv: userData.cvv, usingKey: key)
        NetworkManager.sharedManager.tokenizePaymentMethod(requestToken.authToken,
            guid: requestToken.guid,
            encryptedString: encryptedString)
            { (cardToken, error) in
                if let token = cardToken {
                    if !token.token.isEmpty {
                        completionBlock(cardToken, nil)
                    } else {
                        completionBlock(nil, errorFromString(token.error))
                    }
                } else {
                    completionBlock(nil, error ?? errorFromString(nil))
                }
        }
    }
    
    class func setupPaymentMethod(cardToken: CardTokenModel, userData: UserData, completionBlock: (PaymentMethodModel?, NSError?) -> Void) {
        NetworkManager.sharedManager.setupPaymentMethod(userData.email, token: cardToken.token, userData: userData) { (paymentMethod, error) in
            if let payment = paymentMethod {
                if !payment.pmId.isEmpty {
                    completionBlock(payment, nil)
                } else {
                    completionBlock(nil, errorFromString(payment.errorMsg))
                }
            } else {
                completionBlock(nil, error ?? errorFromString(nil))
            }
        }
    }
    
    class func subscribe(paymentMethod: PaymentMethodModel, userData: UserData, completionBlock: (NSError?) -> Void) {
        NetworkManager.sharedManager.subscribe(userData.email, pmId: paymentMethod.pmId, price: userData.price) { (model, error) in
            if model != nil {
                completionBlock(nil)
            } else {
                completionBlock(error ?? errorFromString(nil))
            }
        }
    }
    
    class func errorFromString(errorString: String?) -> NSError {
        return NSError(domain: kOBISubscriptionsErrorDomain,
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: errorString ?? unknownErrorDescription])
    }
}
