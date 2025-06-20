//
//  PortfolioDataService.swift
//  CryptoTracker
//
//  Created by MAC on 20/06/2025.
//

import Foundation
import CoreData


class PortfolioDataService{
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioCointainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        //initailize core data container
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error{
                print("Error loading coredata")
                print(error.localizedDescription)
            }
            self.getPortfolio()
        }
    }
    
    // MARK: PUBLIC METHODS
    
    func updatePortfolio(coin: Coin, amount: Double){
        
        //check if the coin is already in the portfolio
        if let entity = savedEntities.first(where: {$0.coinId == coin.id}){
            if amount > 0 {
                updateEntiy(entity: entity, amount: amount)
            }else{
                remove(entity: entity)
            }
        }else{
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK: PRIVATE METHODS
    
    //get portfolio data from core data and assign to savedEntities array
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        }catch let error{
            print("Failed to fetch data from context \(error.localizedDescription)")
        }
    }
    
    private func updateEntiy(entity: PortfolioEntity, amount: Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func remove(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    //add a coin to the portfolio and presist it in core data
    private func add(coin: Coin, amount: Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amount
        applyChanges()
        
    }
    
    //save the changes made to the portfolio in core data
    private func save(){
        do {
           try container.viewContext.save()
        }catch let error{
            print("Failed to save changes to coredata: \(error.localizedDescription)")
        }
    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
}
