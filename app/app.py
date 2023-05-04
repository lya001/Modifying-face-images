from PyQt6.QtWidgets import *
from PyQt6.QtGui import *

import subprocess
import shutil
import glob
import os

class Window(QWidget):
    def __init__(self):
        super().__init__()

        # title
        self.setWindowTitle('Modifying Face Images')

        # window size
        self.resize(800, 500)

        # layouts
        self.main_layout = QHBoxLayout()
        
        self.image_layout = QVBoxLayout()
        self.image_buttons_layout = QHBoxLayout()
        self.image_layout.addLayout(self.image_buttons_layout)
        self.image_preview_layout = QGridLayout()
        self.image_layout.addLayout(self.image_preview_layout)
        self.main_layout.addLayout(self.image_layout)
        
        self.features_layout = QVBoxLayout()
        self.main_layout.addLayout(self.features_layout)

        # image selection buttons
        self.file_names = []
        self.current_index = -1

        self.select_button = QPushButton('Select Image')
        self.select_button.pressed.connect(self.select_file)
        self.image_buttons_layout.addWidget(self.select_button)

        self.save_button = QPushButton('Save as')
        self.save_button.pressed.connect(self.save_file)
        self.save_button.setEnabled(False)
        self.image_buttons_layout.addWidget(self.save_button)

        self.undo_button = QPushButton('')
        self.undo_button.setIcon(QIcon('./app/icons/undo.svg')) # flaticon.com
        self.undo_button.pressed.connect(self.undo)
        self.undo_button.setEnabled(False)
        self.image_buttons_layout.addWidget(self.undo_button)

        self.redo_button = QPushButton('')
        self.redo_button.setIcon(QIcon('./app/icons/redo.svg')) # flaticon.com
        self.redo_button.pressed.connect(self.redo)
        self.redo_button.setEnabled(False)
        self.image_buttons_layout.addWidget(self.redo_button)
        
        # image preview
        self.image_label = QLabel()
        self.image_layout.addWidget(self.image_label)

        # feature buttons
        self.restore_button = QPushButton('Restore Face Detail')
        self.restore_button.pressed.connect(self.restore)
        self.restore_button.setEnabled(False)
        self.features_layout.addWidget(self.restore_button)

        self.rotate_button = QPushButton('Rotate to Front')
        self.rotate_button.pressed.connect(self.rotate)
        self.rotate_button.setEnabled(False)
        self.features_layout.addWidget(self.rotate_button)

        self.neutral_button = QPushButton('Neutral Expression')
        self.neutral_button.pressed.connect(self.neutral)
        self.neutral_button.setEnabled(False)
        self.features_layout.addWidget(self.neutral_button)

        # create folder for intermediate results
        os.mkdir('./app/results')

        # display
        self.setLayout(self.main_layout)
        self.show()

    def select_file(self):
        file_name, _ = QFileDialog.getOpenFileName(self, 'Open Image', './', self.tr('Image Files (*.png *.jpg *.jpeg *.bmp)'))
        
        # do nothing if cancelled file selection
        if file_name:

            # copy input image to results folder
            shutil.copyfile(file_name, './app/results/0.png')

            # display selected file
            self.file_names = ['./app/results/0.png']
            self.current_index = 0
            self.image_label.setPixmap(QPixmap(file_name))
            
            # set button availabilities
            self.save_button.setEnabled(True)
            self.undo_button.setEnabled(False)
            self.redo_button.setEnabled(False)
            self.restore_button.setEnabled(True)
            self.rotate_button.setEnabled(True)
            self.neutral_button.setEnabled(True)

    def save_file(self):
        file_name, _ = QFileDialog.getSaveFileName(self, 'Save File', './', 'All Files(*)')

        # do nothing if cancelled file saving
        if file_name:
            shutil.copy(self.file_names[self.current_index], file_name)

    def undo(self):
        self.current_index -= 1
        self.image_label.setPixmap(QPixmap(self.file_names[self.current_index]))

        # adjust button availabilities
        self.undo_button.setEnabled(self.current_index > 0)
        self.redo_button.setEnabled(True)

    def redo(self):
        self.current_index += 1
        self.image_label.setPixmap(QPixmap(self.file_names[self.current_index]))

        # adjust button availabilities
        self.undo_button.setEnabled(True)
        self.redo_button.setEnabled(self.current_index < len(self.file_names) - 1)

    def restore(self):
        new_file_name = str(self.current_index + 1) + '.png'
        subprocess.run(['sh', './app/features/restore.sh', self.file_names[self.current_index], new_file_name])
        self.current_index += 1
        self.file_names = self.file_names[:self.current_index]
        self.file_names.append('./app/results/' + new_file_name)
        self.image_label.setPixmap(QPixmap(self.file_names[self.current_index]))

        # adjust button availabilities
        self.undo_button.setEnabled(True)
        self.redo_button.setEnabled(False)

    def rotate(self):
        new_file_name = str(self.current_index + 1) + '.png'
        subprocess.run(['sh', './app/features/rotate.sh', self.file_names[self.current_index], new_file_name])
        self.current_index += 1
        self.file_names = self.file_names[:self.current_index]
        self.file_names.append('./app/results/' + new_file_name)
        self.image_label.setPixmap(QPixmap(self.file_names[self.current_index]))

        # adjust button availabilities
        self.undo_button.setEnabled(True)
        self.redo_button.setEnabled(False)

    def neutral(self):
        new_file_name = str(self.current_index + 1) + '.png'
        subprocess.run(['sh', './app/features/neutral.sh', self.file_names[self.current_index], new_file_name])
        self.current_index += 1
        self.file_names = self.file_names[:self.current_index]
        self.file_names.append('./app/results/' + new_file_name)
        self.image_label.setPixmap(QPixmap(self.file_names[self.current_index]))
        
        # adjust button availabilities
        self.undo_button.setEnabled(True)
        self.redo_button.setEnabled(False)

    # override closeEvent() to clear intermediate results
    def closeEvent(self, event):
        shutil.rmtree('./app/results')

if __name__ == '__main__':
    app = QApplication([])
    window = Window()
    app.exec()
