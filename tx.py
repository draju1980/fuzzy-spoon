import requests
import json

# WALLET_ADDRESS = "0x00000000219ab540356cBB839Cbe05303d7705Fa"

def fetch_transactions():
    url = f"https://api.etherscan.io/api?module=account&action=txlist&address=0x00000000219ab540356cBB839Cbe05303d7705Fa&startblock=0&endblock=99999999&page=1&offset=100&sort=desc&apikey=UUS1IK6MQFRV6TC935VUXNZJZR8NI41WUT"
    
    response = requests.get(url)
    data = response.json()

    if data["status"] == "1":
        with open("transactions.json", "w") as f:
            json.dump(data["result"], f, indent=4)
        print("Transactions saved to transactions.json")
    else:
        print("Error fetching transactions:", data["message"])

fetch_transactions()