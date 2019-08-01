#Imports & Dependencies
from splinter import Browser
from bs4 import BeautifulSoup
from pprint import pprint
import pandas as pd
import time

def init_browser():
	executable_path = {'executable_path': 'chromedriver.exe'}
	return Browser('chrome', **executable_path, headless=False)


def scrape():
	browser = init_browser()
	news_URL = "https://mars.nasa.gov/news/"
	browser.visit(news_URL)
	time.sleep(1)
	html = browser.html
	soup = BeautifulSoup(html, "html.parser")
	article = soup.find("div", class_='list_text')
	article_date = article.find("div", class_="list_date").text
	news_title = article.find("div", class_="content_title").text
	news_p = article.find("div", class_ ="article_teaser_body").text
	output = [news_title, news_p]


	image_URL = "https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars"
	browser.visit(image_URL)
	time.sleep(1)
	html = browser.html
	soup = BeautifulSoup(html, "html.parser")
	image = soup.find("img", class_="thumb")["src"]
	featured_image_url = "https://www.jpl.nasa.gov" + image

	url_weather = "https://twitter.com/marswxreport?lang=en"
	browser.visit(url_weather)
	time.sleep(1)
	html_weather = browser.html
	soup = BeautifulSoup(html_weather, "html.parser")
	mars_weather = soup.find("p", class_="TweetTextSize TweetTextSize--normal js-tweet-text tweet-text").text


	fact_url = "https://space-facts.com/mars/"
	browser.visit(fact_url)
	time.sleep(1)
	mars_data = pd.read_html(fact_url)
	mars_table = pd.DataFrame(mars_data[0])
	mars_fact = mars_table.to_html(index = False, header = False)


	url_hemisphere = "https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars"
	browser.visit(url_hemisphere)
	time.sleep(1)
	html = browser.html
	soup = BeautifulSoup(html, 'html.parser')
	items = soup.find("div", class_ = "result-list")
	lists = items.find_all('div', class_ = "item")
	mars_hemishpere = []
	for hemi in lists:
	    title = (hemi.find("h3").text)
	    browser.click_link_by_partial_text(title)
	    html = browser.html
	    soup = BeautifulSoup(html, 'html.parser')
	    hemi = soup.find('div', class_= 'downloads')
	    image_url = hemi.find('a')['href']	    
	    mars_hemishpere.append({"Title": title, "img_url" : image_url})	    
	    browser.back()	    
	mars_hemishpere

	mars_data = {
		"news_title" : output[0],
		"mars_p" : output[1],
		"featured_image_url" : featured_image_url,
		"mars_weather" : mars_weather,
		"mars_fact" : mars_fact,
		"mars_hemishpere" : mars_hemishpere
	}
	browser.quit()
	return mars_data