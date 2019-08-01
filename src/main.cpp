#include <iostream>

#if defined(__clang__)
#define CC "clang++"
#elif defined (__GNUC__)
#define CC "g++"
#else
#define CC "<unknown compiler>"
#endif

int main() {
  std::cout << "Hello World!\n"
    << "Compiler: " << CC << " " << __VERSION__ << '\n';
}
