#!/bin/bash

path=~/Desktop/ldap/ldap_nfs_user_management

source $path/sources/add_user.sh
source $path/sources/delete_user.sh
source $path/sources/change_passwd.sh

while true;
do

	echo "##### Welcome To LDAP User Management Main Page #####"
	echo " "
	echo " 1. 계정 생성하기 "
	echo " 2. 계정 삭제하기 "
	echo " 3. 계정 비밀번호 변경하기 "
	echo " "
	echo "#####################################################"

	echo " "
	echo "사용할 기능을 번호로 입력하세요: "
	read digit

	if [ $digit == 1 ]; then
		add_user
	elif [ $digit == 2 ]; then
		minimum_delete
	elif [ $digit == 3 ]; then
		change_passwd
	else
		continue
	fi


done
