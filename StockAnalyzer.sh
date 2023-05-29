#!/bin/bash


sendSms(){
  #CODE IS HIDDEN

  
}

login(){

# Display the Zenity menu
selected_option=$(zenity --list \
  --title="Authentication Options" \
  --text="Choose an authentication method:" \
  --column="Option" \
  "Login with Password" \
  "Login via Mobile OTP" \
  "Signup" \
  --width=400 \
  --height=300 \
  --cancel-label="Cancel" \
  --hide-column=2)

# Process the selected option
case "$selected_option" in
  "Login with Password")
    # Execute the login with password logic
    zenity --info --text="Login with Password option selected."
    home
    ;;
  "Login via Mobile OTP")
    # Execute the login via mobile OTP logic
   sendSms
   if [ $? == 0 ];
    then
    
    home
    else 
      zenity --notification --text=" Invalid OTP ."
      login
    fi
    ;;
  "Signup")
    # Execute the signup logic
    zenity --info --text="Signup option selected."
    login
    ;;
  *)
    # Handle cancel or close button click
    zenity --info --text="No option selected."
    ;;
esac

}

# After Successfull login



home(){


# Display the Zenity menu with four options
CHOICE=$(zenity --list --title="Stock Analyzer" --text="Select an option:" \
                --column="Option" --column="Description" \
                1 "Search Specific Stock" \
                2 "Live Market Feed of Stock" \
                3 "Stock Analyzer" \
                4 "Foreign Exchange" \
                --hide-header --height=300 --width=500 )

# Check the user's choice and perform the corresponding action
case $CHOICE in
    1)
        # Action for "Search Specific Stock" option
        zenity --info --title="Search Specific Stock" --text="You selected 'Search Specific Stock' option."
        # Add your code for searching specific stock here
        ;;
    2)
        # Action for "Live Market Feed of Stock" option
        zenity --info --title="Live Market Feed of Stock" --text="You selected 'Live Market Feed of Stock' option."
        # Add your code for displaying live market feed here
        ;;
    3)
        # Action for "Stock Analyzer" option
        # zenity --info --title="Stock Analyzer" --text="You selected 'Stock Analyzer' option."
        stockAnalyzer
        # Add your code for stock analysis here
        ;;
    4)
        # Action for "Foreign Exchange" option
        zenity --info --title="Foreign Exchange" --text="You selected 'Foreign Exchange' option."
        # Add your code for foreign exchange here
        ;;
    *)
        # Invalid choice or dialog closed
        zenity --error --title="Error" --text="You have not selected any option."
        ;;
esac

}

todaysGainer(){
    

# Fetch JSON data from the API
json_data=$(curl -s "https://api.stockmarketapi.in/api/v1/topgainers?token=620afdf266e887be433a571efcf01a498f53295a73878494e9bc8dd6c3c7104f") # Replace <API_URL> with the actual URL to fetch the JSON data

zenity --notification --text "Data successfully fetched"
# Extract relevant fields from the JSON data and format it as a table
table_data=$(echo "$json_data" | jq -r '.data[] | "\(.CompanyName), \(.MarketCap), \(.NSECode), \(.ltp), \(.dayChange), \(.dayChangePerc), \(.TodayHigh), \(.TodayLow), \(.YrHigh), \(.YrLow)"' | column -t -s ',')

# Add column names to the table
column_names="Company Name, Market Cap, NSE Code, Last Traded Price, Day Change, Day Change Percentage, Today's High, Today's Low, Yearly High, Yearly Low\n"
table_with_header=$(echo -e "$column_names\n$table_data")

# Display the table
clear
spd-say "Data is now visible on terminal"
printf "\n"
figlet "Top Gainers" |lolcat
echo "$table_with_header" |lolcat

}



todaysLoser(){
    

# Fetch JSON data from the API
json_data=$(curl -s "https://api.stockmarketapi.in/api/v1/toplosers?token=620afdf266e887be433a571efcf01a498f53295a73878494e9bc8dd6c3c7104f") # Replace <API_URL> with the actual URL to fetch the JSON data

zenity --notification --text "Data successfully fetched"
# Extract relevant fields from the JSON data and format it as a table
table_data=$(echo "$json_data" | jq -r '.data[] | "\(.CompanyName), \(.MarketCap), \(.NSECode), \(.ltp), \(.dayChange), \(.dayChangePerc), \(.TodayHigh), \(.TodayLow), \(.YrHigh), \(.YrLow)"' | column -t -s ',')

# Add column names to the table
column_names="Company Name, Market Cap, NSE Code, Last Traded Price, Day Change, Day Change Percentage, Today's High, Today's Low, Yearly High, Yearly Low\n"
table_with_header=$(echo -e "$column_names\n$table_data")

# Display the table
clear

spd-say "Data is now visible on terminal"
printf "\n"
figlet "Top Losers" |lolcat
echo "$table_with_header" |lolcat

}


52WeekHigh(){
    # Fetch JSON data from the API
json_data=$(curl -s "https://api.stockmarketapi.in/api/v1/week52high?token=620afdf266e887be433a571efcf01a498f53295a73878494e9bc8dd6c3c7104f") # Replace <API_URL> with the actual URL to fetch the JSON data

zenity --notification --text "Data successfully fetched"
# Extract relevant fields from the JSON data and format it as a table
table_data=$(echo "$json_data" | jq -r '.data[] | "\(.CompanyName), \(.MarketCap), \(.NSECode), \(.ltp), \(.dayChange), \(.dayChangePerc), \(.TodayHigh), \(.TodayLow), \(.YrHigh), \(.YrLow)"' | column -t -s ',')

# Add column names to the table
column_names="Company Name, Market Cap, NSE Code, Last Traded Price, Day Change, Day Change Percentage, Today's High, Today's Low, Yearly High, Yearly Low\n"
table_with_header=$(echo -e "$column_names\n$table_data")

# Display the table
clear

spd-say "Data is now visible on terminal"
printf "\n"
figlet "52 Week High" |lolcat
echo "$table_with_header" |lolcat

}

52WeekLow(){
    # Fetch JSON data from the API
json_data=$(curl -s "https://api.stockmarketapi.in/api/v1/week52low?token=620afdf266e887be433a571efcf01a498f53295a73878494e9bc8dd6c3c7104f") # Replace <API_URL> with the actual URL to fetch the JSON data

zenity --notification --text "Data successfully fetched"
# Extract relevant fields from the JSON data and format it as a table
table_data=$(echo "$json_data" | jq -r '.data[] | "\(.CompanyName), \(.MarketCap), \(.NSECode), \(.ltp), \(.dayChange), \(.dayChangePerc), \(.TodayHigh), \(.TodayLow), \(.YrHigh), \(.YrLow)"' | column -t -s ',')

# Add column names to the table
column_names="Company Name, Market Cap, NSE Code, Last Traded Price, Day Change, Day Change Percentage, Today's High, Today's Low, Yearly High, Yearly Low\n"
table_with_header=$(echo -e "$column_names\n$table_data")

# Display the table
clear
if [ table_data==null ] 
then
    echo "No data exits"
    return
fi
spd-say "Data is now visible on terminal"
printf "\n"
figlet "52 Week Low" |lolcat
echo "$table_with_header" |lolcat

}

stockAnalyzer(){
    #!/bin/bash

# Display the Zenity TUI with four options
CHOICE=$(zenity --list --title="Stock Menu" --text="Select an option:" \
                --column="Option" --column="Description" \
                1 "Top Gainers" \
                2 "Top Losers" \
                3 "Nifty Index Tracking" \
                4 "Heatmap" \
                5 "52 weeks High" \
                6 "52 weeks low" \
                --hide-header --height=300 --width=600)

# Check the user's choice and perform the corresponding action
case $CHOICE in
    1)
        # Action for "Top Gainers" option
        # zenity --info --title="Top Gainers" --text="You selected 'Top Gainers' option."
         todaysGainer
        # Add your code for top gainers here
        ;;
    2)
        # Action for "Top Losers" option
        todaysLoser
        # Add your code for top losers here
        ;;
    3)
        # Action for "Nifty Index Tracking" option
        zenity --info --title="Nifty Index Tracking" --text="You selected 'Nifty Index Tracking' option."
        # Add your code for Nifty index tracking here
        ;;
    4)
        # Action for "Heatmap" option
        zenity --info --title="Heatmap" --text="You selected 'Heatmap' option."
        # Add your code for heatmap here
        ;;
         5)
        # Action for "Heatmap" option
       52WeekHigh
        # Add your code for heatmap here
        ;;

     6)
        # Action for "Heatmap" option
        52WeekLow
        # Add your code for heatmap here
        ;;
    *)
        # Invalid choice or dialog closed
        zenity --error --title="Error" --text="Invalid choice or dialog closed."
        ;;
esac

}



clear

#******TITLE***********
figlet "STOCK ANALYZER" |lolcat
printf "\033[5;33m                  Stock Analyzing made easy\033[0m\n"
#*****TITILE END******
spd-say  'Stock Analyzer'



login

