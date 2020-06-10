//
//  CardLinkingViewModel.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/8.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CardLinkingViewModel {
    var card: Card = Card()
    let isValidCard: PublishSubject<Bool> = PublishSubject()
    
    func saveCard(nickname:String, cardNumber: String, cardHolder:String, expiryMonth:String, expiryYear: String, cvv: String) {
        if cardNumber.count != 16 || expiryMonth.count != 2 || expiryYear.count != 2 || cvv.count != 3 {
            isValidCard.onNext(false)
            return
        }
        if let mon = Int(expiryMonth) {
            if mon > 12 {
                isValidCard.onNext(false)
                return
            }
        }
        card.name = nickname
        card.cardNumber = cardNumber
        card.holderName = cardHolder
        card.expiryDate = expiryMonth + "/" + expiryYear
        card.cvv = cvv
        DBManager.sharedInstance.cardRepository.create(card: card)
        isValidCard.onNext(true)
    }
}
