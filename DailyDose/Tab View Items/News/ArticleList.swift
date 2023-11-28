//
//  ArticleList.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

/*
 Used for news Feed
 */
public class ArticleList: ObservableObject {

    @Published var articles = [NewsStruct]()

    //private var articles = [NewsStruct]()

    private var size: Int = 0
    private let newsHeaders = [
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "newsapi.org"
    ]


    /*
     Add an article to the list
     */
    func add(article: NewsStruct) {
        articles.append(article)
        size += 1
    }

    /*
     Get the size
     */
    func getSize() -> Int {
        return size
    }

    /*
     Clear the array of articles
     */
    func clear() {
        articles.removeAll()
        size = 0
    }

    func get() -> [NewsStruct] {
        return articles
    }



    func getNewsArticlesFromApi(trending: Bool, source: String, query: String) {

        self.clear()
        let apiUrlString = getRequestUrl(trending: trending, source: source, query: query)

            /* wired, bbc-news, abc-news, engadget, business-insider, the-washington-post
             usa-today, cnn, cbs-news */


        var jsonDataFromApi: Data
        let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: newsHeaders, apiUrl: apiUrlString, timeout: 20.0)
        if let jsonData = jsonDataFetchedFromApi {
            jsonDataFromApi = jsonData
        } else { return }

        /*
        **************************************************
        *   Process the JSON Data Fetched from the API   *
        **************************************************
        */
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                               options: JSONSerialization.ReadingOptions.mutableContainers)

            if let jsonObject = jsonResponse as? [String: Any] {

    /*
    {"status":"ok","totalResults":55687,"articles":[
     {"source":{"id":"engadget","name":"Engadget"},"author":"Kris Holt","title":"Apple TV+ prices have doubled in just over a year","description":"Apple is jacking up the prices of several of its subscription services. The price increases to Apple TV+, Apple Arcade and Apple News+ will take effect immediately for newcomers. It's not yet clear when existing subscribers will start paying the higher rates.…","url":"https://www.engadget.com/apple-tv-prices-have-doubled-in-just-over-a-year-150156333.html","urlToImage":"https://s.yimg.com/ny/api/res/1.2/5TBZxGFqcYl8_ZZN2pxMWw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD04MDA-/https://s.yimg.com/os/creatr-uploaded-images/2023-09/a9429540-5292-11ee-a7fa-a08df0c75075","publishedAt":"2023-10-25T15:01:56Z","content":"Apple is jacking up the prices of several of its subscription services. The price increases to Apple TV+, Apple Arcade and Apple News+ will take effect immediately for newcomers. It's not yet clear w… [+1966 chars]"
     },
     {"source":{"id":"the-verge","name":"The Verge"},"author":"Emma Roth","title":"Apple TV Plus is getting a price hike — and other Apple subscriptions are, too","description":"Apple is increasing the price on Apple Arcade, Apple News Plus, and the Apple One bundle. Apple TV Plus is going from $6.99 per month to $9.99 per month.","url":"https://www.theverge.com/2023/10/25/23931577/apple-tv-plus-news-arcade-one-subscription-price-increase","urlToImage":"https://cdn.vox-cdn.com/thumbor/2QP05YUbQ5-8yF2RFEUloacoiQg=/0x0:2040x1360/1200x628/filters:focal(1020x680:1021x681)/cdn.vox-cdn.com/uploads/chorus_asset/file/23988689/acastro_STK069_appleTVPlus_02.jpg","publishedAt":"2023-10-25T14:04:41Z","content":"Apple TV Plus is getting a price hike and other Apple subscriptions are, too\r\nApple TV Plus is getting a price hike and other Apple subscriptions are, too\r\n / Apple Arcade, Apple News Plus, and the A… [+1329 chars]"
     },
    */

                if let arrayOfFoundNews = jsonObject["articles"] as? [Any] {
    /*
    {"source":{"id":"engadget","name":"Engadget"},"author":"Kris Holt","title":"Apple TV+ prices have doubled in just over a year","description":"Apple is jacking up the prices of several of its subscription services. The price increases to Apple TV+, Apple Arcade and Apple News+ will take effect immediately for newcomers. It's not yet clear when existing subscribers will start paying the higher rates.…","url":"https://www.engadget.com/apple-tv-prices-have-doubled-in-just-over-a-year-150156333.html","urlToImage":"https://s.yimg.com/ny/api/res/1.2/5TBZxGFqcYl8_ZZN2pxMWw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD04MDA-/https://s.yimg.com/os/creatr-uploaded-images/2023-09/a9429540-5292-11ee-a7fa-a08df0c75075","publishedAt":"2023-10-25T15:01:56Z","content":"Apple is jacking up the prices of several of its subscription services. The price increases to Apple TV+, Apple Arcade and Apple News+ will take effect immediately for newcomers. It's not yet clear w… [+1966 chars]"
    },
    */

                    // Iterate over the array
                    for source in arrayOfFoundNews {

                        // Intializations of NewsStruct
                        var name = ""
                        var author = ""
                        var title = ""
                        var description = ""
                        var url = ""
                        var urlToImage = ""
                        var publishedAt = ""
                        var content = ""

                        let article = source as? [String: Any]

                        // Source Name
                        if let sourceName = article!["source"] as? [String: Any] {
                            if let temp = sourceName["name"] as? String {
                                name = temp
                            }
                        }

                        // Get Article Author
                        if let articleAuthor = article!["author"] as? String {
                            author = articleAuthor
                        }

                        // Get Article Title
                        if let articleTitle = article!["title"] as? String {
                            title = articleTitle
                        }

                        // Get Article Description
                        if let articleDescription = article!["description"] as? String {
                            description = articleDescription
                        }

                        // Get article url
                        if let articleUrl = article!["url"] as? String {
                            url = articleUrl
                        }

                        // Get article url
                        if let imageUrl = article!["urlToImage"] as? String {
                            urlToImage = imageUrl
                        }

                        if let articleDate = article!["publishedAt"] as? String {
                            publishedAt = articleDate
                        }

                        if let articleContent = article!["content"] as? String {
                            content = articleContent
                        }

                        let newNewsFound = NewsStruct(name: name, author: author, title: title, description: description, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)

                        //foundNewsList.append(newNewsFound)

                        articles.append(newNewsFound)
                        size += 1

                    }   // End of for loop
                } else { return}
            } else { return }
        } catch { return }

        return
    }


    private func getRequestUrl(trending: Bool, source: String, query: String) -> String {

        var apiUrlString = "https://newsapi.org/v2/"
        if trending {
            apiUrlString = apiUrlString + "top-headlines?"

            if !query.isEmpty {
                apiUrlString = apiUrlString + "q=" + query + "&"
            }

            if !source.isEmpty {
                apiUrlString = apiUrlString + "sources=" + source.replacingOccurrences(of: " ", with: "-") + "&"
            } else {
                apiUrlString = apiUrlString + "country=us&"
            }


        } else {
            apiUrlString = apiUrlString + "everything?"
    //        if query.isEmpty && source.isEmpty {
    //            apiUrlString = apiUrlString + "from="
    //            let limit = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    //            let oneMonthAgo: String = String(limit.ISO8601Format().split(separator: "T").dropLast()[0])
    //            apiUrlString = apiUrlString + oneMonthAgo + "&"
    //        }
            if !query.isEmpty {
                apiUrlString = apiUrlString + "q=" + query + "&"
            }

            if !source.isEmpty {
                apiUrlString = apiUrlString + "sources=" + source.replacingOccurrences(of: " ", with: "-") + "&"
            }
        }
        apiUrlString = apiUrlString + "apiKey=" + getNewsApiKey()
        print(apiUrlString)
        return apiUrlString
    }

}
