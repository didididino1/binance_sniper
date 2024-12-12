# coding=utf-8
import ujson as json
import hmac
import hashlib
from cpython.dict cimport PyDict_SetItem
from configparser import ConfigParser
import websockets
import time
import uuid
import urllib.parse
from libc.stdio cimport printf
import cython

cdef str ws_url = "wss://ws-api.binance.com:443/ws-api/v3"
cdef double time_start, time_end


def sign_request(str query_string, str secret_key):
    cdef bytes message = query_string.encode('utf-8')
    cdef bytes secret = secret_key.encode('utf-8')
    sha256_hmac = hmac.new(secret, message, hashlib.sha256)
    return sha256_hmac.hexdigest()


cdef dict parse_trade_message(str message):
    cdef dict data = json.loads(message)
    cdef dict trade_data
    if "data" in data:
        trade_data = data["data"]
        return trade_data
    return {}


async def buy_market_order(str api_key, str secret_key, str symbol, float buy_token_quantity):
    cdef str unique_id = str(uuid.uuid4())
    cdef timestamp = int(time.time() * 1000)

    cdef dict params = {
        "symbol": symbol,
        "side": "BUY",
        "type": "MARKET",
        "quantity": f"{buy_token_quantity}",
        "timestamp": timestamp,
        "apiKey": api_key
    }

    cdef str query_string = '&'.join([f"{key}={urllib.parse.quote(str(value))}" for key, value in sorted(params.items())])
    cdef str signature = hmac.new(secret_key.encode(), query_string.encode(), hashlib.sha256).hexdigest()
    params["signature"] = signature

    cdef dict request_payload = {
        "id": unique_id,
        "method": "order.place",
        "params": params
    }

    response = None
    async with websockets.connect(ws_url) as websocket:
        await websocket.send(json.dumps(request_payload))
        response = await websocket.recv()
        response_data = json.loads(response)
        if "error" in response_data:
            print(f"Failed to place buy order: {response_data['error']}")
        else:
            print(f"Buy order placed successfully: {response_data}")


@cython.cfunc
def get_current_timestamp():
    return long(time.time() * 1000)


@cython.cfunc
def optimized_print(message):
    cdef bytes message_bytes = message.encode('utf-8')
    printf("%s\n", message_bytes)


async def listen_for_trades(str api_key, str secret_key, str token_symbol, float buy_token_quantity, open_trade_time):
    open_trade_time = long(open_trade_time)
    while True:
        current_timestamp = get_current_timestamp()
        time_left = open_trade_time - current_timestamp
        optimized_print(f"Time from opening:{time_left}")
        if time_left < 100:
            time_start = get_current_timestamp()
            await buy_market_order(api_key, secret_key, token_symbol.upper(), buy_token_quantity)
            time_end = get_current_timestamp()
            optimized_print(f'Buy order took {(time_end - time_start)} ms')
