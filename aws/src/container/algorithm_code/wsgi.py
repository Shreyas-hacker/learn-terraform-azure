import predictor as myapp

#Simple wrapper for gunicorn to find app. If want to change algorithm file, change the 'predictor' to new file
app = myapp.app