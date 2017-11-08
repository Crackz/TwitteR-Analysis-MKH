
## **Some Features**

![TwitterSearchAnalysis](https://i.imgur.com/YjBwMFp.png) ![ProfileAnalysis](https://i.imgur.com/q9g3mUc.png)

<p float="left">
  <img src="https://i.imgur.com/o5K2VhT.png" width="400" alt="RegionSelection"/>
  <img src="https://i.imgur.com/b5qDYRA.png" width="400" alt="MostSpokenLang"/> 
</p>


## **How to Setup**

> *this project is developed under visualstudio and rstudio*

Clone Or Download then extract and open it from TwitteR Analysis MKH.rproj Or TwitteR Analysis MKH.sln
click Run App!

> #### In Rstudio
![Run Button](https://i.imgur.com/zyty0u4.png)

###### I have implemented an auto packages downloader functionality so you should go get a  :coffee: while it's installing 

## Project Structure 
```R
  Global                           Server                                                         UI.R                          WWWROOT   
    |                           /    |    \                                     /        /          |          \                   |
LoadConfig       Mining Tweets  UserProfile CountriesAnalysis         UIHelpers Mining Tweets  UserProfile CountriesAnalysis   HTML+JS Native

```
* Global is used for non-related shiny stuff , purely for core code , stuff related to server,ui
* Server is used for handling server logic
* UI is used for styling your pages
* WWWRoot is used for Native web technologies when flexability is needed 
