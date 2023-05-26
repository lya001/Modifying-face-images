from PyQt6.QtWidgets import *
from PyQt6.QtCore import *
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
        self.setFixedSize(1000, 800)

        # layouts
        self.main_layout = QHBoxLayout()
        
        self.image_layout = QVBoxLayout()
        self.image_buttons_layout = QHBoxLayout()
        self.image_layout.addLayout(self.image_buttons_layout)
        self.image_preview_layout = QHBoxLayout()
        self.image_original_layout = QVBoxLayout()
        self.image_preview_layout.addLayout(self.image_original_layout)
        self.image_current_layout = QVBoxLayout()
        self.image_preview_layout.addLayout(self.image_current_layout)
        self.image_layout.addLayout(self.image_preview_layout)
        self.main_layout.addLayout(self.image_layout, 5)
        
        self.features_layout = QVBoxLayout()
        self.main_layout.addLayout(self.features_layout, 1)

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
        self.undo_button.setIcon(QIcon('./app/resources/undo.svg')) # flaticon.com
        self.undo_button.pressed.connect(self.undo)
        self.undo_button.setEnabled(False)
        self.image_buttons_layout.addWidget(self.undo_button)

        self.redo_button = QPushButton('')
        self.redo_button.setIcon(QIcon('./app/resources/redo.svg')) # flaticon.com
        self.redo_button.pressed.connect(self.redo)
        self.redo_button.setEnabled(False)
        self.image_buttons_layout.addWidget(self.redo_button)
        
        # image preview
        QImageReader.setAllocationLimit(0)
        
        self.image_original_label = QLabel()
        self.image_original_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.image_original_layout.addWidget(self.image_original_label, 10)
        original_text = QLabel('Original')
        original_text.setAlignment(Qt.AlignmentFlag.AlignHCenter | Qt.AlignmentFlag.AlignTop)
        self.image_original_layout.addWidget(original_text, 1)
        
        self.image_current_label = QLabel()
        self.image_current_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.image_current_layout.addWidget(self.image_current_label, 10)
        current_text = QLabel('Current')
        current_text.setAlignment(Qt.AlignmentFlag.AlignHCenter | Qt.AlignmentFlag.AlignTop)
        self.image_current_layout.addWidget(current_text, 1)

        # feature buttons
        self.colorize_button = QPushButton('Colorize')
        self.colorize_button.pressed.connect(self.colorize)
        self.colorize_button.setEnabled(False)
        self.features_layout.addWidget(self.colorize_button)

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

        # process for performing inference
        self.process = None

        # create folder for intermediate results
        path = './app/results'
        if os.path.exists(path):
            files = glob.glob(path + '/*')
            for f in files:
                os.remove(f)
        else:
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
            self.image_original_label.setPixmap(QPixmap(file_name).scaled(self.image_original_label.width(), self.image_original_label.height(), Qt.AspectRatioMode.KeepAspectRatio))
            self.image_current_label.setPixmap(QPixmap(file_name).scaled(self.image_current_label.width(), self.image_current_label.height(), Qt.AspectRatioMode.KeepAspectRatio))

            # set button availabilities
            self.save_button.setEnabled(True)
            self.undo_button.setEnabled(False)
            self.redo_button.setEnabled(False)
            self.colorize_button.setEnabled(True)
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
        self.image_current_label.setPixmap(QPixmap(self.file_names[self.current_index]).scaled(self.image_current_label.width(), self.image_current_label.height(), Qt.AspectRatioMode.KeepAspectRatio))

        # adjust button availabilities
        self.undo_button.setEnabled(self.current_index > 0)
        self.redo_button.setEnabled(True)

    def redo(self):
        self.current_index += 1
        self.image_current_label.setPixmap(QPixmap(self.file_names[self.current_index]).scaled(self.image_current_label.width(), self.image_current_label.height(), Qt.AspectRatioMode.KeepAspectRatio))

        # adjust button availabilities
        self.undo_button.setEnabled(True)
        self.redo_button.setEnabled(self.current_index < len(self.file_names) - 1)

    def colorize(self):
        # pause and display loading screen
        self.disable_all_buttons()
        movie = QMovie('./app/resources/icons8-sand-timer.gif') # icons8.com
        self.image_current_label.setMovie(movie)
        movie.start()

        # perform inference
        self.p = QProcess()
        self.p.finished.connect(self.end_loading_screen)
        self.p.start('sh', ['./app/features/colorize.sh', self.file_names[self.current_index], str(self.current_index + 1) + '.png'])

    def restore(self):
        # pause and display loading screen
        self.disable_all_buttons()
        movie = QMovie('./app/resources/icons8-sand-timer.gif') # icons8.com
        self.image_current_label.setMovie(movie)
        movie.start()

        # perform inference
        self.p = QProcess()
        self.p.finished.connect(self.end_loading_screen)
        self.p.start('sh', ['./app/features/restore.sh', self.file_names[self.current_index], str(self.current_index + 1) + '.png'])
        
    def rotate(self):
        # pause and display loading screen
        self.disable_all_buttons()
        movie = QMovie('./app/resources/icons8-sand-timer.gif') # icons8.com
        self.image_current_label.setMovie(movie)
        movie.start()

        # perform inference
        self.p = QProcess()
        self.p.finished.connect(self.end_loading_screen)
        self.p.start('sh', ['./app/features/rotate.sh', self.file_names[self.current_index], str(self.current_index + 1) + '.png'])

    def neutral(self):
        # pause and display loading screen
        self.disable_all_buttons()
        movie = QMovie('./app/resources/icons8-sand-timer.gif') # icons8.com
        self.image_current_label.setMovie(movie)
        movie.start()

        # perform inference
        self.p = QProcess()
        self.p.finished.connect(self.end_loading_screen)
        self.p.start('sh', ['./app/features/neutral.sh', self.file_names[self.current_index], str(self.current_index + 1) + '.png'])

    def disable_all_buttons(self):
        self.select_button.setEnabled(False)
        self.save_button.setEnabled(False)
        self.undo_button.setEnabled(False)
        self.redo_button.setEnabled(False)
        self.colorize_button.setEnabled(False)
        self.restore_button.setEnabled(False)
        self.rotate_button.setEnabled(False)
        self.neutral_button.setEnabled(False)

    def end_loading_screen(self):
        self.current_index += 1
        self.file_names = self.file_names[:self.current_index]
        self.file_names.append('./app/results/' + str(self.current_index) + '.png')
        self.image_current_label.setPixmap(QPixmap(self.file_names[self.current_index]).scaled(self.image_current_label.width(), self.image_current_label.height(), Qt.AspectRatioMode.KeepAspectRatio))

        # adjust button availabilities
        self.select_button.setEnabled(True)
        self.save_button.setEnabled(True)
        self.undo_button.setEnabled(True)
        self.colorize_button.setEnabled(True)
        self.restore_button.setEnabled(True)
        self.rotate_button.setEnabled(True)
        self.neutral_button.setEnabled(True)

    # override closeEvent() to clear intermediate results
    def closeEvent(self, event):
        shutil.rmtree('./app/results')

if __name__ == '__main__':
    app = QApplication([])
    window = Window()
    app.exec()
