#!/bin/bash

# exprot 행 삭제 -> exportfs 다시
# 서버, 클라이언트 유저 삭제 -> userdel -r 옵션 꼭!
# umount 해주기

path=~/Desktop/ldap/ldap_nfs_user_management
member_path=$path/user_list

delete_user(){
	while true;
	do
		# show current LDAP user list
		echo "##### 현재 Ldap 계정 목록 #####"
		ls $member_path | tail -n +2 | sed 's/\.[^.]*$//'
		echo "###############################"
		
		# input user name wana delete
		echo "삭제 할 계정명을 입력하세요: "
		read delete_name
		
		if ls $member_path | tail -n +2 | sed 's/\.[^.]*$//' | grep -q $delete_name; then
			echo "정말로 $delete_name 계정을 삭제 하시겠습니까? [y/n] "
			read -s yn
			
			if [ $yn == "y" ]; then
				# if delete_name exists
				while true;
				do
					# select client to connect
					echo "###### Client #####"
                                	echo " 1. Cluster1"
                                	echo " 2. Cluster2"
					echo " 3. Cluster3"
                                	echo "###################"
                                	echo " "
					echo "$delete_name를 삭제할 클라이언트를 고르세요(숫자만 입력): "
                                	read cluster_number

					if [ $cluster_number == 1 ]; then
						echo "Cluster1은 현재 요양 중입니다ㅜ"
						continue
					elif [ $cluster_number == 2]; then
						ssh -p 6304 root@cluster2 <<EOF
						umount -t /home/"$delete_name"
						userdel -r "$delete_name"
					
EOF
						# delete LDAP account
                                		ldapdelete -x -D "cn=admin,dc=biglab" -W "uid=$delete_name,ou=People,dc=biglab"
                                		echo "LDAP 관리자 비밀번호를 입력하세요"

                                		sleep 1
						
						# delete .ldif file & user account
                                		rm $member_path/$delete_name.ldif
                                		userdel -r $delete_name

                                		# initalize export's information without delete_user
                                		sed -i "/$delete_name/d" /etc/exports
                                		exportfs -ra

						break
					
					elif [ $cluster_number == 3 ]; then
						echo "Cluster1은 현재 요양 중입니다ㅜ"
						continue

					else continue
					
					fi	
				done
			



			else 
				continue
			fi


			break
		# if delete_name does not exists
		else 
			echo "$delete_name이란 계정은 존재하지 않습니다."
			continue
		fi

		#rm $member_path/$name.ldif
        	#ldapdelete -x -D "cn=admin,dc=biglab" -W "uid=$name,ou=People,dc=biglab"
	done
}
