

# Define UI for application that draws a histogram
ui <-function(req){
 
  div(use_daisyui(),`data-theme`="night", useShinyjs(),
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
      class="w-screen h-screen bg-neutral flex flex-col items-center justify-center",
      div(
        class="h-1/6 w-screen bg-neutral flex flex-col justify-end items-center py-6",
        
        tags$h1(class="text-neutral-content text-4xl",
                "IM Revision"),
        tags$h3(class="text-primary text-2xl",
                "Registeration")
      ),
      
      div(
        class="h-5/6 w-screen bg-base-200 flex items-center justify-center ",
        
        div(id="main",
            class="bg-neutral w-2/3 h-2/3  rounded-2xl relative flex items-center justify-center shadow-2xl shadow-cyan-500/10 ",
            
            tags$span(class="absolute block px-10 py-6 shadow-2xl bg-secondary text-secondary-content text-xl rounded-xl",
                      style="transform:translatey(-50%); top:0; left:20px",textOutput("info-span")),
            
            
            div(id="inputs",class="w-full h-1/2 flex justify-evenly items-center lg:flex-row md:flex-col mb-12 px-6",
                
                textInput("name",label = "Enter Your Name:"),
                shinyjs::inlineCSS(list("#name" = "width:100%; color:#555")),
                
                numericInput("iD",label = "Enter Your ID:", value =NA),
                shinyjs::inlineCSS(list("#iD" = "width:100%; color:#555")),
                selectInput("groups",label = "Available Groups:", choices = c(),selectize = FALSE),
                shinyjs::inlineCSS(list("#groups" = "width:100%; color:#555"))
            )
            ,
            actionButton("submit","Submit",class="btn btn-primary btn-large btn-outline absolute lg:w-2/12 md:w-1/3",style="bottom:10%")
        )
      )
      ,
      div(style = "display: none;",
          textInput("remote_addr", "remote_addr",
                    if (!is.null(req[["HTTP_X_FORWARDED_FOR"]]))
                      req[["HTTP_X_FORWARDED_FOR"]]
                    else
                      req[["REMOTE_ADDR"]]
          )
      ),
      div(style="visibility:hidden;",
        downloadButton("downloadData", "Download")
      )
      
  )
  
} 
  