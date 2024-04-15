#!/bin/bash

path=~/Desktop/ldap/ldap_nfs_user_management
member_path=$path/user_list



change_passwd(){

        while true;
        do
                # show current LDAP user list
                echo "##### 현재 Ldap 계정 목록 #####"
                ls $member_path | tail -n +2 | sed 's/\.[^.]*$//'
                echo "###############################"

                # input user name wana delete
                echo "비밀번호를 변경할 계정명을 입력하세요: "
                read change_name

                if ls "$member_path" | tail -n +2 | sed 's/\.[^.]*$//' | grep -q -x "$change_name"; then
                        echo "정말로 $change_name 계정의 비밀번호 변경하시겠습니까? [y/n] "
                        read yn
			if [ $yn == "y" ]; then
				ldappasswd -H ldapi:/// -x -D "cn=admin,dc=biglab" -W -S uid=$change_name,ou=People,dc=biglab
			fi

		else
                        echo "$change_name이란 계정은 존재하지 않습니다."
                        continue
                fi
	done
}
