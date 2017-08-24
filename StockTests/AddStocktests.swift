//
//  AddStocktests.swift
//  Stock
//
//  Created by 성준영 on 2017. 8. 24..
//  Copyright © 2017년 0hoo. All rights reserved.
//

import XCTest
@testable import Stock

// MockObject 를 만들어주는 프레임워크를 쓰면 훨씬 간단

final class MockAskStockCodeService: AskStockCodeProtocol{

    var presentCount = 0
    var returnStockCode: String?
    
    init(stockCode: String?){
        returnStockCode = stockCode
    }
    
    func ask(presentingViewController: UIViewController, onStockCode:@escaping (String) -> ()){
        presentCount += 1
        if let returnStockCode = returnStockCode {
            onStockCode(returnStockCode)
        }
    }
}

final class MockSearchStockService: SearchStockProtocol {
    var acceptedStockCode: String?
    var stockToReturn: Stock?
    func search(stockCode: String, onStock: @escaping (Stock) -> ()){
        acceptedStockCode = stockCode
        if let stockToReturn = stockToReturn {
            onStock(stockToReturn)
        }
    }
}

final class MockProgressHudService: ProgressHudProtocol {
    var showCount = 0
    var dismissCount = 0
    func show() {
        showCount += 1
    }
    
    func dismiss() {
        dismissCount += 1
    }
}

final class AddStocktests: XCTestCase {
    
    var vc: StocksViewController!
    
    override func setUp() {
        super.setUp()
        vc = StocksViewController()
        do {
            Store.shared.dbFileName = "test.db.sqlite3"
            Store.shared.connectDb()
            try Store.shared.createTables()
        } catch{
            
        }

        let _ = vc.view
    }
    
    override func tearDown() {
        super.tearDown()
        do {
            try Store.shared.dropTables()
        }catch {
            
        }
    }
    
    func testRightBarButtonItem(){
        XCTAssertNotNil(vc.navigationItem.rightBarButtonItem)
        XCTAssertEqual(vc.navigationItem.rightBarButtonItem?.action, #selector(StocksViewController.newStock))
    }
    
    func testNewStockShouldPresentAlert() {
        let fakeAskStockCodeService = MockAskStockCodeService(stockCode: nil)
        vc = StocksViewController(askStockCodeService: fakeAskStockCodeService)
        let _ = vc.view
        
        XCTAssertEqual(fakeAskStockCodeService.presentCount, 0)
        vc.newStock()
        XCTAssertEqual(fakeAskStockCodeService.presentCount, 1)
        
        // UI
        
    }
    
    func testEnterStockCodeCallSearchStock() {
        // stub 은 여러개가 될 수 있지만, fake 는 하나만 되어야한다.
        let stockCode = "00001"
        let stubAskStockCodeService = MockAskStockCodeService(stockCode: stockCode)
        let fakeSearchStockService = MockSearchStockService()
        vc = StocksViewController(askStockCodeService: stubAskStockCodeService, searchStockService: fakeSearchStockService)
    
        vc.newStock()
        XCTAssertEqual(fakeSearchStockService.acceptedStockCode, stockCode)
        
        // Network (Alamofire HTTP Request, HTML Parsing)
    }
    
    func testSearchStockShouldIncreaseStockCount() {
        let stockCode = "00001"
        let stubAskStockCodeService = MockAskStockCodeService(stockCode: stockCode)
        let fakeSearchStockService = MockSearchStockService()
        
        fakeSearchStockService.stockToReturn = Stock(stockId: nil, code: "0011", name: "삼성전자", currentPrice: 1200, priceDiff: 120, rateDiff: 10, isPriceUp: true, isPriceKeep: true)
        
        vc = StocksViewController(askStockCodeService: stubAskStockCodeService, searchStockService: fakeSearchStockService)
        let _ = vc.view
    
        XCTAssertEqual(vc.tableView.numberOfRows(inSection: 0), 0)
        vc.newStock()
        XCTAssertEqual(vc.tableView.numberOfRows(inSection: 0), 1)

        let cell = vc.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! StockTableViewCell
        XCTAssertNotNil(cell.stock?.stockId)
        XCTAssertEqual(cell.stock?.code, fakeSearchStockService.stockToReturn?.code)
        
        // Database
    }
    
    func testAddStockProgressHud(){
        let stockCode = "00001"
        let stubAskStockCodeService = MockAskStockCodeService(stockCode: stockCode)
        let stubSearchStockService = MockSearchStockService()
        
        stubSearchStockService.stockToReturn = Stock(stockId: nil, code: "0011", name: "삼성전자", currentPrice: 1200, priceDiff: 120, rateDiff: 10, isPriceUp: true, isPriceKeep: true)
        
        let fakeProgressHudService = MockProgressHudService()
        
        vc = StocksViewController(askStockCodeService: stubAskStockCodeService,
                                  searchStockService: stubSearchStockService,
                                  progressHudService: fakeProgressHudService)
        
        let _ = vc.view
        
        XCTAssertEqual(fakeProgressHudService.showCount, 0)
        XCTAssertEqual(fakeProgressHudService.dismissCount, 0)
        vc.newStock()

        XCTAssertEqual(fakeProgressHudService.showCount, 1)
        XCTAssertEqual(fakeProgressHudService.dismissCount, 1)

    }
}
