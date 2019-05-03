import numpy as np

import datetime as dt

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from flask import Flask, jsonify


#################################################
# Database Setup
#################################################

engine = create_engine("sqlite:///hawaii.sqlite")

# reflect an existing database into a new model

Base = automap_base()

# reflect the tables

Base.prepare(engine, reflect=True)

# Save reference to the table

Measurement = Base.classes.measurement
Station = Base.classes.station

# Create our session (link) from Python to the DB

session = Session(engine)

#################################################
# Flask Setup
#################################################

app = Flask(__name__)

#################################################
# Flask Routes
#################################################

@app.route("/")

def welcome():

    """
    List all available api routes

    """

    return (

        f"Available Routes:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"/api/v1.0/stations<br/>"
        f"/api/v1.0/tobs<br/>"
        f"/api/v1.0/<start><br/>"
        f"/api/v1.0/<start>/<end><br/>"

    )

@app.route("/api/v1.0/precipitation")

def precipitation():

    """
    Return a jsonified dictionary of all
    prcp observations for the past year

    """

    results = session.query(Measurement.date, Measurement.prcp)\
                     .filter(Measurement.date > '2016-08-23')\
                     .all()

    precipitation = []

    for date, prcp in results:

        date_and_prcp_dict = {}
        date_and_prcp_dict["date"] = date
        date_and_prcp_dict["prcp"] = prcp
        precipitation.append(date_and_prcp_dict)

    return jsonify(precipitation)

@app.route("/api/v1.0/stations")

def stations():

    """
    Return a jsonified dictionary of all stations and names

    """

    results = session.query(Station.station, Station.name)\
                     .all()

    stations = []

    for station, name in results:

        station_and_name_dict = {}
        station_and_name_dict["station"] = station
        station_and_name_dict["name"] = name
        stations.append(station_and_name_dict)

    return jsonify(stations)

@app.route("/api/v1.0/tobs")

def tobs():

    """
    Return a jsonified dictionary of all
    temp observations for the past year

    """

    results = session.query(Measurement.date, Measurement.tobs)\
                     .filter(Measurement.date > '2016-08-23')\
                     .all()

    temperature = []

    for date, tobs in results:

        date_and_tobs_dict = {}
        date_and_tobs_dict["date"] = date
        date_and_tobs_dict["tobs"] = tobs
        temperature.append(date_and_tobs_dict)

    return jsonify(temperature)

@app.route("/api/v1.0/<start>")

def start(start = None):

    """
    Return a jsonified dictionary of min, max, and avg
    temp observations for a given date

    """

    start_date = dt.datetime.strptime(start, '%Y-%m-%d')

    results = session.query(func.min(Measurement.tobs),
                            func.avg(Measurement.tobs),
                            func.max(Measurement.tobs))\
                     .filter(Measurement.date >= start_date)\
                     .all()

    stats = list(np.ravel(results))

    return jsonify(stats)

@app.route("/api/v1.0/<start>/<end>")

def start_end(start = None,
              end = None):

    """
    Return a jsonified dictionary of min, max, and avg
    temp observations for a given date range

    """

    start_date = dt.datetime.strptime(start, '%Y-%m-%d')
    end_date = dt.datetime.strptime(end, '%Y-%m-%d')

    results = session.query(func.min(Measurement.tobs),
                            func.avg(Measurement.tobs),
                            func.max(Measurement.tobs))\
                     .filter(Measurement.date >= start_date)\
                     .filter(Measurement.date <= end_date)\
                     .all()

    stats = list(np.ravel(results))

    return jsonify(stats)

if __name__ == '__main__':

    app.run(debug=True)
