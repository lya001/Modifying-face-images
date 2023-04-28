from PyQt6.QtWidgets import *
from PyQt6.QtGui import *

import subprocess

class Window(QWidget):
    def __init__(self):
        super().__init__()

        # title
        self.setWindowTitle('Modifying Face Images')

        # window size
        self.resize(800, 500)

        # layouts
        self.main_layout = QHBoxLayout()
        self.image_layout = QGridLayout()
        self.main_layout.addLayout(self.image_layout)
        self.buttons_layout = QVBoxLayout()
        self.main_layout.addLayout(self.buttons_layout)

        # image selection button and preview
        self.file_name = None
        self.image_button = QPushButton('Select Image')
        self.image_button.pressed.connect(self.get_file)
        self.image_layout.addWidget(self.image_button)
        
        self.image_label = QLabel()
        self.image_layout.addWidget(self.image_label)

        # feature buttons
        self.restore_button = QPushButton('Restore face detail')
        self.restore_button.pressed.connect(self.restore)
        self.buttons_layout.addWidget(self.restore_button)

        self.rotate_button = QPushButton('Rotate to front')
        self.rotate_button.pressed.connect(self.rotate)
        self.buttons_layout.addWidget(self.rotate_button)

        self.neutral_button = QPushButton('Neutral Expression')
        self.neutral_button.pressed.connect(self.neutral)
        self.buttons_layout.addWidget(self.neutral_button)

        # display
        self.setLayout(self.main_layout)
        self.show()

    def get_file(self):
        file_name, _ = QFileDialog.getOpenFileName(self, self.tr('Open Image'), '/.', self.tr('Image Files (*.png *.jpg *.bmp)'))
        if file_name is not None and file_name != '':
            self.file_name = file_name
            self.image_label.setPixmap(QPixmap(self.file_name))        

    def restore(self):
        subprocess.run(['sh', 'restore.sh', self.file_name])
        self.file_name = 'result.png'
        self.image_label.setPixmap(QPixmap(self.file_name))   

    def rotate(self):
        # TODO
        return

    def neutral(self):
        # TODO
        return

if __name__ == '__main__':
    app = QApplication([])
    window = Window()
    app.exec()
