# GraphQLRepoList

## Technologies used: 
- GraphQL
- SwiftUI
- MVVM

## Things to improve:
- Better use of generic with GraphQL to simplify more the queries
- Better use of NetworkError to bring some detail about some particular errors and show the user more information about them
- Create a new ImageNetworkService Protocol just to do the fetch of image. Single responsability
- Better UI and UX

## Choices I've made:
- I didn't use any third party library excluding Apollo for GraphQL queries.
- I rather get the images and store them using DispatchQueue
- Work with different queries and passing the cursor to fetch more repositories
