# binance_sniper

## 脚本用于抢币安新开盘的代币

1.pycharm中打开项目文件夹，pin install 安装需要的库

2.pyinstaller -F Binance_Sniper_3.py打包exe即可；如果部分库丢失，用下面命令打包
pyinstaller --onefile --hidden-import=websockets --hidden-import=ujson -F Binance_Sniper_3.py

3.如果懒得打包，也可直接使用已经打包好的Binance_Sniper_3.exe脚本，只需要配置好config文件即可使用。

## config文件配置：
1.api_key到币安官网申请；

2.token_symbol代币符号，例如买入btc，符号就是btcusdt;

3.buy_token_quantity买入代币数量，由于抢开盘时从交易所获取代币价格比较耗时，所以这里根据可能的价格自己估算出数量即可；

4.open_trade_time 代币开盘时间的毫秒时间戳，脚本会在这里设置的开盘时间前200ms开始死循环通过wss.send持续发送买单。

## 注意事项：
1.币安开盘不好抢，要抢到的话买入代币的时间要压缩到5毫秒以内，代码已经使用cython优化到最好，抢开盘的主要瓶颈在于服务器。如果要抢，建议买的服务器使用东京亚马逊云，或者自己ping wss服务器的ip地址，找对应的机房来买自己的服务器。
