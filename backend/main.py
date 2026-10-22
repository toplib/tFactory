from flask import Flask

app = Flask(__name__)


@app.route("/")
def collect():
    return {
        "error": True,
        "reason": "tFactory (web) is not implemented yet",
    }, 400
