import UIKit
// 불러오는 라이브러리가 적을수록 좋은코드

final class StocksViewController: UIViewController {
    
    let askStockCodeService: AskStockCodeProtocol
    let searchStockService: SearchStockProtocol
    let progressHudService: ProgressHudProtocol
    
    var stocks: [Stock] = []
    
    init(askStockCodeService: AskStockCodeProtocol = AskStockCodeService(),
         searchStockService: SearchStockProtocol = SearchStockService(),
         progressHudService: ProgressHudProtocol = ProgressHudService()){
        self.askStockCodeService = askStockCodeService
        self.searchStockService = searchStockService
        self.progressHudService = progressHudService
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Stocks"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(StocksViewController.newStock))
        
        tableView?.dataSource = self
        tableView?.register(UINib(nibName: StockTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: StockTableViewCell.reuseIdentifier)
        tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        
        reload()
    }
    
    func newStock() {
        askStockCodeService.ask(presentingViewController: self) { (stockCode) in
            self.searchStock(stockCode: stockCode)
        }
    }
    
    func searchStock(stockCode: String) {
        self.progressHudService.show()
        searchStockService.search(stockCode: stockCode) { (stock) in
            self.progressHudService.dismiss()
            StockManager.save(stock)
            self.reload()
        }
    }
    
    func reload() {
        stocks = StockManager.findAll()
        tableView.reloadData()
    }
}

extension StocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.reuseIdentifier) as! StockTableViewCell
        
        let stock = stocks[indexPath.row]
        cell.stock = stock
        
        return cell
    }
}

extension StocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StockTableViewCell.height
    }
}





