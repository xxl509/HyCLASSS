function [getfiles,len_getfile] = getcell(pname,postfix)

%GETCELL get all the *.txt files.
%   [getfiles,len_getfile]=getcell(pname) returns the *.txt files of all the subfiles
%      and the number of the files.
%     subtxt:每个文件夹下的txt文件数目，是一向量
%   Notice: only support two levels of subfolders.
%   You can get all the files names from the folder using
%      getfiles=getcell(pname)
%   for example:
%      [cell_files,len_files] = getcell(pname); %得到所有的文件绝对路径
%      for i = 1:len_files
%      y = load(cell_files{i}); %得到文本文件的内容转换为数组y
%
%      ......
%
%      end
%
%   Copyright UAIS, Yanbing Qi.
%   $Revision: 1.0 $ $Date: 2010/12/07 22:09:00 $


%check the file name
if ~ischar(pname)
    error('MATLAB:the input is not char!');
end

directory = dir(pname); %directory里存放结构体，[当前目录，上级目录，子目录] (子目录有多少个就有多少个结构体)
i=1; %计算第一层目录下的txt文件个数
folders_num=length(directory)-2; %子文件夹数目

if folders_num == 0
    return;
end

for p = 1:folders_num
    if directory(p+2).isdir==1 %是否存在子子文件夹
        disp('ERROR.. This folder should not have a subfolder.');
    else     %不存在文件夹，只有文件
        [path1, fname1, extension1] = fileparts(directory(p + 2).name);
        if strcmp(extension1,lower(postfix)) || strcmp(extension1,upper(postfix) )  %判断文件的格式必须是TXT,才是脑电数据
            getfiles{i} = fullfile(pname,directory(p + 2).name);
            i=i+1;
        end
        
        
    end
end

len_getfile = length(getfiles);









