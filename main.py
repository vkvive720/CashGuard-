from flask import Flask, request, jsonify
import test5
import test1
import test20
import os
import cv2

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
        # Printing the currency field
        currency = request.form.get('currency')
        print(type(currency),">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        print("Currency field received from Flutter:", currency)
        
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        file.save(file_path)

        image = cv2.imread(file_path)
        height, width = image.shape[:2]

        print("height ", height, "  width->", width)
        # cv2.imshow('Image', image)
        # cv2.waitKey(0)
        # cv2.destroyAllWindows()

        # if (height < 519 or width < 1167):
            # return jsonify({'result': "give proper resolution", 'message': 'File uploaded successfully', 'file_path': file_path})

        
        a, b = test5.verify_500(image)
        # a, b = test1.verify_100(image)
        # a, b = test20.verify_2000(image)

        print("list_of_a")
        print(a)
        print("printing b")
        # print(b)

        # cv2.destroyAllWindows()
        return jsonify({'result': a})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4000, debug=True)