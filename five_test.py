from flask import Flask, request, jsonify
import os
import cv2

import numpy as np                    # Importing numpy library 
import matplotlib.pyplot as plt       # Importing matplotlib library to plot the images directly in notebook
from skimage.metrics import structural_similarity as ssim   # Importing ssim calculating modules from skimage library

# Importing tkinter library to build GUI
from tkinter import *
from tkinter.ttk import Progressbar

import time


app = Flask(__name__)
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.route('/upload', methods=['POST'])
def upload_image():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'})

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'})

    if file:
        print(type(file))
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        file.save(file_path)
        image= cv2.imread(file_path)
        cv2.imshow('Image',image)
        cv2.waitKey(0)

        cv2.destroyAllWindows()
        # cv2.destroyAllWindows()
        return jsonify({'message': 'File uploaded successfully', 'file_path': file_path})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4000, debug=True)