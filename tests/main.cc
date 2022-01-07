#include <algorithm>

int main(int argc, char** argv) {
    int clamped_argc = std::clamp(argc, 0, 1);
    if (clamped_argc != 1) {
        return 1;
    }
}
