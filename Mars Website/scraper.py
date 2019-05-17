from splinter import Browser
from bs4 import BeautifulSoup as bs
#import time


def init_browser():
    # @NOTE: Replace the path with your actual path to the chromedriver
    executable_path = {"executable_path": "chromedriver.exe"}
    return Browser("chrome", **executable_path, headless=False)


def scrape_story():
    browser = init_browser()

    # Visit url
    url = "https://mars.nasa.gov/news/?page=0&per_page=40&order=publish_date+desc%2Ccreated_at+desc&search=&category=19%2C165%2C184%2C204&blank_scope=Latest"
    browser.visit(url)

    #time.sleep(1)

    # Scrape page into Soup
    html = browser.html
    soup = bs(html, "html.parser")

    # Get the latest headline
    headline = soup.find_all('div', class_="content_title")[0].text

    # Get the latest summary
    summary = soup.find_all('div', class_="article_teaser_body")[0].text

    # Store data in a dictionary
    story_details = {
        "headline": headline,
        "summary": summary
    }

    # Close the browser after scraping
    browser.quit()

    # Return results
    return story_details