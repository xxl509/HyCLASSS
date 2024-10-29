function [getfiles,len_getfile] = getcell(pname,postfix)

%GETCELL get all the *.txt files.
%   [getfiles,len_getfile]=getcell(pname) returns the *.txt files of all the subfiles
%      and the number of the files.
%     subtxt:ÿ���ļ����µ�txt�ļ���Ŀ����һ����
%   Notice: only support two levels of subfolders.
%   You can get all the files names from the folder using
%      getfiles=getcell(pname)
%   for example:
%      [cell_files,len_files] = getcell(pname); %�õ����е��ļ�����·��
%      for i = 1:len_files
%      y = load(cell_files{i}); %�õ��ı��ļ�������ת��Ϊ����y
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

directory = dir(pname); %directory���Žṹ�壬[��ǰĿ¼���ϼ�Ŀ¼����Ŀ¼] (��Ŀ¼�ж��ٸ����ж��ٸ��ṹ��)
i=1; %�����һ��Ŀ¼�µ�txt�ļ�����
folders_num=length(directory)-2; %���ļ�����Ŀ

if folders_num == 0
    return;
end

for p = 1:folders_num
    if directory(p+2).isdir==1 %�Ƿ���������ļ���
        disp('ERROR.. This folder should not have a subfolder.');
    else     %�������ļ��У�ֻ���ļ�
        [path1, fname1, extension1] = fileparts(directory(p + 2).name);
        if strcmp(extension1,lower(postfix)) || strcmp(extension1,upper(postfix) )  %�ж��ļ��ĸ�ʽ������TXT,�����Ե�����
            getfiles{i} = fullfile(pname,directory(p + 2).name);
            i=i+1;
        end
        
        
    end
end

len_getfile = length(getfiles);









