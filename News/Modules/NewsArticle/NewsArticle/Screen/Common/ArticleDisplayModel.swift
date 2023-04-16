//  Created by Nithi Kulasiriswatdi

import Utils

struct ArticleDisplayModel: Hashable {
    let title: String
    let imageURL: String
    let date: Date?
    let displayDate: String
    let author: String
    let sourceURL: String
    let description: String
    let articleURL: String
    let content: String
    
    /// Init DisplayModel
    /// - Parameters:
    ///   - title: article's title
    ///   - imageURL: article's imageURL
    ///   - date: article's date (raw date)
    ///   - author: article's author
    ///   - sourceURL: article's sourceURL
    ///   - description: article's description
    ///   - articleURL: article's url
    ///   - content: article's conent
    init(
        title: String,
        imageURL: String,
        date: String,
        author: String,
        sourceURL: String,
        description: String,
        articleURL: String,
        content: String
    ) {
        self.title = title
        self.imageURL = imageURL
        self.date = date.toDate()
        if let date = self.date {
            self.displayDate = date.timeAgo() + " ago"
        } else {
            self.displayDate = "At sometime"
        }
        self.author = author.replacingOccurrences(of: "by", with: "", options: [.caseInsensitive])
        self.sourceURL = sourceURL
        self.description = description
        self.articleURL = articleURL
        self.content = content
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func == (lhs: ArticleDisplayModel, rhs: ArticleDisplayModel) -> Bool {
        return lhs.title == rhs.title
    }
}
