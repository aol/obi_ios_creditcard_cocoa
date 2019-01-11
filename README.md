
## Installation with CocoaPods

Please use CocoaPods to install this library. Just add the below code in your Podfile and run **pod install**.

```
pod 'OBICardTokenization', '= 0.0.12'
```


## Usage

To use this library, you need to call **tokenizePaymentMethod()** with the following parameters:

**cardNumber**: card's id number. There are three card number formats that the library supports:

1. With hyphens: 4444-4444-4444-4448
2. With spaces: 4444 4444 4444 4448
3. Without spaces and hyphens: 4444444444444448

**cvv**: card's cvv code
  
**domain**: there are 3 domain types to pick from (QA, PROD, DEV), depending on your project state and whether you want to test or go live.
  
### Example:  

```swift
import OBICardTokenization

let cardNumber = "4444-4444-4444-4448"
let cvv = "123"
OBICardTokenizationManager.tokenizePaymentMethod(cardNumber: cardNumber, cvv: cvv, domain: .QA, completionBlock: { [weak self] (accountNumber, error) in
         
         if let e = error{
         	return
         }
         
      //use accountNumber 
})
```

