#include <cstdlib>
#include <iostream>
#include <string>

int main(int argc, char** argv) {
  if (argc != 2) {
    std::cout << "argc: " << argc << std::endl;
    return 1;
  }
  std::string arg = argv[1];
  std::cout << "args: " << argv[1];
  if (arg != "some_arg") {
    return 1;
  }
  const char* foo = std::getenv("FOO");
  if (foo == nullptr) {
    return 1;
  }
  std::cout << "FOO: " << foo;
  return std::string(foo) != "BAR";
}
