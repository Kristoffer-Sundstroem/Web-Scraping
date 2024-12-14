websearch <- "https://www.allabolag.se/bransch-s%C3%B6k?q=" # Specify the https that is used for the websearch (in this case allabolag.se).
searchname <- paste0(websearch,
                     URLencode(firm_list)) # Create a list that is a combination of the websearch and the URLencoded firm names (taken from firm_list).
Data <- data.frame(length(firm_list)) # Create a dataframe with the same length as firm_list. We will later use this to store the "Organisationsnummer".

for (x in 1:length(firm_list) { # Loop the scraping script over the number of firms in the firm_list.
  message("Retrieving OrgNr ", x, ".") # This line give the user information on how far the code has come in terms of collected "organisationsnummer".
  tmp_doc <- read_html(searchname[x]) # Create a temporary variable called "tmp_doc".
  tmp_html_prod <- tmp_doc %>% # This part makes use of dplyr and it retrieves the "span" element of the html information saved in tmp_doc and then it collects the text in the new temporay file "tmp_html_prod".
    html_elements("span") %>%
    html_text2()
  
  tmp_nr <- grep("Org.nr[0-9]", tmp_html_prod) # This retrieves the organisationsnummer from the tmp_html_prod and saves is as a temporary variable tmp_nr.
  
  Data[x,] <- Data[x,]%>% 
    mutate(OrgNr = tmp_html_prod[tmp_nr[1]]) # Save the retrieved "Organisationsnummer in the dataframe as "OrgNr".
  
  rm(tmp_doc, tmp_html_prod, tmp_nr) # Remove all temporary variables.
  
  if((x %% 100) == 0) { # This part specifies that this specific part (uner the if command) shall run after the loop has reached the 100th iteration.
    message("Taking a break.") # Gives the user information about the fact that the scraping script is taking a break.
    message("Number of retrieved OrgNrs ", x, ".") # Informs the user about the number of retrieved "organisationsnummer".
    Sys.sleep(60) # This forces the script to take a 60 second break in order to not overload the servers.
  }
}

Data$OrgNr <- sub("^\\D+", "", Data$OrgNr) # This code is optional and is used to remove the string of text that is before the "organisationsnummer". So if the goal is pure "organisationsnummer" then one should run this part as well.
