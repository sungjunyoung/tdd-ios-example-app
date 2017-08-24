//
//import XCTest
//
//class StocksViewControllerUITests: XCTestCase {
//    
//    override func setUp() {
//        super.setUp()
//        
//        continueAfterFailure = false
//        XCUIApplication().launch()
//    }
//    
//    override func tearDown() {
//        super.tearDown()
//    }
//    
//    func testTapRightNavigationBarButtonShowStockCodeAlert(){
//        let app = XCUIApplication()
//        XCTAssertEqual(app.alerts.count, 0)
//        app.navigationBars["Stocks"].buttons["Add"].tap()
//        let alert = app.alerts["주식"]
//        XCTAssertNotNil(alert)
//        XCTAssertEqual(app.alerts.count, 1)
//    }
//    
//    func testEnterStockCodeSaveNewStock(){
//        
//    }
//    
//}
