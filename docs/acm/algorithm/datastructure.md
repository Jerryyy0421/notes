
## BIT

```c++
template<typename T, bool P = true>
class BIT {
private:
    std::vector<T> c;

public:
    void init(int n) {
        std::vector<T>(n + 1, 0).swap(c);
    }
    void update(int p, const T& v) {
        if constexpr (P) {
            for(size_t i = p; i < c.size(); i += i & -i) {
                c[i] += v;
            }
        } else {
            for(size_t i = p; i > 0; i -= i & -i) {
                c[i] += v;
            }
        }
    }
    T query(int p) const {
        T res(0);
        if constexpr (P) {
            for(size_t i = p; i > 0; i -= i & -i) {
                res += c[i];
            }
        } else {
            for(size_t i = p; i < c.size(); i += i & -i) {
                res += c[i];
            }
        }
        return res;
    }
};
```
