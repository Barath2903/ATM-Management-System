# ATM-Management-System
This is a shell script-based project that simulates debit and credit transactions. It includes functions for account creation, ATM access, transaction selection, withdrawal, and deposit. The system validates PIN, balance, and denomination rules while providing clear user prompts and error handling through an interactive terminal interface.

1. Project Objective
The script performs:

Customer account creation
ID proof validation (Aadhar / PAN / License)
ATM card processing flow
PIN authentication
Debit (withdraw)
Credit (deposit)
It validates inputs, handles errors, and restarts or re-prompts based on conditions.

2. How to Run
Open terminal.
Go to project folder:
cd "/Users/barath/Shell Scripting"
Make executable (one-time):
chmod +x Transaction.sh
Run:
./Transaction.sh
3. Step-by-Step Flow
Step 1: Customer_Details
This function runs first.

It asks for:

Full name
ID proof type (Aadhar, Pan, License)
ID value based on selected type
Account type (Savings or Current)
Initial deposit amount
Validation logic:

Name: letters and spaces only
Aadhar: exactly 12 digits (example: 123412341234)
PAN: format AAAAA9999A (example: ABCDE1234F)
License: 15 alphanumeric characters (example: TN0120230001234)
Account type: only Savings or Current
Deposit: positive number
If any validation fails:

Error message is displayed
Account Creation Process Failed. Restarting Again.....
Function restarts from beginning
If successful:

Initial balance is stored
A new random 4-digit ATM PIN is generated
Control moves to Customer_Choice
Step 2: Customer_Choice
Prompts user:

Do you want to Apply for ATM Card: Type Yes or No
If No:

Prints thank-you message and exits flow.
If Yes:

Displays card processed message
Displays generated temporary 4-digit ATM PIN
Asks:
Do you want Access ATM?: Type Okay or Cancel
If Cancel:

Prints visit-again message and exits.
If Okay:

Moves to ATM_Process.
Step 3: ATM_Process
Prompts for PIN:

Must match the generated PIN
If wrong, shows Invalid Pin Number and asks again
After successful PIN:

Shows Welcome User!!
Asks transaction choice:
1 for debit
2 for credit
If choice is invalid:

Shows wrong-choice error
Restarts transaction selection loop
If 1:

Calls Debit_Process
If 2:

Calls Credit_Process
Step 4: Debit_Process
Prompts for withdraw amount.

Validation:

Must be numeric
Must be at least 100
Must be multiple of 100
If invalid denomination:

Invalid amount entered. Acceptable denomination is 100,200,500
Re-prompts amount
Balance rule:

If withdraw amount > available balance:
Insufficient Balance
Shows available balance
Re-prompts amount
If valid and sufficient:

Deducts amount from balance
Displays updated balance
Step 5: Credit_Process
Prompts for deposit amount.

Validation:

Must be numeric
Must be at least 100
Must be multiple of 100
If invalid denomination:

Invalid amount entered. Acceptable denomination is 100,200,500
Re-prompts amount
If valid:

Adds amount to balance
Displays deposit success and updated balance
4. Functions Used (Mandatory 5)
Customer_Details
Customer_Choice
ATM_Process
Debit_Process
Credit_Process
5. Bash Concepts Used in This Code
5.1 Functions
All major processes are modularized into 5 functions.
5.2 User Input
read -r -p "..." variable
Inputs are read interactively from terminal.
5.3 Control Structures
while true loops for retry/restart behavior
if / elif / else for decisions
case for ID proof type selection
5.4 Pattern Matching (Regex)
Used with [[ ... =~ ... ]]:

Name validation
Aadhar 12-digit validation
PAN format validation
License format validation
Numeric amount validation
5.5 String Manipulation / Substitution
Remove spaces: ${var// /}
Normalize whitespace: ${customer_name//  / }
Case conversion using tr:
tr '[:upper:]' '[:lower:]'
tr '[:lower:]' '[:upper:]'
5.6 Command Substitution
id_type_lower="$(echo "$id_type" | tr ... )"
account_type="$(echo "$account_type" | tr ... )"
ATM_PIN=$(( ... $(date +%s) ... ))
5.7 Arithmetic Expansion
Initial deposit add: balance=$((balance + deposit_amount))
Debit: balance=$((balance - withdraw_amount))
Credit: balance=$((balance + deposit_amount))
PIN generation math and modulo checks
5.8 Error Handling
Invalid data paths print clear status/error messages
Loop continues until valid input is provided
trap handles interrupt/termination signals:
INT, TERM
6. Important Business Rules Implemented
Account creation must complete before ATM flow.
ATM access allowed only after ATM card flow (Yes + Okay).
PIN must match generated temporary PIN.
Debit allowed only with sufficient balance.
Debit/Credit denomination rule currently checks multiples of 100.
7. Notes
Temporary ATM PIN is generated fresh for each successful account creation.
Current denomination validation message says acceptable denominations are 100,200,500.
8. Example Inputs
Aadhar: 123412341234
PAN: ABCDE1234F
License: TN0120230001234
Account Type: Savings
Initial Deposit: 10000
ATM Card: Yes
ATM Access: Okay
PIN: use the generated 4-digit PIN shown by the script
Transaction: 1 (Debit) or 2 (Credit)
