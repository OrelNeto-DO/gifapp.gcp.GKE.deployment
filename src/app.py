from flask import Flask, render_template, Response
from sqlalchemy import create_engine, text
import os
import random
from dotenv import load_dotenv
from prometheus_flask_exporter import PrometheusMetrics
from prometheus_client import Counter, Gauge, generate_latest, CONTENT_TYPE_LATEST

# Load environment variables from the .env file
load_dotenv()

app = Flask(__name__)
metrics = PrometheusMetrics(app)

# Define Prometheus metrics
VISITORS_TOTAL = Counter('gif_app_visitors_total', 'Total number of visitors')
CURRENT_VISITORS = Gauge('gif_app_current_visitors', 'Current visitor count from database')

# Read environment variables
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST", "mysql")
DB_PORT = os.getenv("DB_PORT", "3306")
DB_NAME = os.getenv("DB_NAME", "mydatabase")

# MySQL connection string
DB_URL = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine = create_engine(DB_URL)

@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

@app.route("/")
def index():
    with engine.connect() as connection:
        # Retrieve all image URLs from the database
        result = connection.execute(text("SELECT image_url FROM images"))
        images = [row["image_url"] for row in result]

        # Select a random image from the list
        url = random.choice(images)

        # Update the visitor count in the database
        connection.execute(text("UPDATE visit_count SET count = count + 1"))

        # Retrieve the updated visitor count
        result = connection.execute(text("SELECT count FROM visit_count"))
        visitor_count = result.fetchone()["count"]
        
        # Update Prometheus metrics
        VISITORS_TOTAL.inc()
        CURRENT_VISITORS.set(visitor_count)

    return render_template("index.html", url=url, visitor_count=visitor_count)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))