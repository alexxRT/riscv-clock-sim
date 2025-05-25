
import vcdvcd as vcd
from pathlib import Path
from collections import defaultdict


def convert_decimal_signed(num: str):
    bit_len = 32

    if (len(num) > bit_len):
        print("Invalid number to convert! Maximum 32 bitwise!")
        assert False

    if (num == 'x'):
        print(f"Invalid number format when convert: num={num}")
        assert False

    num = '0'*(bit_len - len(num)) + num
    signed_bit = num[0]
    dec_value = int(num, 2)

    if signed_bit == "1":
        dec_value -= 1 << bit_len

    return dec_value

def get_last_memory_event(mem_write: list, mem_data: list, mem_addr: list):
    ts = 0
    wr = 0
    data = 0
    addr = 0
    for w in reversed(mem_write):
        if w[1] == '1':
            ts = int(w[0])
            wr = 1
            break

    for d in reversed(mem_data):
        if int(d[0]) == ts:
            data = convert_decimal_signed(d[1])
            break

    for a in reversed(mem_addr):
        if int(a[0]) == ts:
            addr = convert_decimal_signed(a[1])
            break

    return (wr, data, addr)

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
                # instruction result is not written in reg imidiately
                write_result = "\n".join(["00028293"]*10) # addi x5 x5 0
                i.write(write_result)
            case "sub":
                # res: x1 = 5
                i.write("00800293\n") # addi x5 x0 8
                i.write("00300113\n") # addi x2 x0 3
                i.write("402280B3\n") # sub x1 x5 x2
                write_result = "\n".join(["0x00008093"]*10) # addi x1 x1 0
                i.write(write_result)
            case "sw":
                # res MemWrite=1 WriteAddr=52 DataWrite=-34
                i.write("FDE00113\n") # addi x2 x0 -34
                i.write("02202A23\n") # sw x2 52(x0)
            case "lw":
                # res x7 = -34
                i.write("FDE00113\n") # addi x2 x0 -34
                i.write("02202A23\n") # sw x2 52(x0)
                i.write("03402383\n") # lw x7 52(x0)
                write_result = "\n".join(["0x00038393"]*10) # addi x7 x7 0
                i.write(write_result)
            case "and":
                # res x7 = 8 & 3
                i.write("00800293\n") # addi x5 x0 8
                i.write("00300113\n") # addi x2 x0 3
                i.write("0022F3B3\n") # and x7 x5 x2
                write_result = "\n".join(["0x00038393"]*10) # addi x7 x7 0
                i.write(write_result)
            case "or":
                # res x7 = 8 | 3
                i.write("00800293\n") # addi x5 x0 8
                i.write("00300113\n") # addi x2 x0 3
                i.write("0022E3B3\n") # or x7 x5 x2
                write_result = "\n".join(["0x00038393"]*10) # addi x7 x7 0
                i.write(write_result)
            case "jal":
                # res x5 = 8
                i.write("00400293\n") # 00: addi x5 x0 4
                i.write("008003EF\n") # 04: jal x7 8
                i.write("00428293\n") # 08: addi x5 x5 4 shouldn't execute
                i.write("00428293\n") # 0C: addi x5 x5 4
                write_result = "\n".join(["00028293"]*10) # addi x5 x5 0
                i.write(write_result)
            case "beq":
                # res x5 = 0B
                i.write("00400293\n") # 00: addi x5 x0 4
                i.write("00300113\n") # 04: addi x2 x0 3
                i.write("00228463\n") # 08: beq x5 x2 8 # shouldn't jump offset
                i.write("00428293\n") # 0C: addi x5 x5 4
                i.write("00000463\n") # 10: beq x0 x0 8 # should jump offset
                i.write("00A10113\n") # 14: addi x2 x2 10
                i.write("002282B3\n") # 18: add x5 x5 x2
                write_result = "\n".join(["00028293"]*10) # addi x5 x5 0
                i.write(write_result)
            case "slt":
                # res x5 = 0
                i.write("00400293\n") # addi x5 x0 4
                i.write("00300113\n") # addi x2 x0 3
                i.write("0022A2B3\n") # slt x5 x5 x2
                write_result = "\n".join(["00028293"]*10) # addi x5 x5 0
                i.write(write_result)
            case "test1": # example from Haris&Haris
                i.write ("""00500113
00C00193
FF718393
0023E233
0041F2B3
004282B3
02728863
0041A233
00020463
00000293
0023A233
005203B3
402383B3
0471AA23
06002103
005104B3
008001EF
00100113
00910133
0221A023
00210063
00000013
00000013
""")


if __name__ == "__main__":
    read_signals(Path("../dump.vcd"))

