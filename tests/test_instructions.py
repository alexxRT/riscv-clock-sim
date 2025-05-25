from utils import read_signals, gen_instrtxt, convert_decimal_signed, get_last_memory_event
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

# covered by tests instructions, you may want to expand them
@pytest.mark.parametrize("instr,res", [
    ("addi", (52, )),
    ("sub",  (5, )),
    ("sw",   (1, -34, 52)),
    ("lw",   (-34, )),
    ("and",  (0, )),
    ("or",   (11, )),
    ("jal",  (8, )),
    ("beq",  (11, )),
    ("slt",  (0, )),
])
def test_instructions(instr: str, res: tuple):
    gen_instrtxt(instr, INSTR_FILE_NAME)

    run(["chmod", "777", f"{TARGET_BIN}"])
    run([f"{TARGET_BIN}"])

    signals = read_signals("dump.vcd")

    if instr == "sw":
        memory_event = get_last_memory_event(signals[MEMORY_WRITE],
                                             signals[MEMORY_DATA],
                                             signals[MEMORY_ADDR]
                                            )
        result = (memory_event == res)
    else:
        res_val = res[0]
        for sig_val in reversed(signals[REG_RESULT_1]):
            if sig_val[1] != "x":
                dec_val = convert_decimal_signed(sig_val[1])
                result = (dec_val == res_val)
                break

    if CLEAN:
        run(["rm", f"{INSTR_FILE_NAME}"])
        run(["rm", "dump.vcd"])

    assert result














