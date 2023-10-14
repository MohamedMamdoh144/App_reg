#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


get_available<-function(max=30){
  
  sheet_df<- reactive(read_csv("www/sheet.csv",show_col_types = FALSE))
  Globals$sheet<-isolate(sheet_df())
  cur_sheet<-isolate(Globals$sheet)
  if(nrow(cur_sheet)){
  gs<-cur_sheet%>%select(5:ncol(cur_sheet))

  Globals$sums<-as.data.frame(list("Total"=setNames(colSums(gs),group_names)))

  return(colnames(gs[,colSums(gs)<max]))
  }
  else{
    return(group_names)
  }
}
rename_groups<-function(lbls){
  inds<-match(lbls,group_lbls)
  return(setNames(lbls, group_names[inds]))
}

is_exist<-function(id){
  return(nrow(isolate(Globals$sheet)%>%filter(ID==id)))
}

generate_group_vec<-function(g){
  vec<-rep(0,6)
  vec[as.numeric(substr(g,2,2))]<-1
  return( vec)
  
}
# Define server logic required to draw a histogram
server <- function(input, output, session) {
  output$`info-span`<-renderText("Registeration Details")

  observe({
    invalidateLater(2000,session = session)
    updateSelectInput(session = session, inputId ="groups", choices=rename_groups(get_available(max=40)))

    })
  
  
  
  observeEvent(input$submit,{
    
    id_str<-ifelse(!is.na(input$iD),as.character(input$iD),"")
    if(input$name==""){
      shinyjs::addClass(selector = "#name", class="border-2 border-rose-600")
    }
    else{
      shinyjs::removeClass(selector = "#name", class="border-2 border-rose-600")
    }
    
    
    if(nrow(names_df%>%filter(ID==input$iD)) == 0){
      shinyjs::addClass(selector = "#iD", class="border-2 border-rose-600")
      shinyjs::alert("Invalid ID")
    }
    else{
      shinyjs::removeClass(selector = "#iD", class="border-2 border-rose-600")
    }
    
    if(input$name!="" && nrow(names_df%>%filter(ID==input$iD)) ){
      print(1)
        if(!is_exist(input$iD)){

          groups_vec<-generate_group_vec(input$groups)
          row<-c(as.numeric(input$iD),input$name,groups_vec[1],groups_vec[2],
                 groups_vec[3],groups_vec[4],groups_vec[5],groups_vec[6])
          out_sheet<-isolate(Globals$sheet)%>%add_row(ID=input$iD,time=as.character(Sys.time()),
                                                      ip= isolate(input$remote_addr), name=input$name,
                                                      g1=groups_vec[1], g2=groups_vec[2],
                                                      g3=groups_vec[3], g4=groups_vec[4], g5=groups_vec[5], g6=groups_vec[6])
          write.csv(out_sheet,file="www/sheet.csv",row.names = FALSE)
          get_available(max=40)
          output$downloadData <- downloadHandler(
            filename = function() {
              # Use the selected dataset as the suggested file name
              paste0("db", ".csv")
            },
            content = function(file) {
              # Write the dataset to the `file` that will be downloaded
              write.csv(out_sheet, file)
            }
          )
          shinyjs::alert("Submitted")
          removeUI(selector = "#inputs")
          removeUI(selector = "#submit")
          shinyjs::addClass(selector = "#main",class = "flex-col")
          output$`info-span`<-renderText("Thank You")
          
          n_ui<-tagList(tags$h2(class="text-secondary text-lg mb-6", "Number of participants in each group (Max:40)"),tableOutput("sum-table"))
          insertUI(selector = "#main","beforeEnd",ui=n_ui)
          output$`sum-table`<-renderTable(t(isolate(Globals$sums)))
          
         
        }
      else{
        shinyjs::alert("You've already registered")
        removeUI(selector = "#inputs")
        removeUI(selector = "#submit")
        shinyjs::addClass(selector = "#main",class = "flex-col")
        output$`info-span`<-renderText("Registered")
        
        n_ui<-tagList(tags$h2(class="text-secondary text-lg mb-6", "Number of participants in each group (Max:40)"),tableOutput("sum-table"))
        insertUI(selector = "#main","beforeEnd",ui=n_ui)
        output$`sum-table`<-renderTable(t(isolate(Globals$sums)))
       
      }
    }
  })

}

