
#include <stdio.h>

// Dummy implementation to ensure stdout is linked correctly
FILE __stdout;

// Assign stdout to address of __stdout
FILE *const stdout = &__stdout;

// Define the stdout as a constant pointer to FILE.
int fputc(int c, FILE *stream)
{
    // You can implement character output here if needed
    // Currently, just return the character
    return c;
}

void __atomic_compare_exchange_4()
{
    // Dummy implementation
}

void __atomic_load_4()
{
    // Dummy implementation
}

void __atomic_fetch_add_4()
{
    // Dummy implementation
}

void __atomic_store_4()
{
    // Dummy implementation
}

void __atomic_fetch_sub_4()
{
    // Dummy implementation
}