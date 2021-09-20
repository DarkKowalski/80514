#include "Valu.h"
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <verilated.h>

enum alu_method
{
    alu_add,
    alu_sub,
    alu_and,
    alu_or,
    alu_not,
    alu_xor
};

enum alu_shift_method
{
    alu_logical_right_shift,
    alu_right_rotate,
    alu_arithmetic_right_shift,
    alu_left_shift,
    alu_left_rotate
};

typedef bool (*alu_test_t)(Valu *);

bool test_alu_add(Valu *alu)
{
    // Not carry
    alu->method = alu_method::alu_add;
    for (int i = 0; i <= 255; i++)
    {
        alu->a = i;
        alu->b = 0;
        alu->cy_i = 0;
        alu->eval();
        if (alu->o != i || alu->cy_o != 0)
        {
            printf("[Error]: ALU: %u + %u = %u (%x)\n", i, 0, alu->o,
                   alu->cy_o);
            return false;
        }
    }

    // Carry
    for (int i = 128; i <= 255; i++)
    {
        alu->a = i;
        alu->b = i;
        alu->cy_i = 0;
        alu->eval();
        if (alu->o != ((i + i) & 0xff) || alu->cy_o != 1)
        {
            printf("[Error]: ALU: %u + %u = %u (%x)\n", i, i, alu->o,
                   alu->cy_o);
            return false;
        }
    }

    return true;
}

bool test_alu_sub(Valu *alu)
{
    alu->method = alu_method::alu_sub;
    // Not carry
    for (int i = 1; i <= 255; i++)
    {
        alu->a = i;
        alu->b = 1;
        alu->cy_i = 0;
        alu->eval();
        if (alu->o != (i - 1) || alu->cy_o != 0)
        {
            printf("[Error]: ALU: %u - %u = %u (%x)\n", i, 1, alu->o,
                   alu->cy_o);
            return false;
        }
    }

    // Carry
    for (int i = 0; i <= 254; i++)
    {
        alu->a = i;
        alu->b = 255;
        alu->cy_i = 0;
        alu->eval();
        if (alu->o != ((i - 255) & 0xff) || alu->cy_o != 1)
        {
            printf("[Error]: ALU: %u - %u = %u (%x)\n", i, 255, alu->o,
                   alu->cy_o);
            return false;
        }
    }

    return true;
}

bool test_alu_and(Valu *alu)
{
    alu->method = alu_method::alu_and;
    for (int i = 1; i <= 255; i++)
    {
        alu->a = i;
        alu->b = i - 1;
        alu->cy_i = 0;
        alu->eval();
        if (alu->o != (i & (i - 1) & 0xff) || alu->cy_o != 0)
        {
            printf("[Error]: ALU: %u & %u = %u (%x)\n", i, i - 1, alu->o,
                   alu->cy_o);
            return false;
        }
    }

    return true;
}

bool test_alu_or(Valu *alu)
{
    alu->method = alu_method::alu_or;

    for (int i = 1; i <= 255; i++)
    {
        alu->a = i;
        alu->b = i - 1;
        alu->cy_i = 0;
        alu->eval();
        if (alu->o != (i | (i - 1) & 0xff) || alu->cy_o != 0)
        {
            printf("[Error]: ALU: %u | %u = %u (%x)\n", i, i - 1, alu->o,
                   alu->cy_o);
            return false;
        }
    }

    return true;
}

bool test_alu_not(Valu *alu)
{
    alu->method = alu_method::alu_not;

    for (int i = 0; i <= 255; i++)
    {
        alu->a = i;
        alu->b = 0;
        alu->cy_i = 0;
        alu->eval();
        if (alu->o != ((~i) & 0xff) || alu->cy_o != 0)
        {
            printf("[Error]: ALU: !%u = %u (%x)\n", i, alu->o, alu->cy_o);
            return false;
        }
    }

    return true;
}

bool test_alu_xor(Valu *alu)
{
    alu->method = alu_method::alu_xor;

    for (int i = i; i <= 255; i++)
    {
        alu->a = i;
        alu->b = i - 1;
        alu->cy_i = 0;
        alu->eval();
        if (alu->o != ((i ^ (i - 1)) & 0xff) || alu->cy_o != 0)
        {
            printf("[Error]: ALU: %u ^ %u = %u (%x)\n", i, i - 1, alu->o,
                   alu->cy_o);
            return false;
        }
    }

    return true;
}

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    Valu *alu = new Valu;

    alu_test_t tests[] = {test_alu_add, test_alu_sub, test_alu_and,
                          test_alu_or,  test_alu_not, test_alu_xor};
    // TODO: add tests for shift
    size_t all_tests = sizeof(tests) / sizeof(tests[0]);

    int passed = 0;

    for (int i = 0; i < all_tests; i++)
    {
        if (tests[i](alu))
        {
            passed++;
        }
    }

    printf("[Final]: Passed = %d\n", passed);

    if (passed == all_tests)
    {
        return 0;
    }
    else
    {
        return 1;
    }
}
