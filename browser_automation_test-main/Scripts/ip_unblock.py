# -*- coding: utf-8 -*-

import os
import json
import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning
import argparse
from argparse import RawTextHelpFormatter
import re
from pathlib import Path

current_path = Path(__file__).parent
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

with open(os.path.join(os.path.dirname(os.path.realpath(__file__)),"..","Variables","OCAIP_Variables.txt"), encoding = 'utf8') as f:
    API_URL = re.search(r'(?<=\${gOCAIP sURL} {4}).*', f.read()).group(0)
with open(os.path.join(os.path.dirname(os.path.realpath(__file__)),"Admin_token.txt"), encoding = 'utf8') as f:
    API_COOKIE = f.read()

parser = argparse.ArgumentParser(description='IP Unblock',formatter_class=RawTextHelpFormatter)

parser.add_argument('-s', '--server',
                    type=int,
                    required=False,
                    default=2,
                    choices=[1, 2],
                    help='1 is local server;\n2 is ocaip-dev.xaas.tw server')

parser.add_argument('-c', '--code',
                    action='store_true',
                    help='Return http status code')

INFO = '\033[1;38m'
FAIL = '\033[1;31m'
SUCCESS = '\033[1;32m'
HIGHLIGHT = '\033[1;44m'
END = '\033[1;m'

class PrintStatus:
    INFO = 'info'
    FAIL = 'fail'
    HIGHLIGHT = 'highlight'
    SUCCESS = 'success'

def color_print(status, msg):
    if status == PrintStatus.FAIL:
        print('{}{}{}'.format(FAIL, msg, END))
    elif status == PrintStatus.INFO:
        print('{}{}{}'.format(INFO, msg, END))
    elif status == PrintStatus.SUCCESS:
        print('{}{}{}'.format(SUCCESS, msg, END))
    elif status == PrintStatus.HIGHLIGHT:
        print('{}{}{}'.format(HIGHLIGHT, msg, END))

def main(args):
    headers = {'Cookie': 'JWT='+API_COOKIE}
    try:
        if args.server == 1:
            r = requests.delete('http://{}/admin/ip_block'.format(API_URL),
                             headers=headers, verify=False)
        else:
            r = requests.delete('https://{}/admin/ip_block'.format(API_URL),
                             headers=headers, verify=False)
        if args.code:
            print(r.status_code)
        else:
            if r.status_code == 403:
                color_print(PrintStatus.FAIL, '403 forbidden (token錯誤/過期?)')
            elif json.loads(r.text)['success'] == True:
                color_print(PrintStatus.SUCCESS, '解鎖成功')
    except Exception as e:
        color_print(PrintStatus.FAIL, '連線失敗: {}'.format(str(e)))

if __name__ == '__main__':
    args = parser.parse_args()
    try:
        main(args)
    except Exception as e:
        print(str(e))

