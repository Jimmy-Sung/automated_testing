# 計算選單的選項數量
menu_class = "span_patientID"
menu_items = wd.find_elements(By.CLASS_NAME, menu_class)
menu_count = len(menu_items)
print(menu_count,menu_items)
data_row_keys = []
while True:

        # 抓取所有具有 data-row-key 的元素

    try:
        elements = wd.find_elements(By.XPATH, "//tr[@data-row-key]")
        for element in elements:
            data_row_key = element.get_attribute("data-row-key")
            data_row_keys.append(data_row_key)
    except Exception as e:
        print(f"抓取 data-row-key 失敗：{e}")

    for i in range(1, menu_count + 1):
        # print(i, "+++++++++++++++++++++++++++++++++++")
        element_xpath = f"//tbody/tr[{i}]/td[1]/span[1]"

        try:
            # 等待元素可點擊

            element = WebDriverWait(wd, 10).until(
                EC.element_to_be_clickable((By.XPATH, element_xpath))
            )
            element = wd.find_element(By.XPATH, element_xpath)
            # 點擊元素
            element.click()
            print("點擊成功")
        except TimeoutException:
            print(f"等待元素可點擊超時: {element_xpath}")
            break
        # print("second111111111111111111111111111111")


        original_window_handle = wd.current_window_handle
        # 獲取所有窗口的處理
        all_window_handles = wd.window_handles
        new_window_handle = None
        for handle in all_window_handles:
            if handle != original_window_handle:
                new_window_handle = handle
                break
        if new_window_handle:
            wd.switch_to.window(new_window_handle)
            
            try:
                # Wait for the element on the new tab to appear
                search_element = WebDriverWait(wd, 60).until(
                    EC.visibility_of_element_located((By.XPATH, LOGO))
                )
            except TimeoutException:
                print("Timeout: Element not found within the specified time")



            # Check for each class in required_classes
            for cls in required_XPATH:
                try:
                    WebDriverWait(wd, 4).until(
                        EC.presence_of_element_located((By.XPATH, cls))
                    )

                    print('迴圈合格')
                except TimeoutException:
                    missing_classes.append(cls)
                    print(f"Missing class: {cls}")

            # Continue processing missing classes or other operations
            if missing_classes:
                print("Missing classes:", missing_classes)
        else:
            print("New window not found")

        # 保存缺失的 class 到 CSV 和截圖
        if missing_classes:
            screenshot_path = 'missing_classes_screenshot.png'
            wd.save_screenshot(screenshot_path)
            print(f"缺失的 class 已保存到 {screenshot_path}")
            
            with open('missing_classes.csv', mode='w', newline='') as file:
                writer = csv.writer(file)
                writer.writerow(['Missing Class'])
                for cls in missing_classes:
                    writer.writerow([cls])
            wd.close()
        # 切换回原本的页面
            wd.switch_to.window(original_window_handle)
            print("original_window_handle")
            
        else:
            print("合格")
            wd.close()
        # 切换回原本的页面
            wd.switch_to.window(original_window_handle)
    element_xpath = "//li[@title='Next Page']//a[@class='ant-pagination-item-link']"
    try:
        WebDriverWait(wd, 10).until(
            EC.element_to_be_clickable((By.XPATH, element_xpath))
        ).click()
        print("成功點擊元素")
    except Exception as e:
        print(f"點擊元素失敗：{e}")


    # 檢查是否有重複
    unique_keys = set(data_row_keys)
    if len(data_row_keys) == len(unique_keys):
        print("沒有重複的 data-row-key")
        # 在這裡執行下一個動作
    else:
        print("有重複的 data-row-key")
        break