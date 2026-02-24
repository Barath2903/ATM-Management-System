
# ATM Management System - Debit & Credit Transaction Process

set -u

ATM_PIN=""
balance=0
customer_name=""
id_type=""
id_value=""
account_type=""

trap 'printf "\nSession interrupted. Transaction aborted.\n"; exit 1' INT TERM

Customer_Details() {
  while true; do
    echo "Account Creation Process Started..."

    read -r -p "Enter the FullName in Bold Letters: " customer_name
    customer_name="${customer_name//  / }"

    if [[ ! "$customer_name" =~ ^[A-Za-z][A-Za-z[:space:]]*$ ]]; then
      echo "Invalid Customer Name."
      echo "Account Creation Process Failed. Restarting Again....."
      echo "------------------------------------------------------"
      continue
    fi

    read -r -p "Enter the ID Proof Type [Ex: Aadhar, Pan, License, etc..]: " id_type

    # Command substitution + string normalization
    id_type="$(echo "$id_type" | tr -d '[:space:]')"
    id_type_lower="$(echo "$id_type" | tr '[:upper:]' '[:lower:]')"

    case "$id_type_lower" in
      aadhar)
        id_type="Aadhar"
        read -r -p "Enter Aadhar Number: " id_value
        if [[ ! "$id_value" =~ ^[0-9]{12}$ ]]; then
          echo "Invalid Aadhar Number. Enter exactly 12 digits like 123412341234."
          echo "Account Creation Process Failed. Restarting Again....."
          echo "------------------------------------------------------"
          continue
        fi
        ;;
      pan)
        id_type="Pan"
        read -r -p "Enter Pan Card Details [Note: Without Special Characters and Spaces: " id_value
        id_value="${id_value// /}"
        id_value="$(echo "$id_value" | tr '[:lower:]' '[:upper:]')"
        if [[ ! "$id_value" =~ ^[A-Z]{5}[0-9]{4}[A-Z]$ ]]; then
          echo "Invalid PAN Number. Enter full PAN format like ABCDE1234F."
          echo "Account Creation Process Failed. Restarting Again....."
          echo "------------------------------------------------------"
          continue
        fi
        ;;
      license)
        id_type="License"
        read -r -p "Enter the License Number: " id_value
        id_value="${id_value// /}"
        if [[ ! "$id_value" =~ ^[A-Za-z0-9]{15}$ ]]; then
          echo "Invalid License Number. Enter full 15-character alphanumeric value like TN0120230001234."
          echo "Account Creation Process Failed. Restarting Again....."
          echo "------------------------------------------------------"
          continue
        fi
        ;;
      *)
        echo "InValid ID Proof Type."
        echo "Account Creation Process Failed. Restarting Again....."
        echo "------------------------------------------------------"
        continue
        ;;
    esac

    read -r -p "Enter the Account Type as Savings or Current: " account_type
    account_type="$(echo "$account_type" | tr -d '[:space:]')"
    account_type="$(echo "$account_type" | tr '[:upper:]' '[:lower:]')"

    if [[ "$account_type" == "savings" ]]; then
      account_type="Savings"
    elif [[ "$account_type" == "current" ]]; then
      account_type="Current"
    else
      echo "InValid Account Type"
      echo "Account Creation Process Failed. Restarting Again....."
      echo "------------------------------------------------------"
      continue
    fi

    read -r -p "Enter the Deposit Amount: Rs." deposit_amount

    if [[ ! "$deposit_amount" =~ ^[0-9]+$ || "$deposit_amount" -le 0 ]]; then
      echo "InValid Deposit Amount. [Note: Numbers only Allowed."
      echo "Account Creation Process Failed. Restarting Again....."
      echo "------------------------------------------------------"
      continue
    fi

    balance=$((balance + deposit_amount))
    ATM_PIN=$(( (RANDOM + RANDOM + $(date +%s)) % 9000 + 1000 ))

    echo
    echo "Account Created Successfully with Initial Deposit"
    echo "Your Current Available Balance is Rs.$balance"
    Customer_Choice
    return
  done
}

Customer_Choice() {
  while true; do
    read -r -p "Do you want to Apply for ATM Card: Type Yes or No: " apply_card
    apply_card="$(echo "$apply_card" | tr '[:upper:]' '[:lower:]')"

    if [[ "$apply_card" == "no" ]]; then
      echo "Thanks for Being a Valuable Customer to Us"
      return
    elif [[ "$apply_card" == "yes" ]]; then
      echo "Your ATM Card is Processed"
      echo "Your Temporary ATM Pin Number is: $ATM_PIN"

      read -r -p "Do you want Access ATM?: Type Okay or Cancel: " atm_access
      atm_access="$(echo "$atm_access" | tr '[:upper:]' '[:lower:]')"

      if [[ "$atm_access" == "cancel" ]]; then
        echo "Thankyou Visit Again !!"
        return
      elif [[ "$atm_access" == "okay" ]]; then
        ATM_Process
        return
      else
        echo "Invalid Choice. Type Okay or Cancel"
      fi
    else
      echo "Invalid Choice. Type Yes or No"
    fi
  done
}

ATM_Process() {
  while true; do
    read -r -p "Enter the Pin Number: " entered_pin

    if [[ "$entered_pin" != "$ATM_PIN" ]]; then
      echo "Invalid Pin Number"
      continue
    fi

    echo "Welcome $customer_name!!"
    read -r -p "Enter 1 For Cash Withdraw or 2 For Cash Deposit: " transaction_choice

    if [[ "$transaction_choice" == "1" ]]; then
      Debit_Process
      return
    elif [[ "$transaction_choice" == "2" ]]; then
      Credit_Process
      return
    else
      echo "You Have Entered Wrong Choice. Restarting the Process Again......"
      echo "------------------------------------------------------"
    fi
  done
}

Debit_Process() {
  while true; do
    read -r -p "Enter the Amount to Withdraw: Rs." withdraw_amount

    if [[ ! "$withdraw_amount" =~ ^[0-9]+$ || "$withdraw_amount" -lt 100 || $((withdraw_amount % 100)) -ne 0 ]]; then
      echo "Invalid amount entered. Acceptable denomination is 100,200,500"
      continue
    fi

    if (( withdraw_amount > balance )); then
      echo "Insufficient Balance"
      echo "Your Current Available is Rs.$balance"
      continue
    fi

    balance=$((balance - withdraw_amount))
    echo "Your Current Available Balance After Deduction is Rs.$balance"
    echo "Thank You for Using Our ATM Services. Visit Again !!"

    return
  done
}

Credit_Process() {
  while true; do
    read -r -p "Enter the Amount to Deposit Rs." deposit_amount

    if [[ ! "$deposit_amount" =~ ^[0-9]+$ || "$deposit_amount" -lt 100 || $((deposit_amount % 100)) -ne 0 ]]; then
      echo "Invalid amount entered. Acceptable denomination is 100,200,500"
      continue
    fi

    balance=$((balance + deposit_amount))
    echo "Your Amount Deposited Successfully !!"
    echo "Your Current Available Balance is Rs.$balance"
    echo "Thank You for Using Our ATM Services. Visit Again !!"
    return
  done
}

Customer_Details
