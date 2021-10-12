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
        ArticleListView(
            articles: presenter.articles,
            onTapArticle: { article in
                presenter.viewEventSubject.send(.didSelect(article: article))
            }
        )
        .alert(item: $presenter.articleSearchError) { error in
            Alert(
                title: .init("記事の取得に失敗しました"),
                message: .init("時間をおいて再度お試しください"),
                dismissButton: nil
            )
        }.navigationBarTitle(Text("Articles"), displayMode: .large)
        .onAppear {
            presenter.viewEventSubject.send(.viewDidLoad)
        }
    }
}

extension ArticleSearchView {
    struct ArticleListView: View {
        let articles: [ArticleModel]
        let onTapArticle: (ArticleModel) -> Void
        
        var body: some View {
            List(articles) { article in
                HStack {
                    Text(article.title)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onTapArticle(article)
                }
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
            ],
            onTapArticle: { _ in }
        )
    }
}
