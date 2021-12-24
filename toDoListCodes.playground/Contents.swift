import UIKit

import Foundation

struct Task {
    var title: String
    var done: Bool
}



class ViewController: UIViewController {

    @IBOutlet weak var mustDoTableView: UITableView!
    
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mustDoTableView.dataSource = self //dataSource를 가져오는 것.
        //이거랑 reloadData() 둘 중 하나라도 없으면 등록이 안된다.
    }

    @IBAction func tabEditButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func tabAddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "MustDo", message: nil, preferredStyle: .alert)
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            guard let title = alert.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            self?.tasks.append(task) // ?안하면 append할 수 없음. 이유는 찾아보기.
            self?.mustDoTableView.reloadData() // 할 일 등록할 때마다 화면을 갱신하는 것.
            
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력해주세요."
        })
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        // "tasks"에 대한 value가 Any?타입으로 반환되는데, 이 Any를 [[String: Any]] 로 타입캐스팅한 것.
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else { return nil }
            return Task(title: title, done: done)
        }
        
    }
    
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)// cell 위치를 잡음.
        let task = self.tasks[indexPath.row] // 위치에 맞는 요소값을 꺼냄.
        cell.textLabel?.text = task.title
        //현재 보여지는 cell의 textField에 알맞는 tasks[indexPath.row] 요소를 넣은 것.
        return cell
    }

}

