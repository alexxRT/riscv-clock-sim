
import vcdvcd as vcd
from pathlib import Path
from collections import defaultdict

"""
input:
    signals: Path - path to raw .vcd file after simulation
output:
    tree: defaultdict - structuraly organized signals in tree-like style
"""
def read_signals(signals: Path) -> defaultdict:
    read_vcd = vcd.VCDVCD(signals, signals=None, store_tvs=True)
    output = {}

    for signal in [sig.__dict__ for sig in read_vcd.data.values()]:
        sig_name = signal['references'][0].split('.')[-1]
        output[sig_name] = signal['tv']

    return output

def gen_instrtxt(instr: str, instr_file: str):
    with open(instr_file, "w") as i:
        match instr:
            case "addi":
                # res x5 = 52
                i.write("03400293\n") # addi x5 x0 52
            case "sub":
                # res: x1 = 5
                i.write("00800293\n") # addi x5 x0 8
                i.write("00300113\n") # addi x2 x0 3
                i.write("402280B3\n") # sub x1 x5 x2
            case "sw":
                # res MemWrite=1 WriteAddr=52 DataWrite=-34
                i.write("FDE00113\n") # addi x2 x0 -34
                i.write("02202A23\n") # sw x2 52(x0)
            case "lw":
                # res x7 = -34
                i.write("FDE00113\n") # addi x2 x0 -34
                i.write("02202A23\n") # sw x2 52(x0)
                i.write("03402383\n") # lw x7 52(x0)
            case "and":
                # res x7 = 8 & 3
                i.write("00800293\n") # addi x5 x0 8
                i.write("00300113\n") # addi x2 x0 3
                i.write("0022F3B3\n") # and x7 x5 x2
            case "or":
                # res x7 = 8 | 3
                i.write("00800293\n") # addi x5 x0 8
                i.write("00300113\n") # addi x2 x0 3
                i.write("0022E3B3\n") # or x7 x5 x2
            case "jal":
                # res x5 = 8
                i.write("00400293\n") # 00: addi x5 x0 4
                i.write("008002EF\n") # 04: jal x5 8
                i.write("00428293\n") # 08: addi x5 x5 4 shouldn't execute
                i.write("00428293\n") # 0C: addi x5 x5 4
            case "beq":
                # res x5 = 0C
                i.write("00400293\n") # 00: addi x5 x0 4
                i.write("00300113\n") # 04: addi x2 x0 3
                i.write("00228463\n") # 08: beq x5 x2 8 # shouldn't jump offset
                i.write("00428293\n") # 0C: addi x5 x5 4
                i.write("00000463\n") # 10: beq x0 x0 8 # should jump offset
                i.write("00A10113\n") # 14: addi x2 x2 10
                i.write("002282B3\n") # 18: add x5 x5 x2
            case "slt":
                # res x5 = 0
                i.write("00400293\n") # addi x5 x0 4
                i.write("00300113\n") # addi x2 x0 3
                i.write("005122B3\n") # slt x5 x5 x2

if __name__ == "__main__":
    read_signals(Path("../dump.vcd"))

