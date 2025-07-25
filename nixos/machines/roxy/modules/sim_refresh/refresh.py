# Credit goes to DanielWTE/unlimited-ondemand-auto-extender

import os
import time
from playwright.sync_api import sync_playwright
import logging

def check_1und1(username, password, CHECK_INTERVAL):
    logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(message)s")
    browser = None
    page = None

    try:
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()

            logging.info("Open login page...")
            page.goto('https://account.1und1.de/')
            logging.info("Performing login...")
            page.fill('#login-form-user', username)
            page.fill('#login-form-password', password)
            page.click('#login-button')
            
            logging.info("Waiting for robot verification...")
            try:
                robot_button = page.wait_for_selector('button.button-primary.button-access:has-text("E-Mail senden")', timeout=5000)
                if robot_button and robot_button.is_visible():
                    logging.info("robot verification detected")
                    logging.info("Sending verification mail...")
                    robot_button.click()
                    
                    logging.info("Please open the verification mail and confirm")
                    logging.info("The process is going to restart in 60 seconds")
                    time.sleep(60)
                    
                    if browser:
                        browser.close()
                    return
            except Exception as e:
                logging.info(f"No robot verification detected, continuing...")
                
            logging.info("Login successful")
            
            logging.info("Denying cookies...")
            try:
                page.click('#consent_wall_optout')
            except:
                logging.info("Cookie banner not detected or already closed")

            while True:
                try:
                    logging.info("Load usage overview...")
                    page.goto('https://control-center.1und1.de/usages.html')
                    logging.info("Loaded usage overview...")
                    
                    button = page.wait_for_selector('button:has-text("+1 GB")', timeout=5000)
                    if button:
                        is_disabled = button.get_attribute('disabled') is not None
                        if is_disabled:
                            logging.info("Button found, but it is disabled")
                        else:
                            logging.info("Button found and active. Trying to click...")
                            button.click()
                            logging.info("Button successfully clicked")
                            confirm_button = page.wait_for_selector('button:has-text("Ok")', timeout=5000)
                            if confirm_button:
                                confirm_button.click()
                                logging.info("Closed confirmation successfully")
                    else:
                        # Currently has no effect because of wait_for_selector
                        logging.warning("Button '+1 GB' not found")

                    logging.info(f"Waiting {CHECK_INTERVAL} seconds until checking again...")
                    time.sleep(CHECK_INTERVAL)

                except Exception as e:
                    logging.error(f"Error while checking: {str(e)}")
                    if browser:
                        browser.close()
                    return

    except Exception as e:
        logging.error(f"Error while executing: {str(e)}")
        if browser:
            browser.close()



if __name__ == "__main__":
    username = os.getenv('USERNAME')
    password = os.getenv('PASSWORD')
    CHECK_INTERVAL = 60;
    while True:
        check_1und1(username, password, CHECK_INTERVAL)
