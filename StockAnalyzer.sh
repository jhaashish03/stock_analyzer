#!/bin/bash

#********Database Properties**********
HOSTNAME="localhost"
DATABASE_NAME="<name>"
USERNAME="<name>"
PASSWORD="<password>"
#************************************
sendSms(){
    #hidden due to sensititvity
  
}
loginWithPassword(){
    status=1;
logflag=1
until [ $logflag -eq 0 ]
do
user_loginid=$(dialog --title "Login into Stock Analyzer as User"\
 --form "Enter  your credentitals"\
  10 30 1 \
  "Login-ID:" 1 1 "" 1 10 30 10 2>&1 >/dev/tty)
  if [ $? == 0 ]
  then

   
user_password=$(dialog --passwordbox "Password" 10 30 2>&1 >/dev/tty)
 if [ $? == 0 ]
  then

QUERY_RESULT=$(mysql -h $HOSTNAME -u $USERNAME -p$PASSWORD -D $DATABASE_NAME  -se "SELECT password FROM user WHERE mobile_number='$user_loginid';" 2>/dev/null)
# echo $QUERY_RESULT

if [ $QUERY_RESULT == $user_password ]
then
logflag=0
else
spd-say "Invalid Credentials! Try Again!!!"
fi
fi
else
spd-say "You are out of login page."
zenity --notification --text "You are out of login page."
exit 1

fi
done
spd-say 'User Login Successfull'
clear
return 0

}

signUp(){
    new_user_detail=$(dialog --form "ENTER YOUR DETAILS" 15 50 8 \
"First Name:" 1 1 "" 1 15 25 0 \
"Last Name:" 2 1 "" 2 15 25 0 \
"Mobile Number:" 3 1 "" 3 15 25 10 \
"Email:" 4 1 "" 4 15 25 0 \
"Address:" 5 1 "" 5 15 25 0 \
"District:" 6 1 "" 6 15 25 0 \
"State:" 7 1 "" 7 15 25 0 \
"Pincode:" 8 1 "" 8 15 25 6 2>&1 >/dev/tty)
#****User Details taken*****

#**Counting the no of inputs"
wc=`echo $new_user_detail|wc -w`


#*****Setting the input values into variables****

first_name=`echo $new_user_detail|cut -d " " -f 1`
last_name=`echo $new_user_detail|cut -d " " -f 2`
mobile_number=`echo $new_user_detail|cut -d " " -f 3`
email=`echo $new_user_detail|cut -d " " -f 4`
address=`echo $new_user_detail|cut -d " " -f 5`
district=`echo $new_user_detail|cut -d " " -f 6`
state=`echo $new_user_detail|cut -d " " -f 7`
pincode=`echo $new_user_detail|cut -d " " -f 8`

already_a_user=$(mysql -h $HOSTNAME -u $USERNAME -p$PASSWORD -D $DATABASE_NAME  -se "SELECT firstname FROM user WHERE mobile_number='$mobile_number';" 2>/dev/null)
#***Values settled*****
if [ $? == 0 ]
then


if [ ! -z "$already_a_user" ]
then
spd-say "You are already registered into Stock Analyzer "
dialog --title "Electronic Bill Management System" --infobox "\n This mobile number is already registered with Stock Analyzer. \n \n Try logging in as user in Stock Analyzer." 10 40
else

if [ -z $new_user_detail ]
then
dialog  --infobox   "NO VALUE ENTERED" 15 30 
else
#***Random Number Generation******
meter_number=`shuf -i 100000-999999 -n 1`
dialog --msgbox "Your account has been created with name $first_name and loginid $mobile_number.\n\n Click Ok to continue to create password. " 15 25 


#***PASSWORD GENERATION WINDOW******
flag=1


until [ $flag -eq 0 ]
do
password=$(dialog --passwordform "Create Your Password" 15 50 4  \
  "New Password:" 1 1 "" 1 15 25 0 \
  "Re-Password:" 2 1 "" 2 15 35 0 2>&1 >/dev/tty)

pass=`echo $password|cut -d " " -f 1`
rpass=`echo $password|cut -d " " -f 2`
if [ $pass -eq $rpass ]
then
break;
else
spd-say "Try Again!!!"
fi

done
#***Password generated******


#****Connecting with mysql****************
mysql -h $HOSTNAME -u $USERNAME -p$PASSWORD -D $DATABASE_NAME  -se "insert into bill (meter_id) values($meter_number);" 2>/dev/null
mysql -h $HOSTNAME -u $USERNAME -p$PASSWORD -D $DATABASE_NAME  -se "insert into user values('$first_name','$last_name','$mobile_number','$email','$address','$district','$state',$pincode,$meter_number,$pass);" 2>/dev/null
mysql -h $HOSTNAME -u $USERNAME -p$PASSWORD -D $DATABASE_NAME  -se "insert into deposit (meter_id) values($meter_number);" 2>/dev/null

# dialog --msgbox "Your account has been successfully created with meter-id $meter_number" 15 25 
fi
fi
fi

if [  -z "$already_a_user" ];then

cat <<EOF > login.html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Sign Up Successful</title>
	<style>
		body {
			font-family: Arial, sans-serif;
			background-color: #f2f2f2;
			color: #333333;
			margin: 0;
			padding: 0;
		}

		.container {
			max-width: 600px;
			margin: 0 auto;
			padding: 20px;
			background-color: #a4eeee;
			box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
		}

		h1 {
			font-size: 28px;
			font-weight: bold;
			margin-bottom: 20px;
			text-align: center;
		}

		p {
			font-size: 16px;
			line-height: 1.5;
			margin-bottom: 20px;
		}

		.btn {
			display: inline-block;
			background-color: #4CAF50;
			color: #ffffff;
			padding: 10px 20px;
			border-radius: 4px;
			text-decoration: none;
			font-size: 16px;
		}

		.btn:hover {
			background-color: #3e8e41;
		}
	</style>
</head>
<body>
	<div class="container">
		<h1 style="color: mediumblue;">Sign Up Successful</h1>
		<p>Dear $first_name,</p>
		<p>Thank you for signing up with our service. Your account has been successfully created.</p>
		<p>You can now login to your account and start using our service.</p>
		<p>Login Id :<b> $mobile_number</b></p>

		<p>If you have any questions or need assistance, please feel free to contact our support team.</p>
		<p>Best regards,</p>
		<p style="color: cornflowerblue;"><b><i>Stock Analyzer Team</i></b></p>
		<a href="#" class="btn">Login Now</a>
	</div>
</body>
</html>

EOF
echo "Message body" | (echo "To: $email"; echo "Subject: Sign Up Sucessful"; echo "Content-Type: text/html"; echo "Content-Disposition: inline"; cat login.html) | ssmtp $email

spd-say 'Mail Successfully Sent'
zenity --notification --text "Sign up successfull"
login

fi
#******Database Insertion ended**************


#****ON CLICKING CANCEL OUTER IF*************


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
    loginWithPassword
     if [ $? == 0 ];
    then
    home
    fi
    
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
    signUp
    
    ;;
  *)
    # Handle cancel or close button click
    zenity --info --text="No option selected."
    ;;
esac

}

curencyExchange(){
    from_currency=$(zenity --entry --title "Currency Conversion" --text "From Currency Code:" --entry-text "USD")
to_currency=$(zenity --entry --title "Currency Conversion" --text "To Currency Code:" --entry-text "EUR")
amount=$(zenity --entry --title "Currency Conversion" --text "Enter the amount in number:" --entry-text "1")
# Display the selected values
zenity --info --title "Currency Conversion" --text "From Currency: $from_currency\nTo Currency: $to_currency"
json_data=$(curl -s "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=$from_currency&to_currency=$to_currency&apikey=WG296OTTF1HY8CYD")
data=$(echo "$json_data" | jq -r '.["Realtime Currency Exchange Rate"] | to_entries | .[] | .key + ": " + .value' )

figlet "Currency Conversion" |lolcat
echo "$data" |lolcat

# Perform currency conversion or further processing using the selected values
# Your code goes here
}
cryptoExchange(){
     from_crypto=$(zenity --entry --title "Crypto Exchange" --text "From- Crypto Code:" --entry-text "BTC")
to_currency=$(zenity --entry --title "Currency Conversion" --text "To- Currency Code:" --entry-text "EUR")

# Display the selected values
zenity --info --title "Crypto Exchange" --text "From Currency: $from_currency\nTo Currency: $to_currency"
json_data=$(curl -s "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=$from_crypto&to_currency=$to_currency&apikey=WG296OTTF1HY8CYD")
data=$(echo "$json_data" | jq -r '.["Realtime Currency Exchange Rate"] | to_entries | .[] | .key + ": " + .value' )

figlet "Crypto Exchange" |lolcat
echo "$data" |lolcat
}
# After Successfull login

foreignExchange(){
    # Display Zenity dialog to select the option
option=$(zenity --list --title "Foreign Exchange" --text "Select an option:" --column "Option" "Currency Exchange Rate" "Crypto Exchange")

# Check the selected option
case "$option" in
    "Currency Exchange Rate")
      curencyExchange
        # Your code for Currency Exchange Rate goes here
        ;;
    "Crypto Exchange")
        
        cryptoExchange
        # Your code for Crypto Exchange goes here
        ;;
    *)
        zenity --error --title "Error" --text "Invalid option selected. Exiting."
        exit 1
        ;;
esac
}

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
       searchSpecificStock
        # Add your code for searching specific stock here
        ;;
    2)
        # Action for "Live Market Feed of Stock" option
       allstockswithprice
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
        foreignExchange
        # Add your code for foreign exchange here
        ;;
    *)
        # Invalid choice or dialog closed
        zenity --error --title="Error" --text="You have not selected any option."
        ;;
esac

}


searchSpecificStock(){
    nse_code=$(zenity --entry --title "NSE Code Input" --text "Enter NSE Code:")

# Check if the user canceled or left the input blank
if [[ -z $nse_code ]]; then
    zenity --error --title "Error" --text "No NSE code provided. Exiting."
    exit 1
fi


    json_data=$(curl -s "https://api.stockmarketapi.in/api/v1/getprices?token=620afdf266e887be433a571efcf01a498f53295a73878494e9bc8dd6c3c7104f&nsecode=$nse_code") # Replace <API_URL> with the actual URL to fetch the JSON data

zenity --notification --text "Data successfully fetched"
# Extract relevant fields from the JSON data and format it as a table
table_data=$(echo "$json_data" | jq -r '.data[] | "\(.NSECode), \(.TodayOpen), \(.TodayHigh), \(.TodayLow), \(.TodayClose), \(.ltp), \(.dayChange), \(.dayChangePerc), \(.volume), \(.totalBuyQty), \(.totalSellQty)"' | column -t -s ',')

# Add column names to the table
column_names="NSE Code, TodayOpen,Today's High, Today's Low, TodayClose, ltp, dayChange, dayChangePerc, volume, totalBuyQty, totalSellQty\n"
table_with_header=$(echo -e "$column_names\n$table_data")

# Display the table
clear
spd-say "Data is now visible on terminal"
printf "\n"
figlet "$nse_code Stock details" |lolcat
echo "$table_with_header" |lolcat
}

allstockswithprice(){
    

# Fetch JSON data from the API
json_data=$(curl -s "https://api.stockmarketapi.in/api/v1/allstocks?token=620afdf266e887be433a571efcf01a498f53295a73878494e9bc8dd6c3c7104f") # Replace <API_URL> with the actual URL to fetch the JSON data

zenity --notification --text "Data successfully fetched"
# Extract relevant fields from the JSON data and format it as a table
table_data=$(echo "$json_data" | jq -r '.data[] | "\(.CompanyName), \(.MarketCap), \(.NSECode), \(.TodayOpen), \(.TodayHigh), \(.TodayLow), \(.TodayClose), \(.ltp), \(.dayChange), \(.dayChangePerc), \(.volume), \(.totalBuyQty), \(.totalSellQty), \(.YrHigh), \(.YrLow)"' | column -t -s ',')

# Add column names to the table
column_names="Company Name, Market Cap, NSE Code, Last Traded Price, Day Change, Day Change Percentage, Today's High, Today's Low, Yearly High, Yearly Low\n"
table_with_header=$(echo -e "$column_names\n$table_data")

# Display the table
clear
spd-say "Data is now visible on terminal"
printf "\n"
figlet "Live Market Feed of Stock" |lolcat
echo "$table_with_header" |lolcat


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
                3 "NIFTY INDEX LIVE Data" \
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
       niftyIndexTracking
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
niftyIndexTracking(){
    


    json_data=$(curl -s "https://api.stockmarketapi.in/api/v1/indexprice?token=620afdf266e887be433a571efcf01a498f53295a73878494e9bc8dd6c3c7104f&indexcode=BANKNIFTY,NIFTY,FINNIFTY,NIFTY100,NIFTYMIDCAP,NIFTYAUTO,NIFTYFMCG,NIFTYIT,NIFTYMEDIA,NIFTYMETAL,NIFTYPHARMA,NIFTYPSUBANK,NIFTYPVTBANK,NIFTYREALTY") # Replace <API_URL> with the actual URL to fetch the JSON data

zenity --notification --text "Data successfully fetched"
# Extract relevant fields from the JSON data and format it as a table
table_data=$(echo "$json_data" | jq -r '.data[] | "\(.NSECode), \(.TodayOpen), \(.TodayHigh), \(.TodayLow), \(.TodayClose), \(.ltp), \(.dayChange), \(.dayChangePerc)"' | column -t -s ',')

# Add column names to the table
column_names="NSE Code, TodayOpen,Today's High, Today's Low, TodayClose, ltp, dayChange, dayChangePerc\n"
table_with_header=$(echo -e "$column_names\n$table_data")

# Display the table
clear
spd-say "Data is now visible on terminal"
printf "\n"
figlet "NIFTY INDEX LIVE Data" |lolcat
echo "$table_with_header" |lolcat

}


clear

#******TITLE***********
figlet "STOCK ANALYZER" |lolcat
printf "\033[5;33m                  Stock Analyzing made easy\033[0m\n"
#*****TITILE END******
spd-say  'Stock Analyzer'


sleep 3s
login
