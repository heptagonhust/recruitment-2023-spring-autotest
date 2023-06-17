#pragma once
#include <chrono>
#include <iostream>
#include <string>
using namespace std::chrono_literals;

template<class T, class U>
std::string duration_to_string(std::chrono::duration<T, U> duration) {
    double ms = duration / 1.0ms;
    return std::to_string(ms) + " ms";
}

class ScopeTimer {
  public:
    ScopeTimer(std::string name) :
        m_name(std::move(name)),
        m_beg(std::chrono::high_resolution_clock::now()),
        m_tick(m_beg) {}
    void tick(const std::string &name) {
        auto end = std::chrono::high_resolution_clock::now();
        auto dur =
            std::chrono::duration_cast<std::chrono::microseconds>(end - m_tick);
        std::cout << ">>> " << m_name << " >>> " << name << ": "
                  << duration_to_string(dur) << "\n";
        m_tick = std::chrono::high_resolution_clock::now();
    }
    ~ScopeTimer() {
        auto end = std::chrono::high_resolution_clock::now();
        auto dur =
            std::chrono::duration_cast<std::chrono::microseconds>(end - m_beg);
        std::cout << ">>> " << m_name << ": " << duration_to_string(dur)
                  << "\n";
    }

  private:
    std::string m_name;
    std::chrono::time_point<std::chrono::high_resolution_clock> m_beg;
    std::chrono::time_point<std::chrono::high_resolution_clock> m_tick;
};
