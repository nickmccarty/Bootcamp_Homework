from flask import Flask, render_template, redirect
from flask_pymongo import PyMongo
import scraper

app = Flask(__name__)

mongo = PyMongo(app, uri="mongodb://localhost:27017/mars_app")


@app.route("/")

def index():

    # Find one record of data from the mongo database
    mars_data = mongo.db.collection.find_one()

    # Return template and data
    return render_template("index.html", site_data=mars_data)

# Route that will trigger the scrape function
@app.route("/scrape")

def scrape_news():

    # Run the scrape function
    story_details = scraper.scrape_story()

    # Update the Mongo database using update and upsert=True
    mongo.db.collection.update({}, story_details, upsert=True)

    # Redirect back to home page
    return redirect("/")


if __name__ == "__main__":
    app.run(debug=True)
