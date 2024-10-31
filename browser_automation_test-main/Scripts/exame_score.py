import sys
import os
import csv
import math
from dateutil.relativedelta import relativedelta
import argparse
from argparse import RawTextHelpFormatter
from pathlib import Path

current_path = Path(__file__).parent

def readCSV2dict(filename):
    mydict = {}
    with open(filename, mode='r') as csv_f:
        reader = csv.reader(csv_f)
        mydict = {rows[0]:rows[1] for rows in reader}
    return mydict

def readTxt2list(filename):
    mylist = []
    with open(filename, mode='r') as f:
        for line in f:
            mylist.append(line.strip())
    return mylist

def readCSV2dict4Taxi(filename):
    mydict = {}
    with open(filename, mode="r") as csv_f:
        reader = csv.reader(csv_f)
        mydict = {rows[0]:rows[4] for rows in reader}
    return mydict

def readCSV2dict4NRMSE(filename):
    mydict = {}
    with open(filename, mode="r") as csv_f:
        reader = csv.reader(csv_f)
        mydict = {rows[0]:rows[1:401] for rows in reader}
    return mydict

def creareRobotVarFile(filename, pub_score, pri_score):
    with open(current_path / 'OCAIP_Topic_Info.txt', 'r')as f:
        lines = [line for line in f]
        lines[1] = '{}Public score{}    {}\n'.format('${', '}', pub_score)
        lines.append('{}Private score{}    {}\n'.format('${', '}', pri_score))
        with open(current_path / 'OCAIP_Exame_score_{}.txt'.format(filename), 'w') as f:
            f.writelines(lines)

def AECheck(dict_c, dict_t, testSet): # dict_c : correct data, dict_t : test data

    hits = 0.0
    length = float(len(testSet))
    for name in testSet:
        if(dict_c[name] == dict_t[name]):
            hits = hits + 1.0
    return hits/length

def RMSECheck(dict_c, dict_t, testSet): # dict_c : correct data, dict_t : test data

    rmse = 0.0
    length = float(len(testSet))-1
    count = 0
    for name in testSet:
        count = count + 1
        if (count == 1):
            count = count + 1
            continue
        else:
            count = count + 1
        rmse = rmse + math.pow(float(dict_c[name])-float(dict_t[name]),2)
    rmse = math.sqrt(rmse/length)
    return rmse


def NRMSECheck(dict_c, dict_t, testSet): # dict_c : correct data, dict_t : test data

    nrmse = 0.0
    length = float(len(testSet))-1
    count = 0
    for name in testSet:
        count = count + 1
        if (count == 1):
            count = count + 1
            continue
        else:
            count = count + 1
        #datas_c = [float(x) for x in dict_c[name].split(",")]
        #datas_t = [float(x) for x in dict_t[name].split(",")]
        datas_c = []
        datas_t = []
        for i in range(len(dict_c[name])):
            datas_c.append(float(dict_c[name][i]))
            datas_t.append(float(dict_t[name][i]))
        length_c = len(datas_c)
        length_t = len(datas_t)
        if(length_c != length_t):
            sys.exit(-1)
        upper_part = 0.0
        lower_part = 0.0
        for i in range(0, length_c):
            upper_part = upper_part + math.pow(datas_c[i] - datas_t[i],2)
            lower_part = lower_part + datas_c[i]
        upper_part = math.sqrt(upper_part/float(length_c))
        lower_part = lower_part/float(length_c)
        nrmse = nrmse + upper_part/lower_part
    return nrmse/length

def MAPECheck(dict_c, dict_t, testSet):
    mape = 0.0
    length = float(len(testSet))
    for name in testSet:
        mape = mape + math.abs(float(dict_c[name])-float(dict_t[name]))/dict_c[name]
    mape = 100 * mape / float(length)
    return mape

def LogLossCheck(dict_c, dict_t, testSet):
    pass


parser = argparse.ArgumentParser(description='To change the topic status',formatter_class=RawTextHelpFormatter)

parser.add_argument('-t', '--topic',
                    type=str,
                    required=True,
                    default=None,
                    help='topic type.  example: -t tmu-case')

parser.add_argument('-m', '--method',
                    type=int,
                    required=True,
                    default=None,
                    choices=[1, 2, 3, 4, 5],
                    help='1 is AE(average accuarcy);\n2 is RMSE(Root-Mean-Square Error);\n3 is NRMSE(Normalized Root-Mean-Square Error);\n4 is MAPE(Mean absolute percentage error);\n5 is logloss')

parser.add_argument('-n', '--txt_filename',
                    type=str,
                    required=True,
                    default=None,
                    help='This argument is for "OCAIP_TOPIC_Info_{ARGUMENT}.txt".')

parser.add_argument('filename',
                    metavar='file',
                    nargs='+',
                    default=None,
                    help='input four file info solution, testcase, public_set, private_set')

if __name__ == '__main__':

    args = parser.parse_args()
    if(len(args.filename) != 4):
        print('error: there should have exactly four file')
        sys.exit(-1)

    if (args.method == 3):
        dict_c = readCSV2dict4NRMSE(args.filename[0])
        dict_t = readCSV2dict4NRMSE(args.filename[1])
    elif (args.topic == "taxi"):
        dict_c = readCSV2dict4Taxi(args.filename[0])
        dict_t = readCSV2dict4Taxi(args.filename[1])
    else:
        dict_c = readCSV2dict(args.filename[0])
        dict_t = readCSV2dict(args.filename[1])

    pub = readTxt2list(args.filename[2])
    pri = readTxt2list(args.filename[3])

    # basic checking format
    if(len(dict_c) != len(dict_t)):
        print('file format error')
        sys.exit(-1)

    # AE
    if(args.method == 1):
        if(args.topic == "AOI"):
            print('Method usage: AE')
            pub_score = AECheck(dict_c, dict_t, pub)
            pri_score = AECheck(dict_c, dict_t, pri)
            print('public score: {} '.format(pub_score))
            print('private score: {} '.format(pri_score))
            creareRobotVarFile(args.txt_filename,pub_score, pri_score)

    # RMSE
    if(args.method == 2):
        if(args.topic == "Topic3" or args.topic == "Topic4" or args.topic == "taxi"):
            print('Method usage: RMSE')
            pub_score = RMSECheck(dict_c, dict_t, pub)
            pri_score = RMSECheck(dict_c, dict_t, pri)
            print('public score: {} '.format(pub_score))
            print('private score: {} '.format(pri_score))
            creareRobotVarFile(args.txt_filename,pub_score, pri_score)

        elif(args.topic == "topic_3_4"):
            print('Method usage: RMSE')
            pub_score = RMSECheck(dict_c, dict_t, pub)
            print('public score: {} '.format(pub_score))
            creareRobotVarFile(args.txt_filename,pub_score, 0)

    # NRMSE
    if(args.method == 3):
        if(args.topic == "hydraulic"):
            print('Method usage: NRMSE')
            pub_score = NRMSECheck(dict_c, dict_t, pub)
            pri_score = NRMSECheck(dict_c, dict_t, pri)
            print('public score: {} '.format(pub_score))
            print('private score: {} '.format(pri_score))
            creareRobotVarFile(args.txt_filename,pub_score, pri_score)

        elif(args.topic == "SinglePublic"):
            print('Method usage: NRMSE')
            pub_score = NRMSECheck(dict_c, dict_t, pub)
            print('public score: {} '.format(pub_score))
            creareRobotVarFile(args.txt_filename,pub_score, 0)

    # MAPE
    if(args.method == 4):
        print("mape developing")
        pass

    # LogLoss
    if(args.method == 5):
        print("logloss developing")
        pass

