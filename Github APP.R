#Load Packages______________________________________________
{if (!requireNamespace("shinydashboard", quietly = TRUE))
  install.packages("shinydashboard")
  
  if (!requireNamespace("shiny", quietly = TRUE)) 
    install.packages("shiny")
  
  if (!requireNamespace("httpuv", quietly = TRUE)) 
    install.packages("httpuv")
  
  library(httpuv)
  if (!requireNamespace("rtweet", quietly = TRUE)) 
    install.packages("rtweet")
  
  library(rtweet) 
  if (!requireNamespace("remotes", quietly = TRUE))
    install.packages("remotes")
  
  library(remotes)
  if (!requireNamespace("tidyr", quietly = TRUE)) 
    install.packages("tidyr")
  
  if (!requireNamespace("dplyr", quietly = TRUE)) 
    install.packages("dplyr")
  
  if (!requireNamespace("janeaustenr", quietly = TRUE)) 
    install.packages("janeaustenr")
  
  if (!requireNamespace("stringr", quietly = TRUE))
    install.packages("stringr")
  
  if (!requireNamespace("tidytext", quietly = TRUE)) 
    install.packages("tidytext")
  
  if (!requireNamespace("readr", quietly = TRUE)) 
    install.packages("readr")
  
  if (!requireNamespace("data.table", quietly = TRUE)) 
    install.packages("data.table")
  
  if (!requireNamespace("vctrs", quietly = TRUE)) 
    install.packages("vctrs")
  
  if (!requireNamespace("tm", quietly = TRUE)) 
    install.packages("tm")
  
  if (!requireNamespace("SnowballC", quietly = TRUE)) 
    install.packages("SnowballC")
  
  if (!requireNamespace("wordcloud", quietly = TRUE)) 
    install.packages("wordcloud")
  
  if (!requireNamespace("RColorBrewer", quietly = TRUE)) 
    install.packages("RColorBrewer")
  
  if (!requireNamespace("memoise", quietly = TRUE)) 
    install.packages("memoise")
  
  if (!requireNamespace("sentimentr", quietly = TRUE)) 
    install.packages("sentimentr")
  
  if (!requireNamespace("sf", quietly = TRUE)) 
    install.packages("sf")
  
  if (!requireNamespace("mapview", quietly = TRUE)) 
    install.packages("mapview")
  
  if (!requireNamespace("leaflet", quietly = TRUE)) 
    install.packages("leaflet")
  
  if (!requireNamespace("shinycssloaders", quietly = TRUE)) 
    install.packages("shinycssloaders")
  
  if (!requireNamespace("janitor", quietly = TRUE)) 
    install.packages("janitor")
  
  if (!requireNamespace("DT", quietly = TRUE)) 
    install.packages("DT")
  
  if (!requireNamespace("ggmap", quietly = TRUE)) 
    install.packages("ggmap")
  
  library(ggmap)
  library(DT)
  library(tidyr)
  library(dplyr)
  library(janeaustenr)
  library(stringr)
  library(readr)
  library(data.table)
  library(ggplot2)
  library(tidytext)
  library(vctrs)
  library(shiny)
  library(shinydashboard)
  library("tm")
  library("SnowballC")
  library("wordcloud")
  library("RColorBrewer")
  library(memoise)
  library(sentimentr)
  library(sf)
  library(mapview)
  library(leaflet)
  library(shinycssloaders)
  library(janitor)
}
#Twitter API________________________________________________

#Input your own API inofrmation into each quotation
#Twitter API
  {token <- create_token(
                          app = "",
                          consumer_key = "",
                          consumer_secret = "",
                          access_token = "",
                          access_secret = "")
                        identical(token, get_token()
                        )
#Google API key                        
  register_google(key = "")
}
#ask nico how to avoid how to sign in
#we could make a genaric twitter api and provide password

#UI_________________________________________________________
if (interactive()) {
  
  ui <- dashboardPage(
    #style_____________________________________________________
    skin = "purple",
    #Header____________________________________________________
    dashboardHeader(title = "Twitter Scraping",
                    dropdownMenu(type = "messages",
                                 messageItem(
                                   from = "IMPORTANT",
                                   message = "Do not continue to press the Go button."
                                 ))),
    
    #Sidebar___________________________________________________
    dashboardSidebar(
      sidebarMenu(
        menuItem("Search Tweets", tabName = "Search Tweets"),
        #Only Twitter Search related______________
        textInput("search","Search Key Word"),
        sliderInput("slider", "Number of observations:", 50, 18000, 50),
        dateRangeInput('dateRange',
                       label = 'Date range input: dd/mm/yyyy',
                       start = Sys.Date(), end = Sys.Date(),                         
                       min = Sys.Date()-10,
                       max = Sys.Date(),
                       format = "dd/mm//yyyy"),
        actionButton("update","Go"),
        menuItem("Word Cloud Settings"),
        #Here and below only word cloud related stuff______________
        sliderInput("max","Maximum Number of Words:", min = 1,  max = 300, value = 100),
        sliderInput("min","Minimum Frequency:", min = 1,  max = 100, value = 10),
        textInput("stop","Stop Words"),
        actionButton("stopwords","Add Stop Words"))
    ),
    
    #Body_______________________________________________________      
    dashboardBody(
      navbarPage("Navigation Bar", id="myNavbar",
                 tabPanel("Instructions",
                          'The above Navigation Bar contains three tabs: Instructions, Tweet Analysis, and Raw Data. 
                          You are currently on the first tab, "Instructions" which provides a brief overview of how 
                          the app works. The second tab, "Tweet Analysis", produces 3 empty boxes that will show an 
                          error message at first, but later will be filled with a word cloud, sentiment analysis histogram, 
                          and world map. The side bar on the left side of the interface begins with the Twitter search 
                          settings. It contains a text search box which allows you to type the word or phrase to search 
                          twitter for. The first slide bar ranges from 50 to 18 thousand and will be the number of tweets 
                          collected. Next is the date range. The Twitter API only allows for users to search tweets within 
                          the last 3 days. Once you complete all Twitter search settings, press the "Go" button, which 
                          begins to collect tweets from Twitter and formulate the outputs in the Tweet Analysis tab on 
                          the main dashboard. Once the outputs populate on the dashboard, you can adjust the settings for 
                          the word cloud. You have the option to change the amount of words shown from 1 to 300 and place 
                          a minimum frequency on the words shown in the word cloud. The last setting is a text box under 
                          stop words. This is where you can input words shown in the word cloud that are not useful to the 
                          analysis of the tweets. When you enter the word and press the "Add Stop Words" button, the word 
                          disappears from the word cloud. The sentiment box has two tabs. The first tab will generate a 
                          histogram displaying the sentiment analysis. The second tab "Details" will show the average 
                          sentiment analysis as a percentage from -100% to 100%. Once all sidebar settings are complete 
                          you can also use the third tab "Raw Data" to look through each individual tweet. You have the 
                          option to search for specific keywords. At the bottom of "Raw Data" tab you can find a link to 
                          download all the tweets as a CSV. This method works best if you save over an already existing CSV file.'),
                 
                 tabPanel("Tweet Analysis",
                          fluidRow(
                            box(
                              title = "Word Cloud", width = 6, height = 500,
                              plotOutput("wordCloud")%>%
                                withSpinner(color = "blue")),
                            tabBox(
                              title = "Sentiment", width = 6, height = 500,
                              tabPanel("Histogram",
                                       plotOutput("Sentiment")%>%
                                         withSpinner(color = "blue")),
                              tabPanel("Details", fluidRow(align = "center",'Tweets with a positive sentiment have positive values and fall to the right of zero, while tweets with negative sentiment fall to the left. The number shown below is the average sentiment of your search.'),
                                       fluidRow( align ="center",
                                                 infoBoxOutput("averagesent"))))),
                          fluidRow(
                            leafletOutput("Location"))),
                 tabPanel("Raw Data",
                          DTOutput("rawtable")%>%
                            withSpinner(color = "blue"),
                          downloadLink("downloadData", "Download as CSV")
                 ))))
}
#Server_____________________________________________________
{
  server<- function(input, output, session) {  
    data <- reactiveValues()
    data("stop_words")
    data$sw<- stop_words
    observeEvent(input$update, {
      
      withProgress(message = 'Collecting Tweets', 
                   value = 0.3, {
                     
                     rt <- search_tweets(input$search, lang = "en",
                                         n = input$slider,since = input$dataRange$start, until = input$dataRange$end, 
                                         include_rts = FALSE)
                     #dataRange$start
                     #dataRange$end
                     dput(head(rt))
                     rt<-droplevels(rt)
                     scrape <- data.table(rt$screen_name,rt$text,rt$created_at,rt$is_retweet,rt$retweet_count,rt$location,rt$geo_coords)
                     names(scrape)[names(scrape) == "V1"] <- "name"
                     names(scrape)[names(scrape) == "V2"] <- "text"
                     names(scrape)[names(scrape) == "V3"] <- "created_at"
                     names(scrape)[names(scrape) == "V4"] <- "is_retweet"
                     names(scrape)[names(scrape) == "V5"] <- "retweet_count"
                     names(scrape)[names(scrape) == "V6"] <- "city"
                     names(scrape)[names(scrape) == "V7"] <- "location"  
                     
                     data$rt <- scrape
                     
                     data$rawdatatable <- data.table(rt$screen_name,rt$text,rt$location)
                     names(data$rawdatatable)[names(data$rawdatatable) == "V1"] <- "name"
                     names(data$rawdatatable)[names(data$rawdatatable) == "V2"] <- "text"
                     names(data$rawdatatable)[names(data$rawdatatable) == "V3"] <- "city"
                     
                     data$downloadable<- data$rawdatatable
                     data$downloadable$name <- as.character(data$downloadable$name)
                     data$downloadable$city<- as.character(data$downloadable$city)
                     data$downloadable$text<- as.character(data$downloadable$text)
                     data$downloadable <- as.matrix(data$downloadable)
                     
                     
                     data$loc <- geocode(data$rt$city, autocomplete = FALSE)
                     
                     incProgress(0.1)
                     Sys.sleep(1)
                   })
      
    })
    output$Sentiment <- 
      renderPlot({
        scrape_sent <- sentiment_by(data$rt$text)
        scrape_sent$keyword <- input$search
        scrape_sent <- scrape_sent[, c('ave_sentiment', 'keyword')]
        
        ggplot(data = scrape_sent, aes(x = ave_sentiment)) + 
          geom_histogram(aes(fill=..x..)) +
          xlim(-1,1)+
          scale_fill_gradient2(low ="red", mid = "white", high = "dark blue", midpoint = 0)+
          facet_wrap(~keyword, nrow = 2) + 
          theme_bw()
      })
    
    
    output$averagesent<- renderInfoBox({
      scrape_sent <- sentiment_by(data$rt$text)
      scrape_sent$keyword <- input$search
      scrape_sent <- scrape_sent[, c('ave_sentiment', 'keyword')]
      meansent<-mean(scrape_sent$ave_sentiment[scrape_sent$keyword == input$search])
      
      infoBox("AVG Sentiment",paste(round(100*meansent, 2), "%", sep=""),icon = icon("list"),
              color = "purple", fill = TRUE)
    })
    
    output$wordCloud <- renderPlot({
      scrape<- data$rt
      scrape<- scrape %>%
        unnest_tokens(word, text)
      stop_words<-data$sw
      stop_words <- rbind(stop_words, "7th" = c("https","new"))
      stop_words <- rbind(stop_words, "7th" = c("t.co","new"))
      stop_words <- rbind(stop_words, "7th" = c("hk","new"))
      stop_words <- rbind(stop_words, "7th" = c(input$search,"new"))
      stop_words <<- stop_words
      scrape<<- scrape
      scrape<- scrape%>%
        anti_join(stop_words)
      
      scrape<- scrape %>%
        count(word, sort = TRUE) 
      wordcloud(words = scrape$word, freq = scrape$n, min.freq = input$min, max.words = input$max,
                random.order=FALSE, rot.per=0.35, 
                colors=brewer.pal(8, "Dark2"))
    })
    
    
    
    output$Location <-  renderLeaflet({
      data$loc <- data$loc %>% remove_empty("rows")
      leaflet() %>%
        addTiles() %>%
        addMarkers(data = data$loc)
    })    
    observeEvent(input$stopwords, {  
      
      
      data$sw <- rbind(data$sw, "7th" = c(input$stop,"new"))
      
      
    })
    
    ################################  
    output$rawtable <- renderDT(data$rawdatatable,
                                filter= "top")
    ################################
    output$downloadData <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(data$downloadable, file)
      }
    )
    ##############################  
  }
}

shinyApp(ui, server)

#post entire app to gethub

