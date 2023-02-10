from sys import exit
import requests, json, urllib3, os, re
from tabulate import tabulate

from dotenv import load_dotenv
load_dotenv('/opt/.env')

X_Auth_Key = os.environ['X_Auth_Key']
ACCOUNT_ID = os.environ['ACCOUNT_ID']
SUBDOMAIN = os.environ['SUBDOMAIN']
IP = os.environ['IP']
DOMAIN = os.environ['DOMAIN']
X_Auth_Email = "fsteam2023@gmail.com"

def get_zoneid(domain):
    headers = {
        'X-Auth-Email': '{}'.format(X_Auth_Email),
        'X-Auth-Key': '{}'.format(X_Auth_Key),
        'Content-Type': 'application/json',
    }

    params = {
        'name': '{}'.format(domain),
        'status': 'active',
        'account.id': '{}'.format(ACCOUNT_ID),
        'page': '1',
        'per_page': '20',
        'order': 'status',
        'direction': 'desc',
        'match': 'all',
    }

    response = requests.get('https://api.cloudflare.com/client/v4/zones', params=params, headers=headers)
    data = json.loads(response.text)
    zoneid = data['result'][0].get('id')
    return zoneid

def create_subdomain(SUBDOMAIN, DOMAIN, IP):
    zoneid = get_zoneid(DOMAIN)
    headers = {
        'X-Auth-Email': '{}'.format(X_Auth_Email),
        'X-Auth-Key': '{}'.format(X_Auth_Key),
    
    }

    json_data = {
        'type': 'A',
        'name': '{}'.format(SUBDOMAIN),
        'content': '{}'.format(IP),
        'ttl': 1,
        'proxied': True,
}

    response = requests.post('https://api.cloudflare.com/client/v4/zones/{0}/dns_records'.format(zoneid), headers=headers, json=json_data)
    return response

if __name__ == "__main__":
    table = []
    headers = ["Type", "Name", "Content"]
    text = ""

    state = create_subdomain(SUBDOMAIN, DOMAIN, IP)
    if state.status_code == 200:
        text = "Create subdomain success, status code {}".format(state.status_code)
        data = json.loads(state.text)
        table.append([
            data['result'].get('type'),
            data['result'].get('name'),
            data['result'].get('content')
        ])
        text = tabulate(table, headers=headers, tablefmt="pretty")
        print(text)
    else:
        text = "something went wrong !!!"
        print(text)
