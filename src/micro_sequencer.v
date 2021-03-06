// Microcode Format

// +--------+-------+------------+----+----+----+----+----+---+---+---------------------+--------------+---+---+---+-----+-------+-------+
// | 17     | 16    | 15         | 14 | 13 | 12 | 11 | 10 | 9 | 8 | 7                   | 6            | 5 | 4 | 3 | 2   | 1     | 0     |
// +--------+-------+------------+----+----+----+----+----+---+---+---------------------+--------------+---+---+---+-----+-------+-------+
// | JMP_en | Cond  |            |    |    |    |    |    | JMP_imm                                                                      |
// +--------+-------+------------+----+----+----+----+----+-------+----------------------------------------------------------------------+
// | JMP_en | RI_en | Mem_access | ALU_method   | RD      | RS1   | IMM                                                                  |
// +--------+-------+------------+--------------+---------+-------+---------------------+--------------+---+---+---+-----+---------------+
// | JMP_en | RI_en | Mem_access | ALU_method   | RD      | RS1   | ALU_method_from_REG | PC_from_{CD} |   |   |   |     | RS2           |
// +--------+-------+------------+----+----+----+---------+-------+---------------------+--------------+---+---+---+-----+---------------+
// | JMP_en | RI_en | Mem_access |    |    |    | RD      | RS1   |                     |              |   |   |   | R/W | Type(e/i/ROM) |
// +--------+-------+------------+----+----+----+---------+-------+---------------------+--------------+---+---+---+-----+---------------+
// | JMP_en | RI_en | Mem_access | ALU_method   | CMP_value       | IMM                                                                  |
// +--------+-------+------------+--------------+-----------------+----------------------------------------------------------------------+


module micro_sequencer(
    input clk,
    input rst_n,


);

// Microcode ROM
wire [9:0] upc;
wire [17:0] ucode;
microcode u_microcode(upc, ucode);

// Microcode Decoder
wire [9:0] ucode_imm_jmp;
wire [7:0] ucode_imm;

wire [1:0] ucode_rd;
wire [1:0] ucode_rs0;
wire [1:0] ucode_rs1;

wire ucode_jmp;
wire ucode_bus_access;
wire ucode_bus_write;
wire [1:0] ucode_bus_type; // eRAM, iRAM, ROM

wire [2:0] ucode_alu_method;
wire [2:0] ucode_alu_shift_method;

wire ucode_set_pc;

endmodule
