#include <cassert>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>

/*
 * Дан текст не более 255 символов. Удалить последовательности одинаковых символов, завершающиеся символом "#"
 */


 /*
 *
 * Первый модуль использует конвенцию __cdecl (/Gd)
 * Второй модуль использует конвенцию stdcall
 * Третий модуль использует конвенцию cdecl (__cdecl (/Gd))
 *
 */

extern "C" {
    void __stdcall STRREP(char* str);
}

extern "C" {
    void __cdecl StdOutF(char* buffer) {
        std::cout << buffer << std::endl;
    }
}

int main(int argc, const char* argv[]) {
    std::cout << "Input sentence with words ending with #: " << std::endl;
    char str[255];
    gets_s(str, 255);
    STRREP(str);
    std::cout << "(press any key to continue)"<< std::endl;
    return 0;
}

// test strin# for tes# purposes
