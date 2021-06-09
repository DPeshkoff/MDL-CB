
#include <functional>
#include <iostream>
#include <string>
#include <vector>

#include "constants.h"
// import <iostream>;
// import <string>;
// import <vector>;

void log(std::string error, std::string line) {
    std::cout << error << " (at " << line << " )" << std::endl;
}

class Parser {
   public:
    uint16_t num_of_opened_loops = 0;
    uint16_t statements_count = 0;
    int16_t opened_brackets = 0;
    uint32_t global_statements_count = 0;
    std::string current_type;
    bool error = false;

    bool IsIdentifierComplete(const std::string &src, const std::string &type,
                              const bool &position);

    bool IsIdentifier(std::string src);

    bool IsLetter(const char &chr);

    bool IsType(const std::string &src);

    bool IsDigit(const char &chr);

    std::vector<std::string> SplitToVector(const std::string &src,
                                           const char &delimiter);

    bool IsDo(const std::string &src);

    bool IsOpeningBracket(const char &src);

    bool IsClosingBracket(const char &src);

    bool IsBool(const std::string &src);

    bool IsWhile(const std::string &src);

    bool IsValue(std::string src);

    bool IsExpression(const std::string &src);
};

enum state_t { EXPECT_ANY, EXPECT_DEFINITION, EXPECT_EXPRESSTION };

int main() {
    Parser parser;

    // "do { do int a=90; while (f); } while (g);"
    // "do do int a=90; while (f); while (g);"
    // "do do { bool a=90; } while (f); while (g);"
    // "do do { bool a=true; int b=a; } while (f); while (g);"
    // "do do bool a=true; int b=a; while (f); while (g);"
    // "do do a=90 while (f) while (g)"
    // "do 9a=; while (!9b);"
    // "do a=; while (9b);"
    // "do int a=5000; while (!b);"
    // "do { do int a=90; while (f); } while (!g);"
    // "do { do { do { int val=5000; bool tr=0; } while (tr); } while (!base); }
    // while (test);"

    // std::string test = "do do int a=90; while (f); } while (g);";
    // std::string test = "do { do int a=90 while (f); } while (g);";

    std::string test;

    std::getline(std::cin, test, '\n');

    test += ' ';

    std::vector<std::string> data = parser.SplitToVector(test, ' ');
    std::vector<std::string>::iterator data_iterator = data.begin();
    state_t state = EXPECT_ANY;
    std::cout << "\033[1;37m[ Parsing ]\033[0m" << std::endl;
    while (data_iterator != data.end()) {
        switch (state) {
            case EXPECT_ANY:
                if (parser.IsDo(*data_iterator)) {
                    ++parser.num_of_opened_loops;
                }
                if (parser.IsWhile(*data_iterator)) {
                    state = EXPECT_EXPRESSTION;
                }
                if (parser.IsOpeningBracket((*data_iterator)[0])) {
                    ++parser.opened_brackets;
                }
                if (parser.IsClosingBracket((*data_iterator)[0])) {
                    --parser.opened_brackets;
                }
                if (parser.IsType(*data_iterator)) {
                    state = EXPECT_DEFINITION;
                    parser.current_type = *data_iterator;
                }
                if (parser.IsIdentifierComplete(*data_iterator,
                                                parser.current_type, 0)) {
                    ++parser.statements_count;
                    if (parser.statements_count > 1 and
                        parser.opened_brackets == 0) {
                        log("\033[1;31m[ERROR]\033[0m {} are required for "
                            "multi-statement blocks",
                            *data_iterator);
                        parser.error = true;
                    }
                }
                data_iterator += 1;
                break;
            case EXPECT_EXPRESSTION:
                parser.IsExpression(*data_iterator);
                state = EXPECT_ANY;
                data_iterator += 1;
                --parser.num_of_opened_loops;
                break;
            case EXPECT_DEFINITION:
                parser.IsIdentifierComplete(*data_iterator, parser.current_type,
                                            0);
                ++parser.statements_count;
                if (parser.statements_count > 1 and
                    parser.opened_brackets == 0) {
                    log("\033[1;31m[ERROR]\033[0m {} are required for "
                        "multi-statement blocks",
                        *data_iterator);
                    parser.error = true;
                }
                state = EXPECT_ANY;
                data_iterator += 1;
                break;
        }
    }

    if (parser.num_of_opened_loops > 0) {
        std::cout << "\033[1;31m[ERROR]\033[0m Expected loops closure (found "
                  << parser.num_of_opened_loops << " open loops)" << std::endl;
    }
    if (std::abs(parser.opened_brackets) > 0) {
        std::cout << "\033[1;31m[ERROR]\033[0m Found excessive brackets (found "
                  << std::abs(parser.opened_brackets) << " non-paired brackets)"
                  << std::endl;
    }
    if (!parser.error) {
        std::cout << "\033[1;32m[VALID]\033[0m This snippet is valid."
                  << std::endl;
    } else {
        std::cout << "\033[1;31m[NOT VALID]\033[0m This snippet is not valid."
                  << std::endl;
    }

    return EXIT_SUCCESS;
}

std::vector<std::string> Parser::SplitToVector(const std::string &src,
                                               const char &delimiter) {
    std::vector<std::string> dest;
    std::string temp = "";
    for (size_t i = 0; i < src.length(); ++i) {
        if (src[i] == delimiter) {
            dest.push_back(temp);
            temp = "";
        } else {
            temp.push_back(src[i]);
        }
    }
    dest.push_back(temp);
    return dest;
}

bool Parser::IsType(const std::string &src) {
    switch (std::hash<std::string>{}(src)) {
        case INT_HASH:
        case UINT_HASH:
        case BOOL_HASH:
        case CHAR_HASH:
        case LONG_HASH:
        case LONG_LONG_HASH:
        case UNSIGNED_LONG_HASH:
        case UNSIGNED_LONG_LONG_HASH:
            return true;
        default:
            return false;
            //    int | uint | bool | char | long | long
            //    long | unsigned long | unsigned long long
    }
    return true;
}

bool Parser::IsIdentifier(std::string src) {
    if (IsLetter(src[0])) {
        for (std::string::reverse_iterator i = src.rbegin(); i != src.rend();
             ++i) {
            if (!IsLetter(*i) and !IsDigit(*i)) {
                log("\033[1;31m[ERROR]\033[0m Symntax error: identifier error ",
                    src);
                error = true;
                return false;
            }
        }
        return true;
    } else {
        log("\033[1;31m[ERROR]\033[0m Wrong variable name ", src);
        error = true;
        return false;
    }
}

bool Parser::IsIdentifierComplete(const std::string &src,
                                  const std::string &type,
                                  const bool &position) {
    std::vector<std::string> identifier = SplitToVector(src, '=');
    bool is_identifier = false;

    if (identifier.size() >= 2) {
        is_identifier = true;
    }
    if (is_identifier) {
        IsIdentifier(identifier[0]);
        if (type == "bool") {
            if (!IsBool(identifier[1])) {
                log("\033[1;31m[ERROR]\033[0m Unexpected variable value for "
                    "type 'bool' ",
                    identifier[1]);
                error = true;
            }
        } else {
            if (identifier[1].back() != ';' and position == 0) {
                log("\033[1;31m[ERROR]\033[0m Expected ;", identifier[1]);
                error = true;
            }
            IsValue(identifier[1].substr(0, identifier[1].size() - 1));
        }
    } else {
        return is_identifier;
    }
    return false;
}

bool Parser::IsLetter(const char &chr) {
    return (chr >= 'A' && chr <= 'Z' || chr >= 'a' && chr <= 'z' || chr == '_')
               ? true
               : false;
}

bool Parser::IsDigit(const char &chr) {
    return ((int)chr >= '0' and (int) chr <= '9') ? true : false;
}

bool Parser::IsBool(const std::string &src) {
    return (src == "0;" or src == "1;" or src == "true;" or src == "false;")
               ? true
               : false;
}

bool Parser::IsDo(const std::string &src) {
    return (src == "do") ? true : false;
}

bool Parser::IsWhile(const std::string &src) {
    return (src == "while") ? true : false;
}

bool Parser::IsExpression(const std::string &src) {
    if (src[src.size() - 1] != ';') {
        log("\033[1;31m[ERROR]\033[0m Expected ;", src);
        error = true;
    } else if (src[0] == '(' and src[src.size() - 2] == ')') {
        if (src[1] == '!') {
            if (!IsIdentifier(src.substr(2, src.size() - 4))) {
                error = true;
            }
        } else if (!IsIdentifier(src.substr(1, src.size() - 3))) {
            error = true;
        }
    } else {
        log("\033[1;31m[ERROR]\033[0m Expected ()", src);
        error = true;
    }
    return false;
}

bool Parser::IsValue(std::string src) {
    if (IsLetter(src[0])) {
        if (!IsIdentifier(src)) {
            log("\033[1;31m[ERROR]\033[0m Symntax error: identifier error ",
                src);
            error = true;
            return false;
        }
    } else if (IsDigit(src[0]) or src[0] == '-') {
        for (std::string::reverse_iterator i = src.rbegin(); i != src.rend() + 2;
             ++i) {
            if (!IsDigit(*i)) {
                log("\033[1;31m[ERROR]\033[0m Value error: wrong value ", src);
                error = true;
                return false;
            }
        }
    } else {
        log("\033[1;31m[ERROR]\033[0m Value error ", src);
        error = true;
        return false;
    }
    return true;
}

bool Parser::IsOpeningBracket(const char &chr) {
    return (chr == '{') ? true : false;
}

bool Parser::IsClosingBracket(const char &chr) {
    return (chr == '}') ? true : false;
}