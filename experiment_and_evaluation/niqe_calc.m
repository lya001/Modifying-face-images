directory = uigetdir;
files = dir(fullfile(directory, '*.png'));
total = 0;
for k = 1:length(files)
  file = files(k).name;
  fileFullName = fullfile(directory, file);
  image = imread(fileFullName);
  total = total + niqe(image);
end
out = ['Dataset: ', directory];
disp(out);
out = ['NIQE score = ', num2str(total / length(files))];
disp(out);