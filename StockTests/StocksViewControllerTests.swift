//
//  StockViewControllerTests.swift
//  Stock
//
//  Created by Kim Younghoo on 8/23/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import XCTest
@testable import Stock

final class StocksViewControllerTests: XCTestCase {
    
    var vc: StocksViewController!
    
    override func setUp() {
        super.setUp()
        
        do {
            Store.shared.dbFileName = "test.db.sqlite3"
            Store.shared.connectDb()
            try Store.shared.createTables()
        } catch{
            
        }
        
        vc = StocksViewController()
        let _ = vc.view
    }
    
    override func tearDown() {
        super.tearDown()
        do {
            try Store.shared.dropTables()
        }catch {
            
        }

    }
    
    func testStocksViewControllerInit() {
        XCTAssertNotNil(vc)
    }
    
    func testStocksViewControllerTitle() {
        XCTAssertEqual(vc.title, "Stocks")
    }
    
    func testStocksViewControllerHasTableView() {
        XCTAssertNotNil(vc.tableView)
    }
    
    func testStocksViewControllerIsTableViewDataSource() {
        XCTAssert(vc.tableView?.dataSource is StocksViewController)
    }
    
    func testStocksViewControllerNumberOfRows() {
        XCTAssertEqual(vc.tableView?.numberOfSections, 1)
        XCTAssertEqual(vc.tableView?.numberOfRows(inSection: 0), 0)
        
        let stock = Stock(stockId: nil, code: "001100", name: "A", currentPrice: 15000, priceDiff: 100, rateDiff: 0.5, isPriceUp: true, isPriceKeep: false)
        vc.stocks.append(stock)
        vc.tableView?.reloadData()
        XCTAssertEqual(vc.tableView?.numberOfRows(inSection: 0), 1)
    }
    
    func testCellForRowShouldReturnStockTableViewCell() {
        let stock = Stock(stockId: nil, code: "001100", name: "A", currentPrice: 15000, priceDiff: 100, rateDiff: 0.5, isPriceUp: true, isPriceKeep: false)
        vc.stocks.append(stock)
        vc.tableView?.reloadData()
        
        let cell = vc.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! StockTableViewCell
        XCTAssertEqual(cell.nameLabel?.text, "A")
    }
    
    func testStocksViewControllerIsTableViewDelegate() {
        XCTAssert(vc.tableView?.delegate is StocksViewController)
    }
    
    func testStocksViewControllerHeightForRow() {
        XCTAssertEqual(vc.tableView(vc.tableView, heightForRowAt: IndexPath(row: 0, section: 0)), StockTableViewCell.height)
    }
}







