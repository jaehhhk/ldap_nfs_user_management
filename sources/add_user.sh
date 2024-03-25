#!/bin/bash

member_path=~/Desktop/ldap/user_list

add_user(){

	while true;
	do
		echo "아이디를 입력하세요: "
		read name

		if [ -e $member_path/$name.ldif ]; then
			echo "이미 존재하는 아이디입니다!"
			continue
		else
			cp $member_path/form.ldif $member_path/$name.ldif
			break
		fi
	done
	
	
	##  modify ldap file for new user ##
	# create unique uid for new user (max_uid + 1)
	max_uid=$(awk -F: '{ if ($3 > max) max = $3 } END { print max }' /etc/passwd)
	new_uid=$((max_uid + 1))

	sed -i "s/user_name/$name/g" $member_path/$name.ldif
	sed -i "s/user_id/$new_uid/g" $member_path/$name.ldif

	echo "$name의 UID는 $new_uid 입니다." 

}
