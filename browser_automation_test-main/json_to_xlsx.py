import pandas
import json
import numpy
import os
import tempfile
from xlsxwriter.utility import xl_rowcol_to_cell

with open('TestCase.json', encoding='utf-8-sig') as json_data:
    data = json.load(json_data)

with tempfile.TemporaryFile() as tmp:
    pandas.DataFrame.from_dict(data).to_excel(tmp)
    df = pandas.read_excel(tmp)

writer = pandas.ExcelWriter('TestCase.xlsx', engine='xlsxwriter')
df.to_excel(writer, index=True, sheet_name='report')
workbook = writer.book
worksheet = writer.sheets['report']
worksheet.set_zoom(70)

format1 = workbook.add_format({'bg_color': '#FFC7CE',
                               'font_color': '#9C0006'})
format2 = workbook.add_format({'bg_color': '#C6EFCE',
                               'font_color': '#006100'})
format3 = workbook.add_format({'bg_color': '#FFEB9C',
                               'font_color':'#9C6500'})
format4 = workbook.add_format({'align': 'center'})
format5 = workbook.add_format({'bg_color': '#D3D3D3'})

worksheet.set_column('B:B', 30, format4)
worksheet.set_column('C:E', 15, format4)
worksheet.set_column('F:G', 120)
worksheet.set_column('H:H', 25, format4)
worksheet.set_column('I:I', 30, format4)
worksheet.set_column('J:J', 100)

worksheet.conditional_format('B1:B1048576', {'type': 'text',
                                             'criteria': 'containing',
                                             'value': '通用功能－修改帳號資料',
                                             'format': format5})
worksheet.conditional_format('B1:B1048576', {'type': 'text',
                                             'criteria': 'containing',
                                             'value': '通用功能－註冊帳號',
                                             'format': format5})
worksheet.conditional_format('B1:B1048576', {'type': 'text',
                                             'criteria': 'containing',
                                             'value': '議題－「上傳」分頁',
                                             'format': format5})
worksheet.conditional_format('B1:B1048576', {'type': 'text',
                                             'criteria': 'containing',
                                             'value': '議題－日期變動',
                                             'format': format5})
worksheet.conditional_format('B1:B1048576', {'type': 'text',
                                             'criteria': 'containing',
                                             'value': '議題－各階段功能驗證',
                                             'format': format5})
worksheet.conditional_format('B1:B1048576', {'type': 'text',
                                             'criteria': 'containing',
                                             'value': '內容瀏覽',
                                             'format': format5})
worksheet.conditional_format('B1:B1048576', {'type': 'text',
                                             'criteria': 'containing',
                                             'value': '特殊行為禁止',
                                             'format': format5})
worksheet.conditional_format('I1:I1048576', {'type': 'text',
                                             'criteria': 'containing',
                                             'value': '完成',
                                             'format': format2})
worksheet.conditional_format('I1:I1048576', {'type': 'text',
                                             'criteria': 'containing',
                                             'value': '進行中',
                                             'format': format3})
worksheet.conditional_format('I1:I1048576', {'type': 'text',
                                             'criteria': 'containing',
                                             'value': '有困難或需要協助',
                                             'format': format1})
worksheet.conditional_format('I1:I1048576', {'type': 'text',
                                             'criteria': 'containing',
                                             'value': '無此測試資料',
                                             'format': format1})

writer.save()


