_G.conf = _G.conf or {}

_G.conf.welcome = "hello world."

_G.conf.mysqld = _G.conf.mysqld or {
    min_pool_size = 10,
    config = {
		host="127.0.0.1",
		port=3306,
		database="cnc_auth",
        user="ccgame",
        password="K1Sk44O2DK#yQHs2",
        max_packet_size = 1024 * 1024,
        on_connect = function (db_)
            print("connect db ok,set charset to utf8")
		    db_:query("set charset utf8mb4");
	    end,
    }
}
