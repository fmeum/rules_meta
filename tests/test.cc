#include <cstdlib>
#include <iostream>
#include <string>

int main(int argc, char** argv) {
  const char* foo = std::getenv("FOO");
  if (foo == nullptr) {
    return 1;
  }
  std::cout << "FOO: " << foo;
  return std::string(foo) != "BAR";
}
