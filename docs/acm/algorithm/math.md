


## Basis

```c++
template <typename T>
struct Basis {
  static constexpr int M = 60;
  T a[M + 5] {};
  T tmp[M + 5] {}; 
  int t[M + 5] {};
    
  Basis() {
    std::fill(t, t + M + 5, -1);
  }
    
  void add(T x, int y = 1E9) {
    for (int i = M; ~i; i--) {
      if (x >> i & 1) {
        if (y > t[i]) {
          std::swap(a[i], x);
          std::swap(t[i], y);
        }
        x ^= a[i];
      }
    }
  }
    
  bool check(T x, int y = 0) {
    for (int i = M; ~i; i--) {
      if ((x >> i & 1) && t[i] >= y) {
        x ^= a[i];
      }
    }
    return x == 0;
  }

  T qmax(T res = 0) {
    for (int i = M; ~i; i--)
      res = std::max(res, res ^ a[i]);
    return res;
  }
  T qmin(T res = 0) {
    for (int i = 0; i <= M; i++)
        if(a[i]) return a[i];
  }

  T query (int k) {
    T res = 0;
    int cnt = 0;
    if(!k)return 0;
    for(int i = 0; i <= M; i++){
        for(int j = i - 1; ~j; j--)
            if(a[i] & (1ll << j)) a[i] ^= a[j];
        if(a[i]) tmp[cnt++] = a[i];
    }
    if(k >= (1ll << cnt)) return -1;
    for (int i = 0; i < cnt; i++)
        if (k & (1ll << i)) res ^= tmp[i];
    return res;
  }
};
```


