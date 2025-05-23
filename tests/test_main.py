from utils import read_signals, gen_instrtxt, get_last_memory_event
from pathlib import Path
from subprocess import run
import configparser
import pytest

config = configparser.ConfigParser()
config.read("./setup.cfg")

INSTR_FILE_NAME = config["device"]["instr_input"]
REG_RESULT_1 = config["device"]["reg_1"]
MEMORY_WRITE = config["device"]["mem_write"]
MEMORY_DATA = config["device"]["mem_data"]
MEMORY_ADDR = config["device"]["mem_addr"]

TARGET_BIN = config["run"]["target_bin"]
CLEAN = config.getboolean("run", "clean")

@pytest.mark.parametrize("test,res", [
    ("test1", (1, 25, 100))
])
def test_main(test: str, res: tuple):
    gen_instrtxt(test, INSTR_FILE_NAME)

    run(["chmod", "777", f"{TARGET_BIN}"])
    run([f"{TARGET_BIN}"])

    signals = read_signals("dump.vcd")
    result = True

    if (test == "main"):
        memory_event = get_last_memory_event(signals[MEMORY_WRITE],
                                             signals[MEMORY_DATA],
                                             signals[MEMORY_ADDR]
                                            )
        result = (memory_event == res)

    if CLEAN:
        run(["rm", "riscvtest.txt"])
        run(["rm", "dump.vcd"])

    assert result
