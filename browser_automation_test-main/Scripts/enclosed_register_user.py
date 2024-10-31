import os
import json
import sys
import re
import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning
import argparse
from argparse import RawTextHelpFormatter
import datetime
from pathlib import Path

requests.packages.urllib3.disable_warnings(InsecureRequestWarning)
LOCAL_MODE = False

parser = argparse.ArgumentParser(description='enclose topic script',formatter_class=RawTextHelpFormatter)
parser.add_argument('-t', '--topic_id',
                    type=str,
                    required=True,
                    help='topic id  example: -t topic_id')

parser.add_argument('-u', '--user_list',
                    type=str,
                    required=True,
                    nargs='+',
                    help='user list  example: -u t1 t2')

parser.add_argument('-s', '--server',
                    type=int,
                    required=True,
                    choices=[1, 2],
                    help='1 is local server;\n2 is ocaip-dev.xaas.tw server')

parser.add_argument('-n', '--sign_nda',
                    type=int,
                    required=False,
                    default=1,
                    choices=[0, 1],
                    help='1 is True;\n0 is False for signing NDA ')

def _print_debug(info_list):
    print('-' * 42, flush=True)
    if isinstance(info_list, list):
        for i in info_list:
            print(i, flush=True)
    else:
        print(info_list, flush=True)
    print('-' * 42, flush=True)


def get_topic_team(topic_id, username, rest_api_base, rest_api_username, rest_api_password):
    if LOCAL_MODE:
        team_api = 'http://localhost:5090/api/v1/team/info'
    else:
        team_api = '{}/team/api/v1/team/info'.format(rest_api_base)
    res = requests.get('{}/{}/{}'.format(team_api, topic_id, username),
                       auth=(rest_api_username, rest_api_password),
                       verify=False,)
    _print_debug(res.json())
    team_info = None
    if res.status_code == 200:
        data = res.json()
        team_info = data['obj']
    return team_info


def get_topic_detail(topic_id, rest_api_base, rest_api_username, rest_api_password):
    if LOCAL_MODE:
        topic_api = 'http://localhost:5020/api/v1'
    else:
        topic_api = '{}/topic/api/v1'.format(rest_api_base)
    res = requests.get('{}/topics/detail/{}'.format(topic_api, topic_id),
                       auth=(rest_api_username, rest_api_password), verify=False,)
    # _print_debug(res.json())
    topic_detail = None
    if res.status_code == 200:
        data = res.json()
        topic_detail = data['obj']
    return topic_detail


def create_notification_topic_for_1_user_team(topic_id, team_id, username, rest_api_base, rest_api_username, rest_api_password):
    notification_name = 'team_{}_{}'.format(topic_id, team_id)
    _print_debug(notification_name)
    data = {
        'name': notification_name,
        'subscribers': [username],
    }
    if LOCAL_MODE:
        notification_api = 'http://localhost:5080/api/v1'
    else:
        notification_api = '{}/notification/api/v1'.format(rest_api_base)
    response = requests.post(
        '{}/notification/subscriptions'.format(notification_api),
        data=json.dumps(data),
        auth=(rest_api_username, rest_api_password),
        verify=False,)

    if response.status_code == 200:
        msg = 'Topic "{}": Create notification topic "{}" for user "{}" OK!'.format(topic_id, notification_name,
                                                                                    username)
        _print_debug(msg)
        return True, msg
    else:
        msg = 'Error: Topic "{}": Can not create notification topic "{}" for user "{}"'.format(topic_id,
                                                                                               notification_name,
                                                                                               username)
        _print_debug(msg)
        return False, msg


def create_or_update_notification_topic_for_specific_topic(topic_id, username, rest_api_base, rest_api_username, rest_api_password):
    notification_name = 'topic_' + topic_id
    if LOCAL_MODE:
        notification_api = 'http://localhost:5080/api/v1'
    else:
        notification_api = '{}/notification/api/v1'.format(rest_api_base)
    # check if the notification_name exists
    response = requests.get(
        '{}/notification/subscriptions/{}'.format(
            notification_api,
            notification_name,
        ),
        auth=(rest_api_username, rest_api_password),
        verify=False,)

    is_notification_name_existed = True
    if response.status_code == 200:
        data = response.json()
        if not data['obj']:
            is_notification_name_existed = False
    else:
        msg = 'Error: Topic "{}": Can not create or update notification topic "{}" for user "{}"! Notification service error!'.format(
            topic_id,
            notification_name,
            username,
        )
        _print_debug(msg)
        return False, msg

    if not is_notification_name_existed:  # create notification topic if not exists
        data = {
            'name': notification_name,
            'subscribers': [username],
        }
        response = requests.post(
            '{}/notification/subscriptions'.format(
                notification_api
            ),
            auth=(rest_api_username, rest_api_password),
            data=json.dumps(data),
            verify=False,)

        if response.status_code == 200:
            msg = 'Topic "{}": Create notification topic "{}" for user "{}" OK!'.format(
                topic_id,
                notification_name,
                username,
            )
            _print_debug(msg)
            return True, msg
        else:
            msg = 'Error: Topic "{}": Can not create notification topic "{}" for user "{}"!'.format(
                topic_id,
                notification_name,
                username,
            )
            _print_debug(msg)
            return False, msg
    else:  # update current notification topic if exists
        data = {
            'operation': 'add_users',
            'update_data': {
                'user_list': [username],
            }
        }
        response = requests.put(
            '{}/notification/subscriptions/{}'.format(
                notification_api,
                notification_name,
            ),
            auth=(rest_api_username, rest_api_password),
            data=json.dumps(data),
            verify=False,)

        if response.status_code == 200:
            msg = 'Topic "{}": Update notification topic "{}" for user "{}" OK!'.format(
                topic_id,
                notification_name,
                username,
            )
            _print_debug(msg)
            return True, msg
        else:
            msg = 'Error: Topic "{}": Can not update notification topic "{}" for user "{}"!'.format(
                topic_id,
                notification_name,
                username,
            )
            _print_debug(msg)
            return False, msg


def sign_NDA(topic_id, user, rest_api_base, rest_api_username, rest_api_password):
    # get NDA version from topic detail
    topic_detail = get_topic_detail(topic_id, rest_api_base, rest_api_username, rest_api_password)
    nda = topic_detail.get('nda')[0]

    latest_nda_version = nda.get('version')
    nda_data = json.dumps({
        'username': user,
        'version': latest_nda_version,
        'signed_date': str(datetime.datetime.now()),
    })
    _print_debug('NDA to sign: {}'.format(nda_data))

    # sign NDA
    if LOCAL_MODE:
        topic_api = 'http://localhost:5020/api/v1'
    else:
        topic_api = '{}/topic/api/v1'.format(rest_api_base)
    res = requests.post(
        '{}/topics/sign_nda/{}'.format(topic_api, topic_id),
        auth=(rest_api_username, rest_api_password),
        data=nda_data,
        verify=False,)
    _print_debug(res.json())
    if res.status_code == 200:
        return True, 'Signed NDA OK'
    else:
        return False, 'Error: Signed NDA failed'


def register_topic(rest_api_base, rest_api_username, rest_api_password, user, topic_id):
    create_team_data = {
        'topic_id': topic_id,
        'username': user
    }
    if LOCAL_MODE:
        team_api = 'http://localhost:5090/api/v1'
    else:
        team_api = '{}/team/api/v1'.format(rest_api_base)
    res = requests.post('{}/team'.format(team_api),
                        auth=(rest_api_username, rest_api_password),
                        data=json.dumps(create_team_data),
                        headers={'content-type': 'application/json'},
                        verify=False,)

    _print_debug(res.json())
    if res.status_code == 200:
        _print_debug('Create team for user "{}" OK.'.format(user))
        team_info = get_topic_team(topic_id, user, rest_api_base, rest_api_username, rest_api_password)
        _print_debug(team_info)
        if team_info:
            _print_debug('Get team info success')
            team_id = team_info['id']
            create_notification_success, msg = create_notification_topic_for_1_user_team(
                topic_id, team_id, user,
                rest_api_base, rest_api_username, rest_api_password
            )
            if create_notification_success:
                _print_debug('Create_notification_success')
                headers = {'Content-type': 'application/json'}
                data = {'username': user, 'notification_topic': 'topic_{}'.format(topic_id)}

                if LOCAL_MODE:
                    notification_api = 'http://localhost:5080/api/v1'
                else:
                    notification_api = '{}/notification/api/v1'.format(rest_api_base)

                try:
                    pre_res = requests.post('{}/notification/announcement_messages'.format(notification_api),
                                            auth=(rest_api_username, rest_api_password),
                                            headers=headers,
                                            data=json.dumps(data),
                                            verify=False,)
                    if pre_res.status_code != 200:
                        msg = 'Error: Topic "{}": Can not get previous notification messages for user "{}"!'.format(
                            topic_id,
                            user,
                        )
                        _print_debug(msg)
                    _print_debug("Create notification team topic success for user {}!!".format(user))
                except Exception as e:
                    msg = 'Exception happened in when getting previous notification messages! Error: {}'.format(e)
                    _print_debug(e)

            if args.sign_nda:
                sign_NDA_sucess, msg = sign_NDA(topic_id, user, rest_api_base, rest_api_username, rest_api_password)
                if sign_NDA_sucess:
                    _print_debug("Sign NDA for user {}!!".format(user))
                else:
                    _print_debug("Error: Sign NDA failed for user {}!!".format(user))

            create_or_update_notification_success, msg = create_or_update_notification_topic_for_specific_topic(
                topic_id, user, rest_api_base, rest_api_username, rest_api_password)
            if create_or_update_notification_success:
                _print_debug("Create notification team topic success for user {}!!".format(user))
                _print_debug("Register finish! for {}".format(user))
                return True
            else:
                _print_debug("Error: Create notification team topic failed for user {}!!".format(user))

    return False


def check_user_list(user_list, rest_api_base, rest_api_username, rest_api_password):
    correct_user_list = list()
    error_user_list = list()

    if LOCAL_MODE:
        user_api = 'http://localhost:5010/api/v1'
    else:
        user_api = '{}/user/api/v1'.format(rest_api_base)
    res = requests.get('{}/users'.format(user_api),
                       auth=(rest_api_username, rest_api_password),
                       headers={'content-type': 'application/json'},
                       verify=False,)

    lower_case_to_original_user_mapping = dict()
    if res.status_code == 200:
        data = res.json()
        for u in data['obj']:
            lower_case_to_original_user_mapping[u['username'].lower()] = u['username']
    else:
        _print_debug('Error with status code = {}'.format(res.status_code))

    for u in user_list:
        if u.lower() in lower_case_to_original_user_mapping:
            correct_user_list.append(lower_case_to_original_user_mapping[u.lower()])
        else:
            error_user_list.append(u)

    assert len(user_list) == len(correct_user_list) + len(error_user_list)
    return correct_user_list, error_user_list


if __name__ == '__main__':
    args = parser.parse_args()
    server = args.server
    rest_api_base = ''
    if server == 1:
        LOCAL_MODE = True
    elif server == 2:
        with open(os.path.join(os.path.dirname(os.path.realpath(__file__)),"..","Variables","OCAIP_Variables.txt"), encoding = 'utf8') as f:
            API_URL = re.search(r'(?<=\${gOCAIP sURL} {4}).*', f.read()).group(0)
            f.seek(0)
            rest_api_password = re.search(r'(?<=\${gOCAIP PASSWORD} {4}).*', f.read()).group(0)
            f.seek(0)
            API_PATH = re.search(r'(?<=\${gOCAIP PATH} {4}).*', f.read()).group(0)
        rest_api_base = 'https://{}/{}'.format(API_URL, API_PATH)
    rest_api_username = 'apiadmin'
    topic_id = args.topic_id
    user_list = args.user_list
    # -------------------------------------
    # check if user_list in settings is OK
    # -------------------------------------
    print('rest_api_base = {}'.format(rest_api_base))
    print('rest_api_username = {}'.format(rest_api_username))
    print('rest_api_password = {}'.format(rest_api_password))
    print('topic_id = {}'.format(topic_id))
    print('user_list = {}'.format(user_list))
    correct_user_list, error_user_list = check_user_list(
        user_list,
        rest_api_base, rest_api_username, rest_api_password,
    )
    print('-' * 42)
    print('correct_user_list = {}'.format(correct_user_list))
    print('error_user_list = {}'.format(error_user_list))
    print('-' * 42)
    # ------------------------
    # register users in topic
    # ------------------------
    _print_debug('Start registering users...')

    for user in correct_user_list:
        is_success = register_topic(
            rest_api_base, rest_api_username, rest_api_password,
            user, topic_id
        )
        if not is_success:
            error_user_list.append(user)

    if not error_user_list:
        _print_debug('Everything is OK!')
    else:
        _print_debug('Following users are not registered:')
        _print_debug(error_user_list)

        if len(error_user_list) == len(user_list):
            _print_debug('Error: Every user is not registered!')
            _print_debug('Please check if topic_id or server settings are correct! (Production/Staging/Test)')
