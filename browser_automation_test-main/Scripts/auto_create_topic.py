# -*- coding: utf-8 -*-

import os
import json
import time
import shutil
import datetime
import pytz
import requests
import argparse
import configparser
from collections import defaultdict

#===FOR TESTING CUSTOMIZATION===
import re
from dateutil.relativedelta import relativedelta
from requests.packages.urllib3.exceptions import InsecureRequestWarning
from pathlib import Path

current_path = Path(__file__).parent
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)
#===END FOR TESTING CUSTOMIZATION===

API_PREFIX = '/api/v1'
API_USERNAME = 'apiadmin'
#===FOR TESTING CUSTOMIZATION===
with open(os.path.join(os.path.dirname(os.path.realpath(__file__)),"..","Variables","OCAIP_Variables.txt"), encoding = 'utf8') as f:
    API_URL = re.search(r'(?<=\${gOCAIP sURL} {4}).*', f.read()).group(0)
    f.seek(0)
    API_PASSWORD = re.search(r'(?<=\${gOCAIP PASSWORD} {4}).*', f.read()).group(0)
    f.seek(0)
    API_PATH = re.search(r'(?<=\${gOCAIP PATH} {4}).*', f.read()).group(0)
#===END FOR TESTING CUSTOMIZATION===

INFO = '\033[1;38m'
FAIL = '\033[1;31m'
SUCCESS = '\033[1;32m'
HIGHLIGHT = '\033[1;44m'
END = '\033[1;m'

UTC_DATETIME_FORMAT = "%Y-%m-%dT%H:%M:%SZ"

DATETIME_FORMAT = "%Y/%m/%d-%H:%M:%S"
PRECISE_DATETIME_FORMAT = "%Y/%m/%d-%H:%M:%S"

FILE_KEY = ['議題名稱',
            '議題簡介',
            '規則',
            '評估標準',
            '活動時間',
            '主辦單位',
            '贊助商單位',
            '資料說明',
            '上傳格式說明',
            '活動開始時間',
            '活動結束時間',
            '議題管理人員使用者名稱',
            '審核主管使用者名稱',
            '評估方法列表',
            'leaderboard種類',
            '上傳Public開始時間',
            '上傳Public結束時間',
            '組隊型態',
            'web狀態流程種類',
            '報名開始時間',
            '報名截止時間',
            '報名條件',
            '議題是否為學界才可參與',
            '選擇幾筆public分數當作private成績運算',
            '併隊截止時間',
            '組隊說明',
            '議題是否需要討論區',
            '組隊人數上限',
            '資料下載是否有時間性',
            '資料下載開始時間',
            '資料下載結束時間',
            '評估資料轉換資訊',
            '評估分數是否需文件上傳',
            '文件上傳開始時間',
            '文件上傳結束時間',
            '議題標籤',
            '議題是否需要公開排行榜',
            '議題排行榜是否限僅參與者觀看',
            '議題是否為封閉式',
            '封閉式議題白名單',
            '特殊功能說明',
            '每天預測資料最大上傳次數',
            'Public_Private資料轉換資訊',
            '議題是否需要上傳評估結果',
            '英文議題名稱',
            '英文議題簡介',
            '英文規則',
            '英文評估標準',
            '英文活動時間',
            '英文主辦單位',
            '英文資料說明',
            '英文上傳格式說明',
            '英文組隊說明',
            '英文贊助商單位',
            '教授',
            '專題名稱',
            '議題是否需要上傳組隊資訊',
            '上傳組隊資訊開始時間',
            '上傳組隊資訊結束時間',
            '議題是否需要填寫手機資訊',
            'NDA額外文字資訊',
            '是否需上傳執行程式',
            '是否需上傳至評估模組',
            '資源提供器型態',
            '資源提供器限制',
            '執行程式名稱',
            '目標執行程式',
            '執行程式型態',
            '是否上傳zip檔案',
            '遠端資料集是否為zip檔案',
            '遠端資料集路徑',
            '遠端資料及儲存型態',
            '上傳程式大小限制',
            '使用者執行時間限制',
            '議題分類',
            '獎勵說明',
            '英文獎勵說明',
            '議題類型']

DESCRI_KEY = ['title',
              'description',
              'topic_rule',
              'eval_description',
              'event_time_description',
              'organizers_description',
              'sponsors_description',
              'datasets_description',
              'upload_format_description',
              'start_date',
              'end_date',
              'assistant',
              'review_manager',
              'eval_method',
              'eval_type',
              'eval_submit_start_date',
              'eval_submit_end_date',
              'team_type',
              'web_status_flow_type',
              'join_start_date',
              'join_end_date',
              'join_condition',
              'is_academic',
              'eval_private_maximum',
              'team_merge_date',
              'team_description',
              'need_discuss',
              'team_maximum_num',
              'is_data_batch_download',
              'user_download_start_date',
              'user_download_end_date',
              'change_eval_data_date',
              'need_report',
              'report_start_date',
              'report_end_date',
              'tag',
              'need_publish_dashboard',
              'protected_dashboard',
              'enclosed',
              'limited_attend_list',
              'remarks',
              'eval_update_maximum',
              'change_pub_pri_dataset_date',
              'need_upload_eval_result',
              'en_title',
              'en_description',
              'en_topic_rule',
              'en_eval_description',
              'en_event_time_description',
              'en_organizers_description',
              'en_datasets_description',
              'en_upload_format_description',
              'en_team_description',
              'en_sponsors_description',
              'advisor',
              'seminar',
              'need_team_info',
              'team_info_start_date',
              'team_info_end_date',
              'need_phone_info',
              'extra_nda_wording',
              'need_upload_program',
              'is_need_to_send_to_evaluation_service',
              'resource_provider_type',
              'resource_limit',
              'user_program_filename',
              'user_program_to_run',
              'user_program_type',
              'is_user_program_zip_file',
              'is_remote_dataset_zip_file',
              'remote_dataset_path',
              'remote_dataset_storage_type',
              'file_size_limit_in_bytes',
              'user_program_execution_timeout',
              'category',
              'prize_description',
              'en_prize_description',
              'topic_type']


NCHC_FILE_KEY = ['access_key',
                 'login_username_twcc',
                 'login_password_twcc',
                 'container_image_twcc',
                 'container_flavor_twcc',
                 'solution_twcc']

GOC_FILE_KEY = ['api_url',
                'x_api_host',
                'container_image_goc',
                'container_flavor_goc',
                'solution_goc',
                'project',
                'x_api_key',
                'api_username',
                'api_password',
                'login_username_goc',
                'login_password_goc',
                'is_nfs_image',
                'nfssourceip',
                'nfsmountpath',
                'nfssourcepath']

EX_FILE_KEY = ['檔案名稱',
               '網址連結',
               '訊息摘要演算法']

EX_DES_KEY = ['filename',
              'url',
              'md5']

parser = argparse.ArgumentParser(description='create topic script')
parser.add_argument('-t', '--topic_dir',
                    type=str,
                    required=True,
                    default=None,
                    help='topic case dictionary in ./topic_info.  example: -t tmu-case')

parser.add_argument('-s', '--server',
                    type=int,
                    required=True,
                    default=None,
                    choices=[1, 2],
                    help='1 is local server;\n2 is ocaip-dev.xaas.tw server')

#===FOR TESTING CUSTOMIZATION===
parser.add_argument('-d', '--date_range',
                    type=str,
                    required=False,
                    default='now',
                    help='There are 3 options: past, now, future')

parser.add_argument('-n', '--txt_filename',
                    type=str,
                    required=True,
                    default=None,
                    help='This argument is for "OCAIP_TOPIC_Info_{ARGUMENT}.txt".')

parser.add_argument('-c', '--tag',
                    type=str,
                    default=None,
                    help='topic tag in topic_description.ini.')
#===END FOR TESTING CUSTOMIZATION===

class PrintStatus:
    INFO = 'info'
    FAIL = 'fail'
    HIGHLIGHT = 'highlight'
    SUCCESS = 'success'


def folder_is_empty(path):
    if not os.path.isdir(path):
        return True
    files = os.listdir(path)   #查詢路徑下的所有的資料夾及檔案
    if len(files) == 0:
        return True
    for filee in files:
        f = str(path / filee)    #使用絕對路徑
        if os.path.isdir(f):  #判斷是資料夾還是檔案
            if not os.listdir(f):  #判斷資料夾是否為空
                return True
            else:
                return False


def get_topic_description(topic_dir):
    describe = {}
    j = 0
    with open('topic_info/{}/topic_description.txt'.format(topic_dir), encoding='utf-8-sig') as f:
        lines = f.readlines()
        print('=' * 42)
        for i in range(len(lines)):
            line = lines[i].strip()
            if FILE_KEY[j] in line:
                x = j
                if j + 1 > len(FILE_KEY) - 1:
                    j = j
                else:
                    j += 1
                s = ''
            if FILE_KEY[x] not in line:
                s += line
                describe[DESCRI_KEY[x]] = s
        f.close()
    return describe


def get_topic_description_config(topic_dir):
    describe = {}
    config = configparser.ConfigParser()
    config.read(current_path / 'topic_info/{}/topic_description.ini'.format(topic_dir), encoding='utf-8-sig')
    for i in range(len(FILE_KEY)):
        if FILE_KEY[i] in config:
            describe[DESCRI_KEY[i]] = config.get(FILE_KEY[i], DESCRI_KEY[i])
    return describe


def get_external_config(topic_dir):
    describe_dict = defaultdict(list)
    is_empty_folder = folder_is_empty(current_path / 'topic_info/{}/data/external_link'.format(topic_dir))
    if not is_empty_folder:
        folder_list = os.listdir(current_path / 'topic_info/{}/data/external_link'.format(topic_dir))
        for folder in folder_list:
            file_list = os.listdir(current_path / 'topic_info/{}/data/external_link/{}'.format(topic_dir, folder))
            for file in file_list:
                describe = {}
                config = configparser.ConfigParser()
                config.read(current_path / 'topic_info/{}/data/external_link/{}/{}'.format(topic_dir, folder, file), encoding='utf-8-sig')
                for i in range(len(EX_FILE_KEY)):
                    describe[EX_DES_KEY[i]] = config.get(EX_FILE_KEY[i], EX_DES_KEY[i])
                describe_dict[folder].append(describe)
    return describe_dict


def get_resource_provider_property_dict(provider_type):
    property_dict = {}
    config = configparser.ConfigParser()
    config.read(current_path / 'topic_info/resource_provider.ini', encoding='utf-8-sig')
    if provider_type == 'NCHC_TAIWANIA2':
        for i in range(len(NCHC_FILE_KEY)):
            property_dict[NCHC_FILE_KEY[i]] = config.get(NCHC_FILE_KEY[i], NCHC_FILE_KEY[i])
        property_dict['login_username'] = property_dict['login_username_twcc']
        property_dict['login_password'] = property_dict['login_password_twcc']
        property_dict['container_image'] = property_dict['container_image_twcc']
        property_dict['container_flavor'] = property_dict['container_flavor_twcc']
        property_dict['solution'] = property_dict['solution_twcc']
        property_dict.pop('login_username_twcc')
        property_dict.pop('login_password_twcc')
        property_dict.pop('container_image_twcc')
        property_dict.pop('container_flavor_twcc')
        property_dict.pop('solution_twcc')
    elif provider_type == 'GeminiOpenCloud':
        for i in range(len(GOC_FILE_KEY)):
            property_dict[GOC_FILE_KEY[i]] = config.get(GOC_FILE_KEY[i], GOC_FILE_KEY[i])
        property_dict['login_username'] = property_dict['login_username_goc']
        property_dict['login_password'] = property_dict['login_password_goc']
        property_dict['container_image'] = property_dict['container_image_goc']
        property_dict['container_flavor'] = property_dict['container_flavor_goc']
        property_dict['solution'] = property_dict['solution_goc']

        property_dict.pop('login_username_goc')
        property_dict.pop('login_password_goc')
        property_dict.pop('container_image_goc')
        property_dict.pop('container_flavor_goc')
        property_dict.pop('solution_goc')
    return property_dict


def localtime_2_utc(localtime):
    local = pytz.timezone("Asia/Taipei")
    local_dt = local.localize(localtime, is_dst=None)
    return local_dt.astimezone(pytz.utc)


def parseTime(time_str, dataformat=DATETIME_FORMAT):
    date = None
    try:
        date = datetime.datetime.strptime(time_str, dataformat)
        date = localtime_2_utc(date)
    except Exception as e:
        color_print(PrintStatus.FAIL, time_str)
        color_print(PrintStatus.FAIL, str(e))

    return date.strftime(UTC_DATETIME_FORMAT)


def parsePeciseTime(time_str):
    date = None
    try:
        date = datetime.datetime.strptime(time_str, PRECISE_DATETIME_FORMAT)
        date = localtime_2_utc(date)
    except Exception as e:
        color_print(PrintStatus.FAIL, str(e))

    return date.strftime(UTC_DATETIME_FORMAT)


def check_topic_data(topic_dir, describe):
    print('2')
    none_data_key_list = []
    for i in range(len(FILE_KEY) - 2):
        if len(describe[DESCRI_KEY[i]]) == 0:
            none_data_key_list.append(FILE_KEY[i])
    print('1')
    # user_download_data_list = os.listdir(current_path / 'topic_info/{}/data/user_download'.format(topic_dir))
    # solution_data_list = os.listdir(current_path / 'topic_info/{}/data/solution'.format(topic_dir))
    user_download_dir_list = next(os.walk(current_path / 'topic_info/{}/data/user_download'.format(topic_dir)))[1]
    solution_download_dir_list = next(os.walk(current_path / 'topic_info/{}/data/solution'.format(topic_dir)))[1]
    nda_data_list = os.listdir(current_path / 'topic_info/{}/nda'.format(topic_dir))
    big_topic_pic_data_list = os.listdir(current_path / 'topic_info/{}/topic_pic/big_banner'.format(topic_dir))
    small_topic_pic_data_list = os.listdir(current_path / 'topic_info/{}/topic_pic/small_banner'.format(topic_dir))
    orgs_vendor_logo_data_list = os.listdir(current_path / 'topic_info/{}/vendor_logo/organizers'.format(topic_dir))
    sponsors_vendor_logo_data_list = os.listdir(current_path / 'topic_info/{}/vendor_logo/sponsors'.format(topic_dir))
    # if len(none_data_key_list) != 0:
    #     return -1, 'please check {} in ./topic_info/{}/topic_description.ini file'.format(none_data_key_list, topic_dir)
    # if len(user_download_data_list) == 0:
    #     return -1, 'user_download_data is not exist in ./topic_info/{}/data/user_download folder'.format(topic_dir)
    # if len(solution_data_list) == 0:
    #     return -1, 'solution_data is not exist in ./topic_info/{}/data/solution folder'.format(topic_dir)

    if len(user_download_dir_list) == 0:
        return -1, 'topic_info/{}/data/user_download need digit dir'.format(topic_dir)
    if len(solution_download_dir_list) == 0:
        return -1, 'topic_info/{}/data/solution need digit dir'.format(topic_dir)

    for user_download_dir in user_download_dir_list:
        if not user_download_dir.isdigit():
            return -1, 'user_download_dir: ./topic_info/{}/data/user_download is not digit'.format(topic_dir)
    for solution_download_dir in solution_download_dir_list:
        if not solution_download_dir.isdigit():
            return -1, 'solution_download_dir: ./topic_info/{}/data/solution is not digit'.format(topic_dir)
        solution_data_list = os.listdir(current_path / 'topic_info/{}/data/solution/{}'.format(topic_dir, solution_download_dir))
        if len(solution_data_list) > 1:
            return -1, 'Please put only one solution_data in ./topic_info/{}/data/solution/{} folder'.format(topic_dir,
                                                                                                             solution_download_dir)

    if len(nda_data_list) == 0:
        return -1, 'nda_data is not exist in ./topic_info/{}/nda folder'.format(topic_dir)
    if len(big_topic_pic_data_list) == 0:
        return -1, 'big topic_pic_data is not exist in ./topic_info/{}/topic_pic/big_banner folder'.format(topic_dir)
    if len(small_topic_pic_data_list) == 0:
        return -1, 'small topic_pic_data is not exist in ./topic_info/{}/topic_pic/small_banner folder'.format(
            topic_dir)
    if len(orgs_vendor_logo_data_list) == 0:
        return -1, 'vendor_logo_data is not exist in ./topic_info/{}/vendor_logo/organizers folder'.format(topic_dir)
    if len(nda_data_list) > 1:
        return -1, 'Please put only one nda_data in ./topic_info/{}/nda folder'.format(topic_dir)
    if len(big_topic_pic_data_list) > 1:
        return -1, 'Please put only one big topic_pic_data in ./topic_info/{}/topic_pic/big_banner folder'.format(
            topic_dir)
    if len(small_topic_pic_data_list) > 1:
        return -1, 'Please put only one small topic_pic_data in ./topic_info/{}/topic_pic/small_banner folder'.format(
            topic_dir)
    if len(orgs_vendor_logo_data_list) > 1:
        return -1, 'Please put only one vendor_logo_data in ./topic_info/{}/vendor_logo/organizers folder'.format(
            topic_dir)
    if len(sponsors_vendor_logo_data_list) > 1:
        return -1, 'Please put only one vendor_logo_data in ./topic_info/{}/vendor_logo/sponsors folder'.format(
            topic_dir)

    try:
        start_date_datetime = datetime.datetime.strptime(describe['start_date'], DATETIME_FORMAT)
    except:
        return -1, '活動開始時間格式輸入錯誤, 請重新輸入'
    try:
        end_date_datetime = datetime.datetime.strptime(describe['end_date'], DATETIME_FORMAT)
    except:
        return -1, '活動結束時間格式輸入錯誤, 請重新輸入'

    try:
        user_download_start_date_list = describe['user_download_start_date'].replace(' ', '').split(',')
        # if user_download_start_date_list == ['']:
        #     user_download_start_date_list = None
    except:
        user_download_start_date_list = describe['user_download_start_date']

    try:
        user_download_end_date_list = describe['user_download_end_date'].replace(' ', '').split(',')
        # if user_download_end_date_list == ['']:
        #     user_download_end_date_list = None
    except:
        user_download_end_date_list = describe['user_download_end_date']

#===FOR TESTING CUSTOMIZATION===
    if user_download_start_date_list:
        describe['user_download_start_date'] = ""
        for udsdi, udsd in enumerate(user_download_start_date_list):
            if udsd:
                try:
                    datetime.datetime.strptime(udsd, PRECISE_DATETIME_FORMAT)
                    describe['user_download_start_date'] += "{}, ".format((datetime.datetime.utcnow() + relativedelta(days=+1 * udsdi)).strftime(DATETIME_FORMAT))
                except:
                    return -1, '資料下載開始時間格式輸入錯誤, 請重新輸入'

    if user_download_end_date_list:
        describe['user_download_end_date'] = ""
        for udedi, uded in enumerate(user_download_end_date_list):
            if uded:
                try:
                    datetime.datetime.strptime(uded, PRECISE_DATETIME_FORMAT)
                    describe['user_download_end_date'] += "{}, ".format((datetime.datetime.utcnow() + relativedelta(days=+1 * udedi+1)).strftime(DATETIME_FORMAT))
                except:
                    return -1, '資料下載結束時間格式輸入錯誤, 請重新輸入'
#===END FOR TESTING CUSTOMIZATION===

    if user_download_start_date_list:
        if len(user_download_start_date_list) != len(user_download_dir_list):
            return -1, '資料下載開始 與 資料下載資料夾 list數量不合'

    if user_download_end_date_list:
        if len(user_download_start_date_list) != len(user_download_end_date_list):
            return -1, '資料下載開始時間 與 資料下載結束時間 list數量不合'

    if start_date_datetime >= end_date_datetime:
        return -1, '活動結束時間不可早於或等於活動開始時間'
    if describe['eval_private_maximum'] and not describe['eval_private_maximum'].isdigit():
        return -1, '選擇private_data上傳次數必須大於零且為整數'
    if describe['eval_update_maximum'] and not describe['eval_update_maximum'].isdigit():
        return -1, '選擇eval data上傳次數必須大於零且為整數'
    if describe['team_maximum_num'] and not describe['team_maximum_num'].isdigit():
        return -1, '組隊人數上限必須大於零且為整數'

    try:
        tag = {'group': describe['tag'].replace(' ', '').split(','),
               'category': describe['category'].replace(' ', '').split(','),
               'topic_type': describe['topic_type'].replace(' ', '').split(','),
        }
        if tag['group'] == ['']:
            tag['group'] = ['industry']
    except:
        tag = {'group': ['industry']}
    # if tag:
    #     if len(list(set(tag).difference(set(tag_class)))) != 0:
    #         return -1, 'tag must be : {}'.format(tag_class)
    return 0, None


def color_print(status, msg):
    if status == PrintStatus.FAIL:
        print('{}{}{}'.format(INFO, '*' * 42, END))
        print('{}{}{}'.format(FAIL, msg, END))
        print('{}{}{}'.format(INFO, '*' * 42, END))
    elif status == PrintStatus.INFO:
        print('{}{}{}'.format(INFO, '=' * 42, END))
        print('{}{}{}'.format(INFO, msg, END))
        print('{}{}{}'.format(INFO, '=' * 42, END))
    elif status == PrintStatus.SUCCESS:
        print('{}{}{}'.format(INFO, '=' * 42, END))
        print('{}{}{}'.format(SUCCESS, msg, END))
        print('{}{}{}'.format(INFO, '=' * 42, END))
    elif status == PrintStatus.HIGHLIGHT:
        print('{}{}{}'.format(INFO, '=' * 42, END))
        print('{}{}{}'.format(HIGHLIGHT, msg, END))
        print('{}{}{}'.format(INFO, '=' * 42, END))


def update_topic_pic(topic_id, topic_dir, storage_service, topic_service):
    color_print(PrintStatus.INFO, '新增topic圖片')

    small_file_list = os.listdir(current_path / 'topic_info/{}/topic_pic/small_banner'.format(topic_dir))
    if len(small_file_list) > 1:
        color_print(PrintStatus.FAIL,
                    'Please put only one small picture in ./topic_info/{}/topic_pic folder'.format(topic_dir))
        return -1
    big_file_list = os.listdir(current_path / 'topic_info/{}/topic_pic/big_banner'.format(topic_dir))
    if len(big_file_list) > 1:
        color_print(PrintStatus.FAIL,
                    'Please put only one big picture in ./topic_info/{}/topic_pic folder'.format(topic_dir))
        return -1
    small_filename = small_file_list[0]
    big_filename = big_file_list[0]
    name, ext = os.path.splitext(big_filename)
    des_small = current_path / '{}-small{}'.format(topic_id, ext)
    des_big = current_path / '{}-big{}'.format(topic_id, ext)
    shutil.copyfile( current_path / 'topic_info/{}/topic_pic/small_banner/{}'.format(topic_dir, small_filename), des_small)
    shutil.copyfile(current_path / 'topic_info/{}/topic_pic/big_banner/{}'.format(topic_dir, big_filename), des_big)
    try:
        small_file = open(des_small, 'rb')
    except (FileNotFoundError, IOError) as e:
        color_print(PrintStatus.FAIL, 'file not found, plz try again')
    try:
        big_file = open(des_big, 'rb')
    except (FileNotFoundError, IOError) as e:
        color_print(PrintStatus.FAIL, 'file not found, plz try again')

    files = {'small': small_file, 'big': big_file}
    r = requests.post('{}{}/topics/add_topic_image'.format(topic_service, API_PREFIX),
                        files=files, verify=False)
    if not r.ok:
        color_print(PrintStatus.FAIL, r.text)
        color_print(PrintStatus.FAIL, 'update banner圖檔 error, plz try again')
        return -1
    else:
        color_print(PrintStatus.SUCCESS, 'update banner圖檔 success')
        data = json.loads(r.text)
        image_bucket_id = data['obj']['image_bucket_id']

    bucket_data = {
        'image_bucket_id': image_bucket_id
    }
    r = requests.put('{}{}/topics/create_topic_image/{}'.format(topic_service, API_PREFIX, topic_id),
                     data=bucket_data, verify=False)
    if not r.ok:
        color_print(PrintStatus.FAIL, r.text)
        color_print(PrintStatus.FAIL, 'create topic picture error, GG')
        return -2
    else:
        color_print(PrintStatus.SUCCESS, 'create topic picture success')
    small_file.close()
    big_file.close()
    os.remove(des_small)
    os.remove(des_big)
    return 0


def upload_data_to_storage(storage_service, path, bucket):
    data_list = os.listdir(path)
    for dl in data_list:
        try:
            file = open('{}/{}'.format(path, dl), 'rb')
        except (FileNotFoundError, IOError) as e:
            color_print(PrintStatus.FAIL, 'user download file not found, plz try again')
        files = {'file': file}
        r = requests.put('{}{}/storage/upload_data/{}'.format(storage_service,
                                                              API_PREFIX,
                                                              bucket),
                         files=files, verify=False)
        if not r.ok:
            color_print(PrintStatus.FAIL, r.text)
            color_print(PrintStatus.FAIL, 'update  file: {} error, plz try again'.format(dl))
        else:
            color_print(PrintStatus.SUCCESS, 'update  file: {}, success'.format(dl))


def str2bool(v):
    return v.lower() in ("yes", "true", "t", "1")


def create_topic(args):
    topic_dir = args.topic_dir.split('/')[-1]
    server = args.server
    headers = {'Content-type': 'application/json'}
    print('server', server)
    if server == 1:
        USER_SERVICE = 'http://localhost:5010'
        TOPIC_SERVICE = 'http://localhost:5020'
        STORAGE_SERVICE = 'http://localhost:5040'
        EVAL_SERVICE = 'http://localhost:5060'
        COMPUTING_SERVICE = 'http://localhost:5100'
    elif server == 2:
        USER_SERVICE = 'https://{}:{}@{}/{}/user'.format(API_USERNAME, API_PASSWORD, API_URL, API_PATH)
        TOPIC_SERVICE = 'https://{}:{}@{}/{}/topic'.format(API_USERNAME, API_PASSWORD, API_URL, API_PATH)
        STORAGE_SERVICE = 'https://{}:{}@{}/{}/storage'.format(API_USERNAME, API_PASSWORD, API_URL, API_PATH)
        EVAL_SERVICE = 'https://{}:{}@{}/{}/eval'.format(API_USERNAME, API_PASSWORD, API_URL, API_PATH)
        COMPUTING_SERVICE = 'https://{}:{}@{}/{}/computing'.format(API_USERNAME, API_PASSWORD, API_URL, API_PATH)
    else:
        color_print(PrintStatus.FAIL, 'select server error')
        return -1

    # describe = get_topic_description(topic_dir)
    describe = get_topic_description_config(topic_dir)
    print('this')
    external = get_external_config(topic_dir)
    ret_code, msg = check_topic_data(topic_dir, describe)
    print('y')
    if ret_code != 0:
        color_print(PrintStatus.FAIL, msg)
        return -1

    ############################################
    # create_init_topic
    ############################################
    # assistant = describe['assistant']
    # review_manager = describe['review_manager']
    # color_print(PrintStatus.HIGHLIGHT, 'assistant: {}'.format(assistant))
    # color_print(PrintStatus.HIGHLIGHT, 'review_manager: {}'.format(review_manager))

    try:
        assistant = describe['assistant'].replace(' ', '').split(',')
    except:
        assistant = describe['assistant']

    try:
        review_manager = describe['review_manager'].replace(' ', '').split(',')
    except:
        review_manager = describe['review_manager']

    config_user_list = assistant + review_manager

    if config_user_list:
        headers = {'Content-type': 'application/json'}
        for i in range(len(config_user_list)):
            r = requests.get('{}{}/users/{}'.format(USER_SERVICE, API_PREFIX, config_user_list[i]), headers=headers, verify=False)
            if not r.ok:
                color_print(PrintStatus.FAIL, 'user {} is not exist'.format(config_user_list[i]))
                config_user_list[i] = ''
    if '' in config_user_list:
        user_list = []
        color_print(PrintStatus.INFO, '議題管理人員或審核人員名字必須存在於使用者列表裡')
        headers = {'Content-type': 'application/json'}
        r = requests.get('{}{}/users'.format(USER_SERVICE, API_PREFIX), headers=headers)
        if r.ok:
            data = json.loads(r.text)
            print(data)
            print('*' * 21)
            print("目前使用者列表")
            for i in range(0, len(data['obj'])):
                print("使用者{}: ".format(i + 1), data['obj'][i]['username'])
                user_list.append(data['obj'][i]['username'])
            print('*' * 21)

            while True:
                assistant_num = input("請輸入數字選擇議題管理人員使用者: ")
                if not assistant_num.isdigit() or assistant_num == '0':
                    print(' ' * 42)
                    print('x' * 42)
                    print("輸入錯誤，請重新選擇")
                    print('x' * 42)
                    print(' ' * 42)
                    continue
                assistant_num = int(assistant_num)
                if assistant_num > len(user_list):
                    print(' ' * 42)
                    print('x' * 42)
                    print("輸入錯誤，請重新選擇")
                    print('x' * 42)
                    print(' ' * 42)
                    continue
                assistant = user_list[assistant_num - 1]
                break

            while True:
                review_manager_num = input("請輸入數字選擇審核主管使用者: ")
                if not review_manager_num.isdigit() or review_manager_num == '0':
                    print(' ' * 42)
                    print('x' * 42)
                    print("輸入錯誤，請重新選擇")
                    print('x' * 42)
                    print(' ' * 42)
                    continue
                review_manager_num = int(review_manager_num)
                if review_manager_num > len(user_list):
                    print(' ' * 42)
                    print('x' * 42)
                    print("輸入錯誤，請重新選擇")
                    print('x' * 42)
                    print(' ' * 42)
                    continue
                review_manager = user_list[review_manager_num - 1]
                break

    #===FOR TESTING CUSTOMIZATION===
    title_prefix_time = datetime.datetime.utcnow() + relativedelta(hours=+8)
    title = '{} {}'.format(title_prefix_time.strftime("%D-%H:%M:%S"), describe['title'])
    en_title = '{} {}'.format(title_prefix_time.strftime("%D-%H:%M:%S"), describe['en_title'])
    #===END FOR TESTING CUSTOMIZATION===
    description = describe['description']
    en_description = describe['en_description']
    owner = 'no_need'

    if title == None or description == None or assistant == None or review_manager == None or owner == None:
        print('=' * 42)
        print("請輸入必填資訊")
        print('=' * 42)

    topic_init_data = {
        'username': 'no_need',
        'title': {'zh': title, 'en': en_title},
        'description': {'zh': description, 'en': en_description},
        'assistant': assistant,
        'owner': [owner],
        'review_manager': review_manager
    }

    headers = {'Content-type': 'application/json'}
    r = requests.post('{}{}/policy/create_init'.format(TOPIC_SERVICE, API_PREFIX),
                      data=json.dumps(topic_init_data),
                      headers=headers, verify=False)
    if not r.ok:
        color_print(PrintStatus.FAIL, 'create init Topic error, plz try again')
    else:
        data = json.loads(r.text)
        topic_id = data['obj']['id']
        print('{}topic_id:{} {}'.format(INFO, topic_id, END))
        color_print(PrintStatus.SUCCESS, 'create init Topic success')
        color_print(PrintStatus.HIGHLIGHT, 'topic_id: {}'.format(topic_id))

    ############################################
    # update_draft
    ############################################
    headers = {'Content-type': 'application/json'}
    action_update_data = {
        'username': assistant[0],
        'comment': 'onestep'
    }
    r = requests.put('{}{}/policy/update_draft/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                     data=json.dumps(action_update_data),
                     headers=headers, verify=False)
    if not r.ok:
        color_print(PrintStatus.FAIL, r.text)
        color_print(PrintStatus.FAIL, '設定狀態草稿不成功')
    else:
        color_print(PrintStatus.SUCCESS, '設定狀態草稿成功')

    ############################################
    # update Topic Information
    ############################################
    color_print(PrintStatus.INFO, '新增Topic相關資訊')
    # license_list = ['PD', 'NC', 'O']
    headers = {'Content-type': 'application/json'}
    r = requests.get('{}{}/eval/algo_list'.format(EVAL_SERVICE, API_PREFIX), headers=headers, verify=False)
    if not r.ok:
        color_print(PrintStatus.FAIL, 'get algo list fail')
        return -1
    eval_method_data = json.loads(r.text)
    eval_list = eval_method_data['obj']
    if describe['eval_method'] in eval_list:
        eval_method = describe['eval_method']
    else:
        print('*' * 21)
        print('本系統目前支援的評估方法列表: ')
        for i in range(0, len(eval_list)):
            print("{}: ".format(i + 1), eval_list[i])
        print('*' * 21)
        while True:
            eval_method_num = input("請輸入數字選擇預測評比方法: ")
            if not eval_method_num.isdigit() or eval_method_num == '0':
                print(' ' * 42)
                print('x' * 42)
                print("輸入錯誤，請重新選擇")
                print('x' * 42)
                print(' ' * 42)
                continue
            eval_method_num = int(eval_method_num)
            if eval_method_num > len(eval_list):
                print(' ' * 42)
                print('x' * 42)
                print("輸入錯誤，請重新選擇")
                print('x' * 42)
                print(' ' * 42)
                continue
            eval_method = eval_list[eval_method_num - 1]
            break

    #===FOR TESTING CUSTOMIZATION===
    if args.tag:
        describe['tag'] = args.tag
    #===END FOR TESTING CUSTOMIZATION===
    try:
        tag = {'group': describe['tag'].replace(' ', '').split(','),
               'category': describe['category'].replace(' ', '').split(','),
               'topic_type': describe['topic_type'].replace(' ', '').split(','),
        }
        if tag['group'] == ['']:
            tag['group'] = ['industry']
    except:
        tag = {'group': ['industry']}
    print('tag: ', tag)

    topic_rule = describe['topic_rule']
    en_topic_rule = describe['en_topic_rule']
    eval_description = describe['eval_description']
    en_eval_description = describe['en_eval_description']
    eval_type = describe['eval_type']
    team_type = describe['team_type']
    team_description = describe['team_description']
    en_team_description = describe['en_team_description']
    prize_description = describe.get('prize_description', '')
    en_prize_description = describe.get('en_prize_description', '')
    web_status_flow_type = describe['web_status_flow_type']
    event_time_description = describe['event_time_description']
    en_event_time_description = describe['en_event_time_description']
    is_academic = str2bool(describe['is_academic'])
    eval_private_maximum = describe['eval_private_maximum']
    eval_update_maximum = describe['eval_update_maximum']
    team_maximum_num = describe['team_maximum_num']
    is_data_batch_download = str2bool(describe['is_data_batch_download'])
    need_report = str2bool(describe['need_report'])
    need_publish_dashboard = str2bool(describe['need_publish_dashboard'])
    protected_dashboard = str2bool(describe['protected_dashboard'])
    need_upload_eval_result = str2bool(describe['need_upload_eval_result'])
    enclosed = describe['enclosed']
    limited_attend_list = []
    remarks = describe['remarks']
    start_date_datetime = parseTime(describe['start_date'])
    end_date_datetime = parseTime(describe['end_date'])
    advisor = describe['advisor']
    seminar = describe['seminar']
    need_team_info = describe['need_team_info']

    need_phone_info = describe['need_phone_info']
    need_upload_program = str2bool(describe['need_upload_program'])
    #===FOR TESTING CUSTOMIZATION===
    if args.date_range == 'now':
        start_date_datetime = datetime.datetime.utcnow() + relativedelta(months=-3)
        end_date_datetime = datetime.datetime.utcnow() + relativedelta(months=+3)
        join_start_date_datetime = datetime.datetime.utcnow() + relativedelta(months=-1)
        join_end_date_datetime = datetime.datetime.utcnow() + relativedelta(months=+1)
        eval_submit_start_date_datetime = datetime.datetime.utcnow() + relativedelta(months=-2)
        eval_submit_date_datetime = datetime.datetime.utcnow() + relativedelta(months=+2)
    elif args.date_range == 'past':
        start_date_datetime = datetime.datetime.utcnow() + relativedelta(years=-5, months=-3)
        end_date_datetime = datetime.datetime.utcnow() + relativedelta(years=-5, months=+3)
        join_start_date_datetime = datetime.datetime.utcnow() + relativedelta(years=-5, months=-1)
        join_end_date_datetime = datetime.datetime.utcnow() + relativedelta(years=-5, months=+1)
        eval_submit_start_date_datetime = datetime.datetime.utcnow() + relativedelta(years=-5, months=-2)
        eval_submit_date_datetime = datetime.datetime.utcnow() + relativedelta(years=-5, months=+2)
    elif args.date_range == 'future':
        start_date_datetime = datetime.datetime.utcnow() + relativedelta(years=+5, months=-3)
        end_date_datetime = datetime.datetime.utcnow() + relativedelta(years=+5, months=+3)
        join_start_date_datetime = datetime.datetime.utcnow() + relativedelta(years=+5, months=-1)
        join_end_date_datetime = datetime.datetime.utcnow() + relativedelta(years=+5, months=+1)
        eval_submit_start_date_datetime = datetime.datetime.utcnow() + relativedelta(years=+5, months=-2)
        eval_submit_date_datetime = datetime.datetime.utcnow() + relativedelta(years=+5, months=+2)
    start_date_datetime = parseTime(start_date_datetime.strftime(DATETIME_FORMAT))
    end_date_datetime = parseTime(end_date_datetime.strftime(DATETIME_FORMAT))
    topicinfo = '*** Variables ***\n'
    topicinfo += '{}gTopic ID {}{}    {}\n'.format('${', args.date_range.capitalize(), '}', topic_id)
    topicinfo += '{}gTopic Name {}{}    {}\n'.format('${', args.date_range.capitalize(), '}', title)
    with open(current_path / '../Temp/{}.txt'.format(args.txt_filename), 'w')as f:
        f.writelines(topicinfo)
    #===END FOR TESTING CUSTOMIZATION===

    topic_update_data = {
        'username': assistant[0],
        'topic_rule': {'zh': topic_rule, 'en': en_topic_rule},
        'eval_method': eval_method,
        'eval_description': {'zh': eval_description, 'en': en_eval_description},
        'eval_type': eval_type,
        'team_type': team_type,
        'web_status_flow_type': web_status_flow_type,
        'event_time_description': {'zh': event_time_description, 'en': en_event_time_description},
        'prize_description': {'zh': prize_description, 'en': en_prize_description},
        'is_academic': is_academic,
        'enclosed': enclosed,
        'is_data_batch_download': is_data_batch_download,
        'need_report': need_report,
        'need_publish_dashboard': need_publish_dashboard,
        'protected_dashboard': protected_dashboard,
        'need_upload_eval_result': need_upload_eval_result,
        'start_date': start_date_datetime,
        'end_date': end_date_datetime,
        'need_team_info': need_team_info,
        'need_phone_info': need_phone_info,
        'need_upload_program': need_upload_program
    }

    if tag:
        topic_update_data['tag'] = tag

    if describe['need_discuss']:
        topic_update_data['need_discuss'] = str2bool(describe['need_discuss'])

    if eval_private_maximum:
        topic_update_data['eval_private_maximum'] = eval_private_maximum

    if eval_update_maximum:
        topic_update_data['eval_update_maximum'] = eval_update_maximum

    if eval_type == 'public_private':
        #===FOR TESTING CUSTOMIZATION===
        # eval_submit_date_datetime: move to args.date_range == 'now/past/future'
        # topic_update_data['eval_submit_start_date'] = parsePeciseTime(describe['eval_submit_start_date'])
        # topic_update_data['eval_submit_end_date'] = parsePeciseTime(describe['eval_submit_end_date'])
        # topic_update_data['eval_submit_date'] = eval_submit_date_datetime.strftime("%Y-%m-%dT%H:%M:%S.000Z")
        topic_update_data['eval_submit_start_date'] = parsePeciseTime(eval_submit_start_date_datetime.strftime(PRECISE_DATETIME_FORMAT))
        topic_update_data['eval_submit_end_date'] = parsePeciseTime(eval_submit_date_datetime.strftime(PRECISE_DATETIME_FORMAT))
        topic_update_data['eval_select_start_date'] = parsePeciseTime(eval_submit_date_datetime.strftime(PRECISE_DATETIME_FORMAT))
        topic_update_data['eval_select_end_date'] = parsePeciseTime((eval_submit_date_datetime+relativedelta(days=+1)).strftime(PRECISE_DATETIME_FORMAT))
        #===END FOR TESTING CUSTOMIZATION===

    if web_status_flow_type == 'register' or web_status_flow_type == 'team':
        if describe['join_start_date'] == '' or describe['join_end_date'] == '':
            color_print(PrintStatus.FAIL, 'Please check join_start_date and join_end_date in topic_description.ini')
        #===FOR TESTING CUSTOMIZATION===
        # join_start_date_datetime: move to args.date_range == 'now/past/future'
        # topic_update_data['join_start_date'] = parseTime(describe['join_start_date'])
        topic_update_data['join_start_date'] = parseTime(join_start_date_datetime.strftime(PRECISE_DATETIME_FORMAT))
        color_print(PrintStatus.INFO,topic_update_data['join_start_date'])
        # join_end_date_datetime: move to args.date_range == 'now/past/future'
        # topic_update_data['join_end_date'] = parseTime(describe['join_end_date'])
        topic_update_data['join_end_date'] = parseTime(join_end_date_datetime.strftime(PRECISE_DATETIME_FORMAT))
        #===END FOR TESTING CUSTOMIZATION===
        if describe['join_condition'] != '':
            topic_update_data['join_condition'] = [describe['join_condition']]

        if describe['extra_nda_wording'] != '':
            topic_update_data['extra_nda_wording'] = [describe['extra_nda_wording']]

        if web_status_flow_type == 'team':
            #topic_update_data['team_merge_date'] = parseTime(describe['team_merge_date'])
            #===FOR TESTING CUSTOMIZATION===
            topic_update_data['team_merge_date'] = end_date_datetime
            #===END FOR TESTING CUSTOMIZATION===

    if web_status_flow_type == 'team' and team_type == 'team':
        topic_update_data['team_description'] = {'zh': team_description, 'en': en_team_description}
        if team_maximum_num:
            topic_update_data['team_maximum_num'] = team_maximum_num

    if need_report:
        if describe['report_start_date']:
            topic_update_data['report_start_date'] = parseTime(describe['report_start_date'])

        if describe['report_end_date']:
            topic_update_data['report_end_date'] = parseTime(describe['report_end_date'])

    if enclosed:
        topic_update_data['advisor'] = advisor
        topic_update_data['seminar'] = seminar
        topic_update_data['limited_attend_list'] = limited_attend_list
        topic_update_data['remarks'] = remarks

    if need_team_info:
        if describe['team_info_start_date']:
            topic_update_data['team_info_start_date'] = parseTime(describe['team_info_start_date'])

        if describe['team_info_end_date']:
            topic_update_data['team_info_end_date'] = parseTime(describe['team_info_end_date'])

    if need_upload_program:
        property_dict = get_resource_provider_property_dict(describe['resource_provider_type'])
        resource_provider_name = 'computing_provider_for_{}'.format(topic_id)
        if describe['resource_provider_type'] == 'NCHC_TAIWANIA2':
            computing_resource = {
                'container_image': property_dict['container_image'],
                'container_flavor': property_dict['container_flavor'],
                'solution': property_dict['solution']
            }

        elif describe['resource_provider_type'] == 'GeminiOpenCloud':
            computing_resource = {
                'container_image': property_dict['container_image'],
                'container_flavor': property_dict['container_flavor'],
                'solution': property_dict['solution'],
                'project': property_dict['project'],
                'is_nfs_image': str2bool(property_dict['is_nfs_image']),
                'nfssourceip': property_dict['nfssourceip'],
                'nfsmountpath': property_dict['nfsmountpath'],
                'nfssourcepath': property_dict['nfssourcepath']
            }

        options = {
            'resource_provider_name': resource_provider_name,
            'computing_resource': computing_resource
        }
        headers = {'Content-type': 'application/json'}
        create_provider_data = {
            'name': resource_provider_name,
            'resource_provider_type': describe['resource_provider_type'],
            'resource_limit': describe['resource_limit'],
            'property_dict': property_dict
        }
        r = requests.post('{}{}/computing/resource_providers'.format(COMPUTING_SERVICE, API_PREFIX, topic_id),
                          data=json.dumps(create_provider_data),
                          headers=headers)
        if not r.ok:
            color_print(PrintStatus.FAIL, r.text)
            color_print(PrintStatus.FAIL, '建立資源提供器失敗')
        else:
            color_print(PrintStatus.SUCCESS, '設定資源提供器成功')

        user_program_settings = create_provider_data
        user_program_settings['is_need_to_send_to_evaluation_service'] = describe['is_need_to_send_to_evaluation_service']
        user_program_settings['user_program_type'] = describe['user_program_type']
        user_program_settings['user_program_filename'] = describe['user_program_filename']
        user_program_settings['user_program_to_run'] = describe['user_program_to_run']
        user_program_settings['is_user_program_zip_file'] = str2bool(describe['is_user_program_zip_file'])
        user_program_settings['remote_dataset_path'] = describe['remote_dataset_path']
        user_program_settings['remote_dataset_storage_type'] = describe['remote_dataset_storage_type']
        user_program_settings['is_remote_dataset_zip_file'] = str2bool(describe['is_remote_dataset_zip_file'])
        user_program_settings['file_size_limit_in_bytes'] = describe['file_size_limit_in_bytes']
        user_program_settings['user_program_execution_timeout'] = describe['user_program_execution_timeout']
        user_program_settings['options'] = options
        topic_update_data['upload_program_settings'] = user_program_settings

    headers = {'Content-type': 'application/json'}
    r = requests.put('{}{}/topics/update_info/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                     data=json.dumps(topic_update_data),
                     headers=headers, verify=False)
    if not r.ok:
        color_print(PrintStatus.FAIL, r.text)
        color_print(PrintStatus.FAIL, 'update Topic error, plz try again')
    else:
        color_print(PrintStatus.SUCCESS, 'update Topic success')

    ############################################
    # update topic pic (in topic service-mongodb or storage service-ceph)
    ############################################

    ret_code = update_topic_pic(topic_id, topic_dir, STORAGE_SERVICE, TOPIC_SERVICE)
    if ret_code < 0:
        color_print(PrintStatus.FAIL, 'add banner error, plz contact topic assistant')

    ############################################
    # update vendor information to Topic
    ############################################
    ################ update organizers #########
    color_print(PrintStatus.INFO, '新增主辦單位資訊')
    name = 'organizers-name-{}'.format(topic_id)
    organizers_description = describe['organizers_description']
    en_organizers_description = describe['en_organizers_description']
    file_list = os.listdir(current_path / 'topic_info/{}/vendor_logo/organizers'.format(topic_dir))
    logo_path = current_path / 'topic_info/{}/vendor_logo/organizers/{}'.format(topic_dir, file_list[0])
    try:
        file = open(logo_path, 'rb')
    except (FileNotFoundError, IOError) as e:
        color_print(PrintStatus.FAIL, 'file not found, plz try again')
    files = {'file': file}
    vendor_data = {'name': name,
                   'vendor_type': 'organizers',
                   'description': organizers_description,
                   'en_description': en_organizers_description}
    headers = {'content-type': 'multipart/form-data'}
    r = requests.post('{}{}/vendors/add_vendor/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                      files=files, data=vendor_data, verify=False)
    if not r.ok:
        color_print(PrintStatus.FAIL, r.text)
        color_print(PrintStatus.FAIL, 'add vendor error, plz try again')
    else:
        color_print(PrintStatus.SUCCESS, 'add vendor to Topic success')

    '''
    file_list = os.listdir('./topic_info/{}/vendor_logo/co_organizers'.format(topic_dir))
    if len(file_list) == 1:
        color_print(PrintStatus.INFO, '新增協辦單位資訊')
        name = 'co_organizers-{}'.format(topic_id)
        description = describe['co_organizers_description']
        en_description = describe['en_co_organizers_description']

        logo_path = './topic_info/{}/vendor_logo/co_organizers/{}'.format(topic_dir, file_list[0])
        try:
            file = open(logo_path, 'rb')
        except (FileNotFoundError, IOError) as e:
            color_print(PrintStatus.FAIL, 'file not found, plz try again')
        files = {'file': file}
        vendor_data = {'name': name,
                       'vendor_type': 'co_organizers',
                       'description': description,
                       'en_description': en_description}
        headers = {'content-type': 'multipart/form-data'}
        r = requests.post('{}{}/vendors/add_vendor/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                          files=files, data=vendor_data)
        if not r.ok:
            color_print(PrintStatus.FAIL, r.text)
            color_print(PrintStatus.FAIL, 'add co_organizers error, plz try again')
        else:
            color_print(PrintStatus.SUCCESS, 'add co_organizers to Topic success')
    '''
    ################ update sponsors ############

    file_list = os.listdir(current_path / 'topic_info/{}/vendor_logo/sponsors'.format(topic_dir))
    if len(file_list) == 1:
        color_print(PrintStatus.INFO, '新增贊助商單位資訊')
        name = 'sponsors-name-{}'.format(topic_id)
        sponsors_description = describe['sponsors_description']
        en_sponsors_description = describe['en_sponsors_description']

        logo_path = current_path / 'topic_info/{}/vendor_logo/sponsors/{}'.format(topic_dir, file_list[0])
        try:
            file = open(logo_path, 'rb')
        except (FileNotFoundError, IOError) as e:
            color_print(PrintStatus.FAIL, 'file not found, plz try again')
        files = {'file': file}
        vendor_data = {'name': name,
                       'vendor_type': 'sponsors',
                       'description': sponsors_description,
                       'en_description': en_sponsors_description}
        headers = {'content-type': 'multipart/form-data'}
        r = requests.post('{}{}/vendors/add_vendor/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                          files=files, data=vendor_data, verify=False)
        if not r.ok:
            color_print(PrintStatus.FAIL, r.text)
            color_print(PrintStatus.FAIL, 'add vendor error, plz try again')
        else:
            color_print(PrintStatus.SUCCESS, 'add vendor to Topic success')

    ############################################
    # update eval public and private data
    ############################################
    if eval_type == 'public_private':
        color_print(PrintStatus.INFO, '新增public and private id data')
        pub_pri_dir_list = next(os.walk(current_path / 'topic_info/{}/pub_pri_data'.format(topic_dir)))[1]
        pub_pri_dir_list.sort()
        for pub_pri_dir in pub_pri_dir_list:
            try:
                pub_file_list = os.listdir(current_path / 'topic_info/{}/pub_pri_data/{}/pub'.format(topic_dir, pub_pri_dir))
            except:
                color_print(PrintStatus.FAIL, 'pub/{}資料夾不存在, 資料夾內容將不被儲存'.format(pub_pri_dir))
                continue
            try:
                pri_file_list = os.listdir(current_path / 'topic_info/{}/pub_pri_data/{}/pri'.format(topic_dir, pub_pri_dir))
            except:
                color_print(PrintStatus.FAIL, 'pri/{}資料夾不存在, 資料夾內容將不被儲存'.format(pub_pri_dir))
                continue

            if len(pub_file_list) == 0 or len(pri_file_list) == 0:
                color_print(PrintStatus.FAIL, 'public and private id data {}無檔案上傳'.format(pub_pri_dir))
            else:
                if len(pub_file_list) > 1:
                    color_print(PrintStatus.FAIL,
                                'Please put only one data in ./topic_info/{}/pub_pri_data/{}/pub folder'.format(
                                    topic_dir, pub_pri_dir))
                    return -1
                if len(pri_file_list) > 1:
                    color_print(PrintStatus.FAIL,
                                'Please put only one data in ./topic_info/{}/pub_pri_data/{}/pri folder'.format(
                                    topic_dir, pub_pri_dir))
                    return -1
                pub_filename = pub_file_list[0]
                pri_filename = pri_file_list[0]

                des_pub = current_path / 'topic_info/{}/pub_pri_data/{}/pub/{}'.format(topic_dir, pub_pri_dir, pub_filename)
                des_pri = current_path / 'topic_info/{}/pub_pri_data/{}/pri/{}'.format(topic_dir, pub_pri_dir, pri_filename)

                try:
                    pub_file = open(des_pub, 'rb')
                except (FileNotFoundError, IOError) as e:
                    color_print(PrintStatus.FAIL, 'file not found, plz try again')
                try:
                    pri_file = open(des_pri, 'rb')
                except (FileNotFoundError, IOError) as e:
                    color_print(PrintStatus.FAIL, 'file not found, plz try again')

                files = {'public': pub_file, 'private': pri_file}

                r = requests.post('{}{}/topics/update_eval_pub_pri_data/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                                  files=files, verify=False)
                if not r.ok:
                    color_print(PrintStatus.FAIL, r.text)
                    color_print(PrintStatus.FAIL, 'update eval public and private data error, plz try again')
                    return -1
                else:
                    color_print(PrintStatus.SUCCESS,
                                'update eval public and private data {} success'.format(pub_pri_dir))

    if eval_type == 'single_public':
        color_print(PrintStatus.INFO, '新增public id data')
        pub_pri_dir_list = next(os.walk(current_path / 'topic_info/{}/pub_pri_data'.format(topic_dir)))[1]
        pub_pri_dir_list.sort()
        for pub_pri_dir in pub_pri_dir_list:
            try:
                pub_file_list = os.listdir(current_path / 'topic_info/{}/pub_pri_data/{}/pub'.format(topic_dir, pub_pri_dir))
            except:
                color_print(PrintStatus.HIGHLIGHT, 'pub資料夾不存在, 資料夾內容將不被儲存')
                continue

            if len(pub_file_list) == 0:
                color_print(PrintStatus.HIGHLIGHT, 'public and private id data無檔案上傳')
            else:
                if len(pub_file_list) > 1:
                    color_print(PrintStatus.FAIL,
                                'Please put only one data in ./topic_info/{}/pub_pri_data/{}/pub folder'.format(
                                    topic_dir, pub_pri_dir))
                    return -1
                pub_filename = pub_file_list[0]

                des_pub = current_path / 'topic_info/{}/pub_pri_data/{}/pub/{}'.format(topic_dir, pub_pri_dir, pub_filename)

                try:
                    pub_file = open(des_pub, 'rb')
                except (FileNotFoundError, IOError) as e:
                    color_print(PrintStatus.FAIL, 'file not found, plz try again')

                files = {'public': pub_file}

                r = requests.post('{}{}/topics/update_eval_pub_pri_data/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                                  files=files)
                if not r.ok:
                    color_print(PrintStatus.FAIL, r.text)
                    color_print(PrintStatus.FAIL, 'update eval public data error, plz try again')
                    return -1
                else:
                    color_print(PrintStatus.SUCCESS,
                                'update eval public data {} success'.format(pub_pri_dir))

    ############################################
    # update change_pub_pri_data_date
    ############################################

    try:
        change_pub_pri_data_date_list = describe['change_pub_pri_dataset_date'].replace(' ', '').split(',')
        if change_pub_pri_data_date_list == ['']:
            change_pub_pri_data_date_list = None
    except:
        change_pub_pri_data_date_list = describe['change_pub_pri_dataset_date']

    headers = {'Content-type': 'application/json'}
    change_to_index = list()
    change_date = list()

    if change_pub_pri_data_date_list:
        for i in range(len(change_pub_pri_data_date_list)):
            if i % 2 == 0:
                change_to_index.append(change_pub_pri_data_date_list[i])
            elif i % 2 == 1:
                change_date.append(parsePeciseTime(change_pub_pri_data_date_list[i]))

        chage_pub_pri_date_data = {
            "change_to_index": change_to_index,
            "change_date": change_date
        }

        r = requests.post('{}{}/topics/add_pub_pri_timeline/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                          data=json.dumps(chage_pub_pri_date_data),
                          headers=headers, verify=False)
        if not r.ok:
            color_print(PrintStatus.FAIL, r.text)
            color_print(PrintStatus.FAIL, 'add public and private timeline error, GG')
        else:
            color_print(PrintStatus.SUCCESS, 'add public and private timeline success')

    ############################################
    # update NDA to Topic
    ############################################
    color_print(PrintStatus.INFO, '新增Topic NDA資訊')
    file_list = os.listdir(current_path / 'topic_info/{}/nda'.format(topic_dir))
    nda_path = current_path / 'topic_info/{}/nda/{}'.format(topic_dir, file_list[0])
    try:
        file = open(nda_path, 'rb')
    except (FileNotFoundError, IOError) as e:
        color_print(PrintStatus.FAIL, 'file not found, plz try again')
    files = {'file': file}
    r = requests.post('{}{}/topics/upload_nda/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                      files=files, verify=False)
    if not r.ok:
        color_print(PrintStatus.FAIL, r.text)
        color_print(PrintStatus.FAIL, 'add nda error, plz try again')
    else:
        color_print(PrintStatus.SUCCESS, 'add nda to Topic success')

    ############################################
    # Update dataset information to topic
    ############################################
    color_print(PrintStatus.INFO, '新增資料集資訊')

    datasets_description = describe['datasets_description']
    en_datasets_description = describe['en_datasets_description']
    upload_format_description = describe['upload_format_description']
    en_upload_format_description = describe['en_upload_format_description']

    topic_update_data = {
        "username": assistant[0],
        'datasets_description': {'zh': datasets_description, 'en': en_datasets_description},
        'upload_format_description': {'zh': upload_format_description, 'en': en_upload_format_description},
    }

    headers = {'Content-type': 'application/json'}
    r = requests.put('{}{}/topics/update_info/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                     data=json.dumps(topic_update_data),
                     headers=headers, verify=False)
    if not r.ok:
        color_print(PrintStatus.FAIL, r.text)
        color_print(PrintStatus.FAIL, 'update dataset info error, plz try again')
    else:
        color_print(PrintStatus.SUCCESS, 'update dataset info success')

    ############################################
    # Update user_download dataset information to topic
    ############################################

    color_print(PrintStatus.INFO, '新增使用者下載資料集資訊...')

    try:
        user_download_start_date_list = describe['user_download_start_date'].replace(' ', '').split(',')
    except:
        user_download_start_date_list = describe['user_download_start_date']

    try:
        user_download_end_date_list = describe['user_download_end_date'].replace(' ', '').split(',')
    except:
        user_download_end_date_list = describe['user_download_end_date']

    user_download_dir_list = next(os.walk(current_path / 'topic_info/{}/data/user_download'.format(topic_dir)))[1]
    data_serial_id = str(int(round(time.time(), 0)))
    user_download_dir_list.sort()
    external_folder_empty = folder_is_empty(current_path / 'topic_info/{}/data/external_link'.format(topic_dir))
    i = 0

    for user_download_dir in user_download_dir_list:
        # 測試資料(training.csv), 驗證資料(upload.csv), 使用者下載資料
        topic_train_test_bucket = '{}-{}_train_test_dataset_{}'.format(topic_id, data_serial_id, user_download_dir)
        r = requests.put('{}{}/storage/create_bucket/{}'.format(STORAGE_SERVICE, API_PREFIX, topic_train_test_bucket), verify=False)
        if not r.ok:
            color_print(PrintStatus.FAIL,
                        'create bucket Fail for {}, Please contact administrator'.format(topic_train_test_bucket))
            return -1
        color_print(PrintStatus.INFO, '新增使用者下載: {}'.format(topic_train_test_bucket))
        user_download_data_list = os.listdir(current_path / 'topic_info/{}/data/user_download/{}'.format(topic_dir,
                                                                                                         user_download_dir))
        #===FOR TESTING CUSTOMIZATION===
        if user_download_data_list == ['.gitkeep']:
            continue
        #===END FOR TESTING CUSTOMIZATION===

        if len(user_download_data_list) > 0:
            upload_data_to_storage(STORAGE_SERVICE,
                                   current_path / 'topic_info/{}/data/user_download/{}/'.format(topic_dir,
                                                                                   user_download_dir),
                                   topic_train_test_bucket)
        else:
            if external_folder_empty:
                color_print(PrintStatus.HIGHLIGHT, '下載資料集無檔案上傳')

        if not user_download_start_date_list[i]:
            udsd = None
        else:
            udsd = parseTime(user_download_start_date_list[i], PRECISE_DATETIME_FORMAT)

        if not user_download_end_date_list[i]:
            uded = None
        else:
            uded = parseTime(user_download_end_date_list[i], PRECISE_DATETIME_FORMAT)

        bucket_data = {
            'train_test_bucket_id': topic_train_test_bucket,
            'train_test_link': external.get(user_download_dir, []),
            'train_test_bucket_start_date': udsd,
            'train_test_bucket_end_date': uded
        }
        r = requests.put('{}{}/topics/create_dataset/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                         data=json.dumps(bucket_data), headers=headers, verify=False)
        if not r.ok:
            color_print(PrintStatus.FAIL, r.text)
            color_print(PrintStatus.FAIL, bucket_data)
            color_print(PrintStatus.FAIL, 'create topic bucket {}, error, GG'.format(topic_train_test_bucket))
        else:
            color_print(PrintStatus.SUCCESS, 'create topic bucket {}, success'.format(topic_train_test_bucket))
        i += 1

    ############################################
    # Update eval dataset information to topic
    ############################################

    color_print(PrintStatus.INFO, '新增評比資料集資訊')

    solution_dir_list = next(os.walk(current_path / 'topic_info/{}/data/solution'.format(topic_dir)))[1]
    solution_dir_list.sort()
    for solution_dir in solution_dir_list:
        # 評比資料(solution.csv)
        topic_eval_bucket = '{}-{}_eval_dataset_{}'.format(topic_id, data_serial_id, solution_dir)

        r = requests.put('{}{}/storage/create_bucket/{}'.format(STORAGE_SERVICE, API_PREFIX, topic_eval_bucket), verify=False)
        if not r.ok:
            color_print(PrintStatus.FAIL,
                        'create bucket Fail for {}, Please contact administrator'.format(topic_eval_bucket))
            return -1
        color_print(PrintStatus.INFO, '評比資料(solution): {}'.format(topic_eval_bucket))
        solution_data_list = os.listdir(current_path / 'topic_info/{}/data/solution/{}'.format(topic_dir, solution_dir))
        if len(solution_data_list) == 0:
            color_print(PrintStatus.HIGHLIGHT, '評比資料(solution)無檔案上傳')
        elif len(solution_data_list) > 1:
            color_print(PrintStatus.HIGHLIGHT, '評比資料(solution)必須為一個檔')
        else:
            upload_data_to_storage(STORAGE_SERVICE,
                                   current_path / 'topic_info/{}/data/solution/{}'.format(topic_dir, solution_dir),
                                   topic_eval_bucket)
        bucket_data = {
            'eval_bucket_id': topic_eval_bucket,
        }

        r = requests.put('{}{}/topics/create_dataset/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                         data=json.dumps(bucket_data), headers=headers, verify=False)
        if not r.ok:
            color_print(PrintStatus.FAIL, r.text)
            color_print(PrintStatus.FAIL, 'create topic bucket {}, error, GG'.format(topic_eval_bucket))
        else:
            color_print(PrintStatus.SUCCESS, 'create topic bucket {}, success'.format(topic_eval_bucket))

    ############################################
    # update change_eval_data_date
    ############################################

    try:
        change_eval_data_date_list = describe['change_eval_data_date'].replace(' ', '').split(',')
        if change_eval_data_date_list == ['']:
            change_eval_data_date_list = None
    except:
        change_eval_data_date_list = describe['change_eval_data_date']

    headers = {'Content-type': 'application/json'}
    change_to_index = list()
    change_date = list()

    if change_eval_data_date_list:
        for i in range(len(change_eval_data_date_list)):
            if i % 2 == 0:
                change_to_index.append(change_eval_data_date_list[i])
            elif i % 2 == 1:
                change_date.append(parsePeciseTime(change_eval_data_date_list[i]))

        chage_eval_date_data = {
            "change_to_index": change_to_index,
            "change_date": change_date
        }

        r = requests.post('{}{}/topics/add_solution_timeline/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                          data=json.dumps(chage_eval_date_data),
                          headers=headers, verify=False)
        if not r.ok:
            color_print(PrintStatus.FAIL, r.text)
            color_print(PrintStatus.FAIL, 'add solution timeline error, GG')
        else:
            color_print(PrintStatus.SUCCESS, 'add solution timeline success')

    color_print(PrintStatus.HIGHLIGHT, 'topic_id: {}'.format(topic_id))
    ############################################
    # submit_publish_review
    ############################################
    headers = {'Content-type': 'application/json'}
    action_update_data = {
        'username': assistant[0],
        'comment': 'onestep'
    }
    r = requests.put('{}{}/policy/submit_publish_review/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                     data=json.dumps(action_update_data),
                     headers=headers, verify=False)
    if not r.ok:
        color_print(PrintStatus.FAIL, r.text)
        color_print(PrintStatus.FAIL, '上架送審錯誤')
    else:
        color_print(PrintStatus.SUCCESS, '上架送審成功')

    ############################################
    # accept_publish_review
    ############################################
    headers = {'Content-type': 'application/json'}
    action_update_data = {
        'username': review_manager[0],
        'comment': 'onestep'
    }
    r = requests.put('{}{}/policy/accept_publish_review/{}'.format(TOPIC_SERVICE, API_PREFIX, topic_id),
                     data=json.dumps(action_update_data),
                     headers=headers, verify=False)
    if not r.ok:
        color_print(PrintStatus.FAIL, r.text)
        color_print(PrintStatus.FAIL, '上架審核通過錯誤')
    else:
        color_print(PrintStatus.SUCCESS, '上架審核通過成功')


if __name__ == '__main__':
    args = parser.parse_args()
    try:
        create_topic(args)
    except Exception as e:
        print(str(e))
