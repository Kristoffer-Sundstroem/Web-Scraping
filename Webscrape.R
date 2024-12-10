websearch <- "https://www.allabolag.se/bransch-s%C3%B6k?q="
searchname <- paste0(websearch,
                     URLencode(EnvDataSet_Tibble$Företagsnamn))

for (x in 1:2077) {
  message("Retrieving OrgNr ", x, ".")
  tmp_doc <- read_html(searchname[x])
  tmp_html_prod <- tmp_doc %>%
    html_elements("span") %>%
    html_text2()
  
  tmp_nr <- grep("Org.nr[0-9]", tmp_html_prod)
  
  EnvDataSet_Tibble[x,] <- EnvDataSet_Tibble[x,]%>%
    mutate(OrgNr = tmp_html_prod[tmp_nr[1]])
  
  rm(tmp_doc, tmp_html_prod, tmp_nr)
  
  if((x %% 100) == 0) {
    message("Taking a break.")
    message("Number of retrieved OrgNrs ", x, ".")
    Sys.sleep(48)
  }
}

EnvDataSet_Tibble$OrgNr <- sub("^\\D+", "", EnvDataSet_Tibble$OrgNr)