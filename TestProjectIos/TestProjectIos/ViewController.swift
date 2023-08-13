import UIKit
import Combine

class QuoteViewController: UIViewController {
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .blue
        button.configuration = config
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let viewModel = QuoteViewModel()
    private let input: PassthroughSubject<Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] receivedValue in
            guard let self = self else { return }
            switch receivedValue {
            case .fetchQuoteDidFail(error: let error):
                self.label.text = error.localizedDescription
            case .toggleButton(isEnabled: let isEnabled):
                self.button.isEnabled = isEnabled
            case .fetchQuoteDidSuccess(quote: let model):
                self.label.text = model.content
            }
        }
        .store(in: &cancellables)
    }
    
    private func setUI() {
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        view.addSubview(button)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        button.addTarget(self, action: #selector(refreshButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func refreshButtonDidTap() {
        input.send(.refreshButtonDidTap)
    }
}



import Foundation
import Combine

enum Input {
    case viewDidAppear
    case refreshButtonDidTap
}

enum Output {
    case fetchQuoteDidFail(error: Error)
    case fetchQuoteDidSuccess(quote: QuoteModel)
    case toggleButton(isEnabled: Bool)
}

class QuoteViewModel: ObservableObject {
    private let dataService: DataService
    private let output: PassthroughSubject<Output, Never> = .init()
    private let output2: CurrentValueSubject<Output, Never> = .init(.toggleButton(isEnabled: true))
    private var cancellables = Set<AnyCancellable>()
    init(dataService: DataService = QuoteService(urlString: "https://api.quotable.io/random")) {
        self.dataService = dataService
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] receivedValue in
                guard let self = self else { return }
            switch receivedValue {
            case .refreshButtonDidTap, .viewDidAppear:
                self.handleGetRandomQuote()
            }
        }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func handleGetRandomQuote() {
        output.send(.toggleButton(isEnabled: false))
        dataService.getRandomData()
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.output.send(.toggleButton(isEnabled: true))
                switch completion {
                case .failure(let error):
                    self.output.send(.fetchQuoteDidFail(error: error))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] receivedValue in
                guard let self = self else { return }
                self.output.send(.fetchQuoteDidSuccess(quote: receivedValue))
            }
            .store(in: &cancellables)
    }
    
}



import Foundation
import Combine

protocol DataService {
    func getRandomData() -> AnyPublisher<QuoteModel, Error>
}

class QuoteService: DataService {
    
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func getRandomData() -> AnyPublisher<QuoteModel, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError.badURL as! Error).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map {$0.data}
            .decode(type: QuoteModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}


import Foundation

struct QuoteModel: Codable {
    let content: String
    let author: String
}
