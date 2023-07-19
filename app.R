library(shiny)
library(shinythemes)
library(tidyverse)
library(DT)
library(highcharter)
library(shinyWidgets)
library(plotly)
library(htmlwidgets)
library(janitor)

AccesNacion<- read_csv('AccesNacionInt.csv')
AccesProv<- read_csv('AccesProvInt.csv')
VelProv<- read_csv('AccesProvVelInt.csv')
LocInt<- read_csv('AccesLocInt.csv')

AccesNacionMed<- AccesNacion %>% mutate(`%Dial up`= `Dial up`*100/Total, 
                           `%Banda ancha fija`= `Banda ancha fija`*100/Total)

#AccesNacion<- AccesNacion %>% clean_names(.)


ui<- fluidPage(theme = shinytheme('journal'), 
               setBackgroundColor(
                 color = c("#6C9077", "#C2DDCA"),
                 gradient = "linear",
                 direction = "bottom"
               ),
               titlePanel(title = div(tags$img(src = "21915.png",height=72,width=120), 
                                      'Telecomunicaciónes')), 
               sidebarLayout(
                 sidebarPanel(
                   uiOutput("panel1")),
                 
                 mainPanel(
                   
                   tags$style(type="text/css",
                              ".shiny-output-error { visibility: hidden; }",
                              ".shiny-output-error:before { visibility: hidden; }"),
                   tags$style(
                     HTML(".nav-tabs > li > a {
                    border: 1px solid #ddd;
                    background-color: #C8DCF0;
                    color: #707070;
                    }")
                   ),
                   tabsetPanel(
                     id="tab",
                     
                     tabPanel(HTML('<strong>Acceso Nacional</strong>'), #ENTRADA1
                              plotlyOutput('graph1')
                     ),
                     tabPanel(HTML('<strong>Acceso Provincia</strong>'),#NO CAMBIA
                              plotlyOutput('graph2'),
                              plotlyOutput('graph21')
                              ),
                     tabPanel(HTML('<strong>Velocidad Provincia</strong>'),#ENTRADA 2
                              plotlyOutput('graph3')
                              
                     ),
                     tabPanel(HTML('<strong>KPIs</strong>'),#NO CAMBIA
                              h2('Porcentaje de retención de clientes en el servicio'),
                              plotlyOutput('graph4'),
                              h2('Porcentaje de ancho de banda disponible'),
                              plotlyOutput('graph5'),
                              h2('Tecnologia disponible por Provincia'),
                              plotOutput('graph6')
                              
                     )
                     
                   )
                   
                 )
                 
               )
)

server<- function(input, output){
  panelffs<- reactive({
    if(input$tab== "<strong>Acceso Nacional</strong>"){
    selectInput(inputId = 'typeS',
                label = "Por favor selecione el tipo de servicio",
                choices = c('Banda ancha fija', 'Dial up'),
                selected = NULL)
    }
    else if(input$tab== "<strong>Acceso Provincia</strong>"){
        selectInput(inputId = 'typeA',
                    label = "Por favor selecione un Año ",
                    choices = unique(AccesProv$Año),
                    selected = NULL 
      )
    }
    else if(input$tab== '<strong>Velocidad Provincia</strong>'){
      selectInput(inputId = 'typeV',
                  label = "Por favor selecione una Velocidad de Internet",
                  choices = names(VelProv)[4:11],
                  selected = NULL 
      )
    }
    else{
      list(
        selectInput(inputId = 'typeS',
                    label = "Por favor selecione el tipo de servicio",
                    choices = c('%Banda ancha fija', '%Dial up'),
                    selected = NULL), 
        selectInput(inputId = 'typeV',
                    label = "Por favor selecione una Velocidad de Internet",
                    choices = names(VelProv)[4:11],
                    selected = NULL 
        ), 
        selectInput(inputId = 'typeP',
                    label = "Por favor selecione una Provincia",
                    choices = unique(LocInt$Provincia),
                    selected = NULL 
        )
      )
    }
    })
  
  output$panel1 <- renderUI(panelffs())
  grafo1<- reactive({
    plot_ly(
      AccesNacion %>% select(Año, input$typeS) %>% 
        rename(value= input$typeS) %>% 
        dplyr::group_by(Año) %>% 
        summarise(value= mean(value)),
      x= ~Año, y= ~value,
      name= 'Dial up',
      type = "bar"
    ) %>% layout(title = "Acceso a Internet Nivel Naconal",
                 xaxis = list(title = "Año"),
                 yaxis = list(title = input$typeS))
  })
  
  grafo2<- reactive({
    list(plot_ly(
      AccesProv %>% filter(Año == as.numeric(input$typeA)) %>% 
        mutate(`Banda ancha fija`= sort(`Banda ancha fija`, decreasing = TRUE)),
      x= ~`Banda ancha fija`, y= ~fct_infreq(Provincia),
      name= 'Banda ancha fija',
      type = "bar"
    ) %>% layout(title = "Acceso a Internet Nivel por Provincia (Banda ancha fija)",
                 yaxis = list(title = ""),
                 xaxis = list(title = input$typeA)), 
    plot_ly(
      AccesProv %>% filter(Año == as.numeric(input$typeA)) %>%
        mutate(`Dial up`= sort(`Dial up`, decreasing = TRUE)),
      x= ~`Dial up`, y= ~fct_infreq(Provincia),
      name= 'Dial up',
      type = "bar"
    ) %>% layout(title = "Acceso a Internet Nivel por Provincia (Dial up)",
                 yaxis = list(title = ""),
                 xaxis = list(title = input$typeA)))
  })
  
  grafo3<- reactive({
    ggplotly(ggplot(VelProv %>% select(Año, Provincia, input$typeV) %>% 
                      rename(value= input$typeV), aes(x= Año, y= value, color=Provincia)) +
               geom_smooth(se= FALSE) + theme_bw())
  })
  
  grafo4<- reactive({
    ggplotly(ggplot(AccesNacionMed %>% select(Año, input$typeS) %>% 
                      rename(value= input$typeS), aes(x= Año, y= value)) +
               geom_smooth(se= FALSE) + theme_bw() +
               labs(title = 'Porcentaje de retención de clientes en el servicio', 
                    y= input$typeS))
  })
  
  grafo5<- reactive({
    VelProvM<- VelProv %>% select(Año, input$typeV, Total) %>% 
      rename(value= input$typeV) %>% 
      mutate(value= value*100/Total) 
    
    ggplotly(ggplot(VelProvM, aes(x= Año, y= value)) +
               geom_smooth(se= FALSE) + theme_bw() +
               labs(title = 'Porcentaje de ancho de banda disponible', 
                    y= input$typeV))
  })
  
  grafo6<- reactive({
    List= list()
    for (gr in names(LocInt)[4:12]){
      List[[gr]]<- LocInt %>% dplyr::filter(Provincia == input$typeP) %>% 
        ggplot(., aes(x= .[[gr]])) +
        geom_bar() +
        theme_bw()+
        labs(x= gr, y= 'Conteo') 
      
    }
    
    plot_grid(List[[1]], List[[2]], List[[3]],
              List[[4]], List[[5]], List[[6]], List[[7]], 
              List[[8]], List[[9]])
  })
  
  
  output$graph1<- renderPlotly(grafo1())
  output$graph2<- renderPlotly(grafo2()[[1]])
  output$graph21<- renderPlotly(grafo2()[[2]])
  output$graph3<- renderPlotly(grafo3())
  output$graph4<- renderPlotly(grafo4())
  output$graph5<- renderPlotly(grafo5())
  output$graph6<- renderPlot(grafo6())
  
}

shinyApp(ui= ui, server= server)


