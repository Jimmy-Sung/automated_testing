import os
import json
import datetime
import uuid
import re
from dateutil.relativedelta import relativedelta
import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning
import argparse
from argparse import RawTextHelpFormatter

requests.packages.urllib3.disable_warnings(InsecureRequestWarning)
current_path = os.path.dirname(os.path.realpath(__file__))

API_PREFIX = '/api/v1'
API_USERNAME = 'apiadmin'
with open(os.path.join(current_path,"..","Variables","OCAIP_Variables.txt"), encoding = 'utf8') as f:
    API_URL = re.search(r'(?<=\${gOCAIP sURL} {4}).*', f.read()).group(0)
    f.seek(0)
    API_PASSWORD = re.search(r'(?<=\${gOCAIP PASSWORD} {4}).*', f.read()).group(0)
    f.seek(0)
    API_PATH = re.search(r'(?<=\${gOCAIP PATH} {4}).*', f.read()).group(0)

UTC_DATETIME_FORMAT = "%Y-%m-%dT%H:%M:%SZ"

DATETIME_FORMAT = "%Y/%m/%d-%H:%M:%S"
PRECISE_UTC_DATETIME_FORMAT = "%Y/%m/%d-%H:%M:%S"

parser = argparse.ArgumentParser(description="To change the topic status", formatter_class=RawTextHelpFormatter)

parser.add_argument('-t', '--topic_id',
                    type=str,
                    required=False,
                    default=None,
                    help='Enter a topic ID')

parser.add_argument('-s', '--server',
                    type=int,
                    required=True,
                    default=None,
                    choices=[1, 2],
                    help='1 is local server;\n2 is ocaip-dev.xaas.tw server')

parser.add_argument('-S', '--shift',
                    type=int,
                    default=0,
                    help='Time Shift in Secs')

parser.add_argument('-o', '--operation',
                    type=str,
                    required=True,
                    default=None,
                    help='END_TOPIC: show the final ranking;\nEND_ALL: end all open topics.\nEND_STAGE: change topic to stage 2;\nEND_JOIN: make topic can not join;\nSTART_SEL: change to selecting stage;\nDEL_UTEST: delete the utest.;\nPOST_MESSAGES: post multiple messages')

parser.add_argument('-n', '--number_of_post',
                    type=int,
                    required=False,
                    default=200,
                    help='Enter a counts want to post')

def gen_posts(topic_id, counts):

    datas = []
    for i in range(0,counts):
        data = {}
        data['title'] = ""
        data['message'] = 'kerker_'+str(i)
        data['poster'] = 't1'
        data['poster_id'] = i
        data['parent_type'] = 'TOPIC'
        data['parent_id'] = topic_id
        datas.append(data)
    return datas

def change_data(args):
    server = args.server
    if server == 1:
        USER_SERVICE = 'http://localhost:5010'
        TOPIC_SERVICE = 'http://localhost:5020'
        #STORAGE_SERVICE = 'http://localhost:5040'
        EVAL_SERVICE = 'http://localhost:5060'
    elif server == 2:
        USER_SERVICE = 'https://{}:{}@{}/{}/user'.format(API_USERNAME, API_PASSWORD, API_URL, API_PATH)
        TOPIC_SERVICE = 'https://{}:{}@{}/{}/topic'.format(API_USERNAME, API_PASSWORD, API_URL, API_PATH)
        #STORAGE_SERVICE = 'https://{}:{}@{}/{}/storage'.format(API_USERNAME, API_PASSWORD, API_URL, API_PATH)
        EVAL_SERVICE = 'https://{}:{}@{}/{}/eval'.format(API_USERNAME, API_PASSWORD, API_URL, API_PATH)
        DISCUSS_SERVICE = 'https://{}:{}@{}/{}/discuss'.format(API_USERNAME, API_PASSWORD, API_URL, API_PATH)

    if args.operation == 'END_TOPIC':
        start_date_datetime = datetime.datetime.utcnow() + relativedelta(days=-4)
        join_start_date_datetime = datetime.datetime.utcnow() + relativedelta(days=-3)
        join_end_date_datetime = datetime.datetime.utcnow() + relativedelta(days=-2)
        if args.shift == 0:
            end_date_datetime = datetime.datetime.now() + relativedelta(hours=-8)
        else:
            end_date_datetime = datetime.datetime.now() + relativedelta(hours=-8, seconds=args.shift)
        eval_submit_end_date_datetime = end_date_datetime

        update_date = {
            'username': 'u2',
            'start_date': start_date_datetime.strftime(UTC_DATETIME_FORMAT),
            'join_start_date': join_start_date_datetime.strftime(UTC_DATETIME_FORMAT),
            'join_end_date': join_end_date_datetime.strftime(UTC_DATETIME_FORMAT),
            'end_date': end_date_datetime.strftime(UTC_DATETIME_FORMAT),
            'eval_submit_end_date': eval_submit_end_date_datetime.strftime(UTC_DATETIME_FORMAT)
        }

        topic_id = args.topic_id
        headers = {'Content-type': 'application/json'}
        r_change_date = requests.put('{}{}/topics/update_info/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                         data=json.dumps(update_date),
                                     headers=headers, verify=False)
        if r_change_date.ok:
            print('Successfully change topic date.')
        else:
            print('Failed to change topic date.')

        r_show_private = requests.get('{}{}/eval/check_topic_end'.format(EVAL_SERVICE, API_PREFIX), verify=False)
        if r_show_private:
            print('Successfully showed the private board.')
        else:
            print('Failed to show private board.')

    if args.operation == 'END_ALL':
        r_list = requests.get('{}{}/topics/list'.format(TOPIC_SERVICE, API_PREFIX), verify=False)
        for idx in r_list.json()['obj']:
            if (idx['web_status'] == "register" or idx['web_status'] == "going") and idx['advisor'] != None:
                os.system("python3 {}/change_data.py -s {} -o END_TOPIC -t {}".format(current_path, args.server, idx['topic_id']))
        if r_list.ok:
            print('Successfully ended all topics')
        else:
            print('Failed to end all topics')

    if args.operation == 'END_STAGE':
        topic_id = args.topic_id
        user_download_end_date = datetime.datetime.utcnow() + relativedelta(days=-2)
        bucket = requests.get('{}{}/topics/publishing/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id), verify=False).json()
        bucket_id1 = bucket['obj']['train_test_datasets'][-1]['bucket']
        bucket_id2 = bucket['obj']['train_test_datasets'][0]['bucket']

        headers = {'Content-type': 'application/json'}
        update_date = { "train_test_bucket_end_date": user_download_end_date.strftime(UTC_DATETIME_FORMAT) }
        r_download_change_date1 = requests.put('{}{}/topics/update_dataset/{}/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id, bucket_id1),
                                     data=json.dumps(update_date), headers=headers, verify=False)

        update_date = { "train_test_bucket_start_date": (user_download_end_date + relativedelta(hours=+10)).strftime(UTC_DATETIME_FORMAT) }
        r_download_change_date2 = requests.put('{}{}/topics/update_dataset/{}/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id, bucket_id2),
                                     data=json.dumps(update_date), headers=headers, verify=False)
        if r_download_change_date1.ok and r_download_change_date2.ok:
            print('Successfully changed topic stage.')
        else:
            print('Failed to change topic stage.')

    if args.operation == 'START_SEL':
        topic_id = args.topic_id
        eval_submit_end_datetime = datetime.datetime.utcnow() + relativedelta(days=-1)

        update_date = {
            'username': 'u2',
            'eval_submit_end_date': eval_submit_end_datetime.strftime(UTC_DATETIME_FORMAT),
            'eval_select_start_date': eval_submit_end_datetime.strftime(UTC_DATETIME_FORMAT)
        }

        headers = {'Content-type': 'application/json'}
        r_change_date = requests.put('{}{}/topics/update_info/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                                     data=json.dumps(update_date),
                                     headers=headers, verify=False)
        if r_change_date.ok:
            print('Successfully changed topic eval date')
        else:
            print('Failed to change topic eval date')

    if args.operation == 'END_JOIN':
        join_end_date_datetime = datetime.datetime.utcnow() + relativedelta(days=-2)

        update_date = {
            'username': 'u2',
            'join_end_date': join_end_date_datetime.strftime(UTC_DATETIME_FORMAT),
            'team_merge_date': join_end_date_datetime.strftime(UTC_DATETIME_FORMAT)
        }

        topic_id = args.topic_id
        headers = {'Content-type': 'application/json'}
        r_change_date = requests.put('{}{}/topics/update_info/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                                     data=json.dumps(update_date),
                                     headers=headers, verify=False)
        if r_change_date.ok:
            print('Successfully changed topic join_end_date.')
        else:
            print('Failed to change topic join_end_date.')

    if args.operation == 'DEL_UTEST':
        headers = {'Content-type': 'application/json'}
        delete_utest = requests.post('{}{}/user/clear_test_account'.format(USER_SERVICE, API_PREFIX), headers=headers, verify=False)

        if delete_utest.ok:
            print('Successfully deleted utest.')
        else:
            print('Failed to delete utest.')

    if args.operation == 'POST_MESSAGES':
        headers = {'Content-type': 'application/json'}
        topic_id = args.topic_id
        if topic_id == None:
            print('Not assign topic id')
            return 0;

        counts = args.number_of_post

        post_datas = gen_posts(topic_id, counts)

        flag = True
        for i in range(0,counts):
            post_message = requests.post('{}{}/discuss'.format(DISCUSS_SERVICE, API_PREFIX),
                                        data=json.dumps(post_datas[i]),
                                        headers=headers, verify=False)
            if post_message.ok != True:
                print('Failed to post messages')
                flag = False
                break

        if flag:
            print('Successfully post messages.')

    return 0

if __name__ == '__main__':
    args = parser.parse_args()
    try:
        change_data(args)
    except Exception as e:
        print(str(e))
