LuaS �

xV           (w@@userdb_logic.lua         B    @ A@  $� F @ ��  d� � @ ��  �@ � @ �  �� � @ A � @ A� $� F�A G���A �AB��A ǁ��A �BF�A G��@ �B �� �@ � � �A �CF�A G���A �CD��A ǃ�@ A� $� F�A G��  ʁ���D  ʁ���  ʁ����  ʁ�� ʁ���D ʁ��� ʁ���� ʁ�� ʁ��& �    requireskynetosskynet.manager	cc_redisclustercallclustersend_Gservice_name
user_listlogicconfinfocc_log	sprint_rauth_entries	tostring	tonumber
gps_statelogin_typespxget_extra_fieldscopy_extra_fieldsformat_user	add_userget_user_infoget_login_infocreate_user_dbwrite_userwrite_user_field    	       !       F   b@  ��� � �@     A�  �@ �   �  ��� �  & �    errorlogic.get_extra_fields(),entryis not foundlogin_fields   
                                             !      _login_type       entry         auth_entrieslog #   /    
   � @ �@@ �� �   �   @��� @ $� ��  �     �J� )�  �A�& �    get_extra_fieldslogin_typepairs            %   %   %   &   '   '   (   (   (   (   )   *   *   +   (   (   /   	   src       dst       fields      value      (for generator)	      (for state)	      (for control)	      _
      field
         logic_ENV 2   7       E   � @ d� 
@ �E   �@@ d� 
@��E   ��@ d� 
@ �E   ��@ d� 
@��& �    user_idmoney
room_cardlogin_type          3   3   3   3   4   4   4   4   5   5   5   5   6   6   6   6   7      user          	tonumber 9   g    B   G @ �@  �    ��@�    @ �@��  ��   � � � �@���  $� "A  ��F��A �� � dA D  f �@  �     ��  K  � �F�A�  d  ��@i�  ���@B���B���B�F���@������B�����D�G@��F��A �� dA�F��b  ��F��� �   � ��dA �  & �    user_idcopy_extra_fieldsuser:hmseterrorwriter user_idto redis failpairsipaddr0.0.0.0gps_x        gps_y
gps_statenonegate_servicefdhall_serviceupdated info$userdb.logic.add_user(),new user_id	is_debugdebug
   
      B   :   =   >   >   ?   ?   ?   ?   @   D   D   D   E   E   E   E   E   F   F   G   G   G   G   G   H   H   L   M   M   N   Q   Q   R   R   R   R   S   R   R   U   V   W   X   X   Z   [   ]   ^   _   _   a   a   a   a   b   b   b   c   c   c   c   c   c   c   f   g   
   
user_info    B   user_id   B   user   B   key   B   ok   B   (for generator)#   '   (for state)#   '   (for control)#   '   k$   %   v$   %      
user_listlogicredislog_ENV
gps_state	sprint_r i   �    	.   K� � @ J� ��@@ J�����@ J� ���@ J���� A J� ��@A J�����A J� ���A J���� B J� ��@B J�����B J� ���B J���� C J� ��@C J�����C J� ���C � @ �� �   ��� �   � @ �ǁ J��@  j��f  & �    login_typeuser_id
user_namemoney	head_img
room_cardlogin_timelogout_timehall_serviceipaddrgps_xgps_y
gps_stategate_servicefdget_extra_fieldspairs         .   j   k   k   l   l   m   m   n   n   o   o   p   p   q   q   r   r   s   s   t   t   u   u   v   v   w   w   x   x   y   y   }   }   }   ~   ~               �   �         �   �      user    .   t   .   fields"   .   (for generator)'   ,   (for state)'   ,   (for control)'   ,   field(   *      logic_ENV �   �       K�  � @ J� ��@@ J�����@ �    � �@���� �   ��� � �@  @� $� � ��@ f  & �    login_typeuser_idcopy_extra_fields	is_debugdebugogic.get_login_info(),t
   
       �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �      user       t         logiclog	sprint_r �   �    i   F @ �@  � �    � �� d@ F�@��@ d� _ � ��C   �@ � ��A� �� f �D � � � �A@  $@��    �@ �A ��� �� � ����   ��@� �B ��]��@ �� ��  �  � �)�  ���� @� � � B F�C �� � dA�FD�A �� � @ d��bA  ���E �A   A �A �  �� ������  @��E � � @�$� ���A �  �A ������A  @��E � �A �   ���@ B @ �A���   ��& �    info+logic.create_user_db.create_user(),fields
typelogin_typenumber非法的账号类型_login_typepairs',,'insert user_info () values ()debug"logic.create_user_db(),uery sql :callmysqldluaqueryerror*logic.create_user_db(),query failed,s = '查询数据库失败
badresultlogic.create_user_db()
创建用户数据失败
insert_id*logic.create_user_db(),user already exist帐号已经存在"logic.create_user_db() ok,user_id   
       i   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �      fields    i   names   i   values   i   first   i   (for generator)   1   (for state)   1   (for control)   1   name   /   value   /   s7   i   rsA   i   user_idY   i      log	sprint_r_ENV	tostringskynet �   �    	V   "@   �F @ �@  d@ C   f  G�@ ��� � � �� _ A���@A �� �� @� $ �@  �   �  ��A �   ���@A �   � �@��@A �@  @  $� � ��@ ��B �@  @ �� � �  �� � � �� � �� �@ � �AC ����ǁC �����C �����D ���� �@  ��@ AA �� ��   $A�  & ��D� � $� �  �@  ��@ AA �� �A   $A�  & 
�E�� & & �    errorlogic.write_user(),user is niluser_idtypenumberdebug%userdb.write_user(),type(user_id) is	is_debuguserdb.write_user(),user_id
updateduser:hmsetmoney
room_cardlogin_timelogout_timelogic.write_user(),user_idcall redis:hmset() keysaddchanged_users!call redis:hset() changed_users     
      V   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �      user    V   user_id   V   key+   V   ok8   V      log_ENV	sprint_rredis �      N   "@  � �� @ �@  �@ & � ��@ ���   � _ ���� @ A F�� � d �@  & � ƀA �   @���A  AA �� � �@��@  ����@ A� � �A  � A $A & � A @ AE L���  � @�d��bA   ��@ ��   AB �� ��   �A�& � � �DB @ �� @ bA   ��@ ��   AB �� ��   �A�& � & � & �    error%logic.write_user_field(),user is niluser_idtypenumber+userdb.write_user_field(),type(user_id) is	is_debugdebug"userdb.write_user_field(),user_idfield !logic.write_user_field(),user_idis niluser:hsetcall redis:hmset() keysaddchanged_users!call redis:hset() changed_users    
      N   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �                                              
  
  
  
  
  
                               user    N   field    N   user_id   N   value   N   key*   N   ok0   N      log_ENVredisB                                                         	   	   
   
                                                                              !      /   #   7   2   g   9   �   i   �   �   �   �   �   �     �        skynet   B   os   B   redis   B   clustercall   B   clustersend   B   service_name   B   
user_list   B   logic   B   conf   B   info   B   log   B   	sprint_r"   B   auth_entries$   B   	tostring&   B   	tonumber(   B   
gps_state*   B   login_type-   B   spx/   B      _ENV