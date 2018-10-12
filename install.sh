#########################################################################
# File Name: install.sh
# Author: 
# mail: 
# Created Time: 2016年10月07日 星期五 11时22分50秒
#########################################################################
#!/bin/bash

history_path=${HOME}/hcd
history_file=$history_path/history
install_path=${HOME}/bin
bash_file=${HOME}/.bashrc

if [ $# -eq 0 ]
then
	if [ -w $install_path/hcd ]
	then
		echo "You have install the software already"
		exit 1
	fi

	if [ ! -d ${install_path} ];then
		mkdir -p ${install_path}
	fi

	if [ ! -d ${history_path} ];then
		mkdir -p ${history_path}
	fi

	if [ $? -eq 0 ]
	then
		touch $history_file
		if [ $? -eq 0 ]
		then
			cp -f hcd.sh $install_path/hcd
			if [ $? -eq 0 ]
			then
				chmod 0666 $history_file
				chmod 0777 $install_path/hcd
				chmod 0777 $history_path
				echo "alias hcd='source ${install_path}/hcd'" >> ${bash_file}
				source ${bash_file}
				echo "Hcd written by hxe in santachi!"
				echo "Hcd has been installed successfully!"
				echo "Thanks for using!"
			else
				echo "Install failed"
			fi
		else
			echo "Install failed"
		fi
	else
		echo "Install failed"
	fi
else
	if [ "$1" = "-u" ]
	then
		sed -i "/alias hcd='source/d" ${bash_file}
		source ${bash_file}
		rm -rf $history_path
		rm -f $install_path/hcd
	fi
fi
