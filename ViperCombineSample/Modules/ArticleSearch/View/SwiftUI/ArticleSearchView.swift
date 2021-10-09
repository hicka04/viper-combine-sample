//
//  ArticleSearchView.swift
//  ViperCombineSample
//
//  Created by hicka04 on 2021/10/09.
//

import SwiftUI

struct ArticleSearchView: View {
    @ObservedObject var presenter: ArticleSearchPresenter
    
    var body: some View {
        ArticleListView(articles: presenter.articles.elements)
            .onAppear {
                presenter.viewEventSubject.send(.viewDidLoad)
            }
    }
}

extension ArticleSearchView {
    struct ArticleListView: View {
        var articles: [ArticleModel]
        
        var body: some View {
            List(articles) { article in
                Text(article.title)
            }.listStyle(.plain)
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleSearchView.ArticleListView(
            articles: [
                .init(
                    id: .init(rawValue: "hoge"),
                    title: "短いタイトル",
                    body: "ほげ"
                ),
                .init(
                    id: .init(rawValue: "fuga"),
                    title: "長いタイトル長いタイトル長いタイトル長いタイトル長いタイトル長いタイトル長いタイトル長いタイトル長いタイトル長いタイトル",
                    body: "ふが"
                )
            ]
        )
    }
}
