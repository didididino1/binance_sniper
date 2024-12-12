# coding=utf-8
import asyncio
import os.path
from configparser import ConfigParser
from binance_sniper_3 import listen_for_trades


def load_config(path):
    config = ConfigParser()
    config.read(path)
    return {
        "api_key": config.get("DEFAULT", "api_key"),
        "secret_key": config.get("DEFAULT", "secret_key"),
        "token_symbol": config.get("DEFAULT", "token_symbol"),
        "buy_token_quantity": float(config.get("DEFAULT", "buy_token_quantity")),
        "open_trade_time": int(config.get("DEFAULT", "open_trade_time"))
    }


if __name__ == "__main__":
    config_data = load_config(os.path.abspath("./config.ini"))
    print(config_data)
    asyncio.run(
        listen_for_trades(
            config_data["api_key"],
            config_data["secret_key"],
            config_data["token_symbol"],
            float(config_data["buy_token_quantity"]),
            int(config_data['open_trade_time']),
        )
    )
