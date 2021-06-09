#pragma once

#include <functional>
#include <string>

const unsigned long long INT_HASH =
    12597418120160561823;  // std::hash<std::string>{}("int");
const size_t UINT_HASH =
    10112578404243530111;  // std::hash<std::string>{}("uint");
const size_t DOUBLE_HASH =
    13841485242819600253;  // std::hash<std::string>{}("double");
const size_t FLOAT_HASH =
    3529751552447467760;  // std::hash<std::string>{}("float");
const size_t BOOL_HASH =
    16561637548936908746;  // std::hash<std::string>{}("bool");
const size_t CHAR_HASH =
    342363981814211588;  // std::hash<std::string>{}("char");
const size_t LONG_HASH =
    11589084280236039799;  // std::hash<std::string>{}("long");
const size_t LONG_LONG_HASH =
    12194743747536227956;  // std::hash<std::string>{}("long long");
const size_t UNSIGNED_LONG_HASH =
    13581722773404766022;  // std::hash<std::string>{}("unsigned long");
const size_t UNSIGNED_LONG_LONG_HASH =
    3456822550903822590;  // std::hash<std::string>{}("unsigned long long");