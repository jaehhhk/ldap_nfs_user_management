#!/bin/bashi

member_path=~/Desktop/ldap/ldap_nfs_user_management/user_list

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
			
			##  modify ldap file for new user ##
        		# create unique uid for new user (max_uid + 1)
        		max_uid=$(awk -F: '{ if ($3 > max) max = $3 } END { print max }' /etc/passwd)
        		new_uid=$((max_uid + 1))

        		sed -i "s/user_name/$name/g" $member_path/$name.ldif
        		sed -i "s/user_id/$new_uid/g" $member_path/$name.ldif

        		echo "## $name의 UID는 $new_uid, GID는 1500 입니다. ##"

        		## create new ldap account ##
			echo "## LDAP 관리자(admin) 비밀번호를 입력하세요 ##"
        		ldapadd -x -D "cn=admin,dc=biglab" -W -f $member_path/$name.ldif
        		
			if [ $? -ne 0 ]; then
                		echo "## 오류. 처음으로 돌아갑니다 ##"
				rm $member_path/$name.ldif
				continue
        		fi
			
			## create password ##
			max_attempt=3
			current_attempt=1
			while [ $current_attempt -le $max_attempt ]; do
				echo "$name에 대한 비밀번호를 입력하세요: "
				read -s new_password
				echo "재입력 "
				read -s retype_password
			
				if [ "$new_password" == "$retype_password" ]; then
					ldappasswd -H ldapi:/// -x -D "cn=admin,dc=biglab" -W -S uid=$name,ou=People,dc=biglab -s $new_password
					echo "비밀번호 설정 성공!"
					echo " "
					echo "## 생성된 $name 정보 ##"
					slapcat | tail -n 22
					break

					# 비밀번호 형식 오류난 경우
					if [ $? -ne 0 ]; then
                                		echo "## 올바르지 않은 암호 형식입니다.  ##"
                                		continue
                        		fi

				else
					echo "## 비밀번호가 일치하지 않습니다. ##"
					current_attempt=$((current_attempt+1))
				fi
			done

			if [ $current_attempt -gt $max_attempt ]; then
				echo "## 최대 시도 횟수를 초과했습니다. ##"
				echo "## 계정 생성을  다시 시도하기 위해 $name 계정을 삭제합니다. ##"
				echo "## Ldap 관리자 비밀번호를 입력하세요 ##"
				rm $member_path/$name.ldif
				ldapdelete -x -D "cn=admin,dc=biglab" -W "uid=$name,ou=People,dc=biglab"

				if [ $? -ne 0 ]; then
               				echo "비밀번호가 맞지 않습니다."
					echo "계정 수동삭제 해야합니다. readme 파일을 참고하세요"
        			fi

			fi

			break
		fi
	done

}
