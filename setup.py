# setup.py
from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize(r"C:\Users\Administrator\PycharmProjects\pythonProject\CexSniper\Binance_Sniper"
                          r"\binance_sniper_3\binance_sniper_3.pyx", compiler_directives={'language_level': "3"})
)
