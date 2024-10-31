
import random
from selenium.common.exceptions import ElementNotInteractableException, TimeoutException
import numpy as np
import cv2
import os
import traceback
from turtle import delay
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
import time
import csv
from selenium.webdriver.common.action_chains import ActionChains
import json
from tqdm import tqdm
import datetime
from selenium.common.exceptions import NoSuchElementException
import re
class WebAutomation:
    def __init__(self, driver_path, url):
        chrome_options = Options()
        chrome_options.add_argument("--start-maximized")
        chrome_options.add_argument("--ignore-certificate-errors")
        self.driver = webdriver.Chrome(service=Service(driver_path), options=chrome_options)
        self.driver.get(url)
        self.required_XPATH = [
            "//div[@class='ml-4']//div//*[name()='svg']", # V5med
            "//h3[normalize-space()='Medical Viewer']", #medical viewer
            "//button[@data-cy='WindowLevel-split-button-primary']//*[name()='svg']", #window level
            "(//*[name()='svg'][@class='w-5 h-5 fill-current'])[2]",  #zoomtogle
            "(//*[name()='svg'])[9]",  #zoomtogle 箭頭
            "(//*[name()='svg'][@class='w-5 h-5 fill-current'])[3]",# 尺
            "(//*[name()='svg'][@class='w-5 h-5 fill-current'])[4]",# 筆
            "(//*[name()='svg'][@class='w-5 h-5 fill-current'])[5]",# Pan
            "(//*[name()='svg'][@class='w-5 h-5 fill-current'])[6]",# capture
            "(//*[name()='svg'][@class='w-5 h-5 fill-current'])[7]",# grid layout
            "(//*[name()='svg'][@class='w-5 h-5 fill-current'])[8]",#MPR
            "(//*[name()='svg'][@class='w-5 h-5 fill-current'])[9]", # crosshairs
            "(//*[name()='svg'][@class='w-5 h-5 fill-current'])[10]",# reset view
            "(//*[name()='svg'][@class='fill-current'])[1]", #setting
            "//body/div/div/div/div/div/div[1]/div[3]/div[1]/div[1]/div[1]",
            "//body/div[@id='root']/div/div[@class='bg-black flex flex-row items-stretch w-full overflow-hidden flex-nowrap relative']/div[@class='transition-all duration-300 ease-in-out h-100 bg-black border-black justify-start box-content flex flex-col ml-1']/div/div[@class='invisible-scrollbar']/div[1]",
            "//div[@class='overflow-hidden ohif-scrollbar max-h-112']",
            "//button[normalize-space()='Confirm']",
            "//div[@class='pointer-events-auto select-none text-base flex overflow-visible whitespace-nowrap h-8 items-center px-2 shrink-0']",
            "//span[@class='text-white ']"
        ]
        self.missing_classes = []

    def login(self, username, password, login_xpath):
        user_element = WebDriverWait(self.driver, 10).until(EC.visibility_of_element_located((By.ID, 'name')))
        pass_element = self.driver.find_element(By.ID, 'password')
        user_element.send_keys(username)
        pass_element.send_keys(password)
        login_span = self.driver.find_element(By.XPATH, login_xpath)
        time.sleep(1)
        login_span.click()
    def screenpic(self, save_dir):
            try:
                # 確保目錄存在
                if not os.path.exists(save_dir):
                    os.makedirs(save_dir)

                # 生成唯一的檔案名
                timestamp = time.strftime("%Y%m%d-%H%M%S")
                screenshot_path = os.path.join(save_dir, f'screenshot_{timestamp}.png')
                
                # 截圖並保存到指定目錄
                self.driver.save_screenshot(screenshot_path)
                print(f"截圖成功，已保存為{screenshot_path}")
            except Exception as e:
                print(f"錯誤: {e}")

    def send(self, search_input_xpath, search_word, save_dir):
        try:
            send_element = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.XPATH, search_input_xpath))
            )
            send_element.send_keys(Keys.CONTROL + "a")
            send_element.send_keys(Keys.BACKSPACE)
            send_element.send_keys(search_word)
            
            # 等待元素出現，最多等待10秒
            element = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.XPATH, "//div[contains(text(),'min value is error.')]"))
            )
            if element:
                time.sleep(0.1)
                print("合格")
                # 調用screenpic方法進行截圖
                # self.screenpic(save_dir)
        except Exception as e:
            print(f"錯誤: {e}")
            self.screenpic(self, r"C:\selinium\browser_automation_test-main\screenshot")

    def search(self, search_input_xpath, search_word, enter_xpath=None, click=False):
        search_element = WebDriverWait(self.driver, 10).until(EC.presence_of_element_located((By.XPATH, search_input_xpath)))
        search_element.send_keys(search_word)
        time.sleep(2)
        
        # 如果 click 为 True，则点击指定的按钮
        if click:
            enter_button = WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.XPATH, enter_xpath)))
            enter_button.click()
            time.sleep(2)

        try:
            empty_description = self.driver.find_element(By.CLASS_NAME, 'ant-empty-description')
            if empty_description:
                search_element.send_keys(Keys.CONTROL + "a")
                search_element.send_keys(Keys.BACKSPACE)
                print("清除MIXWORD")
        except:
            print("未找到class='ant-empty-description'")
        if click:
            enter_button = WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.XPATH, enter_xpath)))
            enter_button.click()
            time.sleep(2)
            try:
                empty_description = self.driver.find_element(By.CLASS_NAME, 'ant-empty-description')
            except:
                print("輸入欄位--合格")
    def click_first_patient_id(self):
        try:
            element = WebDriverWait(self.driver, 10).until(
                EC.element_to_be_clickable((By.XPATH, "(//i[@aria-label='icon: eye'])[1]"))
            )
            element.click()
            print("已點擊眼睛圖標，進入下個頁面")
        except Exception as e:
            print(f"等待元素可點擊超時或發生錯誤: {e}")
            self.driver.quit()


    def switch_to_new_window(self):
        original_window_handle = self.driver.current_window_handle
        all_window_handles = self.driver.window_handles
        new_window_handle = None
        for handle in all_window_handles:
            if handle != original_window_handle:
                new_window_handle = handle
                break
        if new_window_handle:
            self.driver.switch_to.window(new_window_handle)
        return new_window_handle, original_window_handle

    def check_required_elements(self):
        i = 0
        for xpath in self.required_XPATH:
            i+=1
            try:
                WebDriverWait(self.driver, 10).until(
                    EC.presence_of_element_located((By.XPATH, xpath))
                )
                print(f'項目{i}合格')
            except TimeoutException:
                self.missing_classes.append(xpath)
                print(f"Missing class: {xpath}")
        if self.missing_classes:
            print("Missing classes:", self.missing_classes)
            self.screenpic(r"C:\selinium\browser_automation_test-main\screenshot")
            
   
    def close_window(self):
        self.driver.close()

    def switch_to_window(self, window_handle):
        self.driver.switch_to.window(window_handle)

    def click_element(self, xpath):
        try:
            element = WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.XPATH, xpath)))
            ActionChains(self.driver).move_to_element(element).click().perform()
        except Exception as e:
            print("未顯示點擊項目")
            self.screenpic(r"C:\selinium\browser_automation_test-main\screenshot")

    def count_menu_items(self, class_name):
        menu_items = self.driver.find_elements(By.CLASS_NAME, class_name)
        print("頁面下可點擊項目數量",len(menu_items))
        return len(menu_items), menu_items

    def interact_with_menu_items(self, menu_class, logo_xpath):
       
        for i in range(1):
            element_xpath = f"//tbody/tr[{i}]/td[1]/span[1]"
            try:
                time.sleep(0.2)

            except TimeoutException:
                pass
            new_window_handle, original_window_handle = self.switch_to_new_window()
            if new_window_handle:
                try:
                    WebDriverWait(self.driver, 60).until(
                        EC.visibility_of_element_located((By.XPATH, logo_xpath))
                    )
                except TimeoutException:
                    print("Timeout: Element not found within the specified time")
                self.check_required_elements()
                self.close_window()
                self.switch_to_window(original_window_handle)
       
        menu_count, _ = self.count_menu_items(menu_class)
        print("每項點擊測試")
        
        for i in range(1, menu_count + 1):
            element_xpath = f"//tbody/tr[{i}]/td[1]/span[1]"
            try:
                time.sleep(1)
                element = WebDriverWait(self.driver, 10).until(
                    EC.element_to_be_clickable((By.XPATH, element_xpath))
                )
                element = self.driver.find_element(By.XPATH, element_xpath)
                element.click()
                print("點擊成功")
            except TimeoutException:
                print(f"等待元素可點擊超時: {element_xpath}")
                break
            new_window_handle, original_window_handle = self.switch_to_new_window()
            if new_window_handle:
                try:
                    WebDriverWait(self.driver, 60).until(
                        EC.visibility_of_element_located((By.XPATH, logo_xpath))
                    )
                except TimeoutException:
                    print("Timeout: Element not found within the specified time")
                self.check_required_elements()
                self.close_window()
                self.switch_to_window(original_window_handle)

    def navigate_menu(self, element_xpath, item_xpath):
        self.click_element(element_xpath)
        try:
            self.click_element(item_xpath)
        except:
            print("navigate_menuf_xpath:",{item_xpath},"無法正確點擊該項目標")

    # def fetch_data_row_keys(self):
    #     data_row_keys = []
    #     try:
    #         elements = self.driver.find_elements(By.XPATH, "//tr[@data-row-key]")
    #         for element in elements:
    #             data_row_key = element.get_attribute("data-row-key")
    #             data_row_keys.append(data_row_key)
    #     except Exception as e:
    #         print(f"抓取 data-row-key 失敗：{e}")
    #     return data_row_keys

    def navigate_pagination(self):
        element_xpath = "//li[@title='Next Page']//a[@class='ant-pagination-item-link']"
        try:
            WebDriverWait(self.driver, 10).until(
                EC.element_to_be_clickable((By.XPATH, element_xpath))
            ).click()
            print("成功點擊元素")
            print("進入下一頁")
        except Exception as e:
            print(f"點擊元素失敗：{e}")
    def wait_for_element_visible(self, xpath, timeout=10):
        try:
            WebDriverWait(self.driver, timeout).until(
                EC.visibility_of_element_located((By.XPATH, xpath))
            )
            return True
        except TimeoutException:
            print(f"元素 {xpath} 在 {timeout} 秒內不可見")
            return False
    def compare_img(self, element_id,element_xpath,direction = "vertical",distance = 100,scroll_amount = 100):
        element = self.driver.find_element(By.XPATH,element_id)

        time.sleep(10)
        print("shot")
        element.screenshot('before.png')
        
        self.drag_element(element_xpath, direction, distance) #指定拖動物件垂直拖動到指定距離
        time.sleep(4)
#        WebDriverWait(self.driver, timeout=10).until(
#            EC.invisibility_of_element_located((By.XPATH, "//canvas[@class='cornerstone-canvas']"))
#        )
        self.click_and_scroll_at_coordinates(70, 70, scroll_amount)
        time.sleep(10)
        print("shot")
        # 再次截取相同元素的截圖
        element.screenshot('after.png')

        # 載入圖像並轉換為灰度圖
        img1 = cv2.imread('before.png', cv2.IMREAD_GRAYSCALE)
        img2 = cv2.imread('after.png', cv2.IMREAD_GRAYSCALE)

        if img1 is None or img2 is None:
            raise ValueError('One of the images is not loaded properly')
        if img1.shape != img2.shape:
            print("img1.shape",img1.shape)
            print("img2.shape",img2.shape)
            print('警告：物件長寬不一，若before.png未拍攝到dicom表示加載時間過長')

        if img1.shape != img2.shape:
            img2 = cv2.resize(img2, (img1.shape[1], img1.shape[0]))  # Resize img2 to match img1 size

        # 計算兩張圖像的差異
        diff = cv2.absdiff(img1, img2)
        _, diff = cv2.threshold(diff, 25, 255, cv2.THRESH_BINARY)

        # 檢查差異是否存在
        if np.sum(diff) == 0:
            print("圖像沒有變化")
        else:
            print("合格，圖像發生了變化")

    def click_and_scroll_at_coordinates(self, x, y, scroll_amount):
        try:
            # 確保目標座標在視口內
            self.driver.execute_script("window.scrollTo(arguments[0], arguments[1]);", x, y)
            time.sleep(1)  # 等待滾動完成

            # 創建 ActionChains 對象
            actions = ActionChains(self.driver)

            # 移動到指定座標並點擊
            actions.move_by_offset(x, y).click().perform()
            time.sleep(1)  # 確保點擊完成

            # 執行滾動操作
            self.driver.execute_script("window.scrollBy(0, arguments[0]);", scroll_amount)
            print("點擊並滾動操作成功")
        except Exception as e:
            # 列印詳細的錯誤資訊
            print("無法在座標點擊和滾動:")
            print(e)
            
    def drag_element(self, element_xpath, direction, distance):
        self.wait_for_element_visible(element_xpath)
        time.sleep(1)
        try:
            # 找到要拖曳的元素
            element = self.driver.find_element(By.XPATH, element_xpath)
            
            # 創建 ActionChains 對象
            actions = ActionChains(self.driver)

            # 起始位置
            start_offset_x, start_offset_y = 0, 0

            if direction == "horizontal":
                end_offset_x = distance
                end_offset_y = 0
            elif direction == "vertical":
                end_offset_x = 0
                end_offset_y = distance
            else:
                raise ValueError("Direction must be 'horizontal' or 'vertical'")

            # 執行拖曳操作
            actions.move_to_element_with_offset(element, start_offset_x, start_offset_y)
            actions.click_and_hold()
            
            # 先移動100
            actions.move_by_offset(0, end_offset_y ).perform()
            time.sleep(10)  # 確保動作完成
            
            # 再移動-80
            actions.move_by_offset(0, -80).perform()
            time.sleep(10)  # 確保動作完成
            
            # 釋放
            actions.release().perform()

            print("拖曳操作成功")
        except Exception as e:
            # 列印詳細的錯誤資訊
            print("無法拖曳:")
            print(e)
    def list_store(self, combobox_xpath="//div[@role='combobox']"):
        import json

        # 等待下拉式列示方塊可以點擊
        WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.XPATH, combobox_xpath))).click()

        # 等待下拉選項載入完成
        time.sleep(2)  # 根據實際情況調整等待時間

        # 查找所有下拉選項
        options = self.driver.find_elements(By.CLASS_NAME, "ant-select-dropdown-menu-item")

        # 記錄所有選項的 XPath 和名稱到字典
        options_data = {}
        for option in options:
            option_name = option.text.strip()  # 去除名稱前後的空格
            option_xpath = f"//li[normalize-space()='{option_name}']"
            options_data[option_name] = []

            # 點擊選項以載入其下的小選項
            WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.XPATH, option_xpath))).click()

            # 等待小選項載入完成
            time.sleep(2)  # 根據實際情況調整等待時間

            # 查找所有小選項
            sub_options = self.driver.find_elements(By.XPATH, "span_patientID")
            for sub_option in sub_options:
                sub_option_name = sub_option.text.strip()  # 去除名稱前後的空格
                sub_option_xpath = self.driver.execute_script("return arguments[0].outerHTML;", sub_option)
                options_data[option_name].append({sub_option_name: sub_option_xpath})

            x = 0
            previous_keys = set()

            while True:
                x += 1
                print("第", x, "次進入分次點擊")

                # 抓取當前頁面所有具有 data-row-key 的元素
                data_row_keys = []
                try:
                    elements = self.driver.find_elements(By.XPATH, "//tr[@data-row-key]")
                    current_keys = set(element.get_attribute("data-row-key") for element in elements)
                    print("當前頁面的 data_row_keys:", current_keys)
                except Exception as e:
                    print(f"抓取 data-row-key 失敗：{e}")
                    break

                # 檢查是否有重複的項
                if current_keys & previous_keys:
                    print("有重複的 data-row-key，停止")
                    break
                else:
                    print("沒有重複的 data-row-key")
                    previous_keys.update(current_keys)

                # 進行翻頁
                next_button_xpath = "//li[@title='Next Page']//a[@class='ant-pagination-item-link']"
                try:
                    WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.XPATH, next_button_xpath))).click()
                    time.sleep(2)  # 等待頁面載入
                except Exception as e:
                    print(f"翻頁失敗：{e}")
                    break

            print("所有收集到的 data_row_keys:", previous_keys)


            # 回到下拉式列示方塊以便點擊下一個選項
            WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.XPATH, combobox_xpath))).click()
            time.sleep(2)

        # 將字典保存為 JSON 檔
        with open('options_data.json', 'w', encoding='utf-8') as f:
            json.dump(options_data, f, ensure_ascii=False, indent=4)

    def input_title(self, input_box="/html/body/div[1]/div/section/section/section/main/div/div[2]/div[1]/div"):
        with open('options_data.json', 'r', encoding='utf-8') as f:
            options_data = json.load(f)

        # 解析小標題
        titles = []
        for category in options_data.values():
            for item in category:
                titles.extend(item.keys())

        # 依次點擊小標題
        for title in titles:
            try:
                # 點擊輸入框展開下拉式功能表
                print("click")
                # self.click_element(input_box)

                # 生成小標題的XPath
                title_xpath = f"//li[normalize-space()='{title}']"
                self.navigate_menu( input_box, title_xpath)
                # 等待小標題元素出現並點擊

                # 檢查是否出現關閉對話方塊的按鈕
                try:
                    close_button = WebDriverWait(self.driver, 2).until(
                        EC.presence_of_element_located((By.XPATH, "//div[@id='rcDialogTitle0']"))
                    )
                    if close_button:
                        # 如果出現對話方塊，則點擊關閉按鈕
                        close_icon = self.driver.find_element(By.XPATH, "//i[@aria-label='icon: close']//*[name()='svg']")
                        close_icon.click()
                        print(f"'{title}' 對話方塊已關閉")
                        print("合格")
                except TimeoutException:
                    # 對話方塊未出現
                    pass

                # 檢查是否出現異常元素
                try:
                    WebDriverWait(self.driver, 2).until(
                        EC.presence_of_element_located((By.XPATH, "//div[@class='ant-empty-image']"))
                    )
                    print(f"'{title}' 出現異常")
                except TimeoutException:
                    print(f"'{title}' 正常")
                    print("未出現異常")

            except (TimeoutException, ElementNotInteractableException) as e:
                # print(f"處理 '{title}' 時出錯：{e}")
                pass
    from selenium.webdriver.common.action_chains import ActionChains



    def click_and_drag(self, button_xpath):
        try:
            # 先点击指定按钮
            button = self.driver.find_element(By.XPATH, button_xpath)
            button.click()
            time.sleep(2)  # 增加等待时间，确保页面更新完成
            # 再次确认元素可见性或重新计算坐标
            self.driver.execute_script("window.scrollTo(0, 0);")  # 滚动到页面顶部，确保页面定位正确
            # 定位到页面中间的元素或坐标开始拖曳操作
            middle_x = self.driver.execute_script("return window.innerWidth / 2;")
            middle_y = self.driver.execute_script("return window.innerHeight / 2;")
            

            # 生成随机偏移量
            random_offset_x = random.randint(10, 50)
            random_offset_y = random.randint(10, 50)

            # 创建 ActionChains 对象
            actions = ActionChains(self.driver)

            # 鼠标移动到画面中间，点击并拖动一段距离后释放
            actions.move_by_offset(middle_x, middle_y).click_and_hold().move_by_offset(100 + random_offset_x, 100 + random_offset_y).release().perform()

            print("点击并拖动操作成功")
        except Exception as e:
            print("无法完成点击并拖动操作:")
            print(e)

    def check_for_error_element(self,xpath):
        try:
            # 尝试找到指定的元素
            element = self.driver.find_element(By.XPATH,xpath)
            # 如果找到该元素，返回错误信息
            print('ant-empty-description')
            return "Error: Found element with class 'ant-empty-description'"
        except NoSuchElementException:
            # 如果找不到元素，返回成功信息
            return "Element not found, everything seems okay."



    def perform_svg_clicks_and_validate(self):
        def click_and_record(svg_index, click_times, record=False):
            values = []
            for _ in range(click_times):
                try:
                    # 点击指定的 svg 元素
                    svg_xpath = f"(//*[name()='svg'])[ {svg_index}]"
                    svg_element = self.driver.find_element(By.XPATH, svg_xpath)
                    ActionChains(self.driver).move_to_element(svg_element).click().perform()
                    time.sleep(1)  # 等待页面加载

                    # 如果需要记录，才记录信息
                    if record:
                        td_elements = self.driver.find_elements(By.XPATH, "//td[@title]")
                        for td in td_elements:
                            try:
                                value = td.get_attribute('title')
                                # 只保留符合时间格式的值
                                if re.match(r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}', value):
                                    values.append(value)
                            except:
                                continue
                except NoSuchElementException:
                    print(f"Element not found: {svg_xpath}")
            return values

        try:
            # 第一次点击不需要记录，第二次才记录
            print("Processing (//*[name()='svg'])[6]")
            first_record = click_and_record(6, 1, record=True)  # 第二次点击，记录
            second_record = click_and_record(6, 1, record=True)  # 再次点击，记录
            print("first_record", first_record)
            print("second_record", second_record)

            # 验证记录
            if len(first_record) > 0 and len(second_record) > 0:
                # 验证整个记录列表是否相等
                if first_record == second_record[::-1]:
                    print("合格")
                else:
                    print("不合格")
            else:
                print("记录不足，无法验证")

        finally:
            # 清除记录
            first_record.clear()
            second_record.clear()

        # 使用示例
if __name__ == "__main__":
    #下拉選單按鍵
    click_list ="/html/body/div[1]/div/section/section/section/main/div/div[1]/div[3]"
    list_Sales = "//li[@class='ant-select-dropdown-menu-item' and text()='Sales']"
    list_Q ="//li[@class='ant-select-dropdown-menu-item' and text()='Q']"
    list_Sandy = "//li[normalize-space()='Sales Sandy']"
    CAD_Config = "//li[4]//div[1]"
    m1 = "//li[normalize-space()='M1']"
    dia3 = "//option[@title='Tooltip: The maximum diameter of the lung nodule when viewed in three dimensions, usually measured in millimeters (mm).']"
    prob = "//option[@value='prob']"
    DICOM_patientId = "//div[@class='ant-select-selection__rendered']"
    volumn = "//option[@value='volumn']"
    entropy = "//option[@value='entropy']"
    kutosis = "//option[@value='entropy']"
    hu_mean = "//option[@value='hu_mean']"
    hu_variance = "//option[@value='hu_variance']"
    maxDia = "//option[@title='Tooltip: The longest diameter of the lung nodule, usually measured in millimeters (mm).']"
    minDia = "//option[@title='Tooltip: The shortest diameter of the lung nodule, usually measured in millimeters (mm).']"
    avgDia = "//option[@title='Tooltip: The average diameter of the lung nodule, usually measured in millimeters (mm).']"
    nodule_type = "//option[@value='nodule_type']"
    list_LIDCIDRI1001 ="//li[normalize-space()='LIDC-IDRI-1001']"
    kurtosis = "//option[@value='kurtosis']"
    system_xpath ="/html/body/div[1]/div/section/section/header/ul/li[8]/div"
    sysvariable = "//li[normalize-space()='System variable settings']"
    sysauthority = "//li[normalize-space()='System authority settings']"
    subject_filter = "/html/body/div[1]/div/section/section/section/main/div/div/div/div[1]/div/button"
    dental ="//li[normalize-space()='dental']"
    
    # 初始化 WebAutomation 類
    web_automation = WebAutomation(driver_path='C:\\Python27\\chromedriver.exe', url='http://v5lungct2.v5.com.tw/M1/login')
    
    # 登入操作
    web_automation.login(username="Jimmy", password='Jimmy', login_xpath="/html/body/div/form/div[3]/div/div/span/button")
    
    # 搜尋操作
    try:
        web_automation.search(search_input_xpath="/html/body/div/div/section/section/section/main/div/div[1]/input", search_word='��穃銁��憌�12324',click=False)
        web_automation.click_element("//i[@title='Filter menu']//*[name()='svg']") #點擊篩選
        web_automation.click_element("//li[1]//label[1]//span[1]//input[1]")
        web_automation.navigate_menu(element_xpath = "(//li[@role='menuitem'])[13]", item_xpath = "//a[normalize-space()='OK']")
        web_automation.click_element("//i[@title='Filter menu']//*[name()='svg']") #點擊篩選
        web_automation.navigate_menu(element_xpath = "//a[normalize-space()='Reset']", item_xpath = "//a[normalize-space()='OK']") 
    except:
        print("有項目無法點擊")
        web_automation.screenpic(r"C:\selinium\browser_automation_test-main\screenshot")
    # 點擊首個患者ID
    web_automation.click_first_patient_id()
    
 # 切換到新窗口
    new_window_handle, original_window_handle = web_automation.switch_to_new_window()
    if new_window_handle:
        # 檢查所需的元素
        web_automation.check_required_elements()
        #測試尺
        web_automation.click_and_drag(button_xpath = "//button[@data-cy='Length']")
        print("第一把尺測試完畢")
        # 測試pan
        print("測試pan")
        web_automation.click_and_drag(button_xpath = "//button[@data-cy='Pan']")
        time.sleep(3)
        element_xpath = "(//input[@value='0'])[1]" #這是dicom右側橫桿可使dicom圖像改變
        element_id  = " //div[@class='viewport-element']//*[name()='svg']"
        print("開始比較")
        try:
            web_automation.compare_img(element_id,element_xpath)
            print("比較完畢")
        except:
            print("無法改變")
            pass

        print("畫筆畫線")
        web_automation.click_and_drag(button_xpath ='//*[@id="root"]/div[2]/div[1]/div/div[2]/div/div[4]/div/div/button')

        print("圖像工具檢測完畢")
        # 關閉新窗口
        web_automation.close_window()
        # 切換回原本的窗口
        web_automation.switch_to_window(original_window_handle)
    
    # 導航至選單
    web_automation.list_store(combobox_xpath = "//div[@role='combobox']")#將前面所有的病人ID記錄起來，在另一頁搜尋欄中一一搜尋
    web_automation.navigate_menu(element_xpath = click_list, item_xpath = list_Sales)
    print("***************************")
    web_automation.navigate_menu(element_xpath = CAD_Config, item_xpath = m1)
    web_automation.switch_to_new_window()
    web_automation.navigate_menu(element_xpath = DICOM_patientId, item_xpath = list_LIDCIDRI1001)
    
    item_xpaths = [prob, dia3, volumn, entropy, kurtosis, hu_mean, hu_variance, maxDia, minDia, avgDia]

    for item in item_xpaths:
        web_automation.click_element(item)
        print("測試項目Xpath:",item,"item")
        time.sleep(0.3)
        web_automation.send(search_input_xpath="(//input[@ type='text'])[1]", search_word='0',save_dir = r"C:\selinium\browser_automation_test-main\screenshot")
        time.sleep(1)
        print("測試最小值")
        web_automation.send(search_input_xpath="(//input[@type='text'])[2]", search_word='12347890', save_dir = r"C:\selinium\browser_automation_test-main\screenshot")
        print("測試最大值")
        time.sleep(1)
        web_automation.click_element("//button[@type='submit']")#add
        web_automation.click_element("(//button[@type='button'])[3]")#submit
        time.sleep(1)
        web_automation.click_element("//div[@class='ant-modal-root']//button[1]")
        print(item,"項目測試結束")
    web_automation.click_element("/html/body/div[1]/div/sect  ion/section/section/main/div/div[1]/form/button[1]")
    time.sleep(1)
    web_automation.click_element("/html/body/div[5]/div/div[2]/div/div[2]/div/div/div[2]/button[2]")
    print("最後一個")
    web_automation.input_title("//input[@class='ant-select-search__field']")


    web_automation.click_element("//li[normalize-space()='System record search']") #進入System record search
    web_automation.check_for_error_element(xpath="//p[@class='ant-empty-description']")# 是否有NoData出現
    print("click")
    web_automation.click_element("/html/body/div/div/section/section/section/main/div/div/div/div[2]/div/div/ul/li[7]/a/div/span") #下五頁的按鈕
    web_automation.check_for_error_element(xpath="//p[@class='ant-empty-description']") # 是否有NoData出現
    web_automation.perform_svg_clicks_and_validate()
    web_automation.search(search_input_xpath="//input[@placeholder='search']", search_word='252324',enter_xpath="//button[@class='ant-btn ant-btn-primary']", click=True)

    i=0 
    while True: 
        i+=1
        page_xpath = f"//a[normalize-space()='{i}']"
        try:
            element = WebDriverWait( web_automation.driver, 10).until(EC.element_to_be_clickable((By.XPATH, page_xpath)))
            ActionChains( web_automation.driver).move_to_element(element).click().perform()
        except:
            result_message = web_automation.check_for_error_element(xpath="//p[@class='ant-empty-description']")
            if result_message == "Error: Found element with class 'ant-empty-description":
                web_automation.screenpic(r"C:\selinium\browser_automation_test-main\screenshot")
            break

    
    
    web_automation.navigate_menu(element_xpath = system_xpath, item_xpath = sysvariable)#進入system類
    web_automation.navigate_menu(element_xpath = subject_filter, item_xpath = dental)
    i=0 
    while True: 
        i+=1
        page_xpath = f"//a[normalize-space()='{i}']"
        try:
            element = WebDriverWait( web_automation.driver, 10).until(EC.element_to_be_clickable((By.XPATH, page_xpath)))
            ActionChains( web_automation.driver).move_to_element(element).click().perform()
        except:
            result_message = web_automation.check_for_error_element(xpath="//p[@class='ant-empty-description']")
            if result_message == "Error: Found element with class 'ant-empty-description":
                web_automation.screenpic(r"C:\selinium\browser_automation_test-main\screenshot")
            break


input()