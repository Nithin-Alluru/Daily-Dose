//
//  NewsApiData.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/24/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//
// Referenced:
//  MovieSearchApiData.swift
//  Movies
//
//  Created by Osman Balci on 10/13/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//
/*
import Foundation

// Global variable to hold the API search results
var foundNewssList = [NewsStruct]()

/*
************************************
*   Global TMDb API HTTP Headers   *
************************************
*/
let newsHeaders = [
    "accept": "application/json",
    "cache-control": "no-cache",
    "connection": "keep-alive",
    "host": "newsapi.org"
]



/*
 ===================================================
 |   Fetch and Process JSON Data from the API      |
 |   for Newss Found for the given Search Query   |
 ===================================================
*/
public func getNewsArticlesFromApi(category: String, query: String) {
    
    // Initialize the global variable to hold the API search results
    foundNewssList = [NewsStruct]()

    let apiUrlString = "https://newsapi.org/v2/"
    
    /*
    ***************************************************
    *   Fetch JSON Data from the API Asynchronously   *
    ***************************************************
    */
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: newsHeaders, apiUrl: apiUrlString, timeout: 20.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return
    }

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
 {"page":1,
 "✅results":[
     {
         "✅poster_path":"\/IfB9hy4JH1eH6HEfIgIGORXi5h.jpg",
         "adult":false,
         "✅overview":"Jack Reacher must uncover the truth behind a major government conspiracy in order to clear his name. On the run as a fugitive from the law, Reacher uncovers a potential secret from his past that could change his life forever.",
         "✅release_date":"2016-10-19",
         "genre_ids":[53,28,80,18,9648],
         "✅id":343611,
         "original_title":"Jack Reacher: Never Go Back",
         "original_language":"en",
         "✅title":"Jack Reacher: Never Go Back",
         "backdrop_path":"\/4ynQYtSEuU5hyipcGkfD6ncwtwz.jpg",
         "popularity":25.456843,
         "vote_count":304,
         "video":false,
         "vote_average":4.38
     },
     :
     :
 ],
 "total_results":2,
 "total_pages":1}
 */

            if let arrayOfFoundNewss = jsonObject["results"] as? [Any] {
                
                // Iterate over the array
                for foundNews in arrayOfFoundNewss {
                    
                    // Intializations of NewsStruct
                    var title = "", posterFileName = "", overview = "", releaseDate = ""
                    var runtime = 0, mpaaRating = "", imdbRating = ""
                    var youTubeTrailerId = "", homepageUrl = ""
                    
                    // Intializations of the Other Structs
                    var directorStruct = DirectorStruct(name: "", photoFileName: "")
                    var listOfActorStructs = [ActorStruct]()
                    var listOfGenreStructs = [GenreStruct]()
                    
                    // Intializations of Ids
                    var tmdbId = 0, imdbId = ""
                    
                    let movie = foundNews as? [String: Any]
                    
                    // Get News Poster Filename
                    if let posterPath = movie!["poster_path"] as? String {
                        // {"poster_path":"\/xfWac8MTYDxujaxgPVcRD9yZaul.jpg"
                        // \ is the escape character. So, drop first character "/"
                        posterFileName = String(posterPath.dropFirst(1))
                    }
                    
                    // Get News Overview
                    if let movieOverview = movie!["overview"] as? String {
                        overview = movieOverview
                    }
                    
                    // Get News Release Date
                    if let dateOfRelease = movie!["release_date"] as? String {
                        releaseDate = dateOfRelease
                    }
                    
                    // Get News TMDb Id
                    if let tmdb_id = movie!["id"] as? Int {
                        tmdbId = tmdb_id
                    }
                    
                    // Get News Title
                    if let movieTitle = movie!["title"] as? String {
                        title = movieTitle
                    }
                    
                    //=============================================================
                    
                    let apiUrlString = "https://api.themoviedb.org/3/movie/\(String(tmdbId))?api_key=\(myTMDbApiKey)&append_to_response=credits"
                    
                    /*
                    ***************************************************
                    *   Fetch JSON Data from the API Asynchronously   *
                    ***************************************************
                    */
                    var jsonDataFromApi: Data
                    
                    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: tmdbApiHeaders, apiUrl: apiUrlString, timeout: 20.0)
                    
                    if let jsonData = jsonDataFetchedFromApi {
                        jsonDataFromApi = jsonData
                    } else {
                        return
                    }

                    /*
                    **************************************************
                    *   Process the JSON Data Fetched from the API   *
                    **************************************************
                    */
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                           options: JSONSerialization.ReadingOptions.mutableContainers)
                        
/*
 {
     "adult":false,
     "backdrop_path":"/4ynQYtSEuU5hyipcGkfD6ncwtwz.jpg",
     "belongs_to_collection":{"id":403374,"name":"Jack Reacher Collection","poster_path":"/8MhYmIFNw6Cel6MpNdafZOUJYdE.jpg","backdrop_path":"/3FHrAeYMogXd6K1e5tUzQAiS7GE.jpg"},
     "budget":68000000,
     "✅genres":[{"id":53,"name":"Thriller"},{"id":28,"name":"Action"},{"id":80,"name":"Crime"},{"id":18,"name":"Drama"},{"id":9648,"name":"Mystery"}],
     "homepage":"",
     "id":343611,
     "✅imdb_id":"tt3393786",
     "original_language":"en",
     "original_title":"Jack Reacher: Never Go Back",
     "overview":"Jack Reacher must uncover the truth behind a major government conspiracy in order to clear his name. On the run as a fugitive from the law, Reacher uncovers a potential secret from his past that could change his life forever.",
     "popularity":24.456843,
     "poster_path":"/IfB9hy4JH1eH6HEfIgIGORXi5h.jpg",
     "production_companies":[{"name":"Paramount Pictures","id":4},{"name":"Skydance Productions","id":6277},{"name":"TC Productions","id":21777}],"production_countries":[{"iso_3166_1":"US","name":"United States of America"}],
     "release_date":"2016-10-19",
     "revenue":0,
     "✅runtime":118,
     "spoken_languages":[{"iso_639_1":"en","name":"English"}],
     "status":"Released",
     "tagline":"",
     "title":"Jack Reacher: Never Go Back",
     "video":false,
     "vote_average":4.4,
     "vote_count":363,
     "✅credits":
     {
        "✅cast":[
             {"cast_id":0,
              "character":"Jack Reacher",
              "credit_id":"5573971c9251413f6600024d",
              "id":500,
              "✅name":"Tom Cruise",
              "order":1,
              "✅profile_path":"/3oWEuo0e8Nx8JvkqYCDec2iMY6K.jpg"},

             {"cast_id":5,"character":"Susan Turner","credit_id":"55fdcf53c3a368133b0016bb","id":71189,"name":"Cobie Smulders","order":2,"profile_path":"/qYXbHM3QZwHAOURe0L09Wn4UKsh.jpg"},
             {"cast_id":6,"character":"Espin","credit_id":"55fdcf5a92514152aa001927","id":83860,"name":"Aldis Hodge","order":3,"profile_path":"/n5XzyKltq27Y555fZOEC7KZ6l60.jpg"},
             {"cast_id":7,"character":"Samantha","credit_id":"55fdcf61925141529f0019b5","id":1466613,"name":"Danika Yarosh","order":4,"profile_path":"/uWUZflZvQnhR8FB32yNOEIWEfSr.jpg"},
             {"cast_id":16,"character":"The Hunter","credit_id":"57aed22b92514128f6001b22","id":1223163,"name":"Patrick Heusinger","order":5,"profile_path":"/p63zyQsr6PcT8m0htg5YjJofK1V.jpg"},
             {"cast_id":17,"character":"Col. Morgan","credit_id":"57aed238c3a36821a20018cd","id":7497,"name":"Holt McCallany","order":6,"profile_path":"/iNxSjRCtuz3BGaJlAyALiasVSZm.jpg"},
             {"cast_id":18,"character":"Prudhomme","credit_id":"57aed252c3a36878fe0029a6","id":1367847,"name":"Austin Hébert","order":7,"profile_path":null},
             {"cast_id":19,"character":"Colonel Moorcroft","credit_id":"57aed269c3a36821a5001b1d","id":149590,"name":"Robert Catrini","order":8,"profile_path":"/cBtEHBZ2ykjqCCIjQeoDQ7MVgsU.jpg"},
             {"cast_id":20,"character":"General Harkness","credit_id":"57aed27cc3a36821a5001b2d","id":17343,"name":"Robert Knepper","order":9,"profile_path":"/1ogC78qPLmDz2uRGLjI8LKtjvVl.jpg"},
             {"cast_id":21,"character":"Parasource Aide","credit_id":"57aed28692514128f6001b42","id":62784,"name":"Billy Slaughter","order":10,"profile_path":"/5YykEE15cNzgexL7d5ewAu5M8XN.jpg"},
             {"cast_id":23,"character":"Prud'homme´s wife","credit_id":"57d9a383c3a36878e900867f","id":565501,"name":"Teri Wyble","order":11,"profile_path":"/4peyoUZx7wqQpLCII4Kcb5VmaaV.jpg"}
        ],

        "✅crew":[
             {"credit_id":"55fdcf7f92514152a8001866","department":"Writing","id":22814,"job":"Screenplay","name":"Richard Wenk","profile_path":"/gRwUXjySs6KjdQxJSv8U8Ish0dJ.jpg"},
             {"credit_id":"55e73aad9251416c0d000453","department":"Directing","id":9181,"✅job":"Director","✅name":"Edward Zwick","✅profile_path":"/ucBi071XeIGMEHaEGKtU6PN1FwN.jpg"},
             {"credit_id":"55e73abec3a368379200046f","department":"Writing","id":1056052,"job":"Novel","name":"Lee Child","profile_path":"/n4KwUgMkM7R92PoKBdt8VFqk42t.jpg"},
             {"credit_id":"55fdcf9ac3a36813370017ca","department":"Writing","id":9181,"job":"Screenplay","name":"Edward Zwick","profile_path":"/ucBi071XeIGMEHaEGKtU6PN1FwN.jpg"},
             {"credit_id":"578850cac3a36839190046f8","department":"Camera","id":11409,"job":"Director of Photography","name":"Oliver Wood","profile_path":null},
             {"credit_id":"57aed2b9c3a368213f001bcf","department":"Editing","id":909,"job":"Editor","name":"Billy Weber","profile_path":null}
        ]
     }
 }
 */
                        //-----------------------------
                        // Obtain Top Level JSON Object
                        //-----------------------------
                        
                        if let jsonObject = jsonResponse as? [String: Any] {
                            
                            if let arrayOfGenres = jsonObject["genres"] as? [Any] {
                                
                                for aGenre in arrayOfGenres {
                                    if let movieGenre = aGenre as? [String: Any] {
                                        if let genreName = movieGenre["name"] as? String {
                                            let newGenreStruct = GenreStruct(name: genreName)
                                            listOfGenreStructs.append(newGenreStruct)
                                        }
                                    }
                                }
                                
                                if let imdb_id = jsonObject["imdb_id"] as? String {
                                    imdbId = imdb_id
                                }
                                
                                if let runtimeInMins = jsonObject["runtime"] as? Int {
                                    runtime = runtimeInMins
                                }
                                
                                if let creditsJsonObject = jsonObject["credits"] as? [String: Any] {
                                    if let arrayOfCastMembers = creditsJsonObject["cast"] as? [Any] {
                                        
                                        // Iterate over the array
                                        for member in arrayOfCastMembers {
                                            
                                            let castMember = member as? [String: Any]
                                            
                                            // Get Actor Name
                                            var actorName = ""
                                            if let nameOfActor = castMember!["name"] as? String {
                                                actorName = nameOfActor
                                            }
                                            
                                            // Get Actor's Photo Filename
                                            var actorPhotoFileName = ""
                                            if let profilePath = castMember!["profile_path"] as? String {
                                                // "profile_path":"/3oWEuo0e8Nx8JvkqYCDec2iMY6K.jpg"} --> drop first "/"
                                                actorPhotoFileName = String(profilePath.dropFirst(1))
                                            }
                                            
                                            let newActorStruct = ActorStruct(name: actorName, photoFileName: actorPhotoFileName)
                                            listOfActorStructs.append(newActorStruct)
 
                                        }   // End of for loop

                                    } else { return }
                                    
                                    if let arrayOfCrewMembers = creditsJsonObject["crew"] as? [Any] {
                                        for aCrewMember in arrayOfCrewMembers {
                                            if let crewJsonObject = aCrewMember as? [String: Any] {
                                                if let job = crewJsonObject["job"] as? String {
                                                    if job == "Director" {
                                                        var directorName = ""
                                                        var directorPhotoFileName = ""
                                                        
                                                        if let name = crewJsonObject["name"] as?  String {
                                                            directorName = name
                                                        }
                                                        if let profile_path = crewJsonObject["profile_path"] as?  String {
                                                            directorPhotoFileName = String(profile_path.dropFirst(1))
                                                        }
                                                        directorStruct = DirectorStruct(name: directorName, photoFileName: directorPhotoFileName)
                                                    }
                                                }
                                            }
                                        }
                                    } else { return }
                                    
                                } else { return }
                            } else { return }
                        } else { return }
                    } catch { return }
                    
                    //==============================================================
                    
                    let tmdbApiUrl = "https://api.themoviedb.org/3/movie/\(tmdbId)?api_key=\(myTMDbApiKey)&append_to_response=videos"
                    
                    /*
                    ***************************************************
                    *   Fetch JSON Data from the API Asynchronously   *
                    ***************************************************
                    */
                    var jsonDataFromTmdbApi: Data
                    
                    let jsonDataFetchedFromTmdbApi = getJsonDataFromApi(apiHeaders: tmdbApiHeaders, apiUrl: tmdbApiUrl, timeout: 20.0)
                    
                    if let tmdbJsonData = jsonDataFetchedFromTmdbApi {
                        jsonDataFromTmdbApi = tmdbJsonData
                    } else {
                        return
                    }
                    
                    /*
                    **************************************************
                    *   Process the JSON Data Fetched from the API   *
                    **************************************************
                    */
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromTmdbApi,
                                           options: JSONSerialization.ReadingOptions.mutableContainers)
                        
/*
 {
     "adult":false,
     "backdrop_path":"/tFI8VLMgSTTU38i8TIsklfqS9Nl.jpg",
     "belongs_to_collection":null,
     "budget":165000000,
     "genres":[{"id":28,"name":"Action"},{"id":12,"name":"Adventure"},{"id":14,"name":"Fantasy"},{"id":878,"name":"Science Fiction"}],
     "✅homepage":"http://marvel.com/doctorstrangepremiere",
     "id":284052,
     "✅imdb_id":"tt1211837",
     "original_language":"en",
     "original_title":"Doctor Strange",
     "overview":"After his career is destroyed, a brilliant but arrogant surgeon gets a new lease on life when a sorcerer takes him under his wing and trains him to defend the world against evil.",
     "popularity":27.794961,
     "poster_path":"/xfWac8MTYDxujaxgPVcRD9yZaul.jpg",
     "production_companies":[{"name":"Marvel Studios","id":420}],
     "production_countries":[{"iso_3166_1":"US","name":"United States of America"}],
     "release_date":"2016-10-25",
     "revenue":572090231,
     "runtime":115,
     "spoken_languages":[{"iso_639_1":"en","name":"English"}],
     "status":"Released",
     "tagline":"Open your mind. Change your reality.",
     "title":"Doctor Strange",
     "video":false,
     "vote_average":6.6,
     "vote_count":1233,
     "✅videos":{"✅results":[

         The results array can be empty. If so, skip that movie: if resultsArray.isEmpty { return }

         {"id":"57992d84c3a3687e5c003a3b",
         "iso_639_1":"en",
         "iso_3166_1":"US",
         "✅key":"HSzx-zryEgM",   <--- YouTube Official News Trailer Video ID
         "name":"Doctor Strange Official Trailer 2",
         "site":"YouTube",
         "size":1080,
         "type":"Trailer"},
            :
            :
     ]}
 }
 */
                        if let jsonObject = jsonResponse as? [String: Any] {
                            
                            // Get Homepage
                            if let homepage = jsonObject["homepage"] as? String {
                                homepageUrl = homepage
                            }
                            
                            // Get News IMDb ID
                            if let imdb_id = jsonObject["imdb_id"] as? String {
                                imdbId = imdb_id
                            }
                            
                            // Get News YouTube Trailer Video ID
                            if let videosJsonObject = jsonObject["videos"] as? [String: Any] {
                                if let resultsArray = videosJsonObject["results"] as? [Any] {
                                    
                                    // The results array can be empty
                                    if resultsArray.isEmpty { return }
                                    
                                    if let resultsJsonObject = resultsArray[0] as? [String: Any] {
                                    
                                        if let videoId = resultsJsonObject["key"] as? String {
                                            youTubeTrailerId = videoId
                                        }
                                    
                                    } else { return }
                                } else { return }
                            } else { return }
                        } else { return }
                    } catch { return }
                    
                    //=============================================================
                    
                    let omdbApiUrl = "https://www.omdbapi.com/?apikey=\(myOMDbApiKey)&i=\(imdbId)&plot=full&r=json"
                    
                    /*
                    ***************************************************
                    *   Fetch JSON Data from the API Asynchronously   *
                    ***************************************************
                    */
                    var jsonDataFromOmdbApi: Data
                    
                    let jsonDataFetchedFromOmdbApi = getJsonDataFromApi(apiHeaders: omdbApiHeaders, apiUrl: omdbApiUrl, timeout: 20.0)
                    
                    if let omdbJsonData = jsonDataFetchedFromOmdbApi {
                        jsonDataFromOmdbApi = omdbJsonData
                    } else {
                        return
                    }
                    
                    /*
                    **************************************************
                    *   Process the JSON Data Fetched from the API   *
                    **************************************************
                    */
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromOmdbApi,
                                           options: JSONSerialization.ReadingOptions.mutableContainers)

/*
 After obtaining the IMDb ID from above, obtain the following movie data from OMDb API using
 Dr. Balci's API key: (OMDb API allows 100,000 accesses per day and Dr. Balci is a patron paying $1 per month.)

     http://www.omdbapi.com/?apikey=9f67dd7a&i=tt3393786&plot=full&r=json

 {
     "Title":"Jack Reacher: Never Go Back",
     "Year":"2016",
     "✅Rated":"PG-13",
     "Released":"21 Oct 2016",
     "Runtime":"118 min",
     "Genre":"Action, Adventure, Crime",
     "Director":"Edward Zwick",
     "Writer":"Lee Child (based on the book \"Never Go Back\" by), Richard Wenk (screenplay), Edward Zwick (screenplay), Marshall Herskovitz (screenplay)",
     "Actors":"Tom Cruise, Cobie Smulders, Aldis Hodge, Danika Yarosh",
     "Plot":"Jack Reacher must uncover the truth behind a major government conspiracy in order to clear his name. On the run as a fugitive from the law, Reacher uncovers a potential secret from his past that could change his life forever.",
     "Language":"English",
     "Country":"China, USA",
     "Awards":"N/A",
     "Poster":"https://images-na.ssl-images-amazon.com/images/M/MV5BODQ3ODQ3NDI4NV5BMl5BanBnXkFtZTgwMDY1Mzk5OTE@._V1_SX300.jpg",
     "Metascore":"47",
     "✅imdbRating":"6.4",
     "imdbVotes":"12,507",
     "imdbID":"tt3393786",
     "Type":"movie",
     "Response":"True"
 }
 */
                        //-----------------------------
                        // Obtain Top Level JSON Object
                        //-----------------------------
                        
                        if let jsonObject = jsonResponse as? [String: Any] {
                            
                            // Get News MPAA Rating
                            if let rated = jsonObject["Rated"] as? String {
                                mpaaRating = rated
                            }
                            
                            // Get News IMDb Rating
                            if let movieIMDbRating = jsonObject["imdbRating"] as? String {
                                imdbRating = movieIMDbRating
                            }

                        } else { return }
                    } catch { return }
                    
                    //-------------------------------------------------------------------
                    // Create an Instance of NewsStruct Struct and Append it to the List
                    //-------------------------------------------------------------------
                    let newNewsFound = NewsStruct(title: title, posterFileName: posterFileName, overview: overview, releaseDate: releaseDate, runtime: runtime, mpaaRating: mpaaRating, imdbRating: imdbRating, youTubeTrailerId: youTubeTrailerId, homepageUrl: homepageUrl, genres: listOfGenreStructs, director: directorStruct, actors: listOfActorStructs)
                    
                    foundNewssList.append(newNewsFound)

                }   // End of for loop
            } else { return }
        } else { return }
    } catch { return }
  
}
*/

