LuaS �

xV           (w@@writer_logic.lua         '    @ A@  $� F @ ��  d� � @ ��  �@ � @ �  �� � @ A � @ A� $� F�A G���A �AB��A ǁ��A �BF�A G��  
����B  
����  
�����  
��� 
���& �    requireskynet	cc_mysqlskynet.manager	cc_rediscc_log	sprint_r_G	tostringinfoconflogiccommand
connectdb	check_dbflush_userswrite_user_loopwrite_user                    @ "@  @�@� A�  $@ �@F �$�   �@� A@ $@  @ &  & �    dbinfoconnecting to dbconnectmysqlok                                                                 infologmysqlconf    )     	#    @ $�� F@� ��@ �   d��b@  ����@ GAA � �@ �   �  ǀA�   ����@ GAA �� ��  � ���@ �   �  � BA �@ � � �  & � 
   
connectdbpcallpingerrorlogic.check_db(),db.idid
badresultr:
debuglogic.check_db() ok         #                                                  "   "   "   #   #   #   #   #   #   #   #   #   $   $   '   '   '   (   (   )      db   #   ok   #   r   #      logic_ENVlog	sprint_r ,   :     #     �   � �AA  ���   � ��    �"   ���   ̀�@  ���@  � ��   ��b   @���� �   � �� �  � �@ �   � �AA  ���   � � �& �    spopchanged_usershgetalluser_idwrite_user       #   -   0   0   0   0   0   0   1   1   1   1   2   2   2   2   2   2   3   3   3   3   4   4   4   5   5   5   8   8   8   8   8   8   8   :      	user_key   #   
user_info   #   ok   #      redislogic =   L         @ A@  $@    F�� d�� b   ��F�� d��   � "@  � �F A �@ d@ @ �F�� d@� F�A� ��@B��Bd@ ��& �    infobegin logic.write_user_loop()	check_db
connectdberrorconnect mysql failflush_userssleep_Gconfflush_user_time             >   >   >   @   B   B   B   B   C   C   C   D   D   E   E   E   E   G   G   J   J   J   J   J   J   L      db         loglogicskynet_ENV O   x    W   G @ �@@ ��   � �@���� ��� �@  ���@@  @� �A �@ �   � � �� �  A� � �A � �@��B@�$ �G  �@�FBC �� � dB�C  f )�  ���CDAA ��A �B BB G�B �� $��L�D� d��bA  ���AC ��   A �A �  �A ������  @��AC �� �@�$� ���A �  �A ���� @F���AC ��  � A� �A �  � �� � & �    user_idinfologic.write_user()
connectdblogic.write_user(),user_id
db is nil帐号数据库已经关闭money
room_cardlogin_timelogout_timepairs errorlogic.write_user(),no fieldstringformat]update user_info set money=%s,room_card=%s,login_time='%s',logout_time='%s' where user_id=%squery&logic.write_user(),query failed,s = ''查询数据库失败
badresultlogic.write_user()
affected_rows       !logic.write_user(),write user_idto mysql failed         W   P   Q   Q   Q   Q   S   S   T   T   U   U   U   U   U   V   V   V   Z   [   \   ]   ^   `   `   a   a   a   a   b   b   b   c   c   c   c   d   d   a   a   h   h   h   i   i   i   i   i   h   j   j   j   k   k   l   l   l   l   l   m   m   m   o   o   o   p   p   p   p   p   p   p   q   q   q   s   s   s   t   t   t   t   t   u   u   w   w   x      
user_info    W   user_id   W   db   W   params   W   (for generator)   '   (for state)   '   (for control)   '   _   %   field   %   s0   W   rs3   W      loglogic_ENV	sprint_r'                                                               
   
                           )      :   ,   L   =   x   O   x   
   skynet   '   mysql   '   redis   '   log   '   	sprint_r   '   	tostring   '   info   '   conf   '   logic   '   command   '      _ENV