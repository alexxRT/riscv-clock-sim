from utils import read_signals, gen_instrtxt
from pathlib import Path
from subprocess import run
import configparser
import pytest

config = configparser.ConfigParser()
config.read("./config.cfg")

INSTR_FILE_NAME = config["device"]["instr_input"]

TARGET_BIN = config["run"]["target_bin"]
CLEAN = config.getboolean("run", "clean")

# covered by tests instructions, you may want to expand them
@pytest.mark.parametrize("instr,res", [
    ("addi", (52, )),
    ("sub",  (5, )),
    ("sw",   (1, 52, -34)),
    ("lw",   (-34, )),
    ("and",  (0, )),
    ("or",   (11, )),
    ("jal",  (8, )),
    ("beq",  (12, )),
    ("slt",  (0, ))
])
def test_instructions(instr: str, res: tuple):
    gen_instrtxt(instr, INSTR_FILE_NAME)

    run(["chmod", "777", f"{TARGET_BIN}"])
    run([f"{TARGET_BIN}"])

    signals = read_signals("dump.vcd")

    # check for test results
    result = True

    if CLEAN:
        run(["rm", "riscvtest.txt"])
        run(["rm", "dump.vcd"])


    assert result












