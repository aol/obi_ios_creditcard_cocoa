## Installation with CocoaPods

Please use CocoaPods to install this library. Just add the below code in your Podfile and run **pod install**.

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'OBICardTokenization', :git => 'https://github.com/aol/obi_ios_creditcard_cocoa.git', :tag => '0.0.14'
end
```


## Usage

To use this library, you need to call **tokenizePaymentMethod()** with the following parameters:

**cardNumber**: card's id number
  
**cvv**: card's cvv code
  
**domain**: there are 3 domain types to pick from (QA, PROD, DEV), depending on your project state and whether you want to test or go live.
  
### Example:  

```swift
let cardNumber = "4444-4444-4444-4448"
let cvv = "123"
OBICardTokenizationManager.tokenizePaymentMethod(cardNumber: cardNumber, cvv: cvv, domain: .QA, completionBlock: { [weak self] (accountNumber, error) in
         
         if let e = error{
         	return
         }
         
      //use accountNumber 
})
```

##OBI iOS cocoa pod for credit card tokenization

Tags(_Versions_) for Cocoa Pods:

0.0.5 - Swift 2.3, without other pods(CryptoSwift). Only project without workspace.

0.0.6 - Swift 3.0

0.0.7 - Tokenization URL set outside the library



