#########################################################################
# File Name: hcd.sh
# Author:
# mail: 
# Created Time: 2016年10月07日 星期五 11时34分21秒
#########################################################################
#!/bin/bash

history_file=${HOME}/hcd/history

max_num="*0"

if [ $# = 0 ]	
then
	if [ ! -s $history_file ]
	then
		echo "hcd : No path to enter"
	else
		for x in  `cat $history_file | awk '{print $3}' `
		do
			if [ ${x#*\*} -gt ${max_num#*\*} ]
			then
				max_num=$x
			fi
		done
		
		enter_line=`cat $history_file | grep "$max_num$" | awk '{print $2}'`
		enter_path=`echo $enter_line | sed "s#%#/#g" `
		echo $enter_path
		cd $enter_path
	fi
fi


#***************************************************************************#

empty_flag=""
del_flag=""
if [ $# = 2 ]
then
	if [ "$1" = "-s" ]
	then
		if [ -d $2 ]
		then
			if [ "$2" = "." ]
			then
				temp=`pwd`
				temp=`echo $temp | sed 's#/#%#g' `
			else
				if [ ${2:0:1} = "/" ]
				then
					temp=`echo $2 | sed 's#/#-#g'`
				else
					temp1="`pwd`/$2"
					temp=`echo $temp1 | sed 's#/#%#g'`
				fi

				if [ ${temp: -1} = "-" ]
				then
					len=`expr ${#temp} - 1`
					temp=${temp:0:$len}
				fi
			fi

			if [ ! -s $history_file ]
			then
				echo "1 $temp *0"  >> $history_file
			else
				for x in `cat $history_file | awk '{print $2}'`
				do
					if [ $x = $temp ]
					then 
						echo "hcd : $2 has been already stored "
						empty_flag=1;
						break
					fi
				done

				if [ ! $empty_flag ]
				then
					all_num=`sed -n '$=' $history_file`	
					last_num=`expr $all_num + 1`
					echo "$last_num $temp *0" >> $history_file
				fi

			fi
		else
			echo "$2 is not a directory"
		fi
	elif [ "$1" = "-d" ]
	then
		for x in `cat $history_file | awk '{print $1}'`
		do
			if [ $x = $2 ]
			then
				del_flag="1";
				eval sed -i '/^$2/d' $history_file
				continue 
			fi

			if [ $del_flag ]
			then
				new_num=`expr $x - 1 `
				echo $new_num
				eval sed -i '/^$x/s/$x/$new_num/' $history_file
			fi
		done

		if [  $del_flag ]
		then
			echo hcd : delete success!
		else
			echo hcd : No directory match to $2! delete fail!
		fi
	fi
fi		

#***************************************************************************#
if [ $# = 1 ]
then
	if [ -d $1 ]
	then
		temp=`echo $1 | sed 's#/#%#g'`
		find_num=`cat $history_file | sed -n "/$temp/p" | awk '{print $3}'`  
		if [ -n "$find_num" ]
		then
			add_num=${find_num#*\*}

			let add_num++
			add_num="*"$add_num
			eval sed -i  '/$temp/s/$find_num/$add_num/'  $history_file
		fi
	cd $1
	#***********************************************************************#
	elif [ "$1" = "-l" ]
	then
			sed  's#%#/#g' $history_file	
	elif [ -n "$(echo $1| sed -n "/^[0-9]\+$/p")" ] 
	then
				enter_path="`cat $history_file | grep "^$1" | awk '{print $2}'`"
				if [ -n "$enter_path" ]
				then
					find_num="`cat $history_file | grep "^$1" | awk '{print $3}'`"
					add_num=${find_num#*\*}
					let add_num++
					add_num="*"$add_num
					eval sed -i  '/^$1/s/$find_num/$add_num/'  $history_file
					enter_path="`echo $enter_path | sed 's#%#/#g'`"
					echo ${enter_path}
					cd ${enter_path}
				else
					echo "No path match to number $1"
				fi
	elif [ "$1" = "-h" ]
	then
		echo "usage: hcd [command] <args>"
		echo "These are common hcd commands used in various situations:"
		echo "	-s		save path"
		echo "	-l		show path"
		echo "	-d		delete path"
		echo "	-h		show help"
	fi

fi
#***************************************************************************#

