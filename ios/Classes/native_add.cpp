#include <stdint.h>
//#include <iostream>
#include <string>
#include <string.h>

using namespace std;

extern "C" __attribute__((visibility("default"))) __attribute__((used))
const int32_t full_text_search(char* search_text, char* text) {
    int result = string(text).find(search_text);
    if (result== string::npos) {
        return 0;
    }
    return 1;
}

const int32_t text_search(char* search_text, char* text) {
    int result = string(text).find(search_text);
    if (result== string::npos) {
        return 0;
    }
    return 1;
}
